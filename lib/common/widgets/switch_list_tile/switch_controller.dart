part of 'switch_list_tile.dart';

abstract class ISwitchController {
  RxBool get value;
  RxBool get isEnable;

  void enable();
  void disable();
  void toggle();

  void setValue(bool newValue);
}

class SwitchController extends ISwitchController {
  SwitchController({bool initialValue = false, bool initialEnable = true})
    : value = initialValue.obs,
      isEnable = initialEnable.obs;

  @override
  RxBool value;

  @override
  RxBool isEnable;

  @override
  void setValue(bool newValue) => value.value = newValue;

  @override
  void enable() => isEnable.value = true;

  @override
  void disable() => isEnable.value = false;

  @override
  void toggle() => isEnable.value = !isEnable.value;
}
