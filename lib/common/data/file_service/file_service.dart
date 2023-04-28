import 'dart:async';
import 'dart:io';

import '../../extentions/extentions.dart';
import '../serializable/serializable.dart';

part 'models/content_descriptor.dart';
part 'models/file_content_descriptor.dart';
part 'models/local_content_decriptor.dart';
part 'models/content_descriptor_serializer.dart';

abstract class IFileService {
  Future<IFileContentDescriptor> save(Uri path, Iterable<int> content);
  Future<List<int>> getContent(Uri path);
  Future<void> remove(Uri path);
  Future<bool> has(Uri path);
}

class FileService implements IFileService {  
  @override
  Future<List<int>> getContent(Uri path) async {
    await _validatePath(path);
    return File(path.toFilePath()).readAsBytes();
  }
  
  @override
  Future<IFileContentDescriptor> save(Uri path, Iterable<int> content) async {
    final file = File(path.toFilePath());
    await file.writeAsBytes(content.toList());
    return _FileServiceContentDescriptor(path, this);
  }
  
  @override
  Future<void> remove(Uri path) async {
    await _validatePath(path);
  }

  @override
  Future<bool> has(Uri path) {
    return File(path.toFilePath()).exists();
  }

  Future<void> _validatePath(Uri path) async {
    if(!(await has(path))) throw Exception('File doesn\'t exist');
  }
}
