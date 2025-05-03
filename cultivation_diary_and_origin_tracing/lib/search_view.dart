import 'package:flutter/material.dart';

// Enum for search types
enum SearchType { name, date, info, category }

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String, SearchType) onSearch;
  final Function() onCloseSearch;
  final SearchType initialSearchType;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onCloseSearch,
    this.initialSearchType = SearchType.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Search type selection menu
          PopupMenuButton<SearchType>(
            initialValue: initialSearchType,
            onSelected: (SearchType type) {
              // Trigger search with the new type and current query
              onSearch(controller.text, type);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SearchType.name,
                child: Text('Search by Name'),
              ),
              const PopupMenuItem(
                value: SearchType.date,
                child: Text('Search by Date'),
              ),
              const PopupMenuItem(
                value: SearchType.info,
                child: Text('Search by Info'),
              ),
              const PopupMenuItem(
                value: SearchType.category,
                child: Text('Search by Category'),
              ),
            ],
            icon: const Icon(Icons.filter_list),
            tooltip: 'Select search type',
          ),
          const SizedBox(width: 8.0),
          // Search input field
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          onCloseSearch();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                // Trigger search on every input change
                onSearch(value, initialSearchType);
              },
              onSubmitted: (value) {
                // Trigger search when user presses 'Enter' or 'Done'
                onSearch(value, initialSearchType);
              },
            ),
          ),
        ],
      ),
    );
  }
}