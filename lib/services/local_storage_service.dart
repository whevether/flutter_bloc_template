import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_template/app/log.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  /// 显示模式
  /// * [0] 跟随系统
  /// * [1] 浅色模式
  /// * [2] 深色模式
  static const String kThemeMode = "ThemeMode";
  // 首次运行
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
  //是否记住密码
  static const String kIsRemember = 'isRemember';
  //登陆账号
  static const String kLoginAccount = 'loginAccount';
  //登陆密码
  static const String kLoginPassword = 'loginPassword';

  static const String _kSettingsBoxName = "LocalStorage";

  // 单例
  static LocalStorageService get instance => _getInstance();
  LocalStorageService._();
  static LocalStorageService? _instance;
  static LocalStorageService _getInstance() {
    _instance ??= LocalStorageService._();
    return _instance!;
  }

  // Box 实例
  late Box settingsBox; // 全局设置 Box
  Box? _userMessageBox; // 用户消息 Box (可空，因为登录前不存在)

  // 记录存储路径，供后续打开 UserBox 使用
  String? _dbPath;

  /// 1. App启动时调用：只初始化全局设置
  Future init() async {
    if (!kIsWeb) {
      var dir = await getApplicationSupportDirectory();
      _dbPath = dir.path;
    }
    // 初始化全局设置 Box
    settingsBox = await Hive.openBox(_kSettingsBoxName, path: _dbPath);
  }

  /// 2. 用户登录成功后调用：初始化该用户的专属 Box
  /// [userId] : 用户的唯一标识
  Future initUserBox(String userId) async {
    // 如果之前有打开的 User Box (比如切换账号未重启App)，先关闭
    if (_userMessageBox != null && _userMessageBox!.isOpen) {
      await _userMessageBox!.close();
    }
    
    // 打开名为 "user_msg_{userId}" 的 Box
    String boxName = "user_box_$userId";
    Log.d("Init User Box: $boxName");
    _userMessageBox = await Hive.openBox(boxName, path: _dbPath);
  }

  /// 3. 用户退出登录时调用：关闭/清理用户 Box
  Future closeUserBox() async {
    if (_userMessageBox != null) {
      Log.d("Close User Box");
      await _userMessageBox!.close();
      _userMessageBox = null;
    }
  }
  
  /// 彻底删除当前用户的消息缓存（可选，比如用户选择“清除缓存”）
  Future clearCurrentUserMessages() async {
     if (_userMessageBox != null && _userMessageBox!.isOpen) {
       await _userMessageBox!.clear();
     }
  }

  /// 获取 Box 实例 (内部辅助方法)
  Box _getBox(bool isMessage) {
    if (isMessage) {
      if (_userMessageBox == null || !_userMessageBox!.isOpen) {
        // 如果在未登录或未调用 initUserBox 时尝试读取消息，抛出异常或返回 SettingBox (视业务逻辑而定)
        // 这里建议抛出异常或者打印错误，因为这是逻辑错误
        Log.d("Error: 尝试读取用户消息，但 UserBox 未初始化 (是否未登录?)");
        // 为了不崩馈，这里临时返回 settingsBox，但在开发中应避免此情况
        return settingsBox; 
      }
      return _userMessageBox!;
    }
    return settingsBox;
  }

  /// 获取值
  T getValue<T>(dynamic key, T defaultValue, {bool isMessage = false}) {
    // 如果是取消息，且 box 没打开，直接返回默认值，安全第一
    if (isMessage && (_userMessageBox == null || !_userMessageBox!.isOpen)) {
      Log.d("UserBox not ready, returning default for key: $key");
      return defaultValue;
    }
    
    Box box = _getBox(isMessage);
    var value = box.get(key, defaultValue: defaultValue) as T;
    return value;
  }

  /// 设置值
  Future setValue<T>(dynamic key, T value, {bool isMessage = false}) async {
    if (isMessage && (_userMessageBox == null || !_userMessageBox!.isOpen)) {
      Log.d("UserBox not ready, cannot set value for key: $key");
      return;
    }

    Box box = _getBox(isMessage);
    Log.d("Set ${isMessage ? 'UserMsg' : 'Setting'}：$key\r\n$value");
    return await box.put(key, value);
  }

  /// 删除值
  Future removeValue<T>(dynamic key, {bool isMessage = false}) async {
    if (isMessage && (_userMessageBox == null || !_userMessageBox!.isOpen)) {
       return;
    }
    Box box = _getBox(isMessage);
    Log.d("Remove ${isMessage ? 'UserMsg' : 'Setting'}：$key");
    return await box.delete(key);
  }

  // --- 业务 Getters/Setters ---
  bool get isFirst => getValue("First", true);
  void setNoFirst() async => setValue("First", false);
}
