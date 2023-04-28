part of 'droplist.dart';

class DroplistWidgetStyle {
  const DroplistWidgetStyle({
    this.elevation = 8,
    this.textStyle,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
  });
    final int elevation;
    final TextStyle? textStyle;
    final Widget? underline;
    final Widget? icon;
    final Color? iconDisabledColor;
    final Color? iconEnabledColor;
    final double iconSize;
    final bool isDense;
    final bool isExpanded;
    final double? itemHeight;
    final Color? focusColor;
    final FocusNode? focusNode;
    final bool autofocus;
    final Color? dropdownColor;
    final double? menuMaxHeight;
    final bool? enableFeedback;
    final AlignmentGeometry alignment;
    final BorderRadius? borderRadius;
}

class DroplistItemBuilder<T> {
  const DroplistItemBuilder({
    required this.builder,
    this.enabled = true,
    this.alignment = AlignmentDirectional.centerStart,
  });

  final bool enabled;
  final AlignmentGeometry alignment;
  final Widget Function(T value) builder;
}

class DroplistWidget<T> extends StatelessWidget {
  const DroplistWidget({
    Key? key,
    required this.itemBuilder,
    required this.controller,
    this.hint, 
    this.disabledHint, 
    this.onTap,
    this.style = const DroplistWidgetStyle(), 
  }) : super(key: key);

  final DroplistItemBuilder<T> itemBuilder;
  final DroplistWidgetStyle style;
  final IDroplistController<T> controller;
  final Widget? hint;
  final Widget? disabledHint;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {    
    return Obx(_buildList);
  }

  void _updateValue(T? value) {
    if(value == null) return;
    controller.setValue(value);
  }

  DropdownMenuItem<T> _buildItem(T value) {
    return DropdownMenuItem(
      value: value,
      enabled: itemBuilder.enabled,
      onTap: () => controller.setValue(value),
      alignment: itemBuilder.alignment,
      child: itemBuilder.builder(value),
    );
  }

  DropdownButton<T> _buildList() {
    final DroplistState<T> viewData = controller.state.value;

    final items = viewData.values.map((v) => _buildItem(v)).toList();

    return DropdownButton<T>(
      value: controller.value,
      items: items, 
      onChanged: viewData.enableOnChanged ? (v) => _updateValue(v) : null,
      hint: hint,
      disabledHint: disabledHint,
      onTap: onTap,
      elevation: style.elevation,
      style: style.textStyle,
      underline: style.underline,
      icon: style.icon,
      iconDisabledColor: style.iconDisabledColor,
      iconEnabledColor: style.iconEnabledColor,
      iconSize: style.iconSize,
      isDense: style.isDense,
      isExpanded: style.isExpanded,
      itemHeight: style.itemHeight,
      focusColor: style.focusColor,
      focusNode: style.focusNode,
      autofocus: style.autofocus,
      dropdownColor: style.dropdownColor,
      menuMaxHeight: style.menuMaxHeight,
      enableFeedback: style.enableFeedback,
      alignment: style.alignment,
      borderRadius: style.borderRadius,
    );
  }
}