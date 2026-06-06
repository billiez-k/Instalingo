
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/data/chill_post_loader.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/chill_post.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';

/// Social-media-style feed (Instagram-like) for the Chill Corner.
final chillPostsProvider = FutureProvider<List<ChillPost>>((ref) {
  return ChillPostLoader.loadPosts();
});

class ChillFeedScreen extends ConsumerWidget {
  const ChillFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context);
    final postsAsync = ref.watch(chillPostsProvider);

    return Scaffold(
      backgroundColor: appTheme.harborCream,
      appBar: _buildAppBar(appTheme, l10n),
      body: postsAsync.when(
        loading: () => _buildShimmerList(appTheme),
        error: (error, _) => _buildError(appTheme, l10n),
        data: (posts) => _buildPostList(context, ref, posts, appTheme, l10n),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppThemeExtension appTheme, AppLocalizations l10n) {
    return AppBar(
      backgroundColor: appTheme.harborNavy,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 3,
            height: 20.h,
            color: BusanHarborTokens.orange,
          ),
          SizedBox(width: 10.w),
          Text(
            l10n.chillCorner,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: appTheme.harborInkOnNavy,
              letterSpacing: 2.4,
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  Widget _buildPostList(BuildContext context, WidgetRef ref,
      List<ChillPost> posts, AppThemeExtension appTheme, AppLocalizations l10n) {
    if (posts.isEmpty) {
      return _buildEmpty(appTheme, l10n);
    }

    return RefreshIndicator(
      color: BusanHarborTokens.orange,
      backgroundColor: appTheme.harborNavy,
      onRefresh: () async {
        ref.invalidate(chillPostsProvider);
      },
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: posts.length + 1, // +1 for stories bar
        itemBuilder: (context, index) {
          if (index == 0) return _buildStoriesBar(posts, appTheme);
          final post = posts[index - 1];
          return _PostCard(post: post, appTheme: appTheme);
        },
      ),
    );
  }

  Widget _buildStoriesBar(List<ChillPost> posts, AppThemeExtension appTheme) {
    final grads = [
      [const Color(0xFFEE6C2C), const Color(0xFFD04B43)],
      [const Color(0xFF3E7CB1), const Color(0xFF0F3460)],
      [const Color(0xFF533483), const Color(0xFFD04B43)],
      [const Color(0xFF0F3460), const Color(0xFFEE6C2C)],
      [const Color(0xFFD04B43), const Color(0xFF533483)],
    ];

    return Container(
      height: 100.h,
      color: appTheme.harborNavy,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final g = grads[index % grads.length];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: GestureDetector(
              onTap: () {
                context.push('/swipe');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Instagram-style gradient ring story avatar
                  Container(
                    width: 68.w,
                    height: 68.w,
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: g,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: appTheme.harborNavy, width: 2),
                      ),
                      child: CircleAvatar(
                        backgroundColor: g[0].withValues(alpha: 0.15),
                        child: PhosphorIcon(
                          PhosphorIcons.fire(PhosphorIconsStyle.fill),
                          size: 22.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    post.authorName.length > 8
                        ? '${post.authorName.substring(0, 7)}...'
                        : post.authorName,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: appTheme.harborInkOnNavyMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerList(AppThemeExtension appTheme) {
    return Shimmer.fromColors(
      baseColor: appTheme.skeleton,
      highlightColor: appTheme.skeletonHighlight,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            padding: EdgeInsets.all(16.w),
            height: 160.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(AppThemeExtension appTheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIcons.warningCircle(PhosphorIconsStyle.regular),
            size: 44.sp,
            color: appTheme.onSurfaceVariant,
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.errorLoadingFeed,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: appTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(AppThemeExtension appTheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIcons.chatCircleText(PhosphorIconsStyle.regular),
            size: 48.sp,
            color: appTheme.onSurfaceVariant,
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.chillNoPosts,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: appTheme.harborNavy,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            l10n.chillEmptyMessage,
            style: TextStyle(
              fontSize: 13.sp,
              color: appTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final ChillPost post;
  final AppThemeExtension appTheme;

  const _PostCard({required this.post, required this.appTheme});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> with TickerProviderStateMixin {
  bool _isLiked = false;
  int _likeCount = 0;
  late AnimationController _heartAnimController;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likes;
    _heartAnimController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  void _doubleTapLike() {
    if (!_isLiked) {
      _toggleLike();
    }
    _heartAnimController.forward(from: 0);
  }

  void _openComments(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CommentsSheet(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final post = widget.post;
    final appTheme = widget.appTheme;
    final hasLink = post.targetWordId != null && post.targetWordId!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (hasLink) {
          context.push('/swipe');
        } else {
          context.push('/post/${post.id}');
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: BusanHarborTokens.paperWhite,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: appTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author row
            Row(
              children: [
                _AuthorAvatar(
                  name: post.authorName,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: appTheme.harborNavy,
                        ),
                      ),
                      Text(
                        post.authorHandle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: appTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat('MMM d').format(post.createdAt),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: appTheme.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Instagram-style gradient image header
            AnimatedBuilder(
              animation: _heartAnimController,
              builder: (_, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onDoubleTap: _doubleTapLike,
                      child: child,
                    ),
                    if (_heartAnimController.value > 0)
                      Opacity(
                        opacity: 1 - _heartAnimController.value,
                        child: Transform.scale(
                          scale: 0.5 + _heartAnimController.value * 1.5,
                          child: PhosphorIcon(
                            PhosphorIcons.heart(PhosphorIconsStyle.fill),
                            size: 80.sp,
                            color: BusanHarborTokens.coral,
                          ),
                        ),
                      ),
                  ],
                );
              },
              child: _PostImage(post: post),
            ),

            SizedBox(height: 12.h),

            // Content
            Text(
              post.content,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: appTheme.harborNavy,
                height: 1.5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            // Target word highlight
            if (post.targetWord != null && post.targetWord!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: BusanHarborTokens.orangeWash,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: BusanHarborTokens.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PhosphorIcon(
                      PhosphorIcons.bookOpen(PhosphorIconsStyle.fill),
                      size: 14.sp,
                      color: BusanHarborTokens.orange,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      post.targetWord!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: BusanHarborTokens.orange,
                      ),
                    ),
                    if (hasLink) ...[
                      SizedBox(width: 4.w),
                      Text(
                        l10n.tapToLearn,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: BusanHarborTokens.orange.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            SizedBox(height: 12.h),

            // Tags + Likes
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: post.tags
                        .map((tag) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: appTheme.onSurfaceVariant,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                GestureDetector(
                  onTap: _toggleLike,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PhosphorIcon(
                        _isLiked
                            ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                            : PhosphorIcons.heart(PhosphorIconsStyle.regular),
                        size: 16.sp,
                        color: _isLiked ? BusanHarborTokens.coral : appTheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$_likeCount',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _isLiked ? BusanHarborTokens.coral : appTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                GestureDetector(
                  onTap: () => _openComments(context),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PhosphorIcon(
                        PhosphorIcons.chatCircleText(PhosphorIconsStyle.regular),
                        size: 16.sp,
                        color: appTheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${post.comments.length}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: appTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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

class _PostImage extends StatelessWidget {
    final ChillPost post;
    const _PostImage({required this.post});

    static final _grads = [
      [const Color(0xFF1a1a2e), const Color(0xFF16213e)],
      [const Color(0xFF0f3460), const Color(0xFF1a1a2e)],
      [const Color(0xFF533483), const Color(0xFF16213e)],
      [const Color(0xFF2d3436), const Color(0xFF0f3460)],
      [const Color(0xFF16213e), const Color(0xFF1a1a2e)],
    ];

    @override
    Widget build(BuildContext context) {
      final g = _grads[post.authorName.hashCode.abs() % _grads.length];
      final icon = post.targetWordId != null
          ? PhosphorIcons.bookOpen(PhosphorIconsStyle.fill)
          : PhosphorIcons.chatCircleText(PhosphorIconsStyle.fill);

      return ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: double.infinity,
          height: 220.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: g,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                right: -20.w, top: -20.h,
                child: Container(
                  width: 100.w, height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.047), width: 1),
                  ),
                ),
              ),
              Center(
                child: Opacity(
                  opacity: 0.15,
                  child: PhosphorIcon(icon, size: 80.sp, color: Colors.white),
                ),
              ),
              if (post.targetWord != null && post.targetWord!.isNotEmpty)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(post.targetWord!,
                          style: TextStyle(
                              fontSize: 36.sp, fontWeight: FontWeight.w800,
                              color: Colors.white, letterSpacing: 1.5,
                              shadows: const [Shadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 2))])),
                      SizedBox(height: 4.h),
                      Text('tap to learn →',
                          style: TextStyle(fontSize: 11.sp, color: Colors.white54, letterSpacing: 0.8)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }

  class _AuthorAvatar extends StatelessWidget {
  final String name;

  const _AuthorAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials =
        name.split(' ').map((s) => s[0]).take(2).join('').toUpperCase();

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: BusanHarborTokens.navy,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: BusanHarborTokens.cream,
          ),
        ),
      ),
    );
  }
}

/// Instagram-style comment bottom sheet.
class _CommentsSheet extends StatelessWidget {
  final ChillPost post;
  const _CommentsSheet({required this.post});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final comments = post.comments;

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.25,
      maxChildSize: 0.85,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: appTheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  PhosphorIcon(PhosphorIcons.chatCircleText(PhosphorIconsStyle.fill),
                      size: 18.sp, color: appTheme.harborNavy),
                  SizedBox(width: 8.w),
                  Text('Comments',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: appTheme.harborNavy)),
                  const Spacer(),
                  Text('${comments.length}',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: appTheme.onSurfaceVariant)),
                ],
              ),
            ),
            const Divider(height: 1),
            // Comments list
            Expanded(
              child: comments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PhosphorIcon(PhosphorIcons.chatCircleText(PhosphorIconsStyle.regular),
                              size: 40.sp, color: appTheme.onSurfaceVariant.withValues(alpha: 0.3)),
                          SizedBox(height: 12.h),
                          Text('No comments yet',
                              style: TextStyle(fontSize: 14.sp, color: appTheme.onSurfaceVariant)),
                          SizedBox(height: 4.h),
                          Text('Be the first to comment!',
                              style: TextStyle(fontSize: 12.sp, color: appTheme.onSurfaceVariant.withValues(alpha: 0.6))),
                        ],
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: comments.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
                      itemBuilder: (_, i) {
                        final c = comments[i];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [BusanHarborTokens.orange, BusanHarborTokens.orangeDeep],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    c.authorName.isNotEmpty ? c.authorName[0].toUpperCase() : '?',
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.authorName,
                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: appTheme.harborNavy)),
                                    SizedBox(height: 2.h),
                                    Text(c.content,
                                        style: TextStyle(fontSize: 13.sp, color: appTheme.harborNavy, height: 1.4)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
