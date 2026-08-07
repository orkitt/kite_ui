import 'package:flutter/material.dart';
import 'package:kite_todo_example/core/design/design.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StoreHomePage extends StatelessWidget {
  const StoreHomePage({
    super.key,
    this.selectedNavigationIndex = 0,
    this.onNavigationChanged,
  });

  final int selectedNavigationIndex;
  final ValueChanged<int>? onNavigationChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: _StoreHeader()),

            const SliverToBoxAdapter(
              child: _ResponsiveContent(child: _SearchBar()),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: _StoreUi.sectionGap),
            ),

            const SliverToBoxAdapter(
              child: _ResponsiveContent(child: _HeroBanner()),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: _StoreUi.largeSectionGap),
            ),

            const SliverToBoxAdapter(
              child: _ResponsiveContent(child: _CategoriesSection()),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: _StoreUi.largeSectionGap),
            ),

            const SliverToBoxAdapter(
              child: _ResponsiveContent(child: _FeaturedSection()),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: _StoreUi.largeSectionGap),
            ),

            const SliverToBoxAdapter(
              child: _ResponsiveContent(child: _PromotionBanner()),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: _StoreUi.largeSectionGap),
            ),

            const SliverToBoxAdapter(
              child: _ResponsiveContent(child: _PopularProductsSection()),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: _StoreUi.bottomContentSpace),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _StoreNavigationBar(
        selectedIndex: selectedNavigationIndex,
        onChanged: onNavigationChanged,
      ),
    );
  }
}

// =============================================================================
// HEADER
// =============================================================================

class _StoreHeader extends StatelessWidget {
  const _StoreHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final textTheme = context.typography;

    return _ResponsiveContent(
      child: Padding(
        padding: const EdgeInsets.only(
          top: _StoreUi.headerTopPadding,
          bottom: _StoreUi.headerBottomPadding,
        ),
        child: Row(
          children: [
            Container(
              width: _StoreUi.brandIconSize,
              height: _StoreUi.brandIconSize,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(_StoreUi.brandRadius),
              ),
              child: Icon(
                LucideIcons.shoppingBag,
                color: colors.onPrimary,
                size: _StoreUi.brandGlyphSize,
              ),
            ),

            const SizedBox(width: _StoreUi.smallGap),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NOVA',
                    style: textTheme.h2.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    'Modern essentials',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            _HeaderIconButton(
              icon: LucideIcons.bell,
              onPressed: () {},
              showIndicator: true,
            ),

            const SizedBox(width: _StoreUi.tinyGap),

            _HeaderIconButton(icon: LucideIcons.shoppingCart, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
    this.showIndicator = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: colors.card,
            foregroundColor: colors.icon,
            side: BorderSide(color: colors.borderSoft),
          ),
          icon: Icon(icon),
        ),
        if (showIndicator)
          Positioned(
            right: _StoreUi.indicatorOffset,
            top: _StoreUi.indicatorOffset,
            child: Container(
              width: _StoreUi.indicatorSize,
              height: _StoreUi.indicatorSize,
              decoration: BoxDecoration(
                color: colors.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.card,
                  width: _StoreUi.indicatorBorderWidth,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// =============================================================================
// SEARCH
// =============================================================================

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products',
              prefixIcon: const Icon(LucideIcons.search),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(LucideIcons.scanLine),
              ),
            ),
          ),
        ),

        const SizedBox(width: _StoreUi.smallGap),

        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            minimumSize: const Size.square(_StoreUi.filterButtonSize),
          ),
          icon: const Icon(LucideIcons.slidersHorizontal),
        ),
      ],
    );
  }
}

// =============================================================================
// HERO
// =============================================================================

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final tt = context.typography;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < _StoreUi.heroBreakpoint;

        return Container(
          constraints: const BoxConstraints(minHeight: _StoreUi.heroMinHeight),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.primarySoft,
            borderRadius: BorderRadius.circular(_StoreUi.heroRadius),
            border: Border.all(
              color: colors.primary.withValues(
                alpha: _StoreUi.heroBorderOpacity,
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -_StoreUi.heroDecorationOffset,
                top: -_StoreUi.heroDecorationOffset,
                child: Container(
                  width: _StoreUi.heroCircleLarge,
                  height: _StoreUi.heroCircleLarge,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(
                      alpha: _StoreUi.heroCircleOpacity,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                right: _StoreUi.heroSmallCircleRight,
                bottom: -_StoreUi.heroSmallCircleBottom,
                child: Container(
                  width: _StoreUi.heroCircleSmall,
                  height: _StoreUi.heroCircleSmall,
                  decoration: BoxDecoration(
                    color: colors.secondarySoft,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(
                  compact ? _StoreUi.heroPaddingCompact : _StoreUi.heroPadding,
                ),
                child: compact ? _HeroCompactContent() : _HeroWideContent(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroCompactContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h2 = context.typography.h2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeroBadge(),

        const SizedBox(height: _StoreUi.mediumGap),

        _HeroTitle(style: h2),

        const SizedBox(height: _StoreUi.smallGap),

        const _HeroDescription(),

        const SizedBox(height: _StoreUi.largeGap),

        const _HeroAction(),

        const SizedBox(height: _StoreUi.largeGap),

        const Align(alignment: Alignment.center, child: _HeroProductVisual()),
      ],
    );
  }
}

class _HeroWideContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final h2 = context.typography.h2;
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _HeroBadge(),

              const SizedBox(height: _StoreUi.mediumGap),

              _HeroTitle(style: h2),

              const SizedBox(height: _StoreUi.smallGap),

              const _HeroDescription(),

              const SizedBox(height: _StoreUi.largeGap),

              const _HeroAction(),
            ],
          ),
        ),

        const SizedBox(width: _StoreUi.largeGap),

        const Expanded(flex: 4, child: Center(child: _HeroProductVisual())),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _StoreUi.badgeHorizontalPadding,
        vertical: _StoreUi.badgeVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(_StoreUi.badgeRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.sparkles,
            size: _StoreUi.badgeIconSize,
            color: colors.primary,
          ),
          const SizedBox(width: _StoreUi.tinyGap),
          Text(
            'NEW COLLECTION',
            style: context.typography.label.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle({required this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Text(
      'Less noise.\nBetter essentials.',
      style: style?.copyWith(
        color: colors.textPrimary,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
    );
  }
}

class _HeroDescription extends StatelessWidget {
  const _HeroDescription();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: _StoreUi.heroDescriptionWidth,
      ),
      child: Text(
        'Carefully selected everyday products built around quality, function, and timeless design.',
        style: context.typography.body.copyWith(
          color: context.kolors.textSecondary,
        ),
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction();

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {},
      iconAlignment: IconAlignment.end,
      icon: const Icon(LucideIcons.arrowRight),
      label: const Text('Explore collection'),
    );
  }
}

class _HeroProductVisual extends StatelessWidget {
  const _HeroProductVisual();

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Container(
      width: _StoreUi.heroVisualSize,
      height: _StoreUi.heroVisualSize,
      decoration: BoxDecoration(
        color: colors.card.withValues(alpha: _StoreUi.heroVisualOpacity),
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.card,
          width: _StoreUi.heroVisualBorder,
        ),
      ),
      child: Center(
        child: Transform.rotate(
          angle: _StoreUi.heroVisualRotation,
          child: Icon(
            LucideIcons.headphones,
            size: _StoreUi.heroProductIconSize,
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// CATEGORIES
// =============================================================================

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  static const categories = [
    _StoreCategory(name: 'Audio', icon: LucideIcons.headphones),
    _StoreCategory(name: 'Wearables', icon: LucideIcons.watch),
    _StoreCategory(name: 'Tech', icon: LucideIcons.smartphone),
    _StoreCategory(name: 'Gaming', icon: LucideIcons.gamepad2),
    _StoreCategory(name: 'Travel', icon: LucideIcons.backpack),
    _StoreCategory(name: 'Workspace', icon: LucideIcons.laptop),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionHeader(
          title: 'Shop by category',
          subtitle: 'Find what fits your everyday.',
        ),

        const SizedBox(height: _StoreUi.sectionContentGap),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (int index = 0; index < categories.length; index++) ...[
                _CategoryCard(category: categories[index]),
                if (index != categories.length - 1)
                  const SizedBox(width: _StoreUi.smallGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final _StoreCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(_StoreUi.categoryRadius),
      child: Container(
        width: _StoreUi.categoryWidth,
        padding: const EdgeInsets.all(_StoreUi.categoryPadding),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(_StoreUi.categoryRadius),
          border: Border.all(color: colors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: _StoreUi.categoryIconContainer,
              height: _StoreUi.categoryIconContainer,
              decoration: BoxDecoration(
                color: colors.primarySoft,
                borderRadius: BorderRadius.circular(
                  _StoreUi.categoryIconRadius,
                ),
              ),
              child: Icon(
                category.icon,
                color: colors.primary,
                size: _StoreUi.categoryIconSize,
              ),
            ),

            const SizedBox(height: _StoreUi.mediumGap),

            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typography.h3,
            ),

            const SizedBox(height: _StoreUi.tinyGap),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Explore',
                    style: context.typography.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  LucideIcons.arrowUpRight,
                  size: _StoreUi.smallIconSize,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// FEATURED
// =============================================================================

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(
          title: 'Featured picks',
          subtitle: 'Our current favorites.',
          actionLabel: 'See all',
          onActionPressed: () {},
        ),

        const SizedBox(height: _StoreUi.sectionContentGap),

        SizedBox(
          height: _StoreUi.featuredCardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _StoreProducts.featured.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: _StoreUi.mediumGap);
            },
            itemBuilder: (context, index) {
              return SizedBox(
                width: _StoreUi.featuredCardWidth,
                child: _ProductCard(
                  product: _StoreProducts.featured[index],
                  featured: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// PROMOTION
// =============================================================================

class _PromotionBanner extends StatelessWidget {
  const _PromotionBanner();

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Container(
      padding: const EdgeInsets.all(_StoreUi.promotionPadding),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(_StoreUi.promotionRadius),
        border: Border.all(color: colors.borderSoft),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < _StoreUi.promotionBreakpoint;

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Member exclusive',
                style: context.typography.label.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: _StoreUi.smallGap),

              Text(
                'Get 20% off your\nnext purchase.',
                style: context.typography.h3.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.35,
                ),
              ),

              const SizedBox(height: _StoreUi.smallGap),

              Text(
                'Join NOVA+ and unlock member pricing, early drops and free delivery.',
                style: context.typography.body.copyWith(
                  color: colors.textSecondary,
                ),
              ),

              const SizedBox(height: _StoreUi.mediumGap),

              TextButton.icon(
                onPressed: () {},
                iconAlignment: IconAlignment.end,
                label: const Text('Learn more'),
                icon: const Icon(LucideIcons.arrowRight),
              ),
            ],
          );

          final visual = Container(
            width: _StoreUi.promotionVisualSize,
            height: _StoreUi.promotionVisualSize,
            decoration: BoxDecoration(
              color: colors.card,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.gift,
              size: _StoreUi.promotionIconSize,
              color: colors.primary,
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                visual,
                const SizedBox(height: _StoreUi.largeGap),
                content,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: content),
              const SizedBox(width: _StoreUi.largeGap),
              visual,
            ],
          );
        },
      ),
    );
  }
}

// =============================================================================
// POPULAR PRODUCTS
// =============================================================================

class _PopularProductsSection extends StatelessWidget {
  const _PopularProductsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(
          title: 'Popular right now',
          subtitle: 'Products people keep coming back for.',
          actionLabel: 'View all',
          onActionPressed: () {},
        ),

        const SizedBox(height: _StoreUi.sectionContentGap),

        LayoutBuilder(
          builder: (context, constraints) {
            final columns = _resolveGridColumns(constraints.maxWidth);

            return GridView.builder(
              itemCount: _StoreProducts.popular.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: _StoreUi.gridGap,
                mainAxisSpacing: _StoreUi.gridGap,
                mainAxisExtent: _StoreUi.productCardHeight,
              ),
              itemBuilder: (context, index) {
                return _ProductCard(product: _StoreProducts.popular[index]);
              },
            );
          },
        ),
      ],
    );
  }

  int _resolveGridColumns(double width) {
    if (width >= _StoreUi.desktopGridBreakpoint) {
      return 4;
    }

    if (width >= _StoreUi.tabletGridBreakpoint) {
      return 3;
    }

    return 2;
  }
}

// =============================================================================
// PRODUCT CARD
// =============================================================================

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, this.featured = false});

  final _StoreProduct product;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(_StoreUi.productRadius),
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(_StoreUi.productRadius),
          border: Border.all(color: colors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ProductVisual(product: product)),

            Padding(
              padding: const EdgeInsets.all(_StoreUi.productContentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.tag != null) ...[
                    Text(
                      product.tag!,
                      style: context.typography.label.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: _StoreUi.tinyGap),
                  ],

                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: _StoreUi.tinyGap),

                  Text(
                    product.description,
                    maxLines: featured ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: _StoreUi.mediumGap),

                  Row(
                    children: [
                      Expanded(child: _ProductPrice(product: product)),

                      Container(
                        width: _StoreUi.addButtonSize,
                        height: _StoreUi.addButtonSize,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(
                            _StoreUi.addButtonRadius,
                          ),
                        ),
                        child: Icon(
                          LucideIcons.plus,
                          size: _StoreUi.addButtonIconSize,
                          color: colors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductVisual extends StatelessWidget {
  const _ProductVisual({required this.product});

  final _StoreProduct product;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Container(
      margin: const EdgeInsets.all(_StoreUi.productVisualMargin),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(_StoreUi.productVisualRadius),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: _StoreUi.productIconBackgroundSize,
              height: _StoreUi.productIconBackgroundSize,
              decoration: BoxDecoration(
                color: colors.card,
                shape: BoxShape.circle,
              ),
              child: Icon(
                product.icon,
                size: _StoreUi.productIconSize,
                color: colors.primary,
              ),
            ),
          ),

          Positioned(
            top: _StoreUi.productActionInset,
            right: _StoreUi.productActionInset,
            child: Material(
              color: colors.card,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () {},
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(_StoreUi.favoritePadding),
                  child: Icon(
                    product.isFavorite ? LucideIcons.heart : LucideIcons.heart,
                    size: _StoreUi.favoriteIconSize,
                    color: product.isFavorite ? colors.error : colors.icon,
                  ),
                ),
              ),
            ),
          ),

          if (product.discount != null)
            Positioned(
              top: _StoreUi.productActionInset,
              left: _StoreUi.productActionInset,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: _StoreUi.discountHorizontalPadding,
                  vertical: _StoreUi.discountVerticalPadding,
                ),
                decoration: BoxDecoration(
                  color: colors.errorSoft,
                  borderRadius: BorderRadius.circular(_StoreUi.discountRadius),
                ),
                child: Text(
                  product.discount!,
                  style: context.typography.label.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductPrice extends StatelessWidget {
  const _ProductPrice({required this.product});

  final _StoreProduct product;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: _StoreUi.priceGap,
      children: [
        Text(
          '\$${product.price.toStringAsFixed(0)}',
          style: context.typography.h3.copyWith(fontWeight: FontWeight.w800),
        ),
        if (product.oldPrice != null)
          Text(
            '\$${product.oldPrice!.toStringAsFixed(0)}',
            style: context.typography.bodySmall?.copyWith(
              color: colors.textDisabled,
              decoration: TextDecoration.lineThrough,
              decorationColor: colors.textDisabled,
            ),
          ),
      ],
    );
  }
}

// =============================================================================
// SECTION HEADER
// =============================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.typography.h1.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: _StoreUi.tinyGap),
              Text(
                subtitle,
                style: context.typography.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        if (actionLabel != null)
          TextButton(onPressed: onActionPressed, child: Text(actionLabel!)),
      ],
    );
  }
}

// =============================================================================
// NAVIGATION
// =============================================================================

class _StoreNavigationBar extends StatelessWidget {
  const _StoreNavigationBar({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onChanged,
      destinations: const [
        NavigationDestination(icon: Icon(LucideIcons.house), label: 'Home'),
        NavigationDestination(
          icon: Icon(LucideIcons.layoutGrid),
          label: 'Browse',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.shoppingBag),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.userRound),
          label: 'Profile',
        ),
      ],
    );
  }
}

// =============================================================================
// RESPONSIVE CONTENT
// =============================================================================

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = _horizontalPadding(constraints.maxWidth);

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _StoreUi.maxContentWidth,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: child,
            ),
          ),
        );
      },
    );
  }

  double _horizontalPadding(double width) {
    if (width >= _StoreUi.desktopBreakpoint) {
      return _StoreUi.desktopPadding;
    }

    if (width >= _StoreUi.tabletBreakpoint) {
      return _StoreUi.tabletPadding;
    }

    return _StoreUi.mobilePadding;
  }
}

// =============================================================================
// MODELS
// =============================================================================

class _StoreCategory {
  const _StoreCategory({required this.name, required this.icon});

  final String name;
  final IconData icon;
}

class _StoreProduct {
  const _StoreProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    this.oldPrice,
    this.discount,
    this.tag,
    this.isFavorite = false,
  });

  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String? discount;
  final String? tag;
  final IconData icon;
  final bool isFavorite;
}

// =============================================================================
// MOCK DATA
// =============================================================================

abstract final class _StoreProducts {
  static const featured = [
    _StoreProduct(
      name: 'Studio Pro',
      description: 'Premium wireless headphones',
      price: 249,
      oldPrice: 299,
      discount: '-17%',
      tag: 'BEST SELLER',
      icon: LucideIcons.headphones,
      isFavorite: true,
    ),
    _StoreProduct(
      name: 'Nova Watch',
      description: 'Minimal smart wearable',
      price: 189,
      tag: 'NEW',
      icon: LucideIcons.watch,
    ),
    _StoreProduct(
      name: 'Urban Pack',
      description: 'Daily carry backpack',
      price: 94,
      oldPrice: 119,
      discount: '-21%',
      icon: LucideIcons.backpack,
    ),
  ];

  static const popular = [
    _StoreProduct(
      name: 'Pocket Speaker',
      description: 'Portable wireless audio',
      price: 79,
      icon: LucideIcons.speaker,
    ),
    _StoreProduct(
      name: 'Nova Watch',
      description: 'Smart everyday wearable',
      price: 189,
      icon: LucideIcons.watch,
      isFavorite: true,
    ),
    _StoreProduct(
      name: 'Urban Pack',
      description: 'Minimal daily carry',
      price: 94,
      icon: LucideIcons.backpack,
    ),
    _StoreProduct(
      name: 'Game One',
      description: 'Wireless game controller',
      price: 69,
      oldPrice: 89,
      discount: '-22%',
      icon: LucideIcons.gamepad2,
    ),
    _StoreProduct(
      name: 'Desk Hub',
      description: 'Compact USB-C workstation',
      price: 129,
      icon: LucideIcons.laptop,
    ),
    _StoreProduct(
      name: 'Studio Pro',
      description: 'Wireless over-ear audio',
      price: 249,
      oldPrice: 299,
      discount: '-17%',
      icon: LucideIcons.headphones,
    ),
    _StoreProduct(
      name: 'Pocket Mini',
      description: 'Compact everyday phone',
      price: 499,
      icon: LucideIcons.smartphone,
    ),
    _StoreProduct(
      name: 'Travel Case',
      description: 'Organized tech essentials',
      price: 59,
      icon: LucideIcons.briefcaseBusiness,
    ),
  ];
}

// =============================================================================
// UI TOKENS
// =============================================================================

abstract final class _StoreUi {
  // Layout
  static const double maxContentWidth = 1360;

  static const double mobilePadding = 16;
  static const double tabletPadding = 24;
  static const double desktopPadding = 32;

  static const double tabletBreakpoint = 720;
  static const double desktopBreakpoint = 1100;

  // Spacing
  static const double tinyGap = 6;
  static const double smallGap = 10;
  static const double mediumGap = 14;
  static const double largeGap = 22;

  static const double sectionGap = 20;
  static const double sectionContentGap = 18;
  static const double largeSectionGap = 34;

  static const double gridGap = 14;
  static const double priceGap = 6;

  static const double bottomContentSpace = 36;

  // Header
  static const double headerTopPadding = 10;
  static const double headerBottomPadding = 14;

  static const double brandIconSize = 42;
  static const double brandGlyphSize = 20;
  static const double brandRadius = 12;

  static const double indicatorOffset = 6;
  static const double indicatorSize = 8;
  static const double indicatorBorderWidth = 2;

  // Search
  static const double filterButtonSize = 46;

  // Hero
  static const double heroBreakpoint = 760;

  static const double heroMinHeight = 290;
  static const double heroRadius = 22;

  static const double heroPadding = 32;
  static const double heroPaddingCompact = 22;

  static const double heroDescriptionWidth = 470;

  static const double heroDecorationOffset = 70;

  static const double heroCircleLarge = 240;
  static const double heroCircleSmall = 130;

  static const double heroSmallCircleRight = 80;
  static const double heroSmallCircleBottom = 45;

  static const double heroCircleOpacity = 0.08;
  static const double heroBorderOpacity = 0.14;

  static const double heroVisualSize = 190;
  static const double heroVisualOpacity = 0.72;
  static const double heroVisualBorder = 8;
  static const double heroVisualRotation = -0.10;
  static const double heroProductIconSize = 86;

  // Badge
  static const double badgeHorizontalPadding = 10;
  static const double badgeVerticalPadding = 6;
  static const double badgeRadius = 999;
  static const double badgeIconSize = 14;

  // Categories
  static const double categoryWidth = 150;
  static const double categoryPadding = 14;
  static const double categoryRadius = 16;

  static const double categoryIconContainer = 42;
  static const double categoryIconRadius = 11;
  static const double categoryIconSize = 20;

  static const double smallIconSize = 16;

  // Featured
  static const double featuredCardWidth = 270;
  static const double featuredCardHeight = 350;

  // Promotion
  static const double promotionBreakpoint = 640;
  static const double promotionPadding = 24;
  static const double promotionRadius = 20;

  static const double promotionVisualSize = 120;
  static const double promotionIconSize = 46;

  // Product
  static const double productCardHeight = 310;
  static const double productRadius = 16;
  static const double productContentPadding = 14;

  static const double productVisualMargin = 8;
  static const double productVisualRadius = 12;

  static const double productIconBackgroundSize = 92;
  static const double productIconSize = 42;

  static const double productActionInset = 10;

  static const double favoritePadding = 8;
  static const double favoriteIconSize = 17;

  static const double discountHorizontalPadding = 8;
  static const double discountVerticalPadding = 5;
  static const double discountRadius = 8;

  static const double addButtonSize = 34;
  static const double addButtonRadius = 9;
  static const double addButtonIconSize = 17;

  // Grid
  static const double tabletGridBreakpoint = 720;
  static const double desktopGridBreakpoint = 1080;
}
