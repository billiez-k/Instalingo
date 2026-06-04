import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:instalingo/widgets/animations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AiConversationScreen extends StatefulWidget {
  const AiConversationScreen({super.key});

  @override
  State<AiConversationScreen> createState() => _AiConversationScreenState();
}

class _AiConversationScreenState extends State<AiConversationScreen> {
  final _messages = <_Message>[];
  final _controller = TextEditingController();
  final _inputFocusNode = FocusNode();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  bool _bootstrapped = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bootstrapped) return;
    final l10n = AppLocalizations.of(context)!;
    _messages.add(_Message(
      text: l10n.aiConversationGreeting,
      isUser: false,
      sender: l10n.aiAssistantName,
      avatarColor: AppColors.chillPrimary,
    ));
    _bootstrapped = true;
  }

  void _openMenu(AppLocalizations l10n) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: PhosphorIcon(PhosphorIcons.trash()),
              title: Text(l10n.clearAll),
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _messages
                    ..clear()
                    ..add(_Message(
                      text: l10n.aiConversationGreeting,
                      isUser: false,
                      sender: l10n.aiAssistantName,
                      avatarColor: AppColors.chillPrimary,
                    ));
                  _isTyping = false;
                  _controller.clear();
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: PhosphorIcon(PhosphorIcons.question()),
              title: Text(l10n.helpSupport),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
                context.push('/profile/help');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(_Message(text: text, isUser: true, sender: AppLocalizations.of(context)!.aiYou));
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI response
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _isTyping = false;
        _messages.add(_Message(
          text: l10n.lessonCompleteGreat,
          isUser: false,
          sender: l10n.aiAssistantName,
          avatarColor: AppColors.chillPrimary,
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration.zero, () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Column(
          children: [
            Text(
              l10n.aiConversationTitle,
              style: theme.textTheme.titleLarge,
            ),
            Text(
              '${l10n.aiAssistantName} - ${l10n.aiAssistantRole}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _openMenu(l10n),
            icon: PhosphorIcon(PhosphorIcons.dotsThreeVertical()),
          ),
        ],
      ),
      body: Column(
        children: [
          // Scenario editorial banner
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.secondary, width: 1.4),
            ),
            child: Row(
              children: [
                Container(width: 16.w, height: 3, color: AppColors.secondary),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    l10n.scenarioCafeTokyo,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: appTheme.harborIconFill,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                final msg = _messages[index];
                return FadeSlide(
                  delayMs: index == _messages.length - 1 ? 0 : 0,
                  child: _MessageBubble(message: msg),
                );
              },
            ),
          ),
          // Typing indicator
          if (_isTyping)
            Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: appTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TypingDot(delay: 0),
                        SizedBox(width: 4.w),
                        _TypingDot(delay: 200),
                        SizedBox(width: 4.w),
                        _TypingDot(delay: 400),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // Input
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(top: BorderSide(color: appTheme.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      FocusScope.of(context).requestFocus(_inputFocusNode);
                    },
                    icon: PhosphorIcon(PhosphorIcons.microphone()),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _inputFocusNode,
                      decoration: InputDecoration(
                        hintText: l10n.typeMessage,
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: appTheme.onSurfaceVariant,
                        ),
                        filled: true,
                        fillColor: appTheme.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: PhosphorIcon(
                      PhosphorIcons.paperPlaneRight(PhosphorIconsStyle.fill),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final String sender;
  final Color? avatarColor;

  const _Message({
    required this.text,
    required this.isUser,
    required this.sender,
    this.avatarColor,
  });
}

class _MessageBubble extends StatelessWidget {
  final _Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: message.avatarColor ?? AppColors.primary,
                  width: 1.4,
                ),
              ),
              child: Center(
                child: Text(
                  message.sender[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: message.avatarColor ?? AppColors.primary,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: message.isUser ? appTheme.harborNavy : Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
                border: message.isUser
                    ? null
                    : Border.all(color: appTheme.border, width: 1),
              ),
              child: Text(
                message.text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: message.isUser ? Colors.white : appTheme.harborNavy,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final int delay;
  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    Future.delayed(Duration.zero, () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: context.appTheme.onSurfaceVariant.withValues(alpha: 
              0.3 + _controller.value * 0.5,
            ),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      },
    );
  }
}
