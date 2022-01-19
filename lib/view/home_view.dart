import 'package:flutter/material.dart';
import 'package:hive_lesson/manager/cache_manager.dart';
import 'package:hive_lesson/manager/service_manager.dart';
import 'package:hive_lesson/models/user_model.dart';
import 'package:http/http.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  IServiceManager? serviceManager;
  ICacheManager<UserModel>? cacheManager;

  List<UserModel>? items;

  Future<List<UserModel>> fetchDatas() async {
    await cacheManager!.init();
    if (cacheManager!.getItems()?.isNotEmpty ?? false) {
      print("CACHE");
      items = cacheManager!.getItems()!;
      print(items!.length);
      return cacheManager!.getItems()!;
    } else {
      print("NETWORK");
      items = await serviceManager!.fetchUser();
      return await serviceManager!.fetchUser();
    }
  }

  @override
  void initState() {
    serviceManager = ServiceManager(Client());
    cacheManager = CacheManager();
    //fetchDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await cacheManager!.addItems(items!);
            },
            icon: const Icon(
              Icons.cached_outlined,
            ),
          ),
          IconButton(
            onPressed: () async {
              await cacheManager!.clearAll();
            },
            icon: const Icon(
              Icons.bookmark_remove
            ),
          )
        ],
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return Container(
      child: FutureBuilder(
          future: fetchDatas(),
          builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].username ?? ""),
                      subtitle: Text(snapshot.data![index].email ?? ""),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
