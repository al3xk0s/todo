part of 'serializable.dart';

/// Псевдоним для функции, преобразующие данные [I] в [O]
typedef Transformer<I, O> = O Function(I data);

/// Интерфейс для сериализации / десериализации [I] объекта в [O]
abstract class ISerializer<I, O> {
  O serialize(I data);
  I deserialize(O serializedData);
}

/// Серилизует тип [T] в тип [T]
typedef IDirectSerializer<T> = ISerializer<T, T>;

/// Реализация сериализатора на `callback` - функциях
class Serializer<I, O> implements ISerializer<I, O> {
  const Serializer({
    required O Function(I data) serialize,
    required I Function(O rawData) deserialize,
  }) : _serialize = serialize, _deserialize = deserialize;

  final Transformer<I, O> _serialize;
  final Transformer<O, I> _deserialize;

  @override
  O serialize(I data) => _serialize(data);

  @override
  I deserialize(O serializedData) => _deserialize(serializedData);

  /// Сериализация в [T] и обратно
  static IDirectSerializer<T> direct<T>() => Serializer<T, T>(serialize: (v) => v, deserialize: (v) => v);

  static ISerializer<I, O> serializable<I extends ISerializable<O>, O>({
    required I Function(O rawData) deserialize,
  }) =>
      Serializer<I, O>(
        serialize: (s) => s.serialize(),
        deserialize: deserialize,
      );
}
