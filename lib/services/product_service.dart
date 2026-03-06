import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://dummyjson.com';

  /// Bật/tắt giả lập lỗi để demo Error UI
  static const bool _simulateError = true;

  /// Lưu danh mục đã giả lập lỗi rồi (chỉ lỗi lần đầu)
  static final Set<String> _failedOnce = {};

  /// Danh sách các danh mục hỗ trợ
  static const List<Map<String, String>> categories = [
    {'slug': 'laptops', 'label': 'Laptops'},
    {'slug': 'mobile-accessories', 'label': 'Phụ kiện'},
    {'slug': 'smartphones', 'label': 'Điện thoại'},
    {'slug': 'tablets', 'label': 'Tablets'},
  ];

  /// Lấy danh sách sản phẩm theo danh mục từ DummyJSON API.
  /// Sử dụng try-catch để bắt ngoại lệ an toàn.
  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      // Giả lập lỗi mất mạng lần đầu tiên cho mỗi danh mục
      if (_simulateError && !_failedOnce.contains(category)) {
        _failedOnce.add(category);
        await Future.delayed(const Duration(seconds: 1));
        throw Exception('Không có kết nối mạng. Vui lòng kiểm tra lại.');
      }

      final response = await http
          .get(Uri.parse('$_baseUrl/products/category/$category'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> jsonList = data['products'];
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Lỗi server: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      // Bắt mọi ngoại lệ: mất mạng, timeout, parse lỗi, v.v.
      throw Exception('Không thể tải dữ liệu: $e');
    }
  }
}
