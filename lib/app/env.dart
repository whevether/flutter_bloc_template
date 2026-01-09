class Env {
  //环境标识
  static const String env = String.fromEnvironment('ENV');
  //api基础地址
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  //http端口
  static const String httpPort = String.fromEnvironment('HTTP_PORT');
  //socket端口
  static const String socketPort = String.fromEnvironment('SOCKET_PORT');
  //是否开启日志
  static bool enableLog = String.fromEnvironment('ENABLE_LOG') as bool;
}