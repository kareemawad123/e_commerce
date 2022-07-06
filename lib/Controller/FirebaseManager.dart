import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Model/Constant.dart';

class FirebaseManager {
  var firestore = FirebaseFirestore.instance;

  static Future<void> favoriteFunc(String id, bool isFavorite) async {
    var firestore = FirebaseFirestore.instance;
    if (isFavorite == true) {
      await firestore
          .collection(pCollection)
          .doc(id)
          .update({pFavorite: false});
    } else {
      await firestore.collection(pCollection).doc(id).update({pFavorite: true});
    }
  }

  static Future<void> cartFunc(String id, bool isInCart) async {
    var firestore = FirebaseFirestore.instance;
    if (isInCart == true) {
      await firestore
          .collection(pCollection)
          .doc(id)
          .update({pIsInCart: false});
    } else {
      await firestore.collection(pCollection).doc(id).update({pIsInCart: true});
    }
  }

  static Future<List> getAllProducts(List list) async {
    final List list;
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection(pCollection);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    list = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(list);
    return list;
  }
}
