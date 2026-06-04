import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/models/post.dart';
import 'package:instalingo/providers/post_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/skeleton.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChillScreen extends ConsumerStatefulWidget {
  const ChillScreen({super.key});

  @override
  ConsumerState<ChillScreen> createState() => _ChillScreenState();
}

class _ChillScreenState extends ConsumerState<ChillScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  void _openSearch({
    required List<Post> posts,
    required String nativeLang,
  }) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChillSearchSheet(
        posts: posts,
        nativeLang: nativeLang,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final posts = ref.watch(postsProvider);
    final nativeLang = ref.watch(userProvider).nativeLanguage;
    final learningLang = ref.watch(userProvider).learningLanguage;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const ChillSkeleton(),
      );
    }

    final appTheme = context.appTheme;

    if (posts.isEmpty) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: appTheme.harborNavy,
                padding: EdgeInsets.fromLTRB(22.w, 56.h, 16.w, 22.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          l10n.chill.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: appTheme.harborInkOnNavyMuted,
                            letterSpacing: 2.4,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            l10n.aiBadge.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      l10n.chillCorner,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: appTheme.harborInkOnNavy,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                child: Center(
                  child: Column(
                    children: [
                      PhosphorIcon(
                        PhosphorIcons.newspaperClipping(),
                        size: 48.sp,
                        color: appTheme.onSurfaceVariant,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.chill_noPosts,
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.chill_noPostsMessage,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: appTheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: appTheme.harborNavy,
              padding: EdgeInsets.fromLTRB(22.w, 56.h, 16.w, 22.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.chill.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: appTheme.harborInkOnNavyMuted,
                          letterSpacing: 2.4,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          l10n.aiBadge.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => _openSearch(posts: posts, nativeLang: nativeLang),
                        icon: PhosphorIcon(
                          PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                          color: appTheme.harborInkOnNavy,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    l10n.chillCorner,
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: appTheme.harborInkOnNavy,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.h)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _PostCard(post: posts[index], nativeLang: nativeLang, learningLang: learningLang),
              childCount: posts.length,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        ],
      ),
    );
  }
}

class _PostCard extends ConsumerWidget {
  final Post post;
  final String nativeLang;
  final String learningLang;
  const _PostCard({required this.post, required this.nativeLang, required this.learningLang});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push('/post/${post.id}');
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: appTheme.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — eyebrow timeline + author bar
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: appTheme.borderLight, width: 1)),
              ),
              child: Row(
                children: [
                  Container(width: 16.w, height: 3, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      (post.characterType ?? l10n.chillCorner).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: appTheme.onSurfaceVariant,
                        letterSpacing: 2.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _formatTime(post.createdAt, l10n).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: appTheme.onSurfaceVariant,
                      letterSpacing: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
              child: Row(
                children: [
                  _Avatar(name: post.authorName, avatarUrl: post.authorAvatarUrl),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: appTheme.harborIconFill,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (post.authorHandle != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            post.authorHandle!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Image placeholder — bordered slab
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: appTheme.surfaceVariant,
                border: Border(
                  top: BorderSide(color: appTheme.borderLight),
                  bottom: BorderSide(color: appTheme.borderLight),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PhosphorIcon(
                      PhosphorIcons.image(),
                      size: 40.sp,
                      color: appTheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      l10n.chill_aiGeneratedImage.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: appTheme.onSurfaceVariant,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Word highlight
            if (post.targetWord != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: appTheme.borderLight),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          child: Text(
                            post.targetWord!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.6,
                            ),
                          ),
                        ),
                        if (post.wordPhonetic != null) ...[
                          SizedBox(width: 8.w),
                          Text(
                            post.wordPhonetic!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: appTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (post.wordTranslation != null) ...[
                      SizedBox(height: 10.h),
                      Text(
                        post.wordTranslation!.resolve(nativeLang),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: appTheme.harborIconFill,
                        ),
                      ),
                    ],
                    if (post.wordExplanation != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        post.wordExplanation!.resolve(nativeLang),
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                post.content.resolve(learningLang),
                style: theme.textTheme.bodyLarge,
              ),
            ),

            // Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  _ActionButton(
                    icon: post.isLiked
                        ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                        : PhosphorIcons.heart(),
                    label: '${post.likes}',
                    color: post.isLiked ? AppColors.chillPrimary : appTheme.onSurfaceVariant,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      ref.read(postsProvider.notifier).toggleLike(post.id);
                    },
                  ),
                  SizedBox(width: 24.w),
                  _ActionButton(
                    icon: PhosphorIcons.chatCircle(),
                    label: '${post.comments.length}',
                    color: appTheme.onSurfaceVariant,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push('/post/${post.id}');
                    },
                  ),
                  SizedBox(width: 24.w),
                  _ActionButton(
                    icon: PhosphorIcons.shareNetwork(),
                    label: l10n.chill_share,
                    color: appTheme.onSurfaceVariant,
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                  if (post.location != null) ...[
                    SizedBox(width: 16.w),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PhosphorIcon(
                            PhosphorIcons.mapPin(),
                            size: 14.sp,
                            color: appTheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              post.location!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: appTheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return l10n.timeAgoMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeAgoHours(diff.inHours);
    return DateFormat('MMM d').format(date);
  }
}

class _ChillSearchSheet extends StatefulWidget {
  final List<Post> posts;
  final String nativeLang;
  const _ChillSearchSheet({required this.posts, required this.nativeLang});

  @override
  State<_ChillSearchSheet> createState() => _ChillSearchSheetState();
}

class _ChillSearchSheetState extends State<_ChillSearchSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    final query = _controller.text.trim().toLowerCase();
    final results = query.isEmpty
        ? widget.posts
        : widget.posts.where((p) {
            final haystack = [
              p.targetWord ?? '',
              p.authorName,
              p.authorHandle ?? '',
              p.content,
              p.caption ?? '',
            ].join(' ').toLowerCase();
            return haystack.contains(query);
          }).toList(growable: false);

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            border: Border(top: BorderSide(color: appTheme.border)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 8.w, 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.chillCorner,
                        style: theme.textTheme.titleLarge?.copyWith(color: appTheme.harborIconFill),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pop();
                      },
                      icon: PhosphorIcon(PhosphorIcons.x()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: appTheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              setState(() => _controller.clear());
                            },
                            icon: PhosphorIcon(PhosphorIcons.xCircle()),
                          ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Text(
                          l10n.emptyStateMessage,
                          style: theme.textTheme.bodyLarge?.copyWith(color: appTheme.onSurfaceVariant),
                        ),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (_, index) {
                          final post = results[index];
                          return ListTile(
                            title: Text(
                              post.targetWord ?? post.authorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              post.captionLocalized?.resolve(widget.nativeLang) ??
                                  post.caption ??
                                  post.content.resolve(widget.nativeLang),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: PhosphorIcon(PhosphorIcons.caretRight(), size: 18.sp),
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Navigator.of(context).pop();
                              context.push('/post/${post.id}');
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;

  const _Avatar({required this.name, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final initials = name.split(' ').map((s) => s[0]).take(2).join('');

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.primary, width: 1.4),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(icon, size: 22.sp, color: color),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
