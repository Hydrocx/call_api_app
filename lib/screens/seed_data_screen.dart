import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../services/firebase_service.dart';

class SeedDataScreen extends StatefulWidget {
  const SeedDataScreen({super.key});

  @override
  State<SeedDataScreen> createState() => _SeedDataScreenState();
}

class _SeedDataScreenState extends State<SeedDataScreen> {
  final ProductService _apiService = ProductService();
  final FirebaseService _firebaseService = FirebaseService();

  bool _isSeeding = false;
  String _status = '';
  final List<String> _logs = [];

  Future<void> _seedAllCategories() async {
    setState(() {
      _isSeeding = true;
      _status = 'Đang kiểm tra dữ liệu...';
      _logs.clear();
    });

    // Kiểm tra đã có dữ liệu chưa
    final hasData = await _firebaseService.hasData();
    if (hasData) {
      setState(() {
        _logs.add('⚠️ Firestore đã có dữ liệu. Bỏ qua seed.');
        _status = 'Hoàn tất (đã có dữ liệu)';
        _isSeeding = false;
      });
      return;
    }

    int totalCount = 0;

    for (final category in ProductService.categories) {
      final slug = category['slug']!;
      final label = category['label']!;

      setState(() {
        _status = 'Đang tải $label từ API...';
      });

      try {
        // Reset simulate error để lấy data thật
        ProductService.resetSimulateError();

        final products = await _apiService.fetchProductsByCategory(slug);

        setState(() {
          _logs.add('✅ API $label: ${products.length} sản phẩm');
          _status = 'Đang đẩy $label lên Firestore...';
        });

        final count = await _firebaseService.seedDataFromApi(products);
        totalCount += count;

        setState(() {
          _logs.add('🔥 Firestore $label: $count sản phẩm đã lưu');
        });
      } catch (e) {
        setState(() {
          _logs.add('❌ Lỗi $label: $e');
        });
      }
    }

    setState(() {
      _status = 'Hoàn tất! Tổng: $totalCount sản phẩm';
      _isSeeding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seed Data → Firestore'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.deepPurple[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload, size: 48, color: Colors.deepPurple),
                    const SizedBox(height: 8),
                    const Text(
                      'Đẩy dữ liệu từ DummyJSON API\nlên Firebase Firestore',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isSeeding ? null : _seedAllCategories,
                      icon: _isSeeding
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.upload),
                      label: Text(_isSeeding ? 'Đang xử lý...' : 'Bắt đầu Seed'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_status.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _status,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
