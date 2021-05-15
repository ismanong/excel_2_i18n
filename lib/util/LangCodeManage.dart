class LangCodeManage {
  /// 提醒
  /// 韩语 //公司内部写错的遗留问题  正确的是 ko 朝鲜语 ko-KR 朝鲜语(韩国)
  /// 日文 //公司内部写错的遗留问题  正确的是 "ja": "ja-JP"
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
    ["kr", "kr-kr", "intl_ko", "ko"], // 韩语
    ["jp", "jp-jp", "intl_ja", "ja"], // 日文
    ["vi", "vi-vn", "intl_vi"], // 越南
  ];
  static const Map<String, String> langCodeMapArb = {
    "zh-cn": "intl_zh_CN", // 英语
    "zh-zh": "intl_zh_TW", // 繁体中文
    "en-us": "intl_en", // 简体中文
    "de-de": "intl_de", // 土耳其语
    "fr-fr": "intl_fr", // 德语
    "es-es": "intl_es", // 法语
    "pt-pt": "intl_pt", // 俄语
    "ru-ru": "intl_ru", // 西班牙语
    "tr-tr": "intl_tr", // 葡萄牙语
    "ar-ar": "intl_ar", // 波兰语
    "id-id": "intl_id", // 印尼语
    "it-it": "intl_it", // 意大利语
    "pl-pl": "intl_pl", // 泰语
    "th-th": "intl_th", // 阿拉伯语
    "kr-kr": "intl_ko", // 韩语
    "jp-jp": "intl_ja", // 日文  //公司内部写错的遗留问题  正确的是 "ja": "ja-jp"
    "vi-vn": "intl_vi", // 越南
  };
}
