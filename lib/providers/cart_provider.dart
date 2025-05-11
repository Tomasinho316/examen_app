import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  int item_count = 0;
  int get itemCount => item_count;
  void addItem() {
    item_count++;
    notifyListeners();
  }
}
