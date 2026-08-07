from __future__ import annotations

from pathlib import Path, PurePosixPath
import json
import re
import sys

root = Path(__file__).resolve().parents[1]
templates_root = root / 'lib' / 'src' / 'templates'
registry_path = templates_root / 'registry.json'
registry = json.loads(registry_path.read_text())
descriptors = {item['id']: item for item in registry['templates']}
errors: list[str] = []
loaded: dict[str, tuple[dict, Path]] = {}

for template_id, descriptor in descriptors.items():
    manifest_path = templates_root / descriptor['manifest']
    if not manifest_path.exists():
        errors.append(f'Missing manifest: {manifest_path}')
        continue

    try:
        manifest = json.loads(manifest_path.read_text())
    except json.JSONDecodeError as error:
        errors.append(f'Invalid JSON {manifest_path}: {error}')
        continue

    loaded[template_id] = (manifest, manifest_path)
    if manifest.get('id') != template_id:
        errors.append(f'ID mismatch: {manifest_path}')
    if manifest.get('version') != descriptor.get('version'):
        errors.append(f'Version mismatch: {manifest_path}')

    for required_id in manifest.get('requires', []):
        if required_id not in descriptors:
            errors.append(f'{template_id} requires unknown template {required_id}')

    for item in manifest.get('files', []):
        source = manifest_path.parent / item['template']
        if not source.exists():
            errors.append(f'Missing template: {source}')


def resolve(template_id: str) -> list[str]:
    resolved: list[str] = []
    visiting: set[str] = set()
    visited: set[str] = set()

    def visit(current_id: str) -> None:
        if current_id in visited:
            return
        if current_id in visiting:
            errors.append(f'Circular template dependency: {current_id}')
            return
        visiting.add(current_id)
        manifest, _ = loaded[current_id]
        for dependency_id in manifest.get('requires', []):
            visit(dependency_id)
        visiting.remove(current_id)
        visited.add(current_id)
        resolved.append(current_id)

    visit(template_id)
    return resolved


def flatten(prefix: str, value: object, output: dict[str, str]) -> None:
    if not isinstance(value, dict):
        return
    for key, child in value.items():
        name = str(key) if not prefix else f'{prefix}.{key}'
        if isinstance(child, dict):
            flatten(name, child, output)
        elif child is not None:
            output[name] = str(child)


def render(value: str, variables: dict) -> str:
    replacements: dict[str, str] = {}
    flatten('', variables, replacements)
    output = value
    for key, replacement in replacements.items():
        output = output.replace('{{' + key + '}}', replacement)
    unresolved = re.search(r'\{\{[^}]+\}\}', output)
    if unresolved:
        raise ValueError(f'Unresolved token {unresolved.group(0)}')
    return output


def lookup(path: str, variables: dict) -> object:
    current: object = variables
    for segment in path.split('.'):
        if not isinstance(current, dict):
            return None
        current = current.get(segment)
    return current


def condition_enabled(condition: str | None, variables: dict) -> bool:
    if not condition:
        return True
    condition = condition.strip()
    negated = condition.startswith('!')
    key = condition[1:] if negated else condition
    result = lookup(key, variables) is True
    return not result if negated else result


base_variables = {
    'project': {'name': 'sample_app', 'package': 'sample_app'},
    'feature': {
        'raw': 'user-profile',
        'snake': 'user_profile',
        'camel': 'userProfile',
        'pascal': 'UserProfile',
        'kebab': 'user-profile',
    },
    'config': {
        'sourceDirectory': 'lib',
        'featureDirectory': 'lib/features',
        'architecture': 'clean',
        'router': 'go_router',
        'stateManagement': 'riverpod',
    },
    'includeRoute': True,
    'includeJson': True,
    'kite': {'version': 'static-validation'},
    'generated': {'date': '2026-08-06T00:00:00Z'},
}

scenarios = [
    'project.clean',
    'feature.clean',
    'feature.mvc',
    'component.button',
    'component.card',
    'component.avatar',
    'state.riverpod',
    'api.dio',
]
scenario_counts: dict[str, int] = {}

for root_id in scenarios:
    generated: dict[str, str] = {}
    variables = json.loads(json.dumps(base_variables))
    if root_id == 'feature.mvc':
        variables['config']['architecture'] = 'mvc'

    for template_id in resolve(root_id):
        manifest, manifest_path = loaded[template_id]
        for item in manifest.get('files', []):
            if not condition_enabled(item.get('condition'), variables):
                continue
            try:
                target = render(item['target'], variables)
                content = render(
                    (manifest_path.parent / item['template']).read_text(),
                    variables,
                )
            except ValueError as error:
                errors.append(f'{template_id}: {error}')
                continue

            path = PurePosixPath(target)
            if path.is_absolute() or '..' in path.parts or not target.strip():
                errors.append(f'Unsafe target in {template_id}: {target}')
                continue

            previous = generated.get(target)
            if previous is not None and previous != content:
                errors.append(f'Conflicting generated target in {root_id}: {target}')
            generated[target] = content

    for target, content in generated.items():
        for import_path in re.findall(r"import\s+'(\.{1,2}/[^']+)'", content):
            resolved_import = str(
                (PurePosixPath(target).parent / import_path)
            )
            normalized_parts: list[str] = []
            for part in PurePosixPath(resolved_import).parts:
                if part == '..':
                    if normalized_parts:
                        normalized_parts.pop()
                elif part != '.':
                    normalized_parts.append(part)
            normalized = '/'.join(normalized_parts)
            if normalized not in generated:
                errors.append(
                    f'Missing relative import for {root_id}: '
                    f'{target} -> {import_path} ({normalized})'
                )

    scenario_counts[root_id] = len(generated)

if errors:
    print('\n'.join(errors))
    sys.exit(1)

report = {
    'status': 'passed',
    'registrySchemaVersion': registry.get('schemaVersion'),
    'templateCount': len(descriptors),
    'validatedScenarios': scenario_counts,
    'checks': [
        'registry and manifest JSON parsing',
        'descriptor and manifest ID/version consistency',
        'template dependency existence and cycle detection',
        'template source existence',
        'condition evaluation and token rendering',
        'safe target paths',
        'dependency bundle target conflict detection',
        'generated relative import resolution',
    ],
}
(root / 'STATIC_VALIDATION.json').write_text(json.dumps(report, indent=2) + '\n')
print(f"Validated {len(descriptors)} templates across {len(scenarios)} scenarios")
