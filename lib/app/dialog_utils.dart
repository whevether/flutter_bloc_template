// import 'dart:io';

// import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc_template/app/log.dart';
import 'package:flutter_bloc_template/app/utils.dart';
import 'package:flutter_bloc_template/request/common_request.dart';
import 'package:flutter_bloc_template/services/local_storage_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_bloc_template/app/app_color.dart';
// import 'package:flutter_bloc_template/app/app_constant.dart';
import 'package:flutter_bloc_template/app/app_style.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc_template/app/log.dart';
// import 'package:flutter_bloc_template/app/utils.dart';
// import 'package:wchat/requests/common_request.dart';

class DialogUtils {
  /// 提示弹窗
  /// - `content` 内容
  /// - `title` 弹窗标题
  /// - `confirm` 确认按钮内容，留空为确定
  /// - `cancel` 取消按钮内容，留空为取消
  static Future<bool> showAlertDialog(
    String content, {
    String title = '',
    String confirm = '',
    String cancel = '',
    bool selectable = false,
    bool barrierDismissible = true,
    List<Widget>? actions,
  }) async {
    List<Widget> defaultAction = [
      TextButton(
        onPressed: (() => SmartDialog.dismiss(result: false)),
        child: Text(cancel.isEmpty ? "取消" : cancel),
      ),
      TextButton(
        onPressed: (() => SmartDialog.dismiss(result: true)),
        child: Text(confirm.isEmpty ? "确定" : confirm),
      ),
    ];
    var result = await showBottomSheetCommon<bool>(
      [
        Column(
          children: [
            const SizedBox(height: 20),
            buildBottomSheetHeader(title: title, showClose: true),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Padding(
                padding: AppStyle.edgeInsetsV12,
                child: selectable ? SelectableText(content) : Text(content),
              ),
            ),
            ...defaultAction,
          ],
        ),
      ],
      'alert_dialog',
      alignment: Alignment.center,
      borderRadius: const BorderRadius.all(Radius.circular(40)),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      clickMaskDismiss: false,
    );
    return result ?? false;
  }

  //选项弹窗
  static Future<T?> showOptionDialog<T>(
    List<T> contents,
    T value, {
    String title = '',
    double height = 200,
  }) async {
    var list = contents.map((e) {
      if (e.toString().isEmpty) {
        return const SizedBox.shrink();
      }
      return RadioListTile<T>(
        title: Text(e.toString()),
        value: e,
        groupValue: value,
        onChanged: (e) {
          SmartDialog.dismiss(result: e);
        },
      );
    }).toList();
    var result = await showBottomSheetCommon<T>(
      [
        Column(
          children: [
            const SizedBox(height: 20),
            buildBottomSheetHeader(title: title, showClose: true),
            const SizedBox(height: 20),
            ...list,
          ],
        ),
      ],
      'radio_group',
      alignment: Alignment.center,
      borderRadius: const BorderRadius.all(Radius.circular(40)),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: height,
      clickMaskDismiss: false,
    );
    return result;
  }

  // bottom sheet 头
  static Widget buildBottomSheetHeader({
    bool showClose = false,
    bool isManage = false,
    String? title,
    VoidCallback? onClose,
    Color? closeColor,
    VoidCallback? onManage,
  }) {
    return Stack(
      children: [
        showClose
            ? Positioned(
                top: 0,
                left: 0,
                child: InkWell(
                  child: Icon(Icons.close_sharp, color: closeColor),
                  onTap: () {
                    SmartDialog.dismiss();
                    if (onClose != null) {
                      onClose();
                    }
                  },
                ),
              )
            : const SizedBox.shrink(),
        isManage
            ? Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: () {
                    SmartDialog.dismiss();
                    if (onManage != null) {
                      onManage();
                    }
                  },
                  child: const Text(
                    '管理',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        title != null
            ? SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: closeColor,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  //底部按钮
  static Widget buildActionWidget({
    String? cancelText,
    String? submitText,
    void Function()? onCancel,
    void Function()? onSubmit,
  }) {
    onCancel =
        onCancel ??
        () {
          SmartDialog.dismiss();
        };
    onSubmit =
        onSubmit ??
        () {
          SmartDialog.dismiss(result: true);
        };
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: Axis.horizontal,
      children: [
        if (cancelText != null)
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                backgroundColor: AppColor.backgroundColor,
                foregroundColor: AppColor.black333,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: AppColor.borderTopColor,
                  ),
                  borderRadius: AppStyle.radius48,
                ),
              ),
              child: Text(
                cancelText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColor.black333,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (cancelText != null) const SizedBox(width: 20),
        if (submitText != null)
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                backgroundColor: AppColor.pinkBg,
                foregroundColor: AppColor.backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: AppStyle.radius48),
              ),
              child: Text(
                submitText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 打开弹窗
  static Future<T?> showBottomSheetCommon<T>(
    List<Widget> widget,
    String tag, {
    double? height,
    double? maxHeight,
    double? maxWidth,
    bool showTopBorder = false,
    Color? backgroundColor,
    bool? clickMaskDismiss = true,
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry? margin,
    Duration? displayTime,
    BorderRadiusGeometry borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(40),
      topRight: Radius.circular(40),
    ),
  }) async {
    var result = await SmartDialog.show<T>(
      tag: tag,
      alignment: alignment,
      clickMaskDismiss: clickMaskDismiss,
      displayTime: displayTime,
      builder: (_) {
        return Container(
          // width: double.infinity,
          height: height ?? 358,
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? 500,
            maxWidth: maxWidth ?? double.infinity,
          ),
          margin: margin,
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          decoration: ShapeDecoration(
            color: backgroundColor ?? AppColor.backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: Stack(
            children: [
              showTopBorder
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 6,
                          width: 37.5,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: ShapeDecoration(
                            color: AppColor.borderTopColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppStyle.radius16,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              const Padding(padding: EdgeInsets.only(top: 20)),
              ...widget,
            ],
          ),
        );
      },
    );
    return result;
  }

  /// 检查更新
  static void checkUpdate({bool showMsg = false}) async {
    try {
      int currentVer = Utils.parseVersion(Utils.packageInfo.version);
      CommonRequest request = CommonRequest();
      var versionInfo = await request.checkUpdate();
      if (versionInfo == null) {
        return;
      }
      int skipVersion = LocalStorageService.instance.getValue<int>(
        LocalStorageService.kSkipVersion,
        0,
      );
      int version = Utils.parseVersion(versionInfo.versionNo);
      if (version > currentVer &&
          versionInfo.updateStatus == 1 &&
          version > skipVersion) {
        var result = await showBottomSheetCommon<bool>(
          [
            Column(
              children: [
                const SizedBox(height: 36),
                buildBottomSheetHeader(
                  showClose: false,
                  closeColor: AppColor.backgroundColorDark,
                  title: "发现新版本 v${versionInfo.versionNo}",
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Icon(Icons.system_update),
                        const SizedBox(height: 10),
                        Text(
                          versionInfo.versionName,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.backgroundColorDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          versionInfo.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.backgroundColorDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                buildActionWidget(
                  submitText: '去下载',
                  cancelText: versionInfo.updateType == 0 ? null : '跳过',
                  onCancel: () {
                    SmartDialog.dismiss(result: false);
                  },
                  onSubmit: () {
                    SmartDialog.dismiss(result: true);
                  },
                ),
              ],
            ),
          ],
          'updateApp',
          showTopBorder: true,
          backgroundColor: AppColor.backgroundColor,
          clickMaskDismiss: false,
        );
        if (result == true) {
          Utils.openLaunchUrlString(versionInfo.downUrl);
        } else {
          if (versionInfo.updateType == 2) {
            LocalStorageService.instance.setValue<int>(
              LocalStorageService.kSkipVersion,
              version,
            );
          }
        }
      } else {
        if (showMsg) {
          SmartDialog.showToast("当前已经是最新版本了");
        }
      }
    } catch (e) {
      Log.logPrint(e);
      if (showMsg) {
        SmartDialog.showToast("检查更新失败");
      }
    }
  }
}
