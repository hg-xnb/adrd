import 'package:collection/collection.dart';

class Product {
  String? name;
  String? origin;
  String? info;
  double? price;
  String? productID;
  String? category;
  DateTime? importTime;
  DateTime? exportTime;

  // Default constructor
  Product({
    this.name,
    this.origin,
    this.info,
    this.price,
    this.productID,
    this.category, // Initialize Category
    this.importTime, // Initialize ImportTime
    this.exportTime, // Initialize ExportTime
  }) {
    productID = productID ?? _generateProductID();
    name = name ?? 'new-$productID';
    origin = origin;
    info = info;
    price = price;
    category = category;
    importTime = importTime;
    exportTime = exportTime;
  }

  // Private method to generate Product ID
  String _generateProductID() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2); // YY
    final month = now.month.toString().padLeft(2, '0'); // MM
    final day = now.day.toString().padLeft(2, '0'); // DD
    final hour = now.hour.toString().padLeft(2, '0'); // hh (24-hour format)
    final minute = now.minute.toString().padLeft(2, '0'); // mm (minute)
    final second = now.second.toString().padLeft(2, '0'); // ss
    return '$year$month$day$hour$minute$second';
  }

  // Getter for productID
  String? get id => productID;

  // Optional: Method to convert Product object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'origin': origin,
      'info': info,
      'price': price,
      'productID': productID,
      'category': category, // Add Category to the map
      'importTime':
          importTime?.toIso8601String(), // Convert DateTime to String for map
      'exportTime':
          exportTime?.toIso8601String(), // Convert DateTime to String for map
    };
  }

  // Optional: Method to create a Product object from a Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      origin: map['origin'],
      info: map['info'],
      price: map['price']?.toDouble(),
      productID: map['productID'],
      category: map['category'], // Read Category from the map
      importTime:
          map['importTime'] != null
              ? DateTime.parse(map['importTime'])
              : null, // Parse String to DateTime
      exportTime:
          map['exportTime'] != null
              ? DateTime.parse(map['exportTime'])
              : null, // Parse String to DateTime
    );
  }

  @override
  String toString() {
    return 'Product{name: $name, origin: $origin, info: $info, price: $price, productID: $productID, category: $category, importTime: $importTime, exportTime: $exportTime}';
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

class ProductList {
  final List<Product> _products = [];

  // Constructor that initializes with a list of products
  ProductList({List<Product>? initialProducts}) {
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
}

List<Product> allProducts = [
  Product(
    name: "Laptop Model 1",
    origin: "China",
    info: "High-performance laptop",
    price: 1200.0,
    productID: "240426101530",
    category: "Laptop",
    importTime: DateTime(2024, 3, 1, 10, 15),
    exportTime: DateTime(2024, 4, 20, 14, 30),
  ),
  Product(
    name: "Smartphone X",
    origin: "South Korea",
    info: "Latest generation smartphone",
    price: 999.99,
    productID: "240426101531",
    category: "Smartphone",
    importTime: DateTime(2024, 3, 5, 9, 0),
    exportTime: DateTime(2024, 4, 22, 13, 45),
  ),
  Product(
    name: "Wireless Headphones Pro",
    origin: "USA",
    info: "Noise-cancelling headphones",
    price: 250.0,
    productID: "240426101532",
    category: "Headphones",
    importTime: DateTime(2024, 3, 10, 8, 30),
    exportTime: DateTime(2024, 4, 25, 10, 0),
  ),
  Product(
    name: "Smartwatch Series 7",
    origin: "Japan",
    info: "Fitness and health tracker",
    price: 300.50,
    productID: "240426101533",
    category: "Smartwatch",
    importTime: DateTime(2024, 3, 12, 11, 0),
    exportTime: DateTime(2024, 4, 23, 15, 30),
  ),
  Product(
    name: "Tablet Air",
    origin: "Taiwan",
    info: "Portable and versatile tablet",
    price: 450.0,
    productID: "240426101534",
    category: "Tablet",
    importTime: DateTime(2024, 3, 8, 14, 15),
    exportTime: DateTime(2024, 4, 24, 11, 45),
  ),
  Product(
    name: "Laptop Pro",
    origin: "USA",
    info: "Powerful workstation laptop",
    price: 1800.0,
    productID: "240426101535",
    category: "Laptop",
    importTime: DateTime(2024, 2, 28, 10, 20),
    exportTime: DateTime(2024, 4, 26, 12, 0),
  ),
  Product(
    name: "Budget Smartphone",
    origin: "India",
    info: "Affordable and reliable smartphone",
    price: 299.0,
    productID: "240426101536",
    category: "Smartphone",
    importTime: DateTime(2024, 3, 15, 13, 0),
    exportTime: DateTime(2024, 4, 21, 9, 30),
  ),
  Product(
    name: "Over-Ear Headphones",
    origin: "Germany",
    info: "Premium sound quality headphones",
    price: 350.0,
    productID: "240426101537",
    category: "Headphones",
    importTime: DateTime(2024, 3, 18, 15, 10),
    exportTime: DateTime(2024, 4, 25, 14, 45),
  ),
  Product(
    name: "Smart Band",
    origin: "China",
    info: "Basic fitness tracker",
    price: 50.0,
    productID: "240426101538",
    category: "Smartwatch",
    importTime: DateTime(2024, 3, 6, 10, 30),
    exportTime: DateTime(2024, 4, 20, 16, 15),
  ),
  Product(
    name: "E-reader Tablet",
    origin: "Japan",
    info: "Optimized for reading",
    price: 150.0,
    productID: "240426101539",
    category: "Tablet",
    importTime: DateTime(2024, 3, 3, 8, 50),
    exportTime: DateTime(2024, 4, 19, 17, 0),
  ),
  // Generate the remaining 90 products with different years
  for (int i = 11; i <= 100; i++)
    Product(
      name: "Generic Product $i",
      origin: ["USA", "China", "Japan", "Germany", "India"][i % 5],
      info: "Some information about product $i",
      price: double.tryParse((i * 5.55).toStringAsFixed(2)),
      productID:
          DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
      category:
          ["Electronics", "Fashion", "Books", "Appliances", "Other"][i % 5],
      importTime: DateTime(
        2020 + (i % 5),
        i % 12 + 1,
        i % 28 + 1,
        i % 24,
        i % 60,
      ),
      exportTime: DateTime(
        2021 + (i % 5),
        i % 12 + 1,
        i % 28 + 1,
        i % 24,
        i % 60 + 15,
      ),
    ),
];

ProductList productList = ProductList(initialProducts: allProducts);
