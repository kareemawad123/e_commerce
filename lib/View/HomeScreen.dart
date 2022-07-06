import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Controller/ProviderController.dart';
import 'package:e_commerce/Model/Constant.dart';
import 'package:e_commerce/Model/DataModel.dart';
import 'package:e_commerce/View/CartScreen.dart';
import 'package:e_commerce/View/CategoryScreen.dart';
import 'package:e_commerce/View/FavoriteScreen.dart';
import 'package:e_commerce/View/OffersCard.dart';
import 'package:e_commerce/View/SearchWidget.dart';
import 'package:e_commerce/View/itemCard.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import 'CategoryCard.dart';
import 'SearchBar.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = 'HameScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var firebase = FirebaseFirestore.instance;
  bool showElevatedButtonBadge = true;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  //List list = [];

  DataModel? item;

  // getAllData(){
  //   FirebaseManager.getAllProducts(list);
  //   print('List length00: ${list.length}');
  //   print('Get Products Complete');
  // }

  @override
  void initState() {
    // TODO: implement initState
    //getAllProducts2();
    //getAllData();
    isSearching = false;
    super.initState();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            /// ----- Header -----
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SearchBar(
                    isSearching: isSearching,
                    searchController: searchController,
                  ),
                  SizedBox(
                    width: size.width * 0.04,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: firebase
                          .collection(pCollection)
                          .where(pIsInCart, isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Badge(
                                badgeColor: Color(0xff33ccff),
                                position: BadgePosition.topEnd(top: 0, end: 0),
                                badgeContent: Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color(0xFF979797).withOpacity(0.1),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        Get.to(CartScreen(), transition: Transition.fade, duration: Duration(seconds: 1));
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.cartShopping,
                                        color: Colors.lightBlue,
                                      )),
                                ))
                            : snapshot.hasError
                                ? const Text('Error')
                                : const CircularProgressIndicator.adaptive();
                      }),
                  SizedBox(
                    width: size.width * 0.04,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: firebase
                          .collection(pCollection)
                          .where(pFavorite, isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Badge(
                                badgeColor: Color(0xff33ccff),
                                position: BadgePosition.topEnd(top: 0, end: 0),
                                badgeContent: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color(0xFF979797).withOpacity(0.1),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Get.to(FavoriteScreen(), transition: Transition.fade, duration: Duration(seconds: 1));

                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.heartCircleCheck,
                                        color: Colors.lightBlue,
                                      ),
                                    )))
                            : snapshot.hasError
                                ? const Text('Error')
                                : const CircularProgressIndicator.adaptive();
                      }),
                ],
              ),
            ),
            /// ----- Body -----
            Provider.of<ProviderController>(context).isSearching == false
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// Category Section
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(
                                      top: 0, left: 10, bottom: 0),
                                  child: Text(
                                    'Category',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 0, right: 10, bottom: 0),
                                child: TextButton(
                                    onPressed: () {}, child: Text('See More'))),
                          ],
                        ),
                        Container(
                          height: size.height * 0.13,
                          child: StreamBuilder<QuerySnapshot>(
                              stream:
                                  firebase.collection(cCollection).snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return CategoryItem(
                                            press: () {

                                              Get.to(CategoryScreen(cid: snapshot.data!.docs[index]
                                              [cid], cName: snapshot.data!.docs[index]
                                              [cName],));
                                            },
                                            cName: snapshot.data!.docs[index]
                                                [cName],
                                            cIcon: Icon(Icons.accessibility),
                                          );
                                        },
                                      )
                                    : snapshot.hasError
                                        ? Text('Error')
                                        : Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                              }),
                        ),

                        /// Offers Section
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(
                                      top: 0, left: 10, bottom: 0),
                                  child: Text(
                                    'Special Offers',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 0, right: 10, bottom: 0),
                                child: TextButton(
                                    onPressed: () {}, child: Text('See More'))),
                          ],
                        ),
                        Container(
                          height: size.height * 0.18,
                          child: StreamBuilder<QuerySnapshot>(
                              stream:
                                  firebase.collection(oCollection).snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return OffersCard(
                                            url: snapshot.data!.docs[index]
                                                [oImage],
                                            offerName: snapshot
                                                .data!.docs[index][oName],
                                          );
                                        },
                                      )
                                    : snapshot.hasError
                                        ? Text('Error')
                                        : Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                              }),
                        ),

                        /// Popular Section
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(
                                      top: 0, left: 10, bottom: 0),
                                  child: Text(
                                    'Popular Products',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 0, right: 10, bottom: 0),
                                child: TextButton(
                                    onPressed: () {}, child: Text('See More'))),
                          ],
                        ),
                        Container(
                          height: size.height * 0.35,
                          child: StreamBuilder<QuerySnapshot>(
                              stream:
                                  firebase.collection(pCollection).snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return ItemViewWidget(
                                            pName: snapshot.data!.docs[index]
                                                [pName],
                                            pPrice: snapshot
                                                .data!.docs[index][pPrice]
                                                .toDouble(),
                                            image: snapshot.data!.docs[index]
                                                [pImage],
                                            isFavorite: snapshot
                                                .data!.docs[index][pFavorite],
                                            inCart: snapshot.data!.docs[index]
                                                [pIsInCart],
                                            pid: snapshot.data!.docs[index]
                                                [pid],
                                            stock: snapshot.data!.docs[index]
                                            [pStock],
                                            description: snapshot.data!.docs[index]
                                            [pDescription],
                                          );
                                        },
                                      )
                                    : snapshot.hasError
                                        ? const Text('Error')
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator
                                                  .adaptive(),
                                            ],
                                          );
                              }),
                        ),
                      ],
                    ),
                  )
                : SearchWidget(
                    query: searchController.text.trim(),
                  )
          ],
        ),
      ),
    );
  }
}
