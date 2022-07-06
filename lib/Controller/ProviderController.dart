
import 'package:flutter/cupertino.dart';

class ProviderController extends ChangeNotifier{

  bool isSearching = false;

  checkEmpty(String value){
    if (value.isNotEmpty){
      isSearching = true;
      print('Not Empty');
    }else{
      isSearching = false;
      print('Empty');
    }
    notifyListeners();
  }

}