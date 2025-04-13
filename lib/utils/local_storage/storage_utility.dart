import 'package:get_storage/get_storage.dart';

class PLocalStorage {
  late final GetStorage _storage;

  // Singleton instance
  static PLocalStorage? _instance;

  PLocalStorage._internal();

  /// Create a named constructor to obtain an instance with a specific bucket name
  factory PLocalStorage.instance() {
    _instance ??= PLocalStorage._internal();
    return _instance!;
  }


  /// Asynchronous initialization method
  static Future<void> init(String bucketName) async {
    // Very Important when you want to use Bucket's
    await GetStorage.init(bucketName);
    _instance = PLocalStorage._internal();
    _instance!._storage = GetStorage(bucketName);
  }

  /// Generic method to save data
  Future<void> writeData<P>(String key, P value) async {
    await _storage.write(key, value);
  }

  /// Generic method to read data
  P? readData<P>(String key) {
    return _storage.read<P>(key);
  }

  /// Generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  /// Clear all data in storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
