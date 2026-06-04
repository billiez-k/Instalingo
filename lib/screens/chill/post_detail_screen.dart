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
import 'package:instalingo/widgets/error_states.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailScreen extends ConsumerWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final post = ref.watch(postsProvider.notifier).getPostById(postId);
    final nativeLang = ref.watch(userProvider).nativeLanguage;
    final learningLang = ref.watch(userProvider).learningLanguage;

    if (post == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: ErrorState(
          title: l10n.chill_postNotFound,
          message: l10n.chill_postNotFoundMessage,
          icon: PhosphorIcons.article(),
          onRetry: () => context.pop(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.chillCorner),
      ),
      body: _PostContent(post: post, nativeLang: nativeLang, learningLang: learningLang),
    );
  }
}

class _PostContent extends ConsumerStatefulWidget {
  final Post post;
  final String nativeLang;
  final String learningLang;
  const _PostContent({required this.post, required this.nativeLang, required this.learningLang});

  @override
  ConsumerState<_PostContent> createState() => _PostContentState();
}

class _PostContentState extends ConsumerState<_PostContent> {
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

  void _showWordActions(Post post, AppLocalizations l10n) {
    HapticFeedback.selectionClick();
    final word = post.targetWord;
    if (word == null || word.isEmpty) return;

    final shareText = [
      word,
      if (post.wordPhonetic != null) post.wordPhonetic!,
      if (post.wordExample != null) post.wordExample!,
    ].join('\n');

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                word,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (post.wordTranslation != null) ...[
                SizedBox(height: 6.h),
                Text(
                  post.wordTranslation!.resolve(widget.nativeLang),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Clipboard.setData(ClipboardData(text: shareText));
                        Navigator.of(context).pop();
                      },
                      child: PhosphorIcon(PhosphorIcons.copy()),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Share.share(shareText);
                      },
                      child: PhosphorIcon(PhosphorIcons.shareNetwork(PhosphorIconsStyle.fill)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    final post = widget.post;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Editorial author masthead
                Row(
                  children: [
                    Container(width: 18.w, height: 3, color: AppColors.chillPrimary),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        (post.characterType ?? l10n.chillCorner).toUpperCase(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: appTheme.onSurfaceVariant,
                          letterSpacing: 2.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d').format(post.createdAt).toUpperCase(),
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
                Row(
                  children: [
                    _Avatar(name: post.authorName, avatarUrl: post.authorAvatarUrl),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.authorName,
                            style: theme.textTheme.titleLarge?.copyWith(color: appTheme.harborIconFill),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (post.authorHandle != null)
                            Text(
                              post.authorHandle!,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Image placeholder
                Container(
                  width: double.infinity,
                  height: 240.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: appTheme.border, width: 1),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PhosphorIcon(
                          PhosphorIcons.image(),
                          size: 48.sp,
                          color: appTheme.onSurfaceVariant,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          l10n.chill_aiGeneratedImage,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: appTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Word card
                if (post.targetWord != null) ...[
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: AppColors.chillPrimary, width: 1.4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.chillPrimary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                              child: Text(
                                post.targetWord!.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.chillPrimary,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            if (post.wordPhonetic != null) ...[
                              SizedBox(width: 10.w),
                              Text(
                                post.wordPhonetic!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: appTheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                            const Expanded(child: SizedBox.shrink()),
                            IconButton(
                              onPressed: () => _showWordActions(post, l10n),
                              icon: PhosphorIcon(
                                PhosphorIcons.speakerHigh(),
                                size: 22.sp,
                                color: AppColors.chillPrimary,
                              ),
                            ),
                          ],
                        ),
                        if (post.wordTranslation != null) ...[
                          SizedBox(height: 12.h),
                          Text(
                            post.wordTranslation!.resolve(widget.nativeLang),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.chillPrimary,
                            ),
                          ),
                        ],
                        if (post.wordExplanation != null) ...[
                          SizedBox(height: 8.h),
                          Text(
                            post.wordExplanation!.resolve(widget.nativeLang),
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                        if (post.wordExample != null) ...[
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(color: appTheme.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PhosphorIcon(
                                      PhosphorIcons.quotes(),
                                      size: 18.sp,
                                      color: appTheme.onSurfaceVariant,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        post.wordExample!,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.wordExampleTranslation != null) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    post.wordExampleTranslation!.resolve(widget.nativeLang),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: appTheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                // Content
                Text(
                  post.content.resolve(widget.learningLang),
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: 16.h),

                // Actions
                Row(
                  children: [
                    _ActionButton(
                      icon: post.isLiked
                          ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                          : PhosphorIcons.heart(),
                      label: '${post.likes}',
                      color: post.isLiked ? AppColors.chillPrimary : appTheme.onSurfaceVariant,
                      onTap: () => ref.read(postsProvider.notifier).toggleLike(post.id),
                    ),
                    SizedBox(width: 24.w),
                    _ActionButton(
                      icon: PhosphorIcons.chatCircle(),
                      label: '${post.comments.length}',
                      color: appTheme.onSurfaceVariant,
                      onTap: _focusCommentInput,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Comments section
                Text(
                  l10n.chill_comments,
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(height: 16.h),
                ...post.comments.map((comment) => _CommentItem(comment: comment)),
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
                      hintText: l10n.chill_addComment,
                      filled: true,
                      fillColor: appTheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: () {
                    if (_commentController.text.trim().isNotEmpty) {
                      ref.read(postsProvider.notifier).addComment(
                        post.id,
                        _commentController.text.trim(),
                      );
                      _commentController.clear();
                    }
                  },
                  icon: PhosphorIcon(
                    PhosphorIcons.paperPlaneRight(PhosphorIconsStyle.fill),
                    size: 24.sp,
                    color: AppColors.chillPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        border: Border.all(color: AppColors.chillPrimary, width: 1.4),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.chillPrimary,
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

class _CommentItem extends StatelessWidget {
  final PostComment comment;
  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: comment.isAiReply
            ? AppColors.chillPrimary.withValues(alpha: 0.05)
            : appTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(4.r),
        border: comment.isAiReply
            ? Border.all(color: AppColors.chillPrimary.withValues(alpha: 0.2))
            : Border.all(color: appTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(name: comment.authorName, avatarUrl: comment.authorAvatarUrl),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: theme.textTheme.titleMedium,
                    ),
                    if (comment.isAiReply) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.chillPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          l10n.aiBadge,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.chillPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  comment.content,
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    PhosphorIcon(
                      PhosphorIcons.heart(),
                      size: 16.sp,
                      color: appTheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${comment.likes}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: appTheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      DateFormat('MMM d, h:mm a').format(comment.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: appTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
