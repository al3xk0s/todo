part of '../file_service.dart';

abstract class IContentDescriptorSerializer implements IJsonSerializer<IContentDescriptor> {}

class ContentDescriptorSerializer extends BaseJsonSerializer<IContentDescriptor> implements IContentDescriptorSerializer {
  ContentDescriptorSerializer({required this.fileService});
  
  final IFileService fileService;
  
  late final _typeBuilderMap = <ContentDescriptorType, IContentDescriptor Function(JsonMap map)>{
    ContentDescriptorType.file:  (map) => _FileServiceContentDescriptor.fromMap(map, fileService),
    ContentDescriptorType.local: LocalContentDescriptor.fromMap
  };

  @override
  IContentDescriptor fromMap(JsonMap map) {
    final builder = _typeBuilderMap[ContentDescriptorType.parse(map['type'])]!;
    return builder(map);
  }
  
  @override
  JsonMap toMap(IContentDescriptor value) => value.serialize();
}