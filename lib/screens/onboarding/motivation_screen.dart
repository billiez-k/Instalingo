import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instalingo/providers/onboarding_provider.dart';
import 'package:instalingo/theme/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MotivationScreen extends ConsumerStatefulWidget {
  const MotivationScreen({super.key});

  @override
  ConsumerState<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends ConsumerState<MotivationScreen> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = [
      _MotivationOption(id: 'work', label: 'Career', icon: PhosphorIcons.briefcase()),
      _MotivationOption(id: 'travel', label: 'Travel', icon: PhosphorIcons.airplaneTilt()),
      _MotivationOption(id: 'study', label: 'Study Abroad', icon: PhosphorIcons.student()),
      _MotivationOption(id: 'culture', label: 'Culture', icon: PhosphorIcons.globe()),
      _MotivationOption(id: 'family', label: 'Family', icon: PhosphorIcons.users()),
      _MotivationOption(id: 'fun', label: 'Just for Fun', icon: PhosphorIcons.gameController()),
      _MotivationOption(id: 'brain', label: 'Brain Training', icon: PhosphorIcons.brain()),
      _MotivationOption(id: 'media', label: 'Movies & Shows', icon: PhosphorIcons.filmStrip()),
    ];

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Text('STEP 5/6', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 2.4)),
              SizedBox(height: 6.h),
              Text('Motivation', style: theme.textTheme.displayMedium?.copyWith(fontSize: 32.sp)),
              SizedBox(height: 10.h),
              Container(width: 24.w, height: 3, color: AppColors.primary),
              SizedBox(height: 14.h),
              Text('Select all that apply.', style: theme.textTheme.bodyLarge?.copyWith(color: context.appTheme.onSurfaceVariant)),
              SizedBox(height: 32.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12.w, mainAxisSpacing: 12.h, childAspectRatio: 1.6),
                  itemCount: options.length,
                  itemBuilder: (_, index) => _MotivationCard(
                    option: options[index],
                    isSelected: _selected.contains(options[index].id),
                    onTap: () => setState(() {
                      if (_selected.contains(options[index].id)) {
                        _selected.remove(options[index].id);
                      } else {
                        _selected.add(options[index].id);
                      }
                    }),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity, height: 56.h,
                child: ElevatedButton(
                  onPressed: _selected.isNotEmpty
                      ? () {
                          ref.read(onboardingDataProvider.notifier).setMotivations(_selected.toList());
                          context.push('/onboarding/commitment');
                        }
                      : null,
                  child: Text('Continue', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _MotivationOption {
  final String id;
  final String label;
  final PhosphorIconData icon;
  const _MotivationOption({required this.id, required this.label, required this.icon});
}

class _MotivationCard extends StatelessWidget {
  final _MotivationOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _MotivationCard({required this.option, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: isSelected ? appTheme.harborNavy : appTheme.border, width: isSelected ? 1.6 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32.w, height: 32.w,
                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(2.r), border: Border.all(color: appTheme.border)),
                  child: PhosphorIcon(option.icon, size: 16.sp, color: appTheme.harborIconFill),
                ),
                Container(
                  width: 18.w, height: 18.w,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(2.r),
                    border: Border.all(color: isSelected ? AppColors.primary : appTheme.border, width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: isSelected ? PhosphorIcon(PhosphorIcons.check(PhosphorIconsStyle.bold), size: 11.sp, color: Colors.white) : null,
                ),
              ],
            ),
            Text(option.label, style: theme.textTheme.titleLarge?.copyWith(color: appTheme.harborNavy, fontSize: 14.sp), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
