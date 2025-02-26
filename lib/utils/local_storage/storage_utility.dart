import 'package:get_storage/get_storage.dart';

class PLocalStorage {
  static final PLocalStorage _instance = PLocalStorage._internal();

  factory PLocalStorage() {
    return _instance;
  }

  PLocalStorage._internal();

  final _storage = GetStorage();

  // generic method to save data
  Future<void> saveData<P>(String key, P value) async {
    await _storage.write(key, value);
  }

  // generic method to read data
  P? readData<P>(String key) {
    return _storage.read<P>(key);
  }

  // generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // clear all data in storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}

/// *** *** *** *** *** Example *** *** *** *** *** ///

// LocalStorage localStorage = LocalStorage();
//
// // Save data
// localStorage.saveData('username', 'JohnDoe');
//
// // Read data
// String? username = localStorage.readData<String>('username');
// print('Username: $username'); // Output: Username: JohnDoe
//
// // Remove data
// localStorage.removeData('username');
//
// // Clear all data
// localStorage.clearAll();