/// {@template tagDescription}
/// * [tag] - идентификатор зависимости, используемый для поиска
/// {@endtemplate}

/// {@template permanentDescription}
/// * [permanent] - избегать автоматического удаления зависимости при роутинге
/// {@endtemplate}

/// {@template preventDublicateBindDescription}
/// * [preventDublicateBind] - запретить повторный бинд, если бинд зависимости уже произошел
/// {@endtemplate}

import 'dart:async';

import 'package:get/get.dart';

abstract class IDIManager {
  /// Ищет зависимость по типу [T]
  /// {@macro tagDescription}
  T find<T>({String? tag});

  /// Пытается найти зависимость по типу [T]. В случае неудачи возвращает `null`
  /// {@macro tagDescription}
  T? tryFind<T>({String? tag});

  /// Проверяет, можно есть ли зависимость по типу [T]
  /// {@macro tagDescription}
  bool hasBind<T>({String? tag});

  /// Бинд зависимости на тип [T]. Зависимость соберется вызовом [builder] при вызове [find] или [tryFind] от [T]
  /// * [fenix] - автоматически ребилдить зависимость в случае удаления биндинга
  /// {@macro tagDescription}
  void lazyBind<T>(T Function() builder, {bool fenix = true, String? tag});

  /// Асинхронный бинд зависимости на тип [T]
  /// {@macro permanentDescription}
  /// {@macro preventDublicateBindDescription}
  /// {@macro tagDescription}
  Future<T> asyncBind<T>(FutureOr<T> Function() builder, {bool permanent = true, bool preventDublicateBind = true, String? tag});

  /// Бинд зависимости на тип [T]
  /// {@macro permanentDescription}
  /// {@macro preventDublicateBindDescription}
  /// {@macro tagDescription}
  T bind<T>(T instance, {bool permanent = true, bool preventDublicateBind = true, String? tag});

  /// Не ленивая вариация бинда зависимости на тип [T] по [builder]
  /// {@macro permanentDescription}
  /// {@macro preventDublicateBindDescription}
  /// {@macro tagDescription}
  T bindBuilder<T>(T Function() builder, {bool permanent = true, bool preventDublicateBind = true, String? tag});

  /// Позволяет забиндить фабрику, которая возращает новый экземпляр каждый [find] и [tryFind]
  /// {@macro permanentDescription}
  /// {@macro tagDescription}
  void bindFactory<T>(T Function() builder, {bool permanent = true, String? tag});
}

class _DIManager implements IDIManager {
  const _DIManager._();

  @override
  T find<T>({String? tag}) => Get.find<T>(tag: tag);

  @override
  bool hasBind<T>({String? tag}) => Get.isRegistered<T>(tag: tag);

  @override
  T? tryFind<T>({String? tag}) {
    if(!hasBind<T>()) return null;
    return find<T>();
  }

  @override
  void lazyBind<T>(T Function() builder, {bool fenix = true, String? tag})
    => Get.lazyPut<T>(builder, fenix: fenix, tag: tag);

  @override
  Future<T> asyncBind<T>(FutureOr<T> Function() builder, {bool permanent = true, bool preventDublicateBind = true, String? tag}) async {
    if(preventDublicateBind && hasBind<T>(tag: tag)) return find<T>(tag: tag);
    return Get.putAsync<T>(() async => await builder(), permanent: permanent, tag: tag);
  }

  @override
  T bindBuilder<T>(T Function() builder, {bool permanent = true, bool preventDublicateBind = true, String? tag})
    => bind<T>(builder(), permanent: permanent, preventDublicateBind: preventDublicateBind, tag: tag);

  @override
  T bind<T>(T instance, {bool permanent = true, bool preventDublicateBind = true, String? tag}) {
    if(preventDublicateBind && hasBind<T>(tag: tag)) return find<T>(tag: tag);
    return Get.put<T>(instance, tag: tag, permanent: permanent);
  }

  @override
  void bindFactory<T>(T Function() builder, {bool permanent = true, String? tag})
    => Get.create<T>(builder, permanent: permanent, tag: tag);
}

// ignore: constant_identifier_names
const IDIManager DI = _DIManager._();
