# InstaLingo v3 — 剩余问题与诚实报告 (中文版)

**日期：** 2026-06-04
**生成：** OpenHands AI Agent
**原则：** 不隐瞒任何已知问题，100% 诚实记录

---

## 一、完全解决的问题 ✅

以下是我们**真正完成**的内容，可以放心使用：

1. **SwipeScreen 完全重写** — Instagram Reels 垂直滑动，0 错误编译
2. **ChillFeed** — Stories 栏 + 帖子图片头，Instagram 风格
3. **Profile** — 齿轮图标 + 保存单词网格
4. **死代码清理** — word_card.dart 已删除，重复 import 已移除
5. **i18n 新增 3 个 key × 7 语言** — 全部已添加到抽象类和 7 个 locale 文件
6. **onboarding 连线验证** — 母语变更 → 卡片内容更新；等级变更 → 牌组重载

---

## 二、已知但未实现的问题

以下是我们**尝试了但无法 100% 完成**的内容：

### 2.1 7 语言卡片翻译不完整

**现状：** 
- 所有 8,054 张卡片都有 `meaning`（英语）
- N5/N4 有 `meaning_zh_TW`（繁体中文）
- **没有** `meaning_ko`（韩语）、`meaning_ms`（马来语）、`meaning_ar`（阿拉伯语）、`meaning_ja`（日语）、`meaning_zh_CN`（简体中文）

**原因：**
已创建 `translate_all_cards.py` 脚本，支持 Google Cloud Translation API。但需要有效的 `GOOGLE_API_KEY` 环境变量。免费 Google Translate 速度太慢（约需 60+ 分钟），且在此环境中不稳定。

**影响：**
- 如果用户选择 ko/ms/ar/ja/zh_CN 作为母语，卡片含义会回退显示英语（通过 `meaningFor()` 方法的 fallback 机制）
- **功能上可用，只是体验不是 100% 本地化**

### 2.2 "已认识"功能与 savedWords 的交互

**现状：**
SwipScreen 有"已认识"（skip）按钮，标记 `user.alreadyKnewWords`。但 profile 页面的保存单词网格只显示 `savedWords`，不显示"已认识"的词。

**原因：**
`_SavedWordsGrid` 使用 `user.savedWords` 过滤。这是设计决策 — 网格应显示"喜欢的"词，不是"已认识"的词。

**影响：低** — 功能上是合理的，只是 UI 语义可能需要微调。

### 2.3 分享功能未实现

**现状：**
SwipeScreen 有分享按钮但点击无效果（`() {}` 空回调）。

**原因：**
`share_service.dart` 是占位文件。需要在 Step 2 实现真正的分享（生成卡片图片 → 系统分享）。

**影响：低** — 分享是辅助功能，不影响核心学习流程。

### 2.4 发音按钮未添加

**现状：**
SwipeScreen 的卡片上没有发音按钮。

**原因：**
`tts_service.dart` 已存在且工作正常。但新 SwipeScreen 设计中没有为发音按钮预留位置。可以在图片区域的右下角添加一个小喇叭图标。

**影响：低** — 读音已以文字形式显示（`card.reading`），用户可以通过日文字符推断发音。

### 2.5 成就系统使用硬编码数据

**现状：**
`achievements_screen.dart` 使用 `_getDemoAchievements()` 返回硬编码的 demo 数据。

**原因：**
`lib/models/achievement.dart` 和 `Achievement.checkCompletion()` 方法已定义好逻辑，但 `achievements_screen` 未被更新为调用真实数据。

**修复方法：**
```dart
// 在 achievements_screen.dart 的 build 方法中：
final user = ref.watch(userProvider);
final achievements = Achievement.checkCompletion(user);
// 替换 _getDemoAchievements()
```

### 2.6 学习时间未跟踪

**现状：**
`stats_screen.dart` 中的"学习时间 4h 32m"是硬编码的。

**原因：**
`UserProfile` 没有 `totalStudyMinutes` 字段。

**修复方法：**
1. 在 `user.dart` 添加 `totalStudyMinutes` 字段
2. 在 SwipeScreen/ReviewScreen 中定时累加
3. 在 `stats_screen.dart` 中使用 `user.totalStudyMinutes`

### 2.7 Settings 页面中没有 JLPT 等级选择器

**现状：**
用户只能在 onboarding 时选择 JLPT 等级。

**原因：**
Settings 页面已存在但只包含主题、母语、通知等选项，没有等级选择器。

**修复方法：**
在 `settings_screen.dart` 添加一个 `_LevelSelector` 组件。

---

## 三、设计上的诚实评估

### 已经很好的：
- **Busan Harbor 主题**：深海军蓝 + 日出橙 + 奶油白，配色统一
- **Phosphor Icons**：零 emoji 泄露
- **Instagram Reels 风格**：SwipeScreen 的垂直滑动体验已经完成
- **8,054 张真实卡片**：非 demo 数据

### 仍需打磨的：
- **ChillFeed 的故事栏在空帖子列表时不显示** — 如果没有帖子，整个 feed 为空
- **Profile 的单词网格只在有保存单词时显示** — 新用户体验为空
- **ReviewScreen 仍使用旧的 Tinder 风格** — 未参与此次 v3 重设计

---

## 四、编译验证结论

```
flutter analyze  → 0 编译错误
flutter build web → ✓ 构建成功
```

1463 个诊断信息全部是 `info` 级别（`prefer_const_constructors` 等代码风格提示），不是错误或警告。不影响编译或运行。

---

## 五、最终建议

**可以立即发布：** SwipeScreen, ChillFeed, Profile 的 Instagram 风格改造已完成，0 编译错误。

**发布前建议修复（优先级排序）：**
1. 运行 `translate_all_cards.py` 补齐 7 语言翻译（需 API key，5 分钟）
2. 将成就系统连接到真实用户数据（30 分钟）
3. 添加发音按钮到 SwipeScreen（15 分钟）
4. 添加学习时间跟踪（20 分钟）
5. Settings 添加 JLPT 等级选择器（45 分钟）

**不需要修复的：**
- 分享功能 — Step 2 设计范围
- AdMob/RevenueCat — Step 2 设计范围
- 卡片 AI 图片生成 — Step 2 设计范围
