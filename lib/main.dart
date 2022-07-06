import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Model/Constant.dart';
import 'package:e_commerce/View/CategoryScreen.dart';
import 'package:e_commerce/View/OnboardingScreen.dart';
import 'package:e_commerce/View/ProductScreen.dart';
import 'package:e_commerce/View/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'Controller/ProviderController.dart';

Future<void> main() async {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProviderController(),
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
        ),
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          ProductScreen.routeName: (context) => const ProductScreen(),
          CategoryScreen.routeName: (context) => const CategoryScreen(),
        },
        home: const OnboardingScreen(),
      ),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection(pCollection).snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Text(snapshot.data!.docs[index][pName]);
                          },
                        )
                      : snapshot.hasError
                          ? const Text('Error')
                          : const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
