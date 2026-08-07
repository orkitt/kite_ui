import 'package:flutter/material.dart';
import 'package:kite_todo_example/core/design/design.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SocialHomePage extends StatelessWidget {
  const SocialHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: _HomeHeader()),

            const SliverToBoxAdapter(child: _StoriesSection()),

            const SliverToBoxAdapter(child: Divider()),

            const SliverToBoxAdapter(child: _CreatePostCard()),

            const SliverToBoxAdapter(child: SizedBox(height: Dimensions.s8)),

            SliverList.separated(
              itemCount: DemoSocialData.posts.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: Dimensions.s8);
              },
              itemBuilder: (context, index) {
                return _PostCard(post: DemoSocialData.posts[index]);
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: Dimensions.s32)),
          ],
        ),
      ),
      bottomNavigationBar: const _SocialNavigation(),
    );
  }
}

// =============================================================================
// Header
// =============================================================================

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final typography = context.typography;

    return Padding(
      padding: Dimensions.px16y12,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: Dimensions.s40,
                  height: Dimensions.s40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: Dimensions.rad12,
                  ),
                  child: Icon(
                    LucideIcons.sparkles,
                    size: Dimensions.iconMd,
                    color: colors.onPrimary,
                  ),
                ),
                Dimensions.gapH12,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kite',
                      style: typography.title.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text('Your community', style: typography.caption),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            tooltip: 'Search',
            icon: const Icon(LucideIcons.search),
          ),

          Dimensions.gapH4,

          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                tooltip: 'Notifications',
                icon: const Icon(LucideIcons.bell),
              ),
              Positioned(
                right: Dimensions.s8,
                top: Dimensions.s8,
                child: Container(
                  width: Dimensions.s8,
                  height: Dimensions.s8,
                  decoration: BoxDecoration(
                    color: colors.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.background,
                      width: Dimensions.s2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Stories
// =============================================================================

class _StoriesSection extends StatelessWidget {
  const _StoriesSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        padding: Dimensions.px16,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: DemoSocialData.stories.length,
        separatorBuilder: (_, _) => Dimensions.gapH12,
        itemBuilder: (context, index) {
          final story = DemoSocialData.stories[index];

          return _StoryItem(story: story, isCurrentUser: index == 0);
        },
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  const _StoryItem({required this.story, this.isCurrentUser = false});

  final SocialStory story;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final typography = context.typography;

    return SizedBox(
      width: Dimensions.s64,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: Dimensions.s64,
                height: Dimensions.s64,
                padding: const EdgeInsets.all(Dimensions.s2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: story.hasNewStory ? colors.primary : colors.border,
                    width: Dimensions.s2,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.s2),
                  decoration: BoxDecoration(
                    color: colors.background,
                    shape: BoxShape.circle,
                  ),
                  child: _AvatarImage(url: story.avatarUrl),
                ),
              ),

              if (isCurrentUser)
                Positioned(
                  right: Dimensions.zero,
                  bottom: Dimensions.zero,
                  child: Container(
                    width: Dimensions.s24,
                    height: Dimensions.s24,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.background,
                        width: Dimensions.s2,
                      ),
                    ),
                    child: Icon(
                      LucideIcons.plus,
                      size: Dimensions.iconSm,
                      color: colors.onPrimary,
                    ),
                  ),
                ),
            ],
          ),

          Dimensions.gapV8,

          Text(
            isCurrentUser ? 'Your story' : story.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: typography.caption.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Create Post
// =============================================================================

class _CreatePostCard extends StatelessWidget {
  const _CreatePostCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final typography = context.typography;

    return Padding(
      padding: Dimensions.p16,
      child: Container(
        padding: Dimensions.p16,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: Dimensions.rad16,
          border: Border.all(color: colors.borderSoft),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: Dimensions.s40,
                  height: Dimensions.s40,
                  child: _AvatarImage(
                    url:
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                  ),
                ),

                Dimensions.gapH12,

                Expanded(
                  child: InkWell(
                    onTap: () {},
                    borderRadius: Dimensions.radFull,
                    child: Container(
                      padding: Dimensions.px16y12,
                      decoration: BoxDecoration(
                        color: colors.muted,
                        borderRadius: Dimensions.radFull,
                      ),
                      child: Text(
                        'Share something with your community...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Dimensions.gapV12,

            Divider(color: colors.borderSoft),

            Dimensions.gapV8,

            Row(
              children: [
                Expanded(
                  child: _ComposerAction(
                    icon: LucideIcons.image,
                    label: 'Photo',
                    color: colors.success,
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: _ComposerAction(
                    icon: LucideIcons.video,
                    label: 'Video',
                    color: colors.error,
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: _ComposerAction(
                    icon: LucideIcons.camera,
                    label: 'Story',
                    color: colors.info,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  const _ComposerAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: Dimensions.rad8,
      child: Padding(
        padding: Dimensions.py8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: Dimensions.iconSm, color: color),
            Dimensions.gapH8,
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: context.typography.labelSmall.copyWith(
                  color: context.kolors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Post
// =============================================================================

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final SocialPost post;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Padding(
      padding: Dimensions.px16,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: Dimensions.rad16,
          border: Border.all(color: colors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeader(post: post),

            if (post.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Dimensions.s16,
                  Dimensions.zero,
                  Dimensions.s16,
                  Dimensions.s16,
                ),
                child: _PostContent(post: post),
              ),

            if (post.imageUrl != null) _PostMedia(imageUrl: post.imageUrl!),

            _PostEngagement(post: post),

            Divider(height: 1, color: colors.borderSoft),

            _PostActions(post: post),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Post Header
// =============================================================================

class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post});

  final SocialPost post;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final typography = context.typography;

    return Padding(
      padding: Dimensions.p16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Dimensions.touchTarget,
            height: Dimensions.touchTarget,
            child: _AvatarImage(url: post.avatarUrl),
          ),

          Dimensions.gapH12,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        post.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.title,
                      ),
                    ),

                    if (post.verified) ...[
                      Dimensions.gapH4,
                      Icon(
                        LucideIcons.badgeCheck,
                        size: Dimensions.iconSm,
                        color: colors.primary,
                      ),
                    ],
                  ],
                ),

                Dimensions.gapV4,

                Row(
                  children: [
                    Flexible(
                      child: Text(
                        post.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.caption,
                      ),
                    ),
                    Padding(
                      padding: Dimensions.px8,
                      child: Container(
                        width: Dimensions.s2,
                        height: Dimensions.s2,
                        decoration: BoxDecoration(
                          color: colors.textDisabled,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Text(post.time, style: typography.caption),
                  ],
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            tooltip: 'Post options',
            icon: const Icon(LucideIcons.ellipsis),
            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: 'save', child: Text('Save post')),
                PopupMenuItem(value: 'hide', child: Text('Hide post')),
                PopupMenuItem(value: 'report', child: Text('Report')),
              ];
            },
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Post Content
// =============================================================================

class _PostContent extends StatelessWidget {
  const _PostContent({required this.post});

  final SocialPost post;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.content,
          style: typography.body.copyWith(color: colors.textPrimary),
        ),

        if (post.tags.isNotEmpty) ...[
          Dimensions.gapV8,
          Wrap(
            spacing: Dimensions.s8,
            runSpacing: Dimensions.s4,
            children: post.tags.map((tag) {
              return Text(
                '#$tag',
                style: typography.labelSmall.copyWith(color: colors.primary),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// Media
// =============================================================================

class _PostMedia extends StatelessWidget {
  const _PostMedia({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        color: colors.muted,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return Center(
              child: SizedBox(
                width: Dimensions.s24,
                height: Dimensions.s24,
                child: CircularProgressIndicator(
                  strokeWidth: Dimensions.s2,
                  color: colors.primary,
                ),
              ),
            );
          },
          errorBuilder: (_, _, _) {
            return Center(
              child: Icon(
                LucideIcons.image,
                size: Dimensions.iconLg,
                color: colors.textDisabled,
              ),
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// Engagement
// =============================================================================

class _PostEngagement extends StatelessWidget {
  const _PostEngagement({required this.post});

  final SocialPost post;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final typography = context.typography;

    return Padding(
      padding: Dimensions.px16y12,
      child: Row(
        children: [
          Container(
            width: Dimensions.s24,
            height: Dimensions.s24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.heart,
              size: Dimensions.iconSm,
              color: colors.primary,
            ),
          ),

          Dimensions.gapH8,

          Text(
            _compactCount(post.likes),
            style: typography.caption.copyWith(color: colors.textSecondary),
          ),

          const Spacer(),

          Text(
            '${_compactCount(post.comments)} comments',
            style: typography.caption,
          ),

          Dimensions.gapH12,

          Text(
            '${_compactCount(post.shares)} shares',
            style: typography.caption,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Post Actions
// =============================================================================

class _PostActions extends StatelessWidget {
  const _PostActions({required this.post});

  final SocialPost post;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return Padding(
      padding: Dimensions.p8,
      child: Row(
        children: [
          Expanded(
            child: _PostActionButton(
              icon: post.liked ? LucideIcons.heart : LucideIcons.heart,
              label: 'Like',
              color: post.liked ? colors.primary : colors.textSecondary,
              onTap: () {},
            ),
          ),

          Expanded(
            child: _PostActionButton(
              icon: LucideIcons.messageCircle,
              label: 'Comment',
              color: colors.textSecondary,
              onTap: () {},
            ),
          ),

          Expanded(
            child: _PostActionButton(
              icon: LucideIcons.send,
              label: 'Share',
              color: colors.textSecondary,
              onTap: () {},
            ),
          ),

          IconButton(
            onPressed: () {},
            tooltip: 'Save',
            icon: Icon(
              post.saved ? LucideIcons.bookmark : LucideIcons.bookmark,
              color: post.saved ? colors.primary : colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostActionButton extends StatelessWidget {
  const _PostActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: Dimensions.px8,
      ),
      icon: Icon(icon, size: Dimensions.iconSm),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

// =============================================================================
// Avatar
// =============================================================================

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return ClipOval(
      child: ColoredBox(
        color: colors.muted,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, _, _) {
            return Center(
              child: Icon(
                LucideIcons.userRound,
                size: Dimensions.iconMd,
                color: colors.textDisabled,
              ),
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// Navigation
// =============================================================================

class _SocialNavigation extends StatelessWidget {
  const _SocialNavigation();

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (_) {},
      destinations: const [
        NavigationDestination(icon: Icon(LucideIcons.house), label: 'Home'),
        NavigationDestination(icon: Icon(LucideIcons.search), label: 'Explore'),
        NavigationDestination(icon: Icon(LucideIcons.plus), label: 'Create'),
        NavigationDestination(
          icon: Icon(LucideIcons.messageCircle),
          label: 'Messages',
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
// Models
// =============================================================================

class SocialStory {
  const SocialStory({
    required this.name,
    required this.avatarUrl,
    this.hasNewStory = true,
  });

  final String name;
  final String avatarUrl;
  final bool hasNewStory;
}

class SocialPost {
  const SocialPost({
    required this.author,
    required this.subtitle,
    required this.avatarUrl,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    this.imageUrl,
    this.tags = const [],
    this.verified = false,
    this.liked = false,
    this.saved = false,
  });

  final String author;
  final String subtitle;
  final String avatarUrl;
  final String time;
  final String content;
  final String? imageUrl;

  final int likes;
  final int comments;
  final int shares;

  final List<String> tags;

  final bool verified;
  final bool liked;
  final bool saved;
}

// =============================================================================
// Demo Data
// =============================================================================

abstract final class DemoSocialData {
  static const stories = [
    SocialStory(
      name: 'You',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      hasNewStory: false,
    ),
    SocialStory(
      name: 'Nadia',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    ),
    SocialStory(
      name: 'Ryan',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
    ),
    SocialStory(
      name: 'Sophia',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
    ),
    SocialStory(
      name: 'Alex',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
    ),
    SocialStory(
      name: 'Emma',
      avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
    ),
  ];

  static const posts = [
    SocialPost(
      author: 'Nadia Rahman',
      subtitle: 'Product Designer',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      time: '12 min',
      verified: true,
      content:
          'Slow mornings, good coffee, and a little time away from the screen. Sometimes the best ideas arrive when you stop looking for them.',
      imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
      tags: ['morning', 'design', 'coffee'],
      likes: 2847,
      comments: 184,
      shares: 46,
      liked: true,
    ),
    SocialPost(
      author: 'Ryan Carter',
      subtitle: 'Mobile Engineer',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      time: '36 min',
      content:
          'Spent the afternoon simplifying an old feature. Deleted more code than I added — always a good day.',
      tags: ['flutter', 'development'],
      likes: 921,
      comments: 72,
      shares: 18,
    ),
    SocialPost(
      author: 'Sophia Lee',
      subtitle: 'Travel & Lifestyle',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      time: '1 hr',
      verified: true,
      content:
          'Found this quiet corner while walking with absolutely no plan. Those usually become my favorite places.',
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
      tags: ['travel', 'weekend'],
      likes: 12400,
      comments: 639,
      shares: 311,
      saved: true,
    ),
  ];
}

// =============================================================================
// Helpers
// =============================================================================

String _compactCount(int value) {
  if (value >= 1000000) {
    final result = value / 1000000;
    return '${result.toStringAsFixed(result >= 10 ? 0 : 1)}M';
  }

  if (value >= 1000) {
    final result = value / 1000;
    return '${result.toStringAsFixed(result >= 10 ? 0 : 1)}K';
  }

  return '$value';
}
