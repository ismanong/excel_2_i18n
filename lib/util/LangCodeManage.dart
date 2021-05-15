class LangCodeManage{
  static const List<List<String>> langCodeMap = [
    ["cn", "zh-cn", "intl_zh_CN"], // 简体中文
    ["zh", "zh-zh", "intl_zh_TW"], // 繁体中文
    ["en", "en-us", "intl_en"], // 英语
    ["de", "de-de", "intl_de"], // 德语
    ["fr", "fr-fr", "intl_fr"], // 法语
    ["es", "es-es", "intl_es"], // 西班牙语
    ["pt", "pt-pt", "intl_pt"], // 葡萄牙语
    ["ru", "ru-ru", "intl_ru"], // 俄语
    ["tr", "tr-tr", "intl_tr"], // 土耳其语
    ["ar", "ar-ar", "intl_ar"], // 阿拉伯语
    ["id", "id-id", "intl_id"], // 印尼语
    ["it", "it-it", "intl_it"], // 意大利语
    ["pl", "pl-pl", "intl_pl"], // 波兰语
    ["th", "th-th", "intl_th"], // 泰语
    [
      "kr",
      "kr-kr",
      "intl_ko",
      "ko"
    ], // 韩语 //公司内部写错的遗留问题  正确的是 ko 朝鲜语 ko-KR 朝鲜语(韩国)
    ["jp", "jp-jp", "intl_ja", "ja"], // 日文 //公司内部写错的遗留问题  正确的是 "ja": "ja-JP"
    ["vi", "vi-vn", "intl_vi"], // 越南
  ];
}