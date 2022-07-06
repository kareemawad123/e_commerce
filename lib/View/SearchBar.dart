import 'package:e_commerce/Controller/ProviderController.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../Model/Constant.dart';

class SearchBar extends StatefulWidget {
  final bool? isSearching;
  final TextEditingController searchController;

  const SearchBar({Key? key, required this.isSearching,required this.searchController}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  //TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      width: size.width * 0.6,
      //height: size.height*0.15,
      decoration: BoxDecoration(
        color: Color(0xFF979797).withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Consumer<ProviderController>(
        builder: (context, provider, child) {
          return TextFormField(
            onChanged: (value) {
              provider.checkEmpty(value);
              print(value);
            },
            controller: widget.searchController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: 13, horizontal: 20),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Search product",
                prefixIcon: Icon(Icons.search)),
          );
        },
      ),
    );
  }
}


class CustomSearchDelegate extends SearchDelegate {
  List list = [];

  Future getAllProducts2() async {
    //final List list;
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection(pCollection);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    list = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(list);
    print('List length00: ${list.length}');
    print('Get Products Complete');
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    getAllProducts2();
    list.forEach((element) {
      print('ElementUp: ${element[pName]}');
      if (element[pName].toLowerCase().contains(query.toLowerCase())) {
        print('Element: ${element[pName]}');
        matchQuery.add(element[pName].toString());
      }
    });
    print('matchQuery: ${matchQuery.length}');
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    getAllProducts2();
    list.forEach((element) {
      print('ElementUp: ${element[pName]}');
      if (element[pName].toLowerCase().contains(query.toLowerCase())) {
        print('Element: ${element[pName]}');
        matchQuery.add(element[pName].toString());
      }

    });
    print('matchQuery: ${matchQuery.length}');
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
