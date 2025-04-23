
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qtec/models/products.dart';
import 'package:qtec/services/api_services.dart';

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier();
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ApiService _apiService = ApiService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  int _page = 1;
  final int _limit = 10;
  int _totalProducts = 0;
  String? _currentSearchQuery;

  ProductNotifier() : super(ProductInitial()) {
    fetchProducts();
  }
// In your ProductNotifier class
void resetProducts() {
  _page = 1;
  _allProducts = [];
  _filteredProducts = [];
  _currentSearchQuery = null;
  _totalProducts = 0;
  state = ProductInitial();
  fetchProducts(); // This will trigger a fresh load
}
Future<void> fetchProducts() async {
  try {
    if (state is! ProductLoaded) state = ProductLoading();
    
    final products = await _apiService.fetchProducts(page: _page, limit: _limit);
    _allProducts = [..._allProducts, ...products];
    _totalProducts = _allProducts.length;
    
    // Apply current search filter if exists
    if (_currentSearchQuery != null && _currentSearchQuery!.isNotEmpty) {
      _filteredProducts = _allProducts.where((product) => 
        product.title.toLowerCase().contains(_currentSearchQuery!.toLowerCase()) ||
        product.description.toLowerCase().contains(_currentSearchQuery!.toLowerCase()) ||
        product.brand.toLowerCase().contains(_currentSearchQuery!.toLowerCase()) ||
        product.category.toLowerCase().contains(_currentSearchQuery!.toLowerCase())
      ).toList();
    } else {
      _filteredProducts = List.from(_allProducts);
    }
    
    state = ProductLoaded(
      _filteredProducts, 
      products.length == _limit,
      _totalProducts,
      _currentSearchQuery,
    );
    _page++;
  } catch (e) {
    state = ProductError(e.toString());
    print(e);
  }
}

Future<void> searchProducts(String query) async {
  try {
    state = ProductLoading();
    _currentSearchQuery = query.isNotEmpty ? query : null;
    _page = 1; // Reset page when searching
    
    if (query.isEmpty) {
      _allProducts = [];
      _filteredProducts = [];
      await fetchProducts(); // Fetch fresh data
      return;
    }

    final products = await _apiService.searchProducts(query);
    _allProducts = products;
    _filteredProducts = products;
    _totalProducts = products.length;
    
    state = ProductLoaded(
      _filteredProducts, 
      false,
      _totalProducts,
      query,
    );
  } catch (e) {
    state = ProductError(e.toString());
  }
}

  void sortProducts(String sortBy) {
    if (state is! ProductLoaded) return;
    
    final currentState = state as ProductLoaded;
    List<Product> sortedProducts = [...currentState.products];

    switch (sortBy) {
      case 'price_asc':
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating_desc':
        sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'rating_asc':
        sortedProducts.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }

    state = ProductLoaded(
      sortedProducts, 
      currentState.hasMore,
      currentState.totalProducts,
      currentState.searchQuery,
    );
  }
}

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;
  final int totalProducts;
  final String? searchQuery;

  ProductLoaded(
    this.products,
    this.hasMore,
    this.totalProducts,
    this.searchQuery,
  );
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}