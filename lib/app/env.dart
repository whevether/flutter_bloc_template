class Env {
  //环境标识
  static const String env = String.fromEnvironment('ENV');
  //api基础地址
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  //http端口
  static int httpPort = String.fromEnvironment('HTTP_PORT') as int;
  //socket端口
  static int socketPort = String.fromEnvironment('SOCKET_PORT') as int;
  //是否开启日志
  static bool enableLog = String.fromEnvironment('ENABLE_LOG') as bool;
}