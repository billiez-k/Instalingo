import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/data/chill_post_loader.dart';
import 'package:instalingo/models/chill_post.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/post_image.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// Detail view for a single ChillPost.
///
/// Works with the ChillPost model. No references to old Post/Character models.
class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _focusCommentInput() {
    HapticFeedback.selectionClick();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        FocusScope.of(context).requestFocus(_commentFocusNode);
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      FocusScope.of(context).requestFocus(_commentFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final theme = Theme.of(context);

    return FutureBuilder<ChillPost?>(
      future: ChillPostLoader.loadPost(widget.postId),
      builder: (context, snapshot) {
        final l10n = AppLocalizations.of(context);
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () => context.pop()),
              backgroundColor: appTheme.harborNavy,
            ),
            body: Center(
              child: Text(l10n.error, style: TextStyle(color: appTheme.errorLight)),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () => context.pop()),
              backgroundColor: appTheme.harborNavy,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final post = snapshot.data;

        if (post == null) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () => context.pop()),
              backgroundColor: appTheme.harborNavy,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.article(PhosphorIconsStyle.regular),
                    size: 48.sp,
                    color: appTheme.onSurfaceVariant,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.postNotFound,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: appTheme.harborNavy,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: appTheme.harborCream,
          appBar: AppBar(
            backgroundColor: appTheme.harborNavy,
            leading: BackButton(
              onPressed: () => context.pop(),
              color: appTheme.harborInkOnNavy,
            ),
            title: Text(
              l10n.chillCornerEyebrow,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: appTheme.harborInkOnNavy,
                letterSpacing: 2.0,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Masthead
                      Row(
                        children: [
                          Container(
                            width: 18.w,
                            height: 3,
                            color: BusanHarborTokens.coral,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              l10n.chillCornerEyebrow,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w800,
                                color: appTheme.onSurfaceVariant,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy')
                                .format(post.createdAt)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: appTheme.onSurfaceVariant,
                              letterSpacing: 1.6,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Author
                      Row(
                        children: [
                          _AuthorAvatar(name: post.authorName, avatarUrl: post.authorAvatarUrl),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.authorName,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: appTheme.harborNavy,
                                  ),
                                ),
                                Text(
                                  post.authorHandle,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Instagram-style gradient image
                      PostImage(post: post, height: 200),

                      SizedBox(height: 16.h),

                      // Content
                      Text(
                        post.content,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: appTheme.harborNavy,
                          height: 1.6,
                        ),
                      ),

                      // Target word
                      if (post.targetWord != null &&
                          post.targetWord!.isNotEmpty) ...[
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            if (post.targetWordId != null) {
                              context.push('/swipe?wordId=${post.targetWordId}');
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: BusanHarborTokens.orangeWash,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: BusanHarborTokens.orange
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.featuredWord,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w800,
                                    color: BusanHarborTokens.orange,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  post.targetWord!,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w800,
                                    color: appTheme.harborNavy,
                                  ),
                                ),
                                if (post.targetWordId != null) ...[
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PhosphorIcon(
                                        PhosphorIcons.arrowRight(
                                            PhosphorIconsStyle.bold),
                                        size: 14.sp,
                                        color: BusanHarborTokens.orange,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        l10n.tapToStudyWord,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: BusanHarborTokens.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],

                      // Tags
                      if (post.tags.isNotEmpty) ...[
                        SizedBox(height: 16.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 6.h,
                          children: post.tags
                              .map((tag) => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: appTheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      '#$tag',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: appTheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],

                      SizedBox(height: 24.h),

                      // Actions
                      Row(
                        children: [
                          _ActionBtn(
                            icon: PhosphorIcons.heart(
                                PhosphorIconsStyle.regular),
                            label: '${post.likes}',
                            color: BusanHarborTokens.coral,
                          ),
                          SizedBox(width: 24.w),
                          _ActionBtn(
                            icon: PhosphorIcons.chatCircle(
                                PhosphorIconsStyle.regular),
                            label: '${post.comments.length}',
                            color: appTheme.onSurfaceVariant,
                            onTap: _focusCommentInput,
                          ),
                          const Spacer(),
                          _ActionBtn(
                            icon: PhosphorIcons.shareNetwork(
                                PhosphorIconsStyle.regular),
                            label: l10n.shareLabel,
                            color: appTheme.onSurfaceVariant,
                            onTap: () {
                              final text = [
                                post.content,
                                if (post.targetWord != null)
                                  '${l10n.shareWordPrefix}: ${post.targetWord}',
                                '',
                                l10n.viaInstalingo,
                              ].join('\n');
                              Share.share(text);
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Comments header
                      Text(
                        l10n.commentSectionTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: appTheme.harborNavy,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Comments
                      ...post.comments.map(
                        (comment) => _CommentItem(
                          comment: comment,
                          appTheme: appTheme,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Comment input
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(top: BorderSide(color: appTheme.border)),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          focusNode: _commentFocusNode,
                          decoration: InputDecoration(
                            hintText: l10n.commentHintText,
                            filled: true,
                            fillColor: appTheme.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.r),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      IconButton(
                        onPressed: () {
                          if (_commentController.text.trim().isNotEmpty) {
                            final text = _commentController.text.trim();
                            _commentController.clear();
                            _commentFocusNode.unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.commentPosted),
                                duration: const Duration(seconds: 2),
                                backgroundColor: appTheme.harborNavy,
                              ),
                            );
                          }
                        },
                        icon: PhosphorIcon(
                          PhosphorIcons.paperPlaneRight(
                              PhosphorIconsStyle.fill),
                          size: 24.sp,
                          color: BusanHarborTokens.coral,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AuthorAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  const _AuthorAvatar({required this.name, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final initials =
        name.split(' ').where((s) => s.isNotEmpty).map((s) => s[0]).take(2).join('').toUpperCase();
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      width: 44.w,
      height: 44.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: BusanHarborTokens.navy,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: hasAvatar
          ? CachedNetworkImage(
              imageUrl: avatarUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: BusanHarborTokens.cream,
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: BusanHarborTokens.cream,
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: BusanHarborTokens.cream,
                ),
              ),
            ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        label: label,
        button: true,
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(icon, size: 20.sp, color: color),
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
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final ChillComment comment;
  final AppThemeExtension appTheme;

  const _CommentItem({
    required this.comment,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: appTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: appTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AuthorAvatar(name: comment.authorName),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.authorName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: appTheme.harborNavy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  comment.content,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
