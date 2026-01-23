// 输入框组件 - 支持浮动标签效果
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_template/app/app_color.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';

///
/// 特点：
/// - 未聚焦时：hintText 显示在输入框内作为占位符
/// - 聚焦后：hintText 移动到输入框上方作为标签
/// - 聚焦时显示绿色边框
/// - 白色背景，圆角边框
class CommonInputField extends BaseStatefulWidget {
  /// 占位符文本（聚焦后移动到上方作为标签）
  final String? hintText;

  /// 文本控制器
  final TextEditingController controller;

  /// 键盘类型
  final TextInputType keyboardType;

  /// 是否隐藏密码
  final bool obscureText;

  /// 表单验证函数
  final String? Function(String?)? validator;

  /// 后缀图标
  final Widget? suffixIcon;

  /// 前缀图标
  final Widget? prefixIcon;

  /// 是否自动聚焦
  final bool autofocus;

  /// 自定义文本样式
  final TextStyle? style;

  /// 自定义标签样式
  final TextStyle? labelStyle;

  /// 最大行数
  final int maxLines;

  /// 最小行数
  final int minLines;

  /// 最大输入长度限制
  final int? maxLength;

  /// 输入格式化器
  final List<TextInputFormatter>? inputFormatters;

  /// 自定义焦点节点
  final FocusNode? focusNode;

  /// 文本变化回调
  final ValueChanged<String>? onChanged;

  /// 输入框点击回调
  final VoidCallback? onTap;

  /// 编辑完成回调
  final VoidCallback? onEditingComplete;

  /// 焦点变化回调
  final ValueChanged<bool>? onFocusChange;

  /// 是否启用
  final bool enabled;
  //
  final Iterable<String>? autofillHints;
  //软键盘输入操作按钮
  final TextInputAction? textInputAction;

  const CommonInputField(
      {this.hintText,
      required this.controller,
      this.keyboardType = TextInputType.emailAddress,
      this.obscureText = false,
      this.validator,
      this.suffixIcon,
      this.prefixIcon,
      this.autofocus = false,
      this.style,
      this.labelStyle,
      this.maxLines = 1,
      this.minLines = 1,
      this.maxLength,
      this.inputFormatters,
      this.focusNode,
      this.onChanged,
      this.onTap,
      this.onEditingComplete,
      this.onFocusChange,
      this.enabled = true,
      this.autofillHints,
      this.textInputAction = TextInputAction.next,
      super.key});

  @override
  CommonInputFieldState createState() => CommonInputFieldState();
}

class CommonInputFieldState extends BaseState<CommonInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isFilled = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
    _isFocused = _focusNode.hasFocus;
    _isFilled = widget.controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChanged);

    _focusNode.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    // 失焦时重新验证
    if (!_isFocused && widget.validator != null) {
      final error = widget.validator?.call(widget.controller.text);
      setState(() {
        _errorText = error;
      });
    }
    widget.onFocusChange?.call(_isFocused);
  }

  void _onTextChanged() {
    setState(() {
      _isFilled = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 判断是否应该显示浮动标签（聚焦或有内容时）
    final bool shouldShowFloatingLabel = _isFocused || _isFilled;

    // 计算边框颜色 - 验证通过后使用主题色
    final borderColor = _errorText != null
        ? AppColor.errorColor
        : (_isFocused || _isFilled
            ? Theme.of(context).primaryColor
            : AppColor.borderTopColor); // 浅灰色边框
    final borderWidth = _isFocused ? 1.0 : 1.0;

    // 计算光标颜色 - 验证通过后使用主题色
    final cursorColor = _errorText != null ? AppColor.errorColor : Theme.of(context).primaryColor;

    // 浮动标签样式 - 当标签在上方时使用
    final floatingLabelStyle = TextStyle(
      color: _errorText != null
          ? AppColor.errorColor
          : (_isFocused ? Theme.of(context).primaryColor : AppColor.color8E9AB0),
      fontSize: setFontSize(12),
      fontWeight: FontWeight.w500,
    );

    // 占位符样式 - 输入框内的占位符（未聚焦时显示）
    final hintStyle = TextStyle(
      color: AppColor.greyf0f0f0, // 中灰色占位符
      fontSize: setFontSize(14),
      fontWeight: FontWeight.normal,
    );

    // 输入文本样式
    final defaultInputStyle = TextStyle(
      fontSize: setFontSize(16),
      color: AppColor.color8E9AB0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: widget.maxLines > 1 ? null : setHeight(50.0),
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: circular(8),
            border: Border.all(
              color: borderColor,
              width: setWidth(borderWidth),
            ),
          ),
          child: Stack(
            children: [
              // 浮动标签 - 聚焦或有内容时显示在输入框上方
              if (widget.hintText != null)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  top: setHeight(shouldShowFloatingLabel ? 2 : 16),
                  left: setWidth(16),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: shouldShowFloatingLabel ? 1.0 : 0.0,
                    child: Container(
                      padding: symmetric(horizontal: 4),
                      color: AppColor.backgroundColor,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        style: widget.labelStyle ?? floatingLabelStyle,
                        child: Text(widget.hintText!),
                      ),
                    ),
                  ),
                ),

              // 输入框
              AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                padding: only(top: shouldShowFloatingLabel ? 18 : 0),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  obscureText: widget.obscureText,
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    setState(() {
                      _errorText = error;
                    });
                    return error;
                  },
                  autofocus: widget.autofocus,
                  enabled: widget.enabled,
                  style: widget.style ?? defaultInputStyle,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  maxLength: widget.maxLength,
                  inputFormatters: widget.inputFormatters,
                  onChanged: (value) {
                    // 当用户输入时，如果之前有错误，重新验证
                    if (_errorText != null && widget.validator != null) {
                      final error = widget.validator?.call(value);
                      setState(() {
                        _errorText = error;
                      });
                    }
                    widget.onChanged?.call(value);
                  },
                  onTap: widget.onTap,
                  autofillHints: widget.autofillHints,
                  onEditingComplete: widget.onEditingComplete,
                  textAlignVertical: TextAlignVertical.center,
                  onTapOutside: (event) {
                    if (_focusNode.hasFocus) {
                      _focusNode.unfocus();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: shouldShowFloatingLabel ? null : widget.hintText,
                    hintStyle: hintStyle,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.suffixIcon,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorText: null, // 禁用默认错误显示，我们自定义显示
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                    contentPadding: symmetric(
                      horizontal: 16,
                      vertical: shouldShowFloatingLabel ? 12 : 10,
                    ),
                    isDense: shouldShowFloatingLabel,
                    counterText: '',
                  ),
                  cursorColor: cursorColor,
                ),
              ),
            ],
          ),
        ),
        // 自定义错误信息显示在输入框外部
        if (_errorText != null)
          Padding(
            padding: only(left: 16, top: 4),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: AppColor.errorColor,
                fontSize: setFontSize(12),
              ),
            ),
          ),
      ],
    );
  }
}