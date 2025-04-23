import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec/provider/product_provider.dart';


void showSortModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSortOption(
              context,
              ref,
              'Price: High to Low',
              'price_desc',
              Icons.arrow_downward,
            ),
            _buildSortOption(
              context,
              ref,
              'Price: Low to High',
              'price_asc',
              Icons.arrow_upward,
            ),
            _buildSortOption(
              context,
              ref,
              'Rating: High to Low',
              'rating_desc',
              Icons.star,
            ),
            _buildSortOption(
              context,
              ref,
              'Rating: Low to High',
              'rating_asc',
              Icons.star_border,
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildSortOption(
  BuildContext context,
  WidgetRef ref,
  String text,
  String value,
  IconData icon,
) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: () {
      ref.read(productProvider.notifier).sortProducts(value);
      Navigator.pop(context);
    },
  );
}