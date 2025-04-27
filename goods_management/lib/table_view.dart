import 'package:flutter/material.dart';
import 'new_definations.dart';

enum MenuAction { edit, remove }

class ProductTable extends StatelessWidget {
  final double? widthTable;
  final double? heightTable;
  final ProductList products;
  final Function(int) onEditClicked;
  final Function(int) onRemoveClicked;
  final VoidCallback onSortByNameAscending;
  final VoidCallback onSortByNameDescending;
  final VoidCallback onSortByImportTimeAscending;
  final VoidCallback onSortByImportTimeDescending;
  final VoidCallback onSortByInfoAscending;
  final VoidCallback onSortByInfoDescending;
  final VoidCallback onSortByCategoryAscending;
  final VoidCallback onSortByCategoryDescending;

  const ProductTable({
    super.key,
    this.widthTable,
    this.heightTable,
    required this.products,
    required this.onEditClicked,
    required this.onRemoveClicked,
    required this.onSortByNameAscending,
    required this.onSortByNameDescending,
    required this.onSortByImportTimeAscending,
    required this.onSortByImportTimeDescending,
    required this.onSortByInfoAscending,
    required this.onSortByInfoDescending,
    required this.onSortByCategoryAscending,
    required this.onSortByCategoryDescending,
  });

  // Method to show product details in a dialog
  void _showProductDetails(BuildContext context, Product? product, int index) {
    if (product == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name ?? 'No Name'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${product.productID ?? 'N/A'}'),
              Text('Origin: ${product.origin ?? 'N/A'}'),
              Text('Info: ${product.info ?? 'N/A'}'),
              Text('Price: ${product.price?.toString() ?? 'N/A'}'),
              Text('Category: ${product.category ?? 'N/A'}'),
              Text('Import Time: ${product.importTime?.toString() ?? 'N/A'}'),
              Text('Export Time: ${product.exportTime?.toString() ?? 'N/A'}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Method to show context menu on long press
  void _showContextMenu(BuildContext context, Offset position, int index) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(
          value: MenuAction.edit,
          child: Text('Edit'),
        ),
        const PopupMenuItem(
          value: MenuAction.remove,
          child: Text('Remove'),
        ),
      ],
    ).then((value) {
      if (value == MenuAction.edit) {
        onEditClicked(index);
      } else if (value == MenuAction.remove) {
        onRemoveClicked(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentWidth = MediaQuery.of(context).size.width;
    final parentHeight = MediaQuery.of(context).size.height;

    final tableWidth = widthTable ?? parentWidth;
    final tableHeight = heightTable ?? parentHeight;

    return SizedBox(
      width: tableWidth,
      height: tableHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(minWidth: tableWidth, maxWidth: tableWidth * 2),
          padding: EdgeInsets.symmetric(horizontal: tableWidth * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table Header
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: onSortByNameAscending,
                        onDoubleTap: onSortByNameDescending,
                        child: const Text(
                          'Tên',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: onSortByImportTimeAscending,
                        onDoubleTap: onSortByImportTimeDescending,
                        child: const Text(
                          'Nhập kho',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: onSortByCategoryAscending,
                        onDoubleTap: onSortByCategoryDescending,
                        child: const Text(
                          'Danh mục',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: onSortByInfoAscending,
                        onDoubleTap: onSortByInfoDescending,
                        child: const Text(
                          'Thông tin',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Table Rows
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products.getElementAtIndex(index);
                    return GestureDetector(
                      onTap: () => _showProductDetails(context, product, index),
                      onLongPressStart: (details) =>
                          _showContextMenu(context, details.globalPosition, index),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                product?.name ?? '',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                product?.importTime.toString() ?? '',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                product?.category ?? '',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                product?.info ?? '',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}