import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Controller/ProviderController.dart';
import 'package:e_commerce/Model/Constant.dart';
import 'package:e_commerce/Model/DataModel.dart';
import 'package:e_commerce/View/OffersCard.dart';
import 'package:e_commerce/View/SearchWidget.dart';
import 'package:e_commerce/View/itemCard.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'CategoryCard.dart';
import 'SearchBar.dart';

class FavoriteScreen extends StatefulWidget {
  static String routeName = 'FavoriteScreen';
  final String? cid;
  final String? cName;

  const FavoriteScreen({Key? key, this.cid, this.cName}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var firebase = FirebaseFirestore.instance;
  bool showElevatedButtonBadge = true;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  //List list = [];

  DataModel? item;

  @override
  void initState() {
    // TODO: implement initState
    print('cid: ${widget.cid}');

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
            ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: size.height * 0.1,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff33ccff),
                      Color(0xff19c5ff),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                //color: Colors.red,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 30, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFF979797).withOpacity(0.1),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          //color: Colors.red,
                            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            child: Text(
                              'My Favorite',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'NiseBuschGardens', fontSize: 30),
                            )))
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                child: StreamBuilder<QuerySnapshot>(
                    stream: firebase
                        .collection(pCollection)
                        .where(pFavorite, isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      //print('length: ${snapshot.data!.docs.length}');
                      return snapshot.hasData
                          ? GridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (3 / 4),
                          ),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            print('Index: $index');
                            return ItemViewWidget(
                              pName: snapshot.data!.docs[index][pName],
                              pPrice: snapshot.data!.docs[index][pPrice]
                                  .toDouble(),
                              image: snapshot.data!.docs[index][pImage],
                              isFavorite: snapshot.data!.docs[index]
                              [pFavorite],
                              inCart: snapshot.data!.docs[index][pIsInCart],
                              pid: snapshot.data!.docs[index][pid],
                              stock: snapshot.data!.docs[index][pStock],
                              description: snapshot.data!.docs[index]
                              [pDescription],
                            );
                          })
                          : snapshot.hasError
                          ? Text('Error')
                          : Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20,top: 10),
              width: size.width*0.5,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    backgroundColor: Color(0xff19c5ff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    )),
                child: Text(
                  'BUY NOW',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * .65);

    var firstControlPoint = Offset(0, size.height * .75);
    var firstEndPoint = Offset(size.width / 6, size.height * .75);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width / 1.2, size.height * .75);

    var secControlPoint = Offset(size.width, size.height * .75);
    var secEndPoint = Offset(size.width, size.height * 0.85);

    path.quadraticBezierTo(
        secControlPoint.dx, secControlPoint.dy, secEndPoint.dx, secEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}