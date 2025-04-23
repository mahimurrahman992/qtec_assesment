// screens/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/product_provider.dart';
import '../utils/responsive.dart';
import '../widget/product_card.dart';

class SearchResultsScreen extends ConsumerWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search: "$query"'),leading: IconButton(onPressed: () {
          Navigator.pop(context);
          
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: state is ProductLoaded
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Found ${state.products.length} "${query}" products',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.getCrossAxisCount(context),
                      childAspectRatio: Responsive.getChildAspectRatio(context),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) =>
                        ProductCard(product: state.products[index]),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}