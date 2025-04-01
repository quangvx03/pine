import 'package:get_storage/get_storage.dart';

class PLocalStorage {

  late final GetStorage _storage;

  static PLocalStorage? _instance;

  PLocalStorage._internal();

  factory PLocalStorage.instance() {
    _instance ??= PLocalStorage._internal();
    return _instance!;
  }

  static Future<void> init(String bucketName) async{
    await GetStorage.init(bucketName);
    _instance = PLocalStorage._internal();
    _instance!._storage = GetStorage(bucketName);
  }

  Future<void> writeData<P>(String key, P value) async{
    await _storage.write(key, value);
  }

  P? readData<P>(String key) {
    return _storage.read<P>(key);
  }

  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  Future<void> clearAll() async {
    await _storage.erase();
  }
}
