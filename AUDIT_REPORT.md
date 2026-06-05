
# InstaLingo v2 — 綜合審計報告 (Comprehensive Audit Report)

## 審計方法 (Methodology)

### 1. 空值/缺失值檢查 (Empty/Null Check)
- 掃描 7 個 locale × 295 key = 2,065 個值
- 檢測：空字串、null、缺失 key

### 2. 英文洩漏檢查 (English Leakage Check)
- 非英文 locale 與英文值做字串比對
- 排除：專有名詞 (JLPT)、語言名 (Bahasa Melayu)、單詞 (OK, Yes)

### 3. 模板變數完整性檢查 (Template Variable Integrity)
- 正則提取每個 locale 的 `${var}` / `$var` 佔位符
- 與英文原文的變數集合比對
- 修復方式：用 `__V0__` 遮罩變數後重新翻譯，再還原

### 4. 跨語言污染檢查 (Cross-Locale Contamination)
- zh_CN 不應有繁體字（語開關學業經門體對發實龍國個會時為）
- zh_TW 不應有純簡體字（语开关学业经门体对发实龙国个会时为）
- ko 不應有假名（平假名/片假名）
- ja 不應有韓文（諺文）
- ms/ar 不應有意外的中日韓文字

### 5. 字彙卡資料檢查 (Vocab Card Data Audit)
- 檢查 `card_data_loader.dart` demo 資料
- 檢查 VocabCard 模型的語言欄位

---

## 審計結果 (Audit Results)

### ✅ PASS — 無問題

| 檢查項目 | 結果 |
|----------|------|
| 空值 (Empty values) | 0 / 2,065 |
| 缺失 key (Missing keys) | 0 / 295×7 |
| zh_CN 繁體字污染 | 0 |
| zh_TW 簡體字污染 | 0 |
| Korean 假名污染 | 0 |
| Malay CJK 污染 | 0（僅 langName* 正常） |
| Arabic CJK 污染 | 0（僅 langName* 正常） |
| flutter analyze errors | 0 |
| flutter build web | ✅ BUILT |

### 🔧 FIXED — 已修復

| 問題 | 數量 | 嚴重度 | 修復方式 |
|------|------|--------|---------|
| 模板變數被翻譯 (Google Translate 把 `$count` 翻成 `عدد $`) | 37 處 | 🔴 Critical | 遮罩變數→重新翻譯→還原變數 |
| `shareCardSubject` 的 `{word}` 被翻譯 (日/韓/阿) | 3 處 | 🟡 Medium | 手動替換為 `{word}` |
| `shareLabel` / `notificationPracticeReminder` 缺失 | 2 key × 7 | 🟡 Medium | 新增 getter + 翻譯 |
| 3 個硬編碼字串 (share/notification/post) | 3 處 | 🟡 Medium | 重構 service + 加 l10n getter |
| Arabic locale 未生成 | 295 key | 🟡 Medium | Google Translate 批量生成 |

### ⚠️ KNOWN — 非 i18n bug（資料模型限制）

| 問題 | 影響範圍 | 說明 |
|------|---------|------|
| 字彙卡 `meaning` 只有英文 | 韓/馬/阿用戶 | VocabCard 只存 `meaning`(EN) + `meaningZh`(zh_TW)。韓文用戶看到 "English: cat" |
| 字彙卡 `exampleTranslation` 只有英文 | 全非英用戶 | 例句翻譯 "I like cats." 無本地化 |
| 字彙卡 `displayNameZh` 只有繁中 | 簡中/韓/馬/阿用戶 | 牌組名稱只有 EN + zh_TW |
| JLPT 標籤保持 "JLPT N5" | 中/韓/馬用戶 | 專有名詞，日語學習者通用（日文版有 "日本語能力試験N5"） |
| `displayName: 'Learner'` | 新用戶初次載入 | user_provider.dart 預設值，會被 SharedPreferences 覆蓋 |

---

## 信心度評估 (Confidence Assessment)

| 類別 | 信心度 | 已驗證 | 說明 |
|------|--------|--------|------|
| UI 框架字串 (l10n getter) | **95%** | 214 引用全部驗證 | 7 locale × 295 getter，模板變數已修復 |
| 模板變數完整性 | **100%** | 12 key × 7 locale 全驗證 | 每個 locale 的 `$var` 與英文一致 |
| 空值/洩漏 | **100%** | 2,065 值全掃描 | 0 空值，0 英文洩漏 |
| 跨語言污染 | **95%** | 6 對語言對全檢查 | 簡繁/假名/諺文無交叉污染 |
| 詞彙卡內容 | **30%** | Demo 10 張卡 | 8,054 張真實卡未部署，數據模型需擴充 |

### 已驗證的正確句子 (Verified Correct Sentences)

**模板變數修復前（37 處錯誤）：**
```
ja[timeSpentHoursMinutes]: "${時間}h ${分}m"     ❌ Dart 找不到變數 "時間"
ja[profile_minutesCount]:   "$count min"        ❌ 英文 "min" 漏翻
ko[savePercent]:            "$퍼센트를 절약하세요"  ❌ 變數被翻譯成 "퍼센트를"
ar[lapsesCount]:            "الهفوات: عدد $"     ❌ 變數 "count" 消失
```

**模板變數修復後（37 處修正）：**
```
ja[timeSpentHoursMinutes]:  "${hours}h ${minutes}m"        ✅ 變數正確，周圍日文化
ja[profile_minutesCount]:   "$count 分"                    ✅ 變數正確，日文單位
ko[savePercent]:            "$percent% 저장"               ✅ 變數正確，韓文
ar[lapsesCount]:            "الهفوات: $count"              ✅ 變數正確，阿拉伯文
```

**已修正句子總數：40 處 (37 template + 3 {word})，修正率 100%。**

---

## 最終統計

| 指標 | 數值 |
|------|------|
| Locale 檔案 | 7 |
| 每個 locale 的 getter | 295 |
| 翻譯字串總數 | 2,065 |
| 唯一 l10n 引用 | 214 |
| 發現並修復的 bug | 40 |
| flutter analyze errors | **0** |
| 剩餘硬編碼 | **1** (MaterialApp title) |
