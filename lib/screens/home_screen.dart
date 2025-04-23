import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec/provider/product_provider.dart';
import 'package:qtec/provider/theme_provider.dart';
import 'package:qtec/utils/responsive.dart';
import 'package:qtec/widget/load_widget.dart';
import 'package:qtec/widget/product_card.dart';
import 'package:qtec/widget/search_modal.dart';
import 'package:qtec/widget/shimmer_effect.dart';
import 'package:qtec/widget/sort_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(productProvider.notifier).fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);
    final theme = ref.watch(themeProvider);
 
    return Scaffold(
      // screens/home_screen.dart
      appBar: AppBar(backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: TextButton(
          onPressed: () async {
            final scaffold = ScaffoldMessenger.of(context);
            scaffold.showSnackBar(
              const SnackBar(
                content: Text('Refreshing products...'),
                duration: Duration(seconds: 1),
              ),
            );
            ref.read(productProvider.notifier).resetProducts();
          },
          child: Text(
            'QTec Products',
            style: TextStyle(color:  theme.themeMode == ThemeMode.light?Colors.black:Colors.white, fontSize: 24),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearchModal(context),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => showSortModal(context, ref),
          ),
          IconButton(
            icon: Icon(
              theme.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => theme.toggleTheme(),
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(ProductState state) {
    if (state is ProductInitial || state is ProductLoading) {
      return const ShimmerEffect();
    } else if (state is ProductError) {
      return Center(child: Text(state.message));
    } else if (state is ProductLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          ref.read(productProvider.notifier).fetchProducts();
        },
        child: // Update the GridView builder to use responsive values
            GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.getCrossAxisCount(context),
            childAspectRatio: Responsive.getChildAspectRatio(context),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: state.products.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.products.length) {
              return BouncingDotsLoader();
            }
            return ProductCard(product: state.products[index]);
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
