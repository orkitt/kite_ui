// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.

import 'package:flutter/material.dart';
import 'package:kite/kite_ui.dart';

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  int _navigationIndex = 0;
  int _page = 2;

  bool _notifications = true;
  bool _acceptedTerms = false;
  bool _compactMode = false;
  bool _showAlert = true;

  double _volume = 68;

  String? _role = 'Designer';
  String? _plan = 'pro';
  Set<String> _filters = {'Popular'};

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Scaffold(
      backgroundColor: colors.background,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('Kite UI'),
        actions: [
          KiteTooltip(
            message: 'Search components',
            child: KiteIconButton(
              icon: Icons.search_rounded,
              tooltip: 'Search',
              onPressed: () {
                KiteToast.show(
                  context,
                  message: 'Component search is ready to connect.',
                  variant: KiteToastVariant.info,
                );
              },
            ),
          ),
          Dimensions.gapH4,
          KiteIconButton(
            icon: Icons.notifications_none_rounded,
            tooltip: 'Notifications',
            variant: KiteIconButtonVariant.soft,
            onPressed: () {
              KiteToast.show(
                context,
                message: 'You are all caught up.',
                variant: KiteToastVariant.success,
              );
            },
          ),
          Dimensions.gapH8,
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: Dimensions.p16,
              sliver: SliverList.list(
                children: [
                  _buildIntro(context),
                  Dimensions.gapV24,
                  _buildBreadcrumb(context),
                  Dimensions.gapV24,
                  if (_showAlert) ...[
                    KiteAlert(
                      title: 'Design system connected',
                      message:
                          'Every component below inherits KiteColors, AppTypography, AppDimensions and AppShapes.',
                      variant: KiteAlertVariant.success,
                      onClose: () => setState(() => _showAlert = false),
                      action: KiteButton(
                        label: 'View guidance',
                        size: KiteButtonSize.small,
                        variant: KiteButtonVariant.ghost,
                        onPressed: () => _showGuidanceSheet(context),
                      ),
                    ),
                    Dimensions.gapV24,
                  ],
                  _SectionTitle(
                    title: 'Quick actions',
                    description:
                        'Horizontal content remains compact and touch friendly.',
                    trailing: const KiteBadge(
                      '4 actions',
                      variant: KiteBadgeVariant.primary,
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: _buildQuickActions(context)),
            SliverPadding(
              padding: Dimensions.p16,
              sliver: SliverList.list(
                children: [
                  Dimensions.gapV8,
                  _buildButtonsCard(context),
                  Dimensions.gapV24,
                  _buildIdentityCard(context),
                  Dimensions.gapV24,
                  _buildFormCard(context),
                  Dimensions.gapV24,
                  _buildSelectionCard(context),
                  Dimensions.gapV24,
                  _buildProgressCard(context),
                  Dimensions.gapV24,
                  _buildCarouselSection(context),
                  Dimensions.gapV24,
                  _buildCalendarCard(context),
                  Dimensions.gapV24,
                  _buildAccordionSection(context),
                  Dimensions.gapV24,
                  _buildTabsSection(context),
                  Dimensions.gapV24,
                  _buildContextMenuSection(context),
                  Dimensions.gapV24,
                  _buildPaginationCard(context),
                  Dimensions.gapV32,
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: KiteBottomNavBar(
        selectedIndex: _navigationIndex,
        onChanged: (value) => setState(() => _navigationIndex = value),
        items: const [
          KiteBottomNavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
          ),
          KiteBottomNavItem(
            label: 'Explore',
            icon: Icons.grid_view_outlined,
            selectedIcon: Icons.grid_view_rounded,
          ),
          KiteBottomNavItem(
            label: 'Saved',
            icon: Icons.bookmark_border_rounded,
            selectedIcon: Icons.bookmark_rounded,
          ),
          KiteBottomNavItem(
            label: 'Profile',
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return KiteAppDrawer(
      selectedIndex: _navigationIndex,
      onDestinationSelected: (index) {
        setState(() => _navigationIndex = index);
        Navigator.of(context).pop();
      },
      header: Row(
        children: [
          const KiteAvatar(name: 'Kite UI'),
          Dimensions.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kite Design System', style: context.typography.title),
                Dimensions.gapV4,
                Text('Component showcase', style: context.typography.caption),
              ],
            ),
          ),
        ],
      ),
      footer: Row(
        children: [
          const KiteAvatar(name: 'AR Rahman'),
          Dimensions.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Demo workspace', style: context.typography.label),
                Text('Premium UI preview', style: context.typography.caption),
              ],
            ),
          ),
        ],
      ),
      destinations: const [
        KiteDrawerDestination(label: 'Overview', icon: Icons.home_outlined),
        KiteDrawerDestination(
          label: 'Components',
          icon: Icons.widgets_outlined,
          badge: '35',
        ),
        KiteDrawerDestination(
          label: 'Patterns',
          icon: Icons.dashboard_customize_outlined,
        ),
        KiteDrawerDestination(
          label: 'Profile',
          icon: Icons.person_outline_rounded,
        ),
      ],
    );
  }

  Widget _buildIntro(BuildContext context) {
    final colors = context.kolors;

    return KiteCard(
      padding: Dimensions.p20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Dimensions.s48,
                height: Dimensions.s48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primarySoft,
                  borderRadius: Dimensions.rad16,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: colors.primary,
                  size: Dimensions.iconMd,
                ),
              ),
              Dimensions.gapH12,
              const Expanded(
                child: Wrap(
                  spacing: Dimensions.s8,
                  runSpacing: Dimensions.s8,
                  alignment: WrapAlignment.end,
                  children: [
                    KiteBadge('Mobile', variant: KiteBadgeVariant.primary),
                    KiteBadge('Theme aware', variant: KiteBadgeVariant.success),
                  ],
                ),
              ),
            ],
          ),
          Dimensions.gapV20,
          Text('Build calm, premium interfaces.', style: context.typography.h1),
          Dimensions.gapV8,
          Text(
            'A practical preview of how Kite components work together without local colors, spacing systems, or one-off component styling.',
            style: context.typography.body.copyWith(
              color: colors.textSecondary,
            ),
          ),
          Dimensions.gapV20,
          Row(
            children: [
              Expanded(
                child: KiteButton(
                  label: 'Open sheet',
                  leading: const Icon(Icons.tune_rounded),
                  expand: true,
                  onPressed: () => _showGuidanceSheet(context),
                ),
              ),
              Dimensions.gapH12,
              KiteIconButton(
                icon: Icons.ios_share_rounded,
                tooltip: 'Share',
                variant: KiteIconButtonVariant.outline,
                onPressed: () {
                  KiteToast.show(
                    context,
                    message: 'Showcase link copied.',
                    variant: KiteToastVariant.success,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    return KiteBreadcrumb(
      items: [
        KiteBreadcrumbItem(label: 'Design system', onTap: () {}),
        KiteBreadcrumbItem(label: 'Components', onTap: () {}),
        const KiteBreadcrumbItem(label: 'Showcase'),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return KiteHorizontalListView(
      children: [
        _QuickActionCard(
          icon: Icons.calendar_month_outlined,
          title: 'Date picker',
          subtitle: 'Choose a date',
          onTap: () => _pickDate(context),
        ),
        _QuickActionCard(
          icon: Icons.schedule_outlined,
          title: 'Time picker',
          subtitle: 'Choose a time',
          onTap: () => _pickTime(context),
        ),
        _QuickActionCard(
          icon: Icons.layers_outlined,
          title: 'Bottom sheet',
          subtitle: 'Open overlay',
          onTap: () => _showGuidanceSheet(context),
        ),
        _QuickActionCard(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Dialog',
          subtitle: 'Confirm action',
          onTap: () => _showConfirmDialog(context),
        ),
      ],
    );
  }

  Widget _buildButtonsCard(BuildContext context) {
    return KiteCard(
      title: 'Buttons',
      subtitle: 'One visual hierarchy, multiple emphasis levels.',
      trailing: const KiteBadge('Actions'),
      child: Wrap(
        spacing: Dimensions.s8,
        runSpacing: Dimensions.s8,
        children: [
          KiteButton(
            label: 'Filled',
            leading: const Icon(Icons.add_rounded),
            onPressed: () => _buttonToast(context, 'Filled'),
          ),
          KiteButton(
            label: 'Outline',
            variant: KiteButtonVariant.outline,
            onPressed: () => _buttonToast(context, 'Outline'),
          ),
          KiteButton(
            label: 'Soft',
            variant: KiteButtonVariant.soft,
            onPressed: () => _buttonToast(context, 'Soft'),
          ),
          KiteButton(
            label: 'Ghost',
            variant: KiteButtonVariant.ghost,
            onPressed: () => _buttonToast(context, 'Ghost'),
          ),
          KiteButton(
            label: 'Danger',
            variant: KiteButtonVariant.danger,
            leading: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _showConfirmDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(BuildContext context) {
    final colors = context.kolors;

    return KiteCard(
      title: 'Identity & status',
      subtitle: 'Avatars and semantic badges stay visually quiet.',
      child: Column(
        children: [
          Row(
            children: [
              KiteAvatar(
                name: 'Maya Chen',
                size: Dimensions.s64,
                badge: Container(
                  width: Dimensions.s16,
                  height: Dimensions.s16,
                  decoration: BoxDecoration(
                    color: colors.success,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.card,
                      width: Dimensions.s2,
                    ),
                  ),
                ),
              ),
              Dimensions.gapH16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Maya Chen', style: context.typography.title),
                    Dimensions.gapV4,
                    Text(
                      'Product designer · Online now',
                      style: context.typography.bodySmall,
                    ),
                  ],
                ),
              ),
              KiteIconButton(
                icon: Icons.more_horiz_rounded,
                tooltip: 'More',
                onPressed: () {},
              ),
            ],
          ),
          Dimensions.gapV16,
          const KiteSeparator(),
          Dimensions.gapV16,
          const Wrap(
            spacing: Dimensions.s8,
            runSpacing: Dimensions.s8,
            children: [
              KiteBadge('Primary', variant: KiteBadgeVariant.primary),
              KiteBadge('Success', variant: KiteBadgeVariant.success),
              KiteBadge('Warning', variant: KiteBadgeVariant.warning),
              KiteBadge('Error', variant: KiteBadgeVariant.error),
              KiteBadge('Info', variant: KiteBadgeVariant.info),
              KiteBadge('Neutral'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return KiteCard(
      title: 'Forms',
      subtitle: 'Inputs inherit the theme instead of restyling themselves.',
      child: Column(
        children: [
          const KiteInput(
            label: 'Email address',
            hint: 'maya@example.com',
            type: KiteInputType.email,
            prefixIcon: Icon(Icons.mail_outline_rounded),
          ),
          Dimensions.gapV12,
          const KiteInput(
            label: 'Password',
            hint: 'Enter your password',
            type: KiteInputType.password,
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
          Dimensions.gapV12,
          KiteDropdown<String>(
            label: 'Role',
            value: _role,
            items: const ['Designer', 'Engineer', 'Founder', 'Student'],
            itemLabel: (value) => value,
            prefixIcon: const Icon(Icons.work_outline_rounded),
            onChanged: (value) => setState(() => _role = value),
          ),
          Dimensions.gapV12,
          KiteTextArea(
            controller: _messageController,
            label: 'About you',
            hint: 'Write a short profile description...',
            maxLength: 180,
          ),
          Dimensions.gapV16,
          Align(
            alignment: Alignment.centerLeft,
            child: Text('OTP preview', style: context.typography.label),
          ),
          Dimensions.gapV8,
          KiteOtpInput(
            length: 4,
            autofocus: false,
            onChanged: (_) {},
            onCompleted: (_) {
              KiteToast.show(
                context,
                message: 'OTP completed.',
                variant: KiteToastVariant.success,
              );
            },
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: KiteButton(
              label: 'Reset',
              variant: KiteButtonVariant.ghost,
              expand: true,
              onPressed: () {
                _messageController.clear();
                setState(() => _role = 'Designer');
              },
            ),
          ),
          Dimensions.gapH12,
          Expanded(
            child: KiteButton(
              label: 'Save changes',
              trailing: const Icon(Icons.arrow_forward_rounded),
              expand: true,
              onPressed: () {
                KiteToast.show(
                  context,
                  message: 'Profile saved successfully.',
                  variant: KiteToastVariant.success,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard(BuildContext context) {
    return KiteCard(
      title: 'Selection controls',
      subtitle: 'Dense controls with comfortable interaction targets.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KiteSwitch(
            value: _notifications,
            label: 'Push notifications',
            description: 'Receive important product and account updates.',
            onChanged: (value) => setState(() => _notifications = value),
          ),
          Dimensions.gapV4,
          KiteCheckbox(
            value: _acceptedTerms,
            label: 'Accept product updates',
            description: 'Occasional emails about meaningful new features.',
            onChanged: (value) =>
                setState(() => _acceptedTerms = value ?? false),
          ),
          Dimensions.gapV16,
          KiteSlider(
            label: 'Notification volume',
            value: _volume,
            min: 0,
            max: 100,

            onChanged: (value) => setState(() => _volume = value),
          ),
          Dimensions.gapV16,
          Text('Plan', style: context.typography.label),
          Dimensions.gapV8,
          KiteRadioGroup<String>(
            value: _plan,
            onChanged: (value) => setState(() => _plan = value),
            options: const [
              KiteRadioOption(
                value: 'free',
                label: 'Free',
                description: 'Essential components for personal projects.',
              ),
              KiteRadioOption(
                value: 'pro',
                label: 'Pro',
                description: 'Advanced patterns for production applications.',
              ),
            ],
          ),
          Dimensions.gapV16,
          Text('Filters', style: context.typography.label),
          Dimensions.gapV8,
          KiteToggleGroup<String>(
            selected: _filters,
            multiSelect: true,
            onChanged: (value) => setState(() => _filters = value),
            items: const [
              KiteToggleGroupItem(
                value: 'New',
                label: 'New',
                icon: Icons.auto_awesome_outlined,
              ),
              KiteToggleGroupItem(
                value: 'Popular',
                label: 'Popular',
                icon: Icons.local_fire_department_outlined,
              ),
              KiteToggleGroupItem(
                value: 'Saved',
                label: 'Saved',
                icon: Icons.bookmark_border_rounded,
              ),
            ],
          ),
          Dimensions.gapV12,
          KiteToggle(
            selected: _compactMode,
            label: 'Compact mode',
            icon: Icons.compress_rounded,
            onChanged: (value) => setState(() => _compactMode = value),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return KiteCard(
      title: 'Progress & loading',
      subtitle: 'Use predictable loading states instead of layout jumps.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const KiteProgress(
            label: 'Component coverage',
            value: .82,
            showValue: true,
          ),
          Dimensions.gapV20,
          Row(
            children: [
              const KiteCircularProgress(value: .72),
              Dimensions.gapH16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Theme validation', style: context.typography.title),
                    Dimensions.gapV4,
                    Text(
                      'Light and dark mode component states.',
                      style: context.typography.bodySmall,
                    ),
                  ],
                ),
              ),
              const KiteBadge('72%', variant: KiteBadgeVariant.info),
            ],
          ),
          Dimensions.gapV20,
          const KiteSeparator(),
          Dimensions.gapV20,
          const KiteSkeletonText(lines: 3),
        ],
      ),
    );
  }

  Widget _buildCarouselSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Carousel',
          description: 'Product-style cards with restrained visual emphasis.',
        ),
        Dimensions.gapV12,
        KiteCarousel(
          children: [
            _CarouselCard(
              icon: Icons.palette_outlined,
              badge: 'Foundation',
              title: 'Semantic colors',
              description:
                  'Design with meaning: primary, card, muted, borders and status roles.',
              variant: KiteBadgeVariant.primary,
            ),
            _CarouselCard(
              icon: Icons.text_fields_rounded,
              badge: 'Typography',
              title: 'Clear hierarchy',
              description:
                  'A small semantic type scale keeps complex screens calm and readable.',
              variant: KiteBadgeVariant.info,
            ),
            _CarouselCard(
              icon: Icons.space_bar_rounded,
              badge: 'Layout',
              title: 'Consistent rhythm',
              description:
                  'AppDimensions keeps spacing and touch targets predictable everywhere.',
              variant: KiteBadgeVariant.success,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarCard(BuildContext context) {
    return KiteCard(
      title: 'Calendar & pickers',
      subtitle: 'Native behavior with Kite visual defaults.',
      trailing: KiteBadge(
        _formatDate(_selectedDate),
        variant: KiteBadgeVariant.primary,
      ),
      child: Column(
        children: [
          KiteCalendar(
            selectedDate: _selectedDate,
            onDateChanged: (date) => setState(() => _selectedDate = date),
          ),
          Dimensions.gapV16,
          Row(
            children: [
              Expanded(
                child: KiteButton(
                  label: 'Pick date',
                  variant: KiteButtonVariant.outline,
                  leading: const Icon(Icons.calendar_month_outlined),
                  expand: true,
                  onPressed: () => _pickDate(context),
                ),
              ),
              Dimensions.gapH12,
              Expanded(
                child: KiteButton(
                  label: _selectedTime.format(context),
                  variant: KiteButtonVariant.soft,
                  leading: const Icon(Icons.schedule_outlined),
                  expand: true,
                  onPressed: () => _pickTime(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Accordion',
          description: 'Progressively disclose secondary information.',
        ),
        Dimensions.gapV12,
        KiteAccordion(
          initiallyExpandedIndex: 0,
          items: [
            KiteAccordionItem(
              title: 'Why semantic colors?',
              leading: Icon(
                Icons.palette_outlined,
                color: context.kolors.primary,
              ),
              content: Text(
                'Semantic names keep feature code focused on purpose instead of Material surface levels or raw hex values.',
                style: context.typography.bodySmall,
              ),
            ),
            KiteAccordionItem(
              title: 'Why centralized dimensions?',
              leading: Icon(
                Icons.straighten_rounded,
                color: context.kolors.primary,
              ),
              content: Text(
                'A shared spacing grid prevents each feature from inventing its own visual rhythm.',
                style: context.typography.bodySmall,
              ),
            ),
            KiteAccordionItem(
              title: 'When should I customize a component?',
              leading: Icon(Icons.tune_rounded, color: context.kolors.primary),
              content: Text(
                'Customize behavior and content first. Only introduce a new visual rule when it is reusable across the product.',
                style: context.typography.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabsSection(BuildContext context) {
    return KiteCard(
      title: 'Tabs',
      subtitle: 'A bounded area for related content views.',
      child: SizedBox(
        height: Dimensions.s64 * 4,
        child: KiteTabs(
          items: [
            KiteTabItem(
              label: 'Overview',
              icon: Icons.dashboard_outlined,
              child: Padding(
                padding: Dimensions.p16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Component health', style: context.typography.title),
                    Dimensions.gapV8,
                    const KiteProgress(value: .88, showValue: true),
                    Dimensions.gapV16,
                    Text(
                      'The theme is carrying most visual decisions, leaving components focused on behavior and composition.',
                      style: context.typography.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            KiteTabItem(
              label: 'Activity',
              icon: Icons.history_rounded,
              child: ListView(
                padding: Dimensions.p16,
                children: const [
                  _ActivityRow(
                    icon: Icons.check_circle_outline_rounded,
                    title: 'Button variants validated',
                    time: '2 min ago',
                  ),
                  _ActivityRow(
                    icon: Icons.palette_outlined,
                    title: 'Dark mode palette applied',
                    time: '8 min ago',
                  ),
                  _ActivityRow(
                    icon: Icons.space_bar_rounded,
                    title: 'Spacing rhythm checked',
                    time: '14 min ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Context menu',
          description: 'Long press the card on mobile to reveal actions.',
        ),
        Dimensions.gapV12,
        KiteContextMenu<String>(
          items: const [
            KiteContextMenuItem(
              value: 'edit',
              label: 'Edit component',
              icon: Icons.edit_outlined,
            ),
            KiteContextMenuItem(
              value: 'duplicate',
              label: 'Duplicate',
              icon: Icons.copy_rounded,
            ),
            KiteContextMenuItem(
              value: 'delete',
              label: 'Delete',
              icon: Icons.delete_outline_rounded,
              destructive: true,
            ),
          ],
          onSelected: (value) {
            KiteToast.show(
              context,
              message: 'Context action: $value',
              variant: value == 'delete'
                  ? KiteToastVariant.warning
                  : KiteToastVariant.info,
            );
          },
          child: KiteCard(
            leading: const KiteAvatar(name: 'Context Demo'),
            title: 'Long press this card',
            subtitle: 'Desktop also supports secondary click.',
            trailing: const KiteBadge('Interactive'),
            child: Text(
              'The context menu remains outside the card implementation, so cards stay reusable and behavior stays composable.',
              style: context.typography.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationCard(BuildContext context) {
    return KiteCard(
      title: 'Pagination',
      subtitle: 'Compact page navigation for lists and data views.',
      child: Center(
        child: KitePagination(
          page: _page,
          totalPages: 8,
          onPageChanged: (value) => setState(() => _page = value),
        ),
      ),
      footer: Row(
        children: [
          const KiteBadge('Ready', variant: KiteBadgeVariant.success),
          Dimensions.gapH8,
          Expanded(
            child: Text('Page $_page of 8', style: context.typography.caption),
          ),
          KiteButton(
            label: 'Show toast',
            size: KiteButtonSize.small,
            variant: KiteButtonVariant.soft,
            onPressed: () {
              KiteToast.show(
                context,
                message: 'Kite components are working together nicely.',
                variant: KiteToastVariant.success,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await KiteDatePicker.show(
      context,
      initialDate: _selectedDate,
      helpText: 'Choose showcase date',
    );

    if (date == null || !mounted) return;
    setState(() => _selectedDate = date);
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await KiteTimePicker.show(
      context,
      initialTime: _selectedTime,
      helpText: 'Choose showcase time',
    );

    if (time == null || !mounted) return;
    setState(() => _selectedTime = time);
  }

  Future<void> _showConfirmDialog(BuildContext context) async {
    final confirmed = await KiteDialog.confirm(
      context,
      title: 'Confirm action',
      message:
          'This dialog is using your central dialog theme, typography and semantic colors.',
      confirmLabel: 'Continue',
    );

    if (!mounted || !confirmed) return;

    KiteToast.show(
      context,
      message: 'Action confirmed.',
      variant: KiteToastVariant.success,
    );
  }

  Future<void> _showGuidanceSheet(BuildContext context) async {
    await KiteSheet.show<void>(
      context,
      title: 'Premium UI guidance',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const KiteAlert(
            title: 'Keep hierarchy quiet',
            message:
                'Use card and muted surfaces for structure. Reserve primary and status colors for meaning.',
            variant: KiteAlertVariant.info,
          ),
          Dimensions.gapV16,
          const KiteProgress(
            label: 'Design-system adoption',
            value: .86,
            showValue: true,
          ),
          Dimensions.gapV20,
          KiteButton(
            label: 'Looks good',
            expand: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _buttonToast(BuildContext context, String variant) {
    KiteToast.show(
      context,
      message: '$variant button pressed.',
      variant: KiteToastVariant.info,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.description,
    this.trailing,
  });

  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.typography.h2),
              Dimensions.gapV4,
              Text(description, style: context.typography.bodySmall),
            ],
          ),
        ),
        if (trailing != null) ...[Dimensions.gapH12, trailing!],
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return SizedBox(
      width: Dimensions.s64 * 2 + Dimensions.s48,
      child: KiteCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Dimensions.s40,
              height: Dimensions.s40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primarySoft,
                borderRadius: Dimensions.rad12,
              ),
              child: Icon(icon, color: colors.primary, size: Dimensions.iconMd),
            ),
            Dimensions.gapV16,
            Text(title, style: context.typography.title),
            Dimensions.gapV4,
            Text(subtitle, style: context.typography.caption),
          ],
        ),
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.icon,
    required this.badge,
    required this.title,
    required this.description,
    required this.variant,
  });

  final IconData icon;
  final String badge;
  final String title;
  final String description;
  final KiteBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return KiteCard(
      padding: Dimensions.p20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Dimensions.s48,
                height: Dimensions.s48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primarySoft,
                  borderRadius: Dimensions.rad16,
                ),
                child: Icon(icon, color: colors.primary),
              ),
              const Spacer(),
              KiteBadge(badge, variant: variant),
            ],
          ),
          const Spacer(),
          Text(title, style: context.typography.h3),
          Dimensions.gapV8,
          Text(description, style: context.typography.bodySmall),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.time,
  });

  final IconData icon;
  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Padding(
      padding: Dimensions.py8,
      child: Row(
        children: [
          Container(
            width: Dimensions.s40,
            height: Dimensions.s40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primarySoft,
              borderRadius: Dimensions.rad12,
            ),
            child: Icon(icon, color: colors.primary, size: Dimensions.iconSm),
          ),
          Dimensions.gapH12,
          Expanded(child: Text(title, style: context.typography.bodySmall)),
          Dimensions.gapH12,
          Text(time, style: context.typography.caption),
        ],
      ),
    );
  }
}
