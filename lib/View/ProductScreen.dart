import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Model/Constant.dart';
import 'package:e_commerce/View/itemCard.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:bulleted_list/bulleted_list.dart';

import '../Controller/FirebaseManager.dart';

class ProductScreen extends StatefulWidget {
  static String routeName = 'ProductScreen';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<String>? description;
  var firebase = FirebaseFirestore.instance;

  descFunc(String str) {
    description = str.split("*");
    print(description!.length);
    print('Text: ${description}');
  }

  updateFavorite(String pid, bool isFavorite) {
    setState(() {
      FirebaseManager.favoriteFunc(pid, isFavorite);
    });
  }

  updateCart(String pid, bool isInCart) {
    setState(() {
      FirebaseManager.cartFunc(pid, isInCart);
    });
  }

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)!.settings.arguments as Product;
    descFunc(product.description!);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          body: Container(
        child: Column(
          children: <Widget>[
            /// ----- Header -----
            Container(
              //color: Colors.red,
              child: Stack(
                children: [
                  SimpleShadow(
                    child: ClipPath(
                      clipper: BottomWaveClipper(),
                      child: Container(
                        height: size.height * 0.4,
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
                      ),
                    ),
                  ),
                  Positioned.fill(
                    bottom: 80,
                    child: Image(
                      image: CachedNetworkImageProvider(product.url!),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: size.height * 0.02,
                        left: 20,
                        right: 20,
                      ),
                      alignment: Alignment.bottomCenter,
                      child: TextScroll(
                        '${product.name!}.  ',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Nunito',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 30),
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
                ],
              ),
            ),

            /// ----- Body -----
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 0, bottom: 20),
                //color: Colors.red,
                height: size.height * 0.4,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    /// Description
                    BulletedList(
                      listItems: description!.take(5).toList(),
                      listOrder: ListOrder.unordered,
                      bulletColor: Colors.lightBlueAccent,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: GestureDetector(
                        onTap: () {
                          print('Done');
                        },
                        child: Row(children: <Widget>[
                          Text(
                            'See More Detail',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.lightBlueAccent),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.lightBlueAccent,
                          ),
                        ]),
                      ),
                    ),
                    Expanded(child: Container(
                      //color: Colors.red,
                    )),

                    /// ----- Footer -----
                    Container(
                      width: double.infinity,
                      //color: Colors.red,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          /// Add to Cart
                          StreamBuilder<QuerySnapshot>(
                              stream: firebase
                                  .collection(pCollection)
                                  .where(pid, isEqualTo: product.pid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? SimpleShadow(
                                        color: Colors.blue,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                              color: Colors.lightBlueAccent,
                                            ),
                                          ),
                                          child: snapshot.data!.docs[0]
                                                      [pIsInCart] ==
                                                  false
                                              ? IconButton(
                                                  onPressed: () {
                                                    updateCart(
                                                        snapshot.data!.docs[0]
                                                            [pid],
                                                        snapshot.data!.docs[0]
                                                            [pIsInCart]);
                                                  },
                                                  icon: const Icon(
                                                    Icons.add_shopping_cart,
                                                    color: Colors.black,
                                                  ))
                                              : IconButton(
                                                  onPressed: () {
                                                    updateCart(
                                                        snapshot.data!.docs[0]
                                                            [pid],
                                                        snapshot.data!.docs[0]
                                                            [pIsInCart]);
                                                  },
                                                  icon: const Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.black,
                                                  )),
                                        ),
                                      )
                                    : snapshot.hasError
                                        ? Text('Error')
                                        : CircularProgressIndicator
                                            .adaptive();
                              }),
                          SizedBox(
                            width: 10,
                          ),

                          /// Favorite
                          StreamBuilder<QuerySnapshot>(
                              stream: firebase
                                  .collection(pCollection)
                                  .where(pid, isEqualTo: product.pid)
                                  .snapshots(),
                              builder: (context, snapshot) {

                                return snapshot.hasData
                                    ? SimpleShadow(
                                        color: Colors.blue,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                              color: Colors.lightBlueAccent,
                                            ),
                                          ),
                                          child: snapshot.data!.docs[0]
                                                      [pFavorite] ==
                                                  false
                                              ? IconButton(
                                                  onPressed: () {
                                                    updateFavorite(
                                                        snapshot.data!.docs[0]
                                                            [pid],
                                                        snapshot.data!.docs[0]
                                                            [pFavorite]);
                                                  },
                                                  icon: Icon(
                                                      Icons.favorite_border))
                                              : IconButton(
                                                  onPressed: () {
                                                    updateFavorite(
                                                        snapshot.data!.docs[0]
                                                            [pid],
                                                        snapshot.data!.docs[0]
                                                            [pFavorite]);
                                                  },
                                                  icon: Icon(Icons.favorite)),
                                        ),
                                      )
                                    : snapshot.hasError
                                        ? Text('Error')
                                        : CircularProgressIndicator
                                            .adaptive();
                              }),
                          SizedBox(
                            width: 10,
                          ),

                          /// Buy Now
                          Expanded(
                            child: SizedBox(
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
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
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
