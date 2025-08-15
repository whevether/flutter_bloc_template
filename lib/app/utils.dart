import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_template/app/app_color.dart';
import 'package:flutter_bloc_template/app/dialog_utils.dart';
import 'package:gal/gal.dart';
import 'package:flutter_bloc_template/app/app_constant.dart';
import 'package:flutter_bloc_template/app/log.dart';
import 'package:flutter_bloc_template/i18n/localization_intl.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static late PackageInfo packageInfo;
  static DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  static DateFormat dateTimeFormat = DateFormat("MM-dd HH:mm");
  static DateFormat dateTimeFormatWithYear = DateFormat("yyyy-MM-dd HH:mm");
  static DateTime? dialogDate;

  /// 版本号解析
  static int parseVersion(String version) {
    var sp = version.split('.');
    var num = "";
    for (var item in sp) {
      num = num + item.padLeft(2, '0');
    }
    return int.parse(num);
  }

  /// 时间戳格式化-秒
  static String formatTimestamp(int ts) {
    if (ts == 0) {
      return "----";
    }
    return formatTimestampMS(ts * 1000);
  }

  static String formatTimestampToDate(int ts) {
    if (ts == 0) {
      return "----";
    }
    var dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    return dateFormat.format(dt);
  }

  /// 时间戳格式化-毫秒
  static String formatTimestampMS(int ts) {
    var dt = DateTime.fromMillisecondsSinceEpoch(ts);

    var dtNow = DateTime.now();
    if (dt.year == dtNow.year &&
        dt.month == dtNow.month &&
        dt.day == dtNow.day) {
      return "今天${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }
    if (dt.year == dtNow.year &&
        dt.month == dtNow.month &&
        dt.day == dtNow.day - 1) {
      return "昨天${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }

    if (dt.year == dtNow.year) {
      return dateTimeFormat.format(dt);
    }

    return dateTimeFormatWithYear.format(dt);
  }

  // 检查相机qua权限
  static Future<bool> checkCameraPermission() async {
    try {
      var permission = Permission.camera;
      var status = await permission.status;
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        var status = await permission.request();
        if (status.isGranted) {
          return true;
        } else {
          bool result = await DialogUtils.showAlertDialog('缺少相机权限，点击确定去打开权限',
              title: '请赋予相机权限');
          if (result) {
            openAppSettings();
          } else {
            SmartDialog.showToast("没有相机权限");
          }
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  // 检查麦克风权限
  static Future<bool> checkAudioPermission() async {
    try {
      var permission = Permission.microphone;
      var status = await permission.status;
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        var status = await permission.request();
        if (status.isGranted) {
          return true;
        } else {
          bool result = await DialogUtils.showAlertDialog('缺少麦克风权限，点击确定去打开权限',
              title: '请赋予麦克风权限');
          if (result) {
            openAppSettings();
          } else {
            SmartDialog.showToast("没有麦克风权限");
          }
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  /// 检查相册权限
  static Future<bool> checkPhotoPermission() async {
    try {
      var permission = Permission.photos;
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt >= 32) {
          permission = Permission.photos;
        } else {
          permission = Permission.storage;
        }
      }
      var status = await permission.status;
      if (status == PermissionStatus.granted) {
        return true;
      }

      status = await permission.request();
      if (status.isGranted) {
        return true;
      } else {
        bool result = await DialogUtils.showAlertDialog('缺少相册权限，点击确定去打开权限',
            title: '请赋予相册权限');
        if (result) {
          openAppSettings();
        } else {
          SmartDialog.showToast("没有相册权限");
        }
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // 请求通知权限
  static Future<bool> checkNotificationPermission() async {
    try {
      var permission = Permission.notification;
      var status = await permission.status;
      if (status == PermissionStatus.granted) {
        return true;
      }
      status = await permission.request();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //检查传感器权限
  static Future<bool> checkSensorsPermission(
      {bool isActivityRecognition = false}) async {
    try {
      var permission = Permission.sensors;
      if (Platform.isAndroid && isActivityRecognition) {
        permission = Permission.activityRecognition;
      }
      var status = await permission.status;
      if (status == PermissionStatus.granted) {
        return true;
      }
      status = await permission.request();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// 保存图片
  static void saveImage(String url) async {
    if (Platform.isIOS && !await checkPhotoPermission()) {
      return;
    }
    try {
      if (url.startsWith("http")) {
        final Directory cacheDir =
            await getDirectory(AppConstant.imageCache, isCache: true);
        List<String> urlList = url.split('/');
        String path = '${cacheDir.path}/${urlList.last}';
        await Dio().download(url, path);
        url = path;
      }
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        Log.w('不支持桌面平台');
        SmartDialog.showToast("不支持桌面平台");
        return;
      } else {
        await Gal.putImage(url);
        SmartDialog.showToast("保存成功");
      }
    } catch (e) {
      SmartDialog.showToast("保存失败");
    }
  }

  /// 保存视频
  static void saveVideo(String url, {String? album}) async {
    if (Platform.isIOS && !await checkPhotoPermission()) {
      return;
    }
    try {
      if (url.startsWith("http")) {
        final Directory cacheDir =
            await getDirectory(AppConstant.videoCache, isCache: true);
        List<String> urlList = url.split('/');
        String path = '${cacheDir.path}/${urlList.last}';
        await Dio().download(url, path);
        url = path;
      }
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        Log.w('不支持桌面平台');
        SmartDialog.showToast("不支持桌面平台");
        return;
      } else {
        await Gal.putVideo(url, album: album);
        SmartDialog.showToast("保存成功");
      }
    } catch (e) {
      SmartDialog.showToast("保存失败");
    }
  }

  //保存图片
  static void saveByteImage(ByteData? data, String name) async {
    if (!await checkPhotoPermission()) {
      openAppSettings();
      return;
    }
    try {
      if (data == null) {
        SmartDialog.showToast('保存图片失败');
        return;
      }
      var fileData =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        SmartDialog.showToast('不支持的平台');
        return;
      } else {
        await Gal.putImageBytes(fileData, name: name);
        SmartDialog.showToast('保存成功');
      }
    } catch (e) {
      SmartDialog.showToast('保存失败');
    }
  }

  //保存图片到零时文件夹
  static Future<XFile?> saveByteImageTemp(ByteData? data, String name) async {
    if (!await checkPhotoPermission()) {
      openAppSettings();
      return null;
    }
    try {
      if (data == null) {
        SmartDialog.showToast('操作失败');
        return null;
      }
      var fileData =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        SmartDialog.showToast('不支持的平台');
        return null;
      } else {
        final Directory dir = await getDirectory(name, isCache: true);
        var file = File(dir.path);
        await file.writeAsBytes(fileData);
        return XFile(file.path,
            mimeType: 'image/png',
            name: name,
            bytes: fileData,
            length: fileData.length);
      }
    } catch (e) {
      SmartDialog.showToast('操作失败');
      return null;
    }
  }

  /// 分享
  static void share(BuildContext context,String url, {String content = ""}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      useSafeArea: true,
      backgroundColor: AppColor.color2,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text("复制链接"),
            onTap: () {
              Navigator.pop(context);
              copyText(url);
            },
          ),
          Visibility(
            visible: content.isNotEmpty,
            child: ListTile(
              leading: const Icon(Icons.copy),
              title: const Text("复制标题与链接"),
              onTap: () {
                Navigator.pop(context);
                copyText("$content\n$url");
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text("浏览器打开"),
            onTap: () {
              Navigator.pop(context);
              openLaunchUrlString(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("系统分享"),
            onTap: () {
               Navigator.pop(context);

              SharePlus.instance.share(
                  ShareParams(text: content.isEmpty ? url : "$content\n$url"));
            },
          ),
        ],
      ),
    );
  }

  //打开网址
  static void openLaunchUrlString(String url) async {
    if (!await canLaunchUrlString(url)) {
      SmartDialog.showToast('不是正确的网址无法打开');
      return;
    }
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  /// 复制文本
  static void copyText(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      SmartDialog.showToast("已复制到剪切板");
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  // 多语言翻译
  static LanguageLocalizations?  translationI18(BuildContext context) =>
      LanguageLocalizations.of(context);





  // 缓存文件路径
  static Future<Directory> getDirectory(String name,
      {bool isCache = false}) async {
    //getApplicationDocumentsDirectory
    if (isCache == true) {
      final storage = (Platform.isIOS
          ? await getApplicationCacheDirectory()
          : await getExternalStorageDirectory());
      return Directory('${storage!.path}/$name');
    } else {
      return Directory('${(await getTemporaryDirectory()).path}/$name');
    }
  }

// 获取单个缓存大小
  static Future<int> getNameCachedSizeBytes(String name,
      {bool isCache = false}) async {
    int size = 0;
    final Directory cacheDirectory = await getDirectory(name, isCache: isCache);
    if (cacheDirectory.existsSync()) {
      await for (final FileSystemEntity file in cacheDirectory.list()) {
        size += file.statSync().size;
      }
    }
    return size;
  }

  // 获取所有缓存大小
  static Future<int> getTotalCachedSizeBytes() async {

      //图片缓存
      var imageCache = await getCachedSizeBytes();
      //视频缓存
      var videoCache =
          await getNameCachedSizeBytes(AppConstant.videoCache, isCache: true);
      //语音缓存
      var audioCache =
          await getNameCachedSizeBytes(AppConstant.audioCache, isCache: true);
      // 缓存
      var storageCache =
          await getNameCachedSizeBytes(AppConstant.imageCache, isCache: true);
      // 缓存
      var avatarCache = await getNameCachedSizeBytes(AppConstant.avatarCache);
      return imageCache + videoCache + audioCache + storageCache + avatarCache;
    
  }

  //清除单个缓存
  static Future<bool> clearNameDiskCached(String name,
      {Duration? duration, bool isCache = false}) async {
    try {
      final Directory cacheDirectory =
          await getDirectory(name, isCache: isCache);
      if (cacheDirectory.existsSync()) {
        if (duration == null) {
          cacheDirectory.deleteSync(recursive: true);
        } else {
          final DateTime now = DateTime.now();
          await for (final FileSystemEntity file in cacheDirectory.list()) {
            final FileStat fs = file.statSync();
            if (now.subtract(duration).isAfter(fs.changed)) {
              file.deleteSync(recursive: true);
            }
          }
        }
      }
    } catch (_) {
      return false;
    }
    return true;
  }

  //清除所有缓存
  static Future<bool> clearTotalDiskCache(
      { Duration? duration}) async {

      var imageCache = await clearDiskCachedImages();
      var videoCache =
          await clearNameDiskCached(AppConstant.videoCache, isCache: true);
      var audioCache =
          await clearNameDiskCached(AppConstant.audioCache, isCache: true);
      var storageCache =
          await clearNameDiskCached(AppConstant.imageCache, isCache: true);
      var avatarCache = await clearNameDiskCached(AppConstant.avatarCache);
      return imageCache &&
          videoCache &&
          audioCache &&
          storageCache &&
          avatarCache;
    
  }


  // 创建临时文件
  static Future<File> createTempFile({
    required String dir,
    required String name,
    required Uint8List list,
  }) async {
    final Directory storage = await getDirectory(dir);

    File file = File('${storage.path}/$name');
    if (!(file.existsSync())) {
      file.createSync(recursive: true);
    }
    await file.writeAsBytes(list);
    return file;
  }

  //对比时间
  static Duration differenceTime(int time) {
    DateTime now = DateTime.now();
    Duration difference =
        now.difference(DateTime.fromMillisecondsSinceEpoch(time * 1000));
    return difference;
  }

  //格式化时间为小时前
  static String formatTimeDifference(int time, {String? customFormat}) {
    var difference = differenceTime(time);
    if (difference.inSeconds < 10) {
      return '刚刚';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds}秒前';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return '$weeks周前';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months月前';
    } else if (difference.inDays >= 365) {
      int year = (difference.inDays / 365).floor();
      return '$year年前';
    } else {
      // 如果传入了 customFormat，则使用传入的格式化字符串
      if (customFormat != null) {
        return DateFormat(customFormat)
            .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
      } else {
        // 否则返回默认的格式化字符串
        return DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
      }
    }
  }


  //检查相机与麦克风权限

  static Future<bool> checkPermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false;
    }
    bool isCameraPermission = await checkCameraPermission();
    bool isAudioPermission = await checkAudioPermission();
    if (isCameraPermission && isAudioPermission) {
      return true;
    } else {
      return false;
    }
  }
}
