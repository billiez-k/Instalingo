import 'package:flutter/material.dart';
import 'package:instalingo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/services/tts_service.dart';

class KanjiScreen extends StatefulWidget {
  const KanjiScreen({super.key});
  @override
  State<KanjiScreen> createState() => _KanjiScreenState();
}

class _KanjiScreenState extends State<KanjiScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const _n5Kanji = [
    ["一", "いち", "ひと", "one"],
    ["二", "に", "ふた", "two"],
    ["三", "さん", "み", "three"],
    ["四", "し", "よん", "four"],
    ["五", "ご", "いつ", "five"],
    ["六", "ろく", "む", "six"],
    ["七", "しち", "なな", "seven"],
    ["八", "はち", "や", "eight"],
    ["九", "く", "きゅう", "nine"],
    ["十", "じゅう", "とお", "ten"],
    ["百", "ひゃく", "", "hundred"],
    ["千", "せん", "", "thousand"],
    ["万", "まん", "", "ten thousand"],
    ["円", "えん", "", "yen/circle"],
    ["年", "ねん", "とし", "year"],
    ["月", "げつ", "つき", "month/moon"],
    ["日", "にち", "ひ", "day/sun"],
    ["時", "じ", "とき", "time/hour"],
    ["分", "ふん", "わ", "minute/part"],
    ["今", "こん", "いま", "now"],
    ["先", "せん", "さき", "previous"],
    ["来", "らい", "く", "come/next"],
    ["前", "ぜん", "まえ", "before/front"],
    ["後", "ご", "あと", "after/behind"],
    ["上", "じょう", "うえ", "above/up"],
    ["下", "か", "した", "below/down"],
    ["中", "ちゅう", "なか", "middle/inside"],
    ["外", "がい", "そと", "outside"],
    ["右", "う", "みぎ", "right"],
    ["左", "さ", "ひだり", "left"],
    ["北", "ほく", "きた", "north"],
    ["南", "なん", "みなみ", "south"],
    ["東", "とう", "ひがし", "east"],
    ["西", "せい", "にし", "west"],
    ["大", "だい", "おお", "big"],
    ["小", "しょう", "ちい", "small"],
    ["人", "にん", "ひと", "person"],
    ["子", "し", "こ", "child"],
    ["女", "じょ", "おんな", "woman"],
    ["男", "だん", "おとこ", "man"],
    ["学", "がく", "まな", "study/learn"],
    ["校", "こう", "", "school"],
    ["生", "せい", "う", "life/birth"],
    ["先", "せん", "さき", "previous/teacher"],
    ["生", "せい", "", "student (combined)"],
    ["電", "でん", "", "electricity"],
    ["気", "き", "", "spirit/energy"],
    ["車", "しゃ", "くるま", "car/vehicle"],
    ["本", "ほん", "もと", "book/origin"],
    ["名", "めい", "な", "name"],
    ["語", "ご", "かた", "language/word"],
    ["国", "こく", "くに", "country"],
    ["山", "さん", "やま", "mountain"],
    ["川", "かわ", "", "river"],
    ["天", "てん", "あま", "heaven/sky"],
    ["雨", "う", "あめ", "rain"],
    ["花", "か", "はな", "flower"],
    ["金", "きん", "かね", "gold/money"],
    ["土", "ど", "つち", "earth/soil"],
    ["水", "すい", "みず", "water"],
    ["火", "か", "ひ", "fire"],
    ["木", "もく", "き", "tree/wood"],
    ["食", "しょく", "た", "eat/food"],
    ["飲", "いん", "の", "drink"],
    ["見", "けん", "み", "see"],
    ["聞", "ぶん", "き", "hear/ask"],
    ["読", "どく", "よ", "read"],
    ["書", "しょ", "か", "write"],
    ["話", "わ", "はな", "talk/speak"],
    ["買", "ばい", "か", "buy"],
    ["入", "にゅう", "い", "enter/insert"],
    ["出", "しゅつ", "で", "exit/go out"],
    ["行", "こう", "い", "go"],
    ["休", "きゅう", "やす", "rest"],
    ["立", "りつ", "た", "stand"],
    ["間", "かん", "あいだ", "interval/between"],
    ["何", "なに", "なん", "what"],
    ["半", "はん", "", "half"],
    ["毎", "まい", "ごと", "every"],
    ["長", "ちょう", "なが", "long/leader"],
  ];
  static const _n4Kanji = [
    ["不", "ふ", "", "not/un-"],
    ["会", "かい", "あ", "meet/society"],
    ["社", "しゃ", "", "company/shrine"],
    ["店", "てん", "みせ", "shop/store"],
    ["屋", "おく", "や", "roof/shop"],
    ["道", "どう", "みち", "road/way"],
    ["地", "ち", "", "ground/earth"],
    ["方", "ほう", "かた", "direction/person"],
    ["場", "じょう", "ば", "place"],
    ["通", "つう", "とお", "pass through"],
    ["運", "うん", "はこ", "carry/luck"],
    ["働", "どう", "はたら", "work"],
    ["使", "し", "つか", "use"],
    ["作", "さく", "つく", "make"],
    ["新", "しん", "あたら", "new"],
    ["古", "こ", "ふる", "old"],
    ["高", "こう", "たか", "high/expensive"],
    ["安", "あん", "やす", "cheap/peace"],
    ["多", "た", "おお", "many/much"],
    ["少", "しょう", "すく", "few/little"],
    ["近", "きん", "ちか", "near"],
    ["遠", "えん", "とお", "far"],
    ["早", "そう", "はや", "early/fast"],
    ["遅", "ち", "おそ", "late/slow"],
    ["広", "こう", "ひろ", "wide/spacious"],
    ["強", "きょう", "つよ", "strong"],
    ["弱", "じゃく", "よわ", "weak"],
    ["明", "めい", "あか", "bright"],
    ["暗", "あん", "くら", "dark"],
    ["軽", "けい", "かる", "light (weight)"],
    ["重", "じゅう", "おも", "heavy"],
    ["親", "しん", "おや", "parent"],
    ["友", "ゆう", "とも", "friend"],
    ["兄", "けい", "あに", "older brother"],
    ["弟", "てい", "おとうと", "younger brother"],
    ["姉", "し", "あね", "older sister"],
    ["妹", "まい", "いもうと", "younger sister"],
    ["父", "ふ", "ちち", "father"],
    ["母", "ぼ", "はは", "mother"],
    ["家", "か", "いえ", "house/family"],
    ["族", "ぞく", "", "tribe/family"],
    ["室", "しつ", "", "room"],
    ["台", "だい", "", "stand/machine"],
    ["料", "りょう", "", "fee/ingredients"],
    ["理", "り", "", "reason/science"],
    ["飯", "はん", "めし", "meal/rice"],
    ["肉", "にく", "", "meat"],
    ["魚", "ぎょ", "さかな", "fish"],
    ["野", "や", "の", "field/wild"],
    ["菜", "さい", "な", "vegetable"],
    ["茶", "ちゃ", "", "tea"],
    ["塩", "えん", "しお", "salt"],
    ["酒", "しゅ", "さけ", "alcohol/sake"],
    ["牛", "ぎゅう", "うし", "cow"],
    ["鳥", "ちょう", "とり", "bird"],
    ["馬", "ば", "うま", "horse"],
    ["犬", "けん", "いぬ", "dog"],
    ["猫", "びょう", "ねこ", "cat"],
    ["海", "かい", "うみ", "sea"],
    ["森", "しん", "もり", "forest"],
    ["空", "くう", "そら", "sky/empty"],
    ["風", "ふう", "かぜ", "wind"],
    ["雪", "せつ", "ゆき", "snow"],
    ["音", "おん", "おと", "sound"],
    ["楽", "がく", "たの", "music/comfort"],
    ["歌", "か", "うた", "song"],
    ["旅", "りょ", "たび", "travel"],
    ["心", "しん", "こころ", "heart/mind"],
    ["思", "し", "おも", "think"],
    ["知", "ち", "し", "know"],
    ["考", "こう", "かんが", "think/consider"],
    ["死", "し", "し", "death"],
    ["病", "びょう", "やまい", "illness"],
    ["医", "い", "", "medicine/doctor"],
    ["薬", "やく", "くすり", "medicine/drug"],
    ["自", "じ", "みずか", "self"],
    ["動", "どう", "うご", "move"],
    ["開", "かい", "ひら", "open"],
    ["閉", "へい", "と", "close/shut"],
    ["切", "せつ", "き", "cut"],
  ];

  @override
  void initState() { super.initState(); _tabController = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.kanjiReference),
        bottom: TabBar(controller: _tabController, tabs: [Tab(text: l10n.jlptN5Label), Tab(text: l10n.jlptN4Label)]),
      ),
      body: TabBarView(controller: _tabController, children: [
        _KanjiList(kanji: _n5Kanji),
        _KanjiList(kanji: _n4Kanji),
      ]),
    );
  }
}

class _KanjiList extends ConsumerWidget {
  final List<List<String>> kanji;
  const _KanjiList({required this.kanji});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tts = ref.watch(ttsServiceProvider);
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: kanji.length,
      separatorBuilder: (_, __) => Divider(height: 1),
      itemBuilder: (_, i) {
        final k = kanji[i];
        return GestureDetector(
          onTap: () {
            // Speak the on-reading (most common reading)
            final reading = k[1].isNotEmpty ? k[1] : k[0];
            tts.speakJapanese(reading);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(children: [
              Container(width: 56.w, height: 56.w, decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: theme.dividerColor)),
                child: Center(child: Text(k[0], style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)))),
              SizedBox(width: 16.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(k[3], style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 2.h),
                Text("On: ${k[1]}  Kun: ${k[2]}", style: TextStyle(fontSize: 12.sp, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
              ])),
            ]),
          ),
        );
      },
    );
  }
}
