import 'package:flutter/material.dart';
import 'new_definations.dart';

class ProductListNotifier extends ChangeNotifier {
  ProductList productList; // Changed from _productList to public productList

  ProductListNotifier({List<Product>? initialProducts})
      : productList = ProductList(initialProducts: initialProducts);

  void sortByNameAscending() {
    productList.sortByNameAscending();
    notifyListeners();
  }

  void sortByNameDescending() {
    productList.sortByNameDescending();
    notifyListeners();
  }

  void sortByImportTimeAscending() {
    productList.sortByImportTimeAscending();
    notifyListeners();
  }

  void sortByImportTimeDescending() {
    productList.sortByImportTimeDescending();
    notifyListeners();
  }

  void sortByInfoAscending() {
    productList.sortByInfoAscending();
    notifyListeners();
  }

  void sortByInfoDescending() {
    productList.sortByInfoDescending();
    notifyListeners();
  }

  void removeProductAtIndex(int index) {
    final product = productList.getElementAtIndex(index);
    if (product != null && product.productID != null) {
      productList.deleteProduct(product.productID!);
      notifyListeners();
    }
  }

  void addProduct(Product product) {
    productList.addProduct(product);
    notifyListeners();
  }
}