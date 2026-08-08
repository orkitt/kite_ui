enum RouteTargetKind { root, branch }

final class RouteTarget {
  const RouteTarget.root() : kind = RouteTargetKind.root, branch = null;

  const RouteTarget.branch(String branch)
    : kind = RouteTargetKind.branch,
      branch = branch;

  final RouteTargetKind kind;
  final String? branch;

  bool get isRoot => kind == RouteTargetKind.root;
}
