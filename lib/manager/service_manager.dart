import 'dart:convert';

import 'package:hive_lesson/models/user_model.dart';
import 'package:http/http.dart';

abstract class IServiceManager {
  Future<List<UserModel>> fetchUser();
}

class ServiceManager implements IServiceManager {

  Client client;
  
  ServiceManager(this.client);

  @override
  Future<List<UserModel>> fetchUser() async {
    Uri url = Uri.https("jsonplaceholder.typicode.com", "users");
    final response = await client.get(url);
    var jsonModel = jsonDecode(response.body);
    if(response.statusCode == 200) {
      if(jsonModel is List){
        return jsonModel.map((item) => UserModel.fromJson(item)).toList();
      }
    }
    return [];
  }
}
