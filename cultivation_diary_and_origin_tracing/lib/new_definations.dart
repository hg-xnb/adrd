import 'package:collection/collection.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

/// ------------------------------------------------------------------- ///

class Product {
  String? name;
  String? origin;
  String? info;
  double? price;
  String? productID;
  String? category;
  DateTime? importTime;
  DateTime? exportTime;
  
  double? quantity;
  String? quantityUnit;

  String? cultivationInfo;     // Thông tin canh tác
  String? productProperties;   // Tính chất sản phẩm

  // Constructor
  Product({
    this.name,
    this.origin,
    this.info,
    this.price,
    this.productID,
    this.category,
    this.importTime,
    this.exportTime,
    this.quantity,
    this.quantityUnit,
    this.cultivationInfo,
    this.productProperties,
  }) {
    productID = productID ?? _generateProductID();
    name = name ?? 'new-$productID';
    importTime = importTime ?? DateTime.now();
    quantity = quantity ?? 0;
  }

  String _generateProductID() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    return '$year$month$day$hour$minute$second';
  }

  String? get id => productID;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'origin': origin,
      'info': info,
      'price': price,
      'productID': productID,
      'category': category,
      'importTime': importTime?.toIso8601String(),
      'exportTime': exportTime?.toIso8601String(),
      'quantity': quantity,
      'quantityUnit': quantityUnit,
      'cultivationInfo': cultivationInfo,
      'productProperties': productProperties,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      origin: map['origin'],
      info: map['info'],
      price: map['price']?.toDouble(),
      productID: map['productID'],
      category: map['category'],
      importTime: map['importTime'] != null ? DateTime.parse(map['importTime']) : null,
      exportTime: map['exportTime'] != null ? DateTime.parse(map['exportTime']) : null,
      quantity: map['quantity'],
      quantityUnit: map['quantityUnit'],
      cultivationInfo: map['cultivationInfo'],
      productProperties: map['productProperties'],
    );
  }

  @override
  String toString() {
    return 'Product{name: $name, origin: $origin, info: $info, price: $price, productID: $productID, category: $category, importTime: $importTime, exportTime: $exportTime, quantity: $quantity, quantityUnit: $quantityUnit, cultivationInfo: $cultivationInfo, productProperties: $productProperties}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          productID == other.productID;

  @override
  int get hashCode => productID.hashCode;
}


class ProductsList {
  final List<Product> _products = [];

  // Constructor that initializes with a list of products
  ProductsList({List<Product>? initialProducts}) {
    if (initialProducts != null) {
      _products.addAll(initialProducts);
    }
  }

  // Method to add a product
  void addProduct(Product product) {
    // Check if the product is already in the list
    if (_products.any((p) => p.productID == product.productID)) {
      throw ArgumentError("Product with this ID already exists");
    }
    _products.add(product);
  }

  // Method to remove a product by index
  void removeByIndex(int index) {
    if (index < 0 || index >= _products.length) {
      throw ArgumentError("Index out of bounds");
    }
    _products.removeAt(index);
  }

  // Method to delete a product by ID
  void deleteProduct(String productID) {
    _products.removeWhere((product) => product.productID == productID);
  }

  // Method to find a product by ID
  Product? findProductByID(String productID) {
    return _products.firstWhereOrNull(
      (product) => product.productID == productID,
    );
  }

  // Method to find products by name (case-insensitive)
  List<Product> findProductsByName(String name) {
    return _products
        .where(
          (product) =>
              product.name?.toLowerCase().contains(name.toLowerCase()) ?? false,
        )
        .toList();
  }

  // Getter to get all products. This returns a copy to prevent external modification.
  List<Product> get allProducts {
    return [..._products];
  }

  // Method to get the count of each category
  Map<String, int> getCategoryCounts() {
    final categoryCounts = <String, int>{};
    for (final product in _products) {
      final category = product.category;
      if (category != null) {
        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
      }
    }
    return categoryCounts;
  }

  // Method to count the number of products in a specific category
  int countProductsFromCategory(String category) {
    return _products
        .where(
          (product) =>
              product.category?.toLowerCase() == category.toLowerCase(),
        )
        .length;
  }

  // Getter to get the length of the product list
  int get length => _products.length;

  // Method to get a product at a specific index
  Product? getElementAtIndex(int index) {
    if (index >= 0 && index < _products.length) {
      return _products[index];
    }
    return null; // Return null if the index is out of bounds
  }

  // Sorting methods to match ProductTable's onSort callbacks
  void sortByNameAscending() {
    _products.sort((a, b) {
      final aName = a.name ?? '';
      final bName = b.name ?? '';
      return aName.compareTo(bName);
    });
  }

  void sortByNameDescending() {
    _products.sort((a, b) {
      final aName = a.name ?? '';
      final bName = b.name ?? '';
      return bName.compareTo(aName);
    });
  }

  void sortByImportTimeAscending() {
    _products.sort((a, b) {
      final aTime = a.importTime ?? DateTime(0);
      final bTime = b.importTime ?? DateTime(0);
      return aTime.compareTo(bTime);
    });
  }

  void sortByImportTimeDescending() {
    _products.sort((a, b) {
      final aTime = a.importTime ?? DateTime(0);
      final bTime = b.importTime ?? DateTime(0);
      return bTime.compareTo(aTime);
    });
  }

  void sortByInfoAscending() {
    _products.sort((a, b) {
      final aInfo = a.info ?? '';
      final bInfo = b.info ?? '';
      return aInfo.compareTo(bInfo);
    });
  }

  void sortByInfoDescending() {
    _products.sort((a, b) {
      final aInfo = a.info ?? '';
      final bInfo = b.info ?? '';
      return bInfo.compareTo(aInfo);
    });
  }

  void sortByCategoryAscending() {
    _products.sort((a, b) {
      final aCategory = a.category ?? '';
      final bCategory = b.category ?? '';
      return aCategory.compareTo(bCategory);
    });
  }

  void sortByCategoryDescending() {
    _products.sort((a, b) {
      final aCategory = a.category ?? '';
      final bCategory = b.category ?? '';
      return bCategory.compareTo(aCategory);
    });
  }

  void sortByAmountAscending() {
    _products.sort((a, b) => (a.quantity ?? 0).compareTo(b.quantity ?? 0));
  }

  void sortByAmountDescending() {
    _products.sort((a, b) => (b.quantity ?? 0).compareTo(a.quantity ?? 0));
  }
}

List<Product> allProducts = [
  // 10 sản phẩm cố định đầu tiên
  Product(
    name: "Cà chua",
    origin: "Việt Nam",
    info: "Rau quả sạch, giàu vitamin C",
    price: 15000.0,
    productID: "250503100001",
    category: "Rau củ",
    importTime: DateTime(2025, 4, 10, 7, 30),
    exportTime: DateTime(2025, 4, 20, 16, 0),
    quantity: 100,
    cultivationInfo: "Trồng hữu cơ, không thuốc trừ sâu",
    productProperties: "Chín mọng, màu đỏ tươi",
  ),
  Product(
    name: "Cải bó xôi",
    origin: "Đà Lạt",
    info: "Tươi xanh, thích hợp cho món xào hoặc salad",
    price: 20000.0,
    productID: "250503100002",
    category: "Rau lá",
    importTime: DateTime(2025, 4, 12, 8, 15),
    exportTime: DateTime(2025, 4, 22, 17, 0),
    quantity: 80,
    cultivationInfo: "Trồng trong nhà kính",
    productProperties: "Lá dày, giàu sắt",
  ),
  Product(
    name: "Khoai tây",
    origin: "Lâm Đồng",
    info: "Củ đều, vỏ mỏng, ngọt bùi",
    price: 18000.0,
    productID: "250503100003",
    category: "Củ",
    importTime: DateTime(2025, 4, 8, 6, 45),
    exportTime: DateTime(2025, 4, 19, 14, 30),
    quantity: 150,
    cultivationInfo: "Trồng ở cao nguyên",
    productProperties: "Củ chắc, không sâu bệnh",
  ),
  Product(
    name: "Cà rốt",
    origin: "Hà Nội",
    info: "Giàu beta-carotene, củ lớn đều",
    price: 16000.0,
    productID: "250503100004",
    category: "Củ",
    importTime: DateTime(2025, 4, 9, 7, 0),
    exportTime: DateTime(2025, 4, 21, 15, 45),
    quantity: 120,
    cultivationInfo: "Tưới tiêu nhỏ giọt",
    productProperties: "Màu cam đậm, giòn",
  ),
  Product(
    name: "Xà lách",
    origin: "Đà Lạt",
    info: "Giòn, tươi, phù hợp làm salad",
    price: 12000.0,
    productID: "250503100005",
    category: "Rau lá",
    importTime: DateTime(2025, 4, 11, 8, 0),
    exportTime: DateTime(2025, 4, 23, 16, 15),
    quantity: 70,
    cultivationInfo: "Không dùng phân hóa học",
    productProperties: "Lá xoăn, vị dịu",
  ),
  Product(
    name: "Hành lá",
    origin: "Hưng Yên",
    info: "Gia vị không thể thiếu trong bữa ăn",
    price: 10000.0,
    productID: "250503100006",
    category: "Gia vị",
    importTime: DateTime(2025, 4, 10, 6, 30),
    exportTime: DateTime(2025, 4, 20, 13, 20),
    quantity: 60,
    cultivationInfo: "Tưới nước sông sạch",
    productProperties: "Thân trắng, lá dài",
  ),
  Product(
    name: "Ớt chuông đỏ",
    origin: "Đà Lạt",
    info: "Màu đẹp, vị ngọt, ít cay",
    price: 25000.0,
    productID: "250503100007",
    category: "Rau củ",
    importTime: DateTime(2025, 4, 13, 9, 30),
    exportTime: DateTime(2025, 4, 24, 17, 45),
    quantity: 90,
    cultivationInfo: "Trồng bằng phân vi sinh",
    productProperties: "Màu đỏ đậm, giòn",
  ),
  Product(
    name: "Bí đỏ",
    origin: "Quảng Nam",
    info: "Ngọt, dẻo, phù hợp nấu canh hoặc chè",
    price: 14000.0,
    productID: "250503100008",
    category: "Củ quả",
    importTime: DateTime(2025, 4, 7, 7, 15),
    exportTime: DateTime(2025, 4, 18, 12, 50),
    quantity: 110,
    cultivationInfo: "Không phun thuốc bảo vệ thực vật",
    productProperties: "Vỏ xanh, ruột vàng",
  ),
  Product(
    name: "Đậu que",
    origin: "Long An",
    info: "Giòn, non, phù hợp luộc/xào",
    price: 17000.0,
    productID: "250503100009",
    category: "Đậu",
    importTime: DateTime(2025, 4, 14, 10, 0),
    exportTime: DateTime(2025, 4, 25, 15, 30),
    quantity: 85,
    cultivationInfo: "Tưới tiêu nhỏ giọt, không phân hóa học",
    productProperties: "Màu xanh bóng, hạt nhỏ",
  ),
  Product(
    name: "Su su",
    origin: "Sapa",
    info: "Trái su su non, giòn, ngọt",
    price: 13000.0,
    productID: "250503100010",
    category: "Rau củ",
    importTime: DateTime(2025, 4, 6, 6, 0),
    exportTime: DateTime(2025, 4, 17, 11, 15),
    quantity: 95,
    cultivationInfo: "Trồng ở vùng núi cao, khí hậu lạnh",
    productProperties: "Vỏ xanh nhạt, không xơ",
  ),

  // Tạo sản phẩm từ 11 đến 100 với giá trị mẫu ngẫu nhiên
  for (int i = 11; i <= 100; i++)
    Product(
      name: [
        "Bí xanh",
        "Cải ngọt",
        "Cải thảo",
        "Rau muống",
        "Rau dền",
        "Rau mồng tơi",
        "Đậu bắp",
        "Hành tím",
        "Tỏi",
        "Gừng",
      ][i % 10],
      origin: ["Đà Lạt", "Lâm Đồng", "Hưng Yên", "Cần Thơ", "Quảng Nam"][i % 5],
      info: "Nông sản tươi sạch số $i",
      price: double.parse(((i * 1.1 + 10) * 1000).toStringAsFixed(0)),
      productID: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
      category: ["Rau lá", "Củ", "Gia vị", "Rau củ", "Đậu"][i % 5],
      importTime: DateTime(
        2023 + (i % 2),
        i % 12 + 1,
        i % 28 + 1,
        i % 24,
        i % 60,
      ),
      exportTime: DateTime(
        2024 + (i % 2),
        i % 12 + 1,
        i % 28 + 1,
        (i + 1) % 24,
        (i + 10) % 60,
      ),
      quantity: 50 + (i % 100),
      cultivationInfo: "Canh tác tự nhiên số $i",
      productProperties: "Chất lượng cao số $i",
    ),
];

ProductsList productsList = ProductsList(initialProducts: allProducts);

List<Map<String, double>> runningConfig = [
  {"ac": 12.0},
];


/// ------------------------------------------------------------------- ///
class FarmingLogEntry {
  List<File> images = [];
  int currentImageIndex = 0;
  DateTime entryDateTime;
  String cropVariety;
  String care;
  String fertilizing;
  String spraying;
  int wateringAmount;
  String wateringNote;
  DateTime? harvestTime;
  String harvestNote;
  String preservation;

  FarmingLogEntry({
    DateTime? entryDateTime,
    this.cropVariety = '',
    this.care = '',
    this.fertilizing = '',
    this.spraying = '',
    this.wateringAmount = 0,
    this.wateringNote = '',
    this.harvestTime,
    this.harvestNote = '',
    this.preservation = '',
  }) : entryDateTime = entryDateTime ?? DateTime.now();

  Future<void> pickImage(BuildContext context) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder:
          (ctx) => SimpleDialog(
            title: const Text('Chọn nguồn ảnh'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, ImageSource.camera),
                child: const Text('Chụp ảnh'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
                child: const Text('Thư viện'),
              ),
            ],
          ),
    );

    if (source != null) {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        images.add(File(picked.path));
      }
    }
  }

  File? get currentImage => images.isEmpty ? null : images[currentImageIndex];
}