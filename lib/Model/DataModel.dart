

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Constant.dart';

class DataModel{
  String? uid;
  String? name;
  String? description;
  String? image;
  int? stock;
  bool? favorite;
  bool? isInCart;
  double? price;


   String getID(){
     FirebaseFirestore? firebase = FirebaseFirestore.instance;
     return firebase.collection('products').doc().id;
   }

  DataModel(
      {this.uid,
      this.name,
      this.description,
      this.image,
      this.stock,
      this.favorite,
      this.isInCart,
      this.price});


  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'name': this.name,
      'description': this.description,
      'image': this.image,
      'stock': this.stock,
      'favorite': this.favorite,
      'isInCart': this.isInCart,
      'price': this.price,
    };
  }

  factory DataModel.fromMap(dynamic map) {
    return DataModel(
      uid: map[pid] as String,
      name: map[pName] as String,
      description: map[pDescription] as String,
      image: map[pImage] as String,
      stock: map[pStock] as int,
      favorite: map[pFavorite] as bool,
      isInCart: map[pIsInCart] as bool,
      price: map[pPrice] as double,
    );
  }
}