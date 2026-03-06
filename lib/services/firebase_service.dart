import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy danh sách sản phẩm theo danh mục từ Firestore.
  /// Collection: "products", lọc theo field "category".
  /// Sử dụng try-catch để bắt ngoại lệ an toàn.
  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Product.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Không thể tải dữ liệu từ Firebase: $e');
    }
  }

  /// Thêm sản phẩm vào Firestore (dùng để seed dữ liệu)
  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      await _firestore.collection('products').add(productData);
    } catch (e) {
      throw Exception('Không thể thêm sản phẩm: $e');
    }
  }

  /// Seed dữ liệu từ DummyJSON API vào Firestore
  /// Gọi 1 lần để đẩy dữ liệu lên Firebase
  Future<int> seedDataFromApi(List<Product> products) async {
    try {
      final batch = _firestore.batch();
      int count = 0;

      for (final product in products) {
        final docRef = _firestore.collection('products').doc();
        batch.set(docRef, product.toFirestore());
        count++;
      }

      await batch.commit();
      return count;
    } catch (e) {
      throw Exception('Không thể seed dữ liệu: $e');
    }
  }

  /// Kiểm tra collection đã có dữ liệu chưa
  Future<bool> hasData() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
