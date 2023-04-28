import 'package:flutter/widgets.dart';

abstract class InheritProvider<Model> implements InheritedWidget {
  @override
  Widget get child;

  Model get model;
}

extension ProvideModelExtention on BuildContext {
  M? readModel<M, P extends InheritProvider<M>>() {
  final widget = getElementForInheritedWidgetOfExactType<P>()?.widget as P?;
  return widget?.model;
}

  M? watchModel<M, P extends InheritProvider<M>>() {
    return dependOnInheritedWidgetOfExactType<P>()?.model;
  }
}

class ListenableModelProvider<Model extends Listenable> extends InheritedNotifier<Model> implements InheritProvider<Model> {
  const ListenableModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(notifier: model, child: child, key: key);

  static Model? read<Model extends Listenable>(BuildContext context) {
    return context.readModel<Model, ListenableModelProvider<Model>>();
  }

  static Model? watch<Model extends Listenable>(BuildContext context) {
    return context.watchModel<Model, ListenableModelProvider<Model>>();
  }

  @override
  final Model model;
}

class ModelProvider<Model> extends InheritedWidget implements InheritProvider<Model> {
  const ModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(child: child, key: key);

  @override
  final Model model;

  static Model? read<Model>(BuildContext context) {
    return context.readModel<Model, ModelProvider<Model>>();
  }

  static Model? watch<Model>(BuildContext context) {
    return context.watchModel<Model, ModelProvider<Model>>();
  }

  @override
  bool updateShouldNotify(covariant ModelProvider<Model> oldWidget) {
    return oldWidget.model != model;
  }
}