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

  @override
  Widget build(BuildContext context) {
    final parentWidth = MediaQuery.of(context).size.width;
    final parentHeight = MediaQuery.of(context).size.height;

    final tableWidth = widthTable ?? parentWidth;
    final tableHeight = heightTable ?? parentHeight;

    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(
        left: 0.065 * tableWidth,
        right: 0.065 * tableHeight,
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
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Nhập kho',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Thông tin',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 40), // Space for menu button
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(flex: 4, child: Text(product?.name ?? '')),
                        Expanded(
                          flex: 3,
                          child: Text(product?.importTime.toString() ?? ''),
                        ),
                        Expanded(flex: 3, child: Text(product?.info ?? '')),

                        PopupMenuButton<MenuAction>(
                          onSelected: (action) {
                            if (action == MenuAction.edit) {
                              onEditClicked(index);
                            } else if (action == MenuAction.remove) {
                              onRemoveClicked(index);
                            }
                          },
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: MenuAction.edit,
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: MenuAction.remove,
                                  child: Text('Remove'),
                                ),
                              ],
                        ),
                      ],
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
