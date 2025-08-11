import 'package:flutter_bloc_template/app/log.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  /// 显示模式
  /// * [0] 跟随系统
  /// * [1] 浅色模式
  /// * [2] 深色模式
  static const String kThemeMode = "ThemeMode";

  /// 首次运行
  static const String kFirstRun = "FirstRun";
  // 定义引导页缓存
  static const String kIntroduction = 'kIntroduction';
  // 生物验证锁
  static const String kLocalAuth = 'kLocalAuth';
  // 设置app语言
  static const String kLanguage = 'kLanguage';
  //设置跳过更新版本
  static const String kSkipVersion = 'kSkipVersion';
  // token
  static const String kToken = "token";
  //单例
  static LocalStorageService get instance => _getInstance();
  //缓存实例
  LocalStorageService._();
  static LocalStorageService? _instance;
  static LocalStorageService _getInstance() {
    _instance ??= LocalStorageService._();
    return _instance!;
  }
  //缓存Box
  late Box settingsBox;
  Future init() async {
    var dir = await getApplicationSupportDirectory();
    settingsBox = await Hive.openBox("LocalStorage", path: dir.path);
  }

  T getValue<T>(dynamic key, T defaultValue) {
    var value = settingsBox.get(key, defaultValue: defaultValue) as T;
    Log.d("Get LocalStorage：$key\r\n$value");
    return value;
  }

  Future setValue<T>(dynamic key, T value) async {
    Log.d("Set LocalStorage：$key\r\n$value");
    return await settingsBox.put(key, value);
  }

  Future removeValue<T>(dynamic key) async {
    Log.d("Remove LocalStorage：$key");
    return await settingsBox.delete(key);
  }

  //获取是否为首次进入app
  bool get isFirst => getValue("First", true);
  //设置不是首次进入app
  void setNoFirst() async {
    setValue("First", false);
  }
}
