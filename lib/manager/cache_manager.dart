import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_lesson/models/user_model.dart';

abstract class ICacheManager<T> {
  Future<void> init();
  void registerAdapter();
  Future<void> addItems(List<T> items);
  Future<void> putItems(List<T> items);
  T? getItem(String key);
  List<T>? getItems();
  Future<void> clearAll();
}

class CacheManager implements ICacheManager<UserModel> {

  Box<UserModel>? boxUser;

  @override
  Future<void> init() async {
    registerAdapter();
    boxUser = await Hive.openBox("userCahce");
  }

  

  @override
  Future<void> addItems(List<UserModel> items) async {
    await boxUser?.addAll(items);
  }

  @override
  void registerAdapter() {
    if(!Hive.isAdapterRegistered(1)){
      Hive.registerAdapter(UserModelAdapter());
      Hive.registerAdapter(AddressAdapter());
      Hive.registerAdapter(GeoAdapter());
      Hive.registerAdapter(CompanyAdapter());
    }
  }

  @override
  UserModel? getItem(String key) {
    return boxUser!.get(key);
  }

  @override
  List<UserModel>? getItems() {
    return boxUser?.values.toList();
  }

  @override
  Future<void> putItems(List<UserModel> items) async {
    await boxUser?.putAll(Map.fromEntries(items.map((item) => MapEntry(item.id, item))));
  }

  @override
  Future<void> clearAll() async {
    await boxUser!.clear();
  }

}