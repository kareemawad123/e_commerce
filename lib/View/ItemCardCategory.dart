import 'package:bulleted_list/bulleted_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/Controller/FirebaseManager.dart';
import 'package:e_commerce/Model/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:text_scroll/text_scroll.dart';

import 'ProductScreen.dart';

class Product {
  String? pid;
  String? url;
  String? name;
  int? stock;
  String? description;
  double? price;
  bool? isFavorite;
  bool? isInCart;

  Product(
      {this.pid,
        this.url,
        this.name,
        this.stock,
        this.description,
        this.price,
        this.isFavorite,
        this.isInCart});
}

class ItemViewWidgetCategory extends StatefulWidget {
  final String? pName;
  final double? pPrice;
  final String? image;
  final bool? isFavorite;
  final DataModel? item;
  final bool? inCart;
  final String? pid;
  final int? stock;
  final String? description;

  const ItemViewWidgetCategory(
      {Key? key,
        this.pid,
        this.pName,
        this.description,
        this.pPrice,
        this.image,
        this.isFavorite,
        this.item,
        this.stock,
        this.inCart})
      : super(key: key);

  @override
  State<ItemViewWidgetCategory> createState() => _ItemViewWidgetCategoryState();
}

class _ItemViewWidgetCategoryState extends State<ItemViewWidgetCategory> {
  List<String>? description;

  descFunc(String str) {
    description = str.split("*");
    print(description!.length);
    print('Text: ${description}');
  }

  updateFavorite() {
    setState(() {
      FirebaseManager.favoriteFunc(widget.pid!, widget.isFavorite!);
    });
  }

  updateCart() {
    setState(() {
      FirebaseManager.cartFunc(widget.pid!, widget.inCart!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    descFunc(widget.description!);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductScreen.routeName,
            arguments: Product(
              pid: widget.pid!,
              url: widget.image!,
              name: widget.pName!,
              stock: widget.stock!,
              description: widget.description!,
              price: widget.pPrice!,
              isFavorite: widget.isFavorite,
              isInCart: widget.inCart,
            ));
      },
      child: Container(
        height: size.height * 0.25,
        width: size.width * 0.45,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff33ccff),
              Color(0xff19c5ff),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0xff33ccff).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            /// Product Image
            Container(
              margin: const EdgeInsets.all(10),
              width: size.width * 0.44,
              height: size.height * 0.15,
              child: Image(
                image: CachedNetworkImageProvider(widget.image!),
              ),
            ),

            /// Product Name
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              child: TextScroll(
                "${widget.pName}.  ",
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            /// Product Description
            Expanded(child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
            )),
            Row(
              children: [
                widget.inCart == false
                    ? IconButton(
                    onPressed: updateCart,
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ))
                    : IconButton(
                    onPressed: updateCart,
                    icon: const Icon(Icons.shopping_cart,
                        color: Colors.white)),
                Expanded(
                  child: Text(
                    "\$${widget.pPrice}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Nunito',
                    ),
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.clip,
                  ),
                ),
                widget.isFavorite == true
                    ? IconButton(
                    onPressed: updateFavorite,
                    icon: const Icon(Icons.favorite_outlined,
                        color: Colors.white))
                    : IconButton(
                    onPressed: updateFavorite,
                    icon: const Icon(Icons.favorite_border_outlined,
                        color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
