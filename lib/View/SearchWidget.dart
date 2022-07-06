import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/View/ProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/Constant.dart';

class SearchWidget extends StatefulWidget {
  final String query;
  const SearchWidget({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List list = [];

  Future getAllProducts2() async {
    //final List list;
    final CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection(pCollection);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    list = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(list);
    print('List length: ${list.length}');
    print('Get Products Complete');
  }

  @override
  Widget build(BuildContext context) {
    return buildResults(context);
  }

  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    getAllProducts2();
    list.forEach((element) {
      print('ElementUp: ${element[pName]}');
      if (element[pName].toLowerCase().contains(widget.query.toLowerCase())) {
        print('Element: ${element[pName]}');
        matchQuery.add(element[pName].toString());
      }
    });
    print('matchQuery: ${matchQuery.length}');
    return Expanded(
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return GestureDetector(
            onTap: (){
              Get.to(ProductScreen(), duration: Duration(milliseconds: 500),transition: Transition.leftToRight );

            },
            child: ListTile(
              title: Text(result),
            ),
          );
        },
      ),
    );
  }
}
