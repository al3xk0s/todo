part of 'key_value_storage.dart';

/// Реализация хранилища, использующая [SharedPreferences]
class KeyValueStoragePrefs implements IStringKeyValueStorage {
  const KeyValueStoragePrefs();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  FutureOr<String> read(String key) async {
    final storage = await _prefs;
    final result = storage.getString(key);
    
    if(result == null) throw Exception('There is no value for the key "$key"');

    return result;
  }

  @override
  FutureOr<void> write(String key, String value) async {
    final storage = await _prefs;
    final success = await storage.setString(key, value);
    
    if(!success) throw Exception('Failed to set value by key "$key"');
  }

  @override
  FutureOr<void> delete(String key) async {
    final storage = await _prefs;
    final success = await storage.remove(key);
    
    if(!success) throw Exception('Failed to remove value by key "$key"');
  }

  @override
  FutureOr<bool> contains(String key) async {
    final storage = await _prefs;
    return storage.getString(key) != null;
  }
}
