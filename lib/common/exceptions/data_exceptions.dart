part of 'exceptions.dart';

abstract class DataException implements CommonException {}
abstract class DataNotExistException implements CommonException {}

abstract class FileServiceException implements DataException {}

class FileNotExistException extends CommonException implements FileServiceException, DataNotExistException {
  const FileNotExistException(this.filename);

  final String filename;

  @override
  String get message => 'File \'$filename\' isn\'t exist';
}

class FileSystemPermissionException extends FileServiceException {
  @override
  String get message => 'File system permission denied';
}

abstract class KeyValueStorageException implements CommonException {}

class KeyNotExistException extends CommonException implements KeyValueStorageException, DataNotExistException {
  const KeyNotExistException(this.key);

  final String key;

  @override
  String get message => 'There is no value for the key \'$key\'';
}
