import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:instalingo/models/vocab_card.dart';

class CardDataLoader {
  CardDataLoader._();
  static const _assetBase = 'instalingo_content/japanese';

  static Future<CardDeck> loadDeck(String level) async {
    final levelLower = level.toLowerCase();
    final path = '$_assetBase/$levelLower/cards.json';
    try {
      final jsonString = await rootBundle.loadString(path);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return CardDeck.fromJson(data);
    } catch (_) {
      return _generateDemoDeck(levelLower);
    }
  }

  static CardDeck _generateDemoDeck(String level) {
    final levelUpper = level.toUpperCase();
    final cards = List.generate(10, (i) {
      final d = _demoMeanings[i];
      final ex = _demoExamples[i];
      return VocabCard(
        id: '${level}_demo_$i',
        word: '${d['word']}$i',
        reading: '${d['reading']}$i',
        pos: d['pos'] as String,
        level: levelUpper,
        topic: d['topic'] as String,
        exampleText: d['exampleText'] as String?,
        exampleReading: d['exampleReading'] as String?,
        source: 'demo',
        meanings: (d['meanings'] as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
        exampleTranslations: (ex['translations'] as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
      );
    });
    return CardDeck(
      id: '${level}_demo',
      language: 'ja',
      level: levelUpper,
      displayName: 'JLPT $levelUpper',
      displayNameZh: 'JLPT $levelUpper',
      totalCards: cards.length,
      cards: cards,
    );
  }
}

const _demoMeanings = [
  {
    'word': '猫',
    'reading': 'ねこ',
    'pos': 'noun',
    'topic': 'animals',
    'exampleText': '猫が好きです。',
    'exampleReading': 'ねこがすきです。',
    'meanings': {'en': 'cat', 'zh_TW': '貓', 'zh_CN': '猫', 'ja': '猫', 'ko': '고양이', 'ms': 'kucing', 'ar': 'قطة'},
  },
  {
    'word': '食べる',
    'reading': 'たべる',
    'pos': 'verb',
    'topic': 'food',
    'exampleText': '朝ごはんを食べる。',
    'exampleReading': 'あさごはんをたべる。',
    'meanings': {'en': 'to eat', 'zh_TW': '吃', 'zh_CN': '吃饭', 'ja': '食べる', 'ko': '먹다', 'ms': 'makan', 'ar': 'لتناول الطعام'},
  },
  {
    'word': '学校',
    'reading': 'がっこう',
    'pos': 'noun',
    'topic': 'education',
    'exampleText': '学校へ行きます。',
    'exampleReading': 'がっこうへいきます。',
    'meanings': {'en': 'school', 'zh_TW': '學校', 'zh_CN': '学校', 'ja': '学校', 'ko': '학교', 'ms': 'sekolah', 'ar': 'مدرسة'},
  },
  {
    'word': '大きい',
    'reading': 'おおきい',
    'pos': 'adj',
    'topic': 'descriptions',
    'exampleText': '大きい犬です。',
    'exampleReading': 'おおきいいぬです。',
    'meanings': {'en': 'big', 'zh_TW': '大的', 'zh_CN': '大的', 'ja': '大きい', 'ko': '큰', 'ms': 'besar', 'ar': 'كبير'},
  },
  {
    'word': '水',
    'reading': 'みず',
    'pos': 'noun',
    'topic': 'nature',
    'exampleText': '水をください。',
    'exampleReading': 'みずをください。',
    'meanings': {'en': 'water', 'zh_TW': '水', 'zh_CN': '水', 'ja': '水', 'ko': '물', 'ms': 'air', 'ar': 'ماء'},
  },
  {
    'word': '行く',
    'reading': 'いく',
    'pos': 'verb',
    'topic': 'travel',
    'exampleText': '東京に行く。',
    'exampleReading': 'とうきょうにいく。',
    'meanings': {'en': 'to go', 'zh_TW': '去', 'zh_CN': '去', 'ja': '行く', 'ko': '가다', 'ms': 'pergi', 'ar': 'للذهاب'},
  },
  {
    'word': '本',
    'reading': 'ほん',
    'pos': 'noun',
    'topic': 'education',
    'exampleText': '本を読む。',
    'exampleReading': 'ほんをよむ。',
    'meanings': {'en': 'book', 'zh_TW': '書', 'zh_CN': '书', 'ja': '本', 'ko': '책', 'ms': 'buku', 'ar': 'كتاب'},
  },
  {
    'word': '話す',
    'reading': 'はなす',
    'pos': 'verb',
    'topic': 'communication',
    'exampleText': '日本語を話す。',
    'exampleReading': 'にほんごをはなす。',
    'meanings': {'en': 'to speak', 'zh_TW': '說', 'zh_CN': '说话', 'ja': '話す', 'ko': '말하다', 'ms': 'bercakap', 'ar': 'للتحدث'},
  },
  {
    'word': '天気',
    'reading': 'てんき',
    'pos': 'noun',
    'topic': 'nature',
    'exampleText': '今日はいい天気ですね。',
    'exampleReading': 'きょうはいいてんきですね。',
    'meanings': {'en': 'weather', 'zh_TW': '天氣', 'zh_CN': '天气', 'ja': '天気', 'ko': '날씨', 'ms': 'cuaca', 'ar': 'طقس'},
  },
  {
    'word': '新しい',
    'reading': 'あたらしい',
    'pos': 'adj',
    'topic': 'descriptions',
    'exampleText': '新しい車です。',
    'exampleReading': 'あたらしいくるまです。',
    'meanings': {'en': 'new', 'zh_TW': '新的', 'zh_CN': '新的', 'ja': '新しい', 'ko': '새로운', 'ms': 'baru', 'ar': 'جديد'},
  },
];

const _demoExamples = [
  {'translations': {'en': 'I like cats.', 'zh_TW': '我喜歡貓。', 'zh_CN': '我喜欢猫。', 'ja': '私は猫が好きです。', 'ko': '나는 고양이를 좋아한다.', 'ms': 'Saya suka kucing.', 'ar': 'أنا أحب القطط.'}},
  {'translations': {'en': 'I eat breakfast.', 'zh_TW': '我吃早餐。', 'zh_CN': '我吃早餐。', 'ja': '私は朝食を食べます。', 'ko': '나는 아침을 먹는다.', 'ms': 'Saya makan sarapan pagi.', 'ar': 'أنا أتناول وجبة الإفطار.'}},
  {'translations': {'en': 'I go to school.', 'zh_TW': '我去上學。', 'zh_CN': '我去上学。', 'ja': '私は学校に行きます。', 'ko': '나는 학교에 간다.', 'ms': 'Saya pergi ke sekolah.', 'ar': 'أذهب إلى المدرسة.'}},
  {'translations': {'en': 'It is a big dog.', 'zh_TW': '牠是一隻大狗。', 'zh_CN': '它是一只大狗。', 'ja': '大きな犬です。', 'ko': '큰 개입니다.', 'ms': 'Ia adalah anjing besar.', 'ar': 'إنه كلب كبير.'}},
  {'translations': {'en': 'Water, please.', 'zh_TW': '請給我水。', 'zh_CN': '请给我一杯水。', 'ja': 'お水をください。', 'ko': '물 주세요.', 'ms': 'Tolong berikan air.', 'ar': 'ماء، من فضل.'}},
  {'translations': {'en': 'I go to Tokyo.', 'zh_TW': '我去東京。', 'zh_CN': '我去东京。', 'ja': '東京に行きます。', 'ko': '나는 도쿄에 간다.', 'ms': 'Saya pergi ke Tokyo.', 'ar': 'أذهب إلى طوكيو.'}},
  {'translations': {'en': 'I read a book.', 'zh_TW': '我讀一本書。', 'zh_CN': '我读了一本书。', 'ja': '本を読みました。', 'ko': '나는 책을 읽었다.', 'ms': 'Saya membaca buku.', 'ar': 'قرأت كتابا.'}},
  {'translations': {'en': 'I speak Japanese.', 'zh_TW': '我說日語。', 'zh_CN': '我说日语。', 'ja': '私は日本語を話します。', 'ko': '나는 일본어를 할 수 있습니다.', 'ms': 'Saya bercakap Jepun.', 'ar': 'أنا أتكلم اليابانية.'}},
  {'translations': {'en': 'The weather is nice today.', 'zh_TW': '今天天氣很好。', 'zh_CN': '今天天气很好。', 'ja': '今日はいい天気ですね。', 'ko': '오늘 날씨가 좋아요.', 'ms': 'Cuaca baik hari ini.', 'ar': 'الطقس جميل اليوم.'}},
  {'translations': {'en': 'It is a new car.', 'zh_TW': '這是一輛新車。', 'zh_CN': '这是一辆新车。', 'ja': '新しい車です。', 'ko': '새 차입니다.', 'ms': 'Ia adalah kereta baru.', 'ar': 'إنها سيارة جديدة.'}},
];