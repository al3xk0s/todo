part of '../file_service.dart';

class LocalContentDescriptor extends _BaseContentDescriptor implements IContentDescriptor {
  const LocalContentDescriptor(List<int> content) : _content = content, super(ContentDescriptorType.local);

  final List<int> _content;

  @override
  FutureOr<List<int>> read() {
    return _content;
  }

  @override
  FutureOr<void> write(Iterable<int> content) {
    clear();
    _content.addAll(content);
  }

  @override
  FutureOr<void> clear() {
    _content.clear();
  }

  @override
  JsonMap serialize() {
    return super
      .serialize()
      ..put('content', _content);
  }

  LocalContentDescriptor.fromMap(JsonMap map) : _content = map['content'], super.fromMap(map);
}
