part of '../file_service.dart';

abstract class IReadonlyContentDescriptor implements IJsonSerializable {
  ContentDescriptorType get type;

  FutureOr<List<int>> read();
}

abstract class IContentDescriptor implements IReadonlyContentDescriptor {
  FutureOr<void> write(Iterable<int> content);
  FutureOr<void> clear();
}

abstract class _BaseContentDescriptor implements IContentDescriptor {
  const _BaseContentDescriptor(this.type);

  @override
  final ContentDescriptorType type;

  _BaseContentDescriptor.fromMap(JsonMap map) : type = ContentDescriptorType.parse(map['type']);

  @override
  JsonMap serialize() {
    return { 'type': type.name };
  }

}

class ContentDescriptorType {
  const ContentDescriptorType._(this.name);

  final String name;

  factory ContentDescriptorType.parse(String rawType) {
    final typeList = ContentDescriptorType.values.where((element) => element.name == rawType);
    if(typeList.isEmpty) throw Exception('Type $rawType isn\'t ContentDecriptorType');
    return typeList.first;
  }

  bool get isFile => this == file;
  bool get isLocal => this == local;

  static const file = ContentDescriptorType._('file');
  static const local = ContentDescriptorType._('local');

  static const values = [ file, local ];
}
