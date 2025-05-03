import 'package:flutter/material.dart';

import 'new_definations.dart';

enum MenuAction { edit, remove }

class ProductTable extends StatelessWidget {
  final double? widthTable;
  final double? heightTable;
  final ProductsList products;
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

  Widget wrapTextRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value ?? 'N/A'),
          ],
        ),
        maxLines: null,
        textAlign: TextAlign.left,
        overflow: TextOverflow.visible,
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product? product, int index) {
    if (product == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(product.name ?? 'No Name'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  wrapTextRow('ID: ', product.productID),
                  wrapTextRow('X. xứ: ', product.origin),
                  wrapTextRow('S. lượng: ', product.quantity?.toString()),
                  wrapTextRow('Đ. vị: ', product.quantityUnit),
                  wrapTextRow('T. tin: ', product.info),
                  wrapTextRow('G. tiền: ', product.price?.toString()),
                  wrapTextRow('P. loại: ', product.category),
                  wrapTextRow('T.G. Nhập: ', product.importTime?.toString()),
                  wrapTextRow('T.G. Xuất: ', product.exportTime?.toString()),
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
        const PopupMenuItem(value: MenuAction.edit, child: Text('Edit')),
        const PopupMenuItem(value: MenuAction.remove, child: Text('Remove')),
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
          constraints: BoxConstraints(
            minWidth: tableWidth,
            maxWidth: tableWidth * 2,
          ),
          padding: EdgeInsets.symmetric(horizontal: tableWidth * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 2),
              // Table Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Distinct background for header
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                        child: InkWell(
                          onTap: onSortByNameAscending,
                          onDoubleTap: onSortByNameDescending,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Tên',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                        child: InkWell(
                          onTap: onSortByImportTimeAscending,
                          onDoubleTap: onSortByImportTimeDescending,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Nhập kho',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                        child: InkWell(
                          onTap: onSortByCategoryAscending,
                          onDoubleTap: onSortByCategoryDescending,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Danh mục',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: InkWell(
                          onTap: onSortByInfoAscending,
                          onDoubleTap: onSortByInfoDescending,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Thông tin',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Table Rows
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products.getElementAtIndex(index);
                    return GestureDetector(
                      onTap: () => _showProductDetails(context, product, index),
                      onLongPressStart:
                          (details) => _showContextMenu(
                            context,
                            details.globalPosition,
                            index,
                          ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Different background for rows
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                            left: BorderSide(color: Colors.grey.shade300),
                            right: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product?.name ?? '',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product?.importTime.toString() ?? '',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product?.category ?? '',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product?.info ?? '',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
