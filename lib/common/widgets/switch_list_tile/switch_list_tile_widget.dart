part of 'switch_list_tile.dart';

class SwitchListTileStyle {
  const SwitchListTileStyle({
    this.isAdaptive = false,
    this.tileColor,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.isThreeLine = false,
    this.dense,
    this.contentPadding,
    this.selected = false,
    this.autofocus = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.shape,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
    this.hoverColor,
  });

  final bool isAdaptive;
  final Color? tileColor;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final bool isThreeLine;
  final bool? dense;
  final EdgeInsetsGeometry? contentPadding;
  final bool selected;
  final bool autofocus;
  final ListTileControlAffinity controlAffinity;
  final ShapeBorder? shape;
  final Color? selectedTileColor;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool? enableFeedback;
  final Color? hoverColor;
}

class SwitchListTileWidget extends StatelessWidget {
  const SwitchListTileWidget({
    required this.controller,
    super.key,
    this.style = const SwitchListTileStyle(),
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.title,
    this.subtitle,
    this.secondary,
  });

  final ISwitchController controller;

  final SwitchListTileStyle style;
  final ImageProvider<Object>? activeThumbImage;
  final ImageProvider<Object>? inactiveThumbImage;
  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _buildWidget(
        context,
        controller,
        style.isAdaptive ? SwitchListTile.adaptive : SwitchListTile.new,
      ),
    );
  }

  Widget _buildWidget(BuildContext context, ISwitchController controller, Function builder) {
    return builder(
      attempt: controller.value.value,
      onChanged: controller.isEnable.value ? (value) => controller.setValue(value) : null,
      title: title,
      subtitle: subtitle,
      secondary: secondary,
      activeThumbImage: activeThumbImage,
      inactiveThumbImage: inactiveThumbImage,
      tileColor: style.tileColor,
      activeColor: style.activeColor,
      activeTrackColor: style.activeTrackColor,
      inactiveThumbColor: style.inactiveThumbColor,
      inactiveTrackColor: style.inactiveTrackColor,
      isThreeLine: style.isThreeLine,
      dense: style.dense,
      contentPadding: style.contentPadding,
      selected: style.selected,
      autofocus: style.autofocus,
      controlAffinity: style.controlAffinity,
      shape: style.shape,
      selectedTileColor: style.selectedTileColor,
      visualDensity: style.visualDensity,
      focusNode: style.focusNode,
      enableFeedback: style.enableFeedback,
      hoverColor: style.hoverColor,
    );
  }
}
