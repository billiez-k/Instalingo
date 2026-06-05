import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:instalingo/models/vocab_card.dart';
import 'package:instalingo/providers/revenuecat_provider.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/providers/vocab_deck_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Shows the user's saved word collection.
///
/// Grid of saved VocabCards with search/filter by level and topic.
/// Free tier limited to 100 words with upgrade prompt.
class CollectionsScreen extends ConsumerStatefulWidget {
  const CollectionsScreen({super.key});

  @override
  ConsumerState<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  String _searchQuery = '';
  String? _levelFilter;
  // ignore: unused_field
  bool _showBackForCard = false;
  String? _flippedCardId;

  static const int _freeLimit = 100;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    final isPro = ref.watch(isProProvider);
    final deckAsync = ref.watch(currentDeckProvider);

    final savedCards = deckAsync.whenOrNull<List<VocabCard>>(
          data: (deck) => deck.cards
              .where((c) => user.savedWords.contains(c.id))
              .toList(),
        ) ??
        [];

    // Filter
    var filtered = savedCards;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((c) {
        final q = _searchQuery.toLowerCase();
        return c.word.toLowerCase().contains(q) ||
            c.reading.toLowerCase().contains(q) ||
            c.meaning.toLowerCase().contains(q) ||
            c.meaningZh.contains(q);
      }).toList();
    }
    if (_levelFilter != null) {
      filtered = filtered.where((c) => c.level == _levelFilter).toList();
    }

    final levels = savedCards.map((c) => c.level).toSet().toList()..sort();

    return Scaffold(
      backgroundColor: appTheme.harborCream,
      appBar: AppBar(
        backgroundColor: appTheme.harborNavy,
        elevation: 0,
        title: Text(
          l10n.collectionsTitle,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: appTheme.harborInkOnNavy,
            letterSpacing: 2.4,
          ),
        ),
      ),
      body: Column(
        children: [
          // Count and search
          Container(
            color: appTheme.harborNavy,
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
            child: Column(
              children: [
                // Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${savedCards.length} / ${isPro ? l10n.collectionsUnlimited : '$_freeLimit ${l10n.collectionsWordsCount}'}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: appTheme.harborInkOnNavy,
                      ),
                    ),
                    if (!isPro && savedCards.length >= _freeLimit)
                      GestureDetector(
                        onTap: () => context.push('/paywall'),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: BusanHarborTokens.brass.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: BusanHarborTokens.brass.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            l10n.upgradePrompt,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: BusanHarborTokens.brass,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Search field
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: appTheme.harborInkOnNavy,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.collectionsSearchHint,
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: appTheme.harborInkOnNavyMuted,
                    ),
                    filled: true,
                    fillColor: BusanHarborTokens.navyMid.withValues(alpha: 0.5),
                    prefixIcon: PhosphorIcon(
                      PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
                      size: 18.sp,
                      color: appTheme.harborInkOnNavyMuted,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  ),
                ),

                // Level filter chips
                if (levels.length > 1) ...[
                  SizedBox(height: 10.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: l10n.collectionsFilterAll,
                          isSelected: _levelFilter == null,
                          onTap: () => setState(() => _levelFilter = null),
                        ),
                        ...levels.map((level) => _FilterChip(
                              label: level,
                              isSelected: _levelFilter == level,
                              onTap: () => setState(() => _levelFilter = level),
                            )),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Card grid
          Expanded(
            child: filtered.isEmpty
                ? _buildEmpty(appTheme, l10n, savedCards.isEmpty)
                : GridView.builder(
                    padding: EdgeInsets.all(16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      final card = filtered[index];
                      return _CollectionCard(
                        card: card,
                        appTheme: appTheme,
                        isFlipped: _flippedCardId == card.id,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            if (_flippedCardId == card.id) {
                              _flippedCardId = null;
                            } else {
                              _flippedCardId = card.id;
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(AppThemeExtension appTheme, AppLocalizations l10n, bool isCollectionEmpty) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            isCollectionEmpty
                ? PhosphorIcons.bookmarks(PhosphorIconsStyle.regular)
                : PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
            size: 48.sp,
            color: appTheme.onSurfaceVariant,
          ),
          SizedBox(height: 16.h),
          Text(
            isCollectionEmpty ? l10n.collectionsNoSavedWords : l10n.collectionsEmptyTitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: appTheme.harborNavy,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            isCollectionEmpty
                ? l10n.collectionsEmptyMessage
                : l10n.collectionsEmptyHint,
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? BusanHarborTokens.orange.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isSelected
                ? BusanHarborTokens.orange
                : appTheme.harborInkOnNavyMuted.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: isSelected
                ? BusanHarborTokens.orange
                : appTheme.harborInkOnNavyMuted,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final VocabCard card;
  final AppThemeExtension appTheme;
  final bool isFlipped;
  final VoidCallback onTap;

  const _CollectionCard({
    required this.card,
    required this.appTheme,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: appTheme.harborNavy,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: BusanHarborTokens.orange.withValues(alpha: 0.2),
          ),
        ),
        child: isFlipped ? _buildBack() : _buildFront(),
      ),
    );
  }

  Widget _buildFront() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Level badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: BusanHarborTokens.orange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(3.r),
          ),
          child: Text(
            card.level,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              color: BusanHarborTokens.orange,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          card.word,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: appTheme.harborInkOnNavy,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          card.reading,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            color: appTheme.harborInkOnNavyMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildBack() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              card.meaning,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: appTheme.harborInkOnNavy,
              ),
            ),
            if (card.meaningZh.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                card.meaningZh,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: appTheme.harborInkOnNavyMuted,
                ),
              ),
            ],
            SizedBox(height: 8.h),
            Text(
              '${card.pos}  .  ${card.topic}',
              style: TextStyle(
                fontSize: 10.sp,
                color: appTheme.harborInkOnNavyMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
