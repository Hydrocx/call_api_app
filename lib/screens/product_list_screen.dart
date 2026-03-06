import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/firebase_service.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final String categorySlug;
  final String categoryLabel;
  final bool useFirebase;

  const ProductListScreen({
    super.key,
    required this.categorySlug,
    required this.categoryLabel,
    this.useFirebase = false,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _apiService = ProductService();
  final FirebaseService _firebaseService = FirebaseService();

  // 3 trạng thái: loading, success, error
  bool _isLoading = true;
  String? _errorMessage;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  /// Gọi dữ liệu từ API hoặc Firebase tùy theo nguồn
  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<Product> products;
      if (widget.useFirebase) {
        products = await _firebaseService.fetchProductsByCategory(widget.categorySlug);
      } else {
        products = await _apiService.fetchProductsByCategory(widget.categorySlug);
      }
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryLabel,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              avatar: Icon(
                widget.useFirebase ? Icons.cloud : Icons.public,
                size: 16,
                color: widget.useFirebase ? Colors.orange : Colors.blue,
              ),
              label: Text(
                widget.useFirebase ? 'Firebase' : 'API',
                style: const TextStyle(fontSize: 11, color: Colors.white),
              ),
              backgroundColor: Colors.deepPurple[300],
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Trạng thái 1: Đang tải (Loading)
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.deepPurple,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Đang tải dữ liệu...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Trạng thái 3: Lỗi (Error UI & Retry)
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 80,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                'Đã xảy ra lỗi!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Trạng thái 2: Thành công (Success) - hiển thị ListView
    return RefreshIndicator(
      onRefresh: _fetchProducts,
      color: Colors.deepPurple,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: _products[index]);
        },
      ),
    );
  }
}
