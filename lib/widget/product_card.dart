import 'package:flutter/material.dart';
import 'package:qtec/models/products.dart';
import 'package:qtec/screens/product_details_screen.dart';
import 'package:qtec/utils/responsive.dart';
import 'package:qtec/widget/load_widget.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});
  // Update the card to be more responsive
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Add product detail navigation if needed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.error, size: 40)),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: GradientProgressRing(),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Responsive.isDesktop(context) ? 12 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.isDesktop(context) ? 18 : 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.isDesktop(context) ? 16 : 14,
                      color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: Responsive.isDesktop(context) ? 20 : 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: Responsive.isDesktop(context) ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
