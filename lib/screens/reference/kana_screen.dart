import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/services/tts_service.dart';

class KanaScreen extends StatefulWidget {
  const KanaScreen({super.key});
  @override
  State<KanaScreen> createState() => _KanaScreenState();
}

class _KanaScreenState extends State<KanaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _hiragana = [
    ["あ","a"],["い","i"],["う","u"],["え","e"],["お","o"],
    ["か","ka"],["き","ki"],["く","ku"],["け","ke"],["こ","ko"],
    ["さ","sa"],["し","shi"],["す","su"],["せ","se"],["そ","so"],
    ["た","ta"],["ち","chi"],["つ","tsu"],["て","te"],["と","to"],
    ["な","na"],["に","ni"],["ぬ","nu"],["ね","ne"],["の","no"],
    ["は","ha"],["ひ","hi"],["ふ","fu"],["へ","he"],["ほ","ho"],
    ["ま","ma"],["み","mi"],["む","mu"],["め","me"],["も","mo"],
    ["や","ya"],["ゆ","yu"],["よ","yo"],
    ["ら","ra"],["り","ri"],["る","ru"],["れ","re"],["ろ","ro"],
    ["わ","wa"],["を","wo"],["ん","n"],
  ];

  static const _katakana = [
    ["ア","a"],["イ","i"],["ウ","u"],["エ","e"],["オ","o"],
    ["カ","ka"],["キ","ki"],["ク","ku"],["ケ","ke"],["コ","ko"],
    ["サ","sa"],["シ","shi"],["ス","su"],["セ","se"],["ソ","so"],
    ["タ","ta"],["チ","chi"],["ツ","tsu"],["テ","te"],["ト","to"],
    ["ナ","na"],["ニ","ni"],["ヌ","nu"],["ネ","ne"],["ノ","no"],
    ["ハ","ha"],["ヒ","hi"],["フ","fu"],["ヘ","he"],["ホ","ho"],
    ["マ","ma"],["ミ","mi"],["ム","mu"],["メ","me"],["モ","mo"],
    ["ヤ","ya"],["ユ","yu"],["ヨ","yo"],
    ["ラ","ra"],["リ","ri"],["ル","ru"],["レ","re"],["ロ","ro"],
    ["ワ","wa"],["ヲ","wo"],["ン","n"],
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.kanaReference),
        bottom: TabBar(controller: _tabController, tabs: [Tab(text: l10n.hiraganaChart), Tab(text: l10n.katakanaChart)]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_KanaGrid(chars: _hiragana), _KanaGrid(chars: _katakana)],
      ),
    );
  }
}

class _KanaGrid extends ConsumerWidget {
  final List<List<String>> chars;
  const _KanaGrid({required this.chars});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tts = ref.watch(ttsServiceProvider);
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 8.h, crossAxisSpacing: 8.w, childAspectRatio: 0.85),
      itemCount: chars.length,
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => tts.speakJapanese(chars[i][0]),
        child: Container(
          decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: theme.dividerColor)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(chars[i][0], style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 4.h),
            Text(chars[i][1], style: TextStyle(fontSize: 10.sp, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          ]),
        ),
      ),
    );
  }
}
