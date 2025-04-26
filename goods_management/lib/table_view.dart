import 'package:flutter/material.dart';
import 'new_definations.dart';

enum MenuAction { edit, remove }

class ProductTable extends StatelessWidget {
  final double? widthTable;
  final double? heightTable;
  final ProductList products;
  final Function(int) onEditClicked;
  final Function(int) onRemoveClicked;

  const ProductTable({
    super.key,
    this.widthTable,
    this.heightTable,
    required this.products,
    required this.onEditClicked,
    required this.onRemoveClicked,
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

    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(
        left: 0.01 * tableWidth,
        right: 0.01 * tableHeight,
      ),
      child: SizedBox(
        width: tableWidth,
        height: tableHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Table Header
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Tên',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Nhập kho',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Thông tin',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
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
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              product?.importTime.toString() ?? '',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              product?.info ?? '',
                              textAlign: TextAlign.start,
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
    );
  }
}