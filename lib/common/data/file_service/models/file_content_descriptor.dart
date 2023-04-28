part of '../file_service.dart';

abstract class IFileContentDescriptor extends IContentDescriptor {
  Uri get path;
}

class _FileServiceContentDescriptor extends _BaseContentDescriptor implements IFileContentDescriptor {
  _FileServiceContentDescriptor(this.path, IFileService fileService) : _fileService = fileService, super(ContentDescriptorType.file);

  @override
  final Uri path;

  final IFileService _fileService;

  @override
  FutureOr<List<int>> read() {
    return _fileService.getContent(path);
  }

  @override
  FutureOr<void> write(Iterable<int> content) async {
    await _fileService.save(path, content);
  }

  @override
  FutureOr<void> clear() async {
    await _fileService.remove(path);
  }

  @override
  JsonMap serialize() {
    return super.serialize()
      ..put('path', path.toFilePath());
  }

  _FileServiceContentDescriptor.fromMap(JsonMap map, IFileService fileService) 
    : path = Uri.parse(map['path']), _fileService = fileService, super.fromMap(map);
}
