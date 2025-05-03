import 'diary_tab.dart';
import 'table_view.dart';
import 'new_definations.dart';
import 'package:flutter/material.dart';
import 'settings_utilities_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<FarmingLogEntry> entries = [FarmingLogEntry()];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '© ngxxfus',
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF006A71),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(child: Text('Nhật ký', style: TextStyle(color: Colors.white))),
            Tab(child: Text('Nhà kho', style: TextStyle(color: Colors.white))),
            Tab(
              child: Text(
                'Thiết lập kho',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          /// TAB 0 --------------------------------------------------------------- ///
          LogbookTab(
            entries: entries,
            pageController: _pageController,
            currentPage: _currentPage,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            onAddEntry: () {
              setState(() {
                entries.add(FarmingLogEntry());
                _pageController.jumpToPage(entries.length - 1);
                _currentPage = entries.length - 1;
              });
            },
          ),

          /// TAB 1 --------------------------------------------------------------- ///
          Container(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductTable(
                  products: productsList,
                  heightTable: MediaQuery.of(context).size.height - 251,
                  onEditClicked: (int index) async {
                    // Navigate to ProductProperties and wait for the result
                    final result = await Navigator.pushNamed(
                      context,
                      '/productProperties',
                      arguments: index, // Pass the index
                    );

                    // Handle the returned updatedProduct
                    if (result is Product) {
                      setState(() {
                        productsList.removeByIndex(index);
                        productsList.addProduct(result);
                      });
                      // Show confirmation
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sản phẩm đã được cập nhật'),
                          ),
                        );
                      }
                    }
                  },
                  onRemoveClicked: (int index) {
                    setState(() {
                      productsList.removeByIndex(index);
                    });
                  },
                  onSortByImportTimeAscending: () {
                    setState(() {
                      productsList.sortByImportTimeAscending();
                    });
                  },
                  onSortByImportTimeDescending: () {
                    setState(() {
                      productsList.sortByImportTimeDescending();
                    });
                  },
                  onSortByInfoAscending: () {
                    setState(() {
                      productsList.sortByInfoAscending();
                    });
                  },
                  onSortByInfoDescending: () {
                    setState(() {
                      productsList.sortByInfoDescending();
                    });
                  },
                  onSortByNameAscending: () {
                    setState(() {
                      productsList.sortByNameAscending();
                    });
                  },
                  onSortByNameDescending: () {
                    setState(() {
                      productsList.sortByNameDescending();
                    });
                  },
                  onSortByCategoryAscending: () {
                    setState(() {
                      productsList.sortByCategoryAscending();
                    });
                  },
                  onSortByCategoryDescending: () {
                    setState(() {
                      productsList.sortByCategoryDescending();
                    });
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed:
                            () => Navigator.pushNamed(context, '/scanQRCode'),
                        child: const Text(
                          'Quét mã QR',
                          style: TextStyle(color: Color(0xFF006A71)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              '/productsReport',
                              arguments: productsList,
                            ),
                        child: const Text(
                          'Thống kê',
                          style: TextStyle(color: Color(0xFF006A71)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          /// TAB 2 --------------------------------------------------------------- ///
          SettingsUtilitiesScreen(productsList: productsList),
        ],
      ),
    );
  }
}
