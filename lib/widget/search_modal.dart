// widgets/search_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec/screens/search_screen.dart';
import '../provider/product_provider.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _isSearching = false);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => _isSearching = value.isNotEmpty);
              },
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                ref.watch(productProvider);
                
                return ElevatedButton(
                   onPressed: _searchController.text.isEmpty
      ? null
      : () {
          ref.read(productProvider.notifier).searchProducts(
                _searchController.text,
              );
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultsScreen(
                query: _searchController.text,
              ),
            ),
          );
        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Search'),
                );
              },
            ),
            const SizedBox(height: 8),
            if (_isSearching)
              Consumer(
                builder: (context, ref, child) {
                  ref.watch(productProvider);
                  
                  return Text(
                    '${_searchController.text.isEmpty ? '' : 'Search for "${_searchController.text}" '}',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

void showSearchModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const SearchModal(),
  );
}