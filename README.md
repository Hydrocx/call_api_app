# 📱 Call API App — Bài Thực Hành 3: Gọi dữ liệu từ API

**TH3 - Nguyễn Anh Quân - 2351160541**

Ứng dụng Flutter gọi dữ liệu sản phẩm từ [DummyJSON API](https://dummyjson.com), hiển thị theo 4 danh mục và xử lý đầy đủ các trạng thái bất đồng bộ (Loading, Success, Error).

---

## 📋 Mục lục

1. [Thiết kế giao diện và hiển thị dữ liệu](#1-thiết-kế-giao-diện-và-hiển-thị-dữ-liệu)
2. [Xử lý 3 trạng thái dữ liệu](#2-xử-lý-3-trạng-thái-dữ-liệu)
3. [Tổ chức code và xử lý API](#3-tổ-chức-code-và-xử-lý-api)

---

## 1. Thiết kế giao diện và hiển thị dữ liệu

### 🏠 Màn hình chính
- **GridView 2×2**: 4 ô danh mục (Laptops, Phụ kiện, Điện thoại, Tablets)
- Mỗi ô: Icon + Gradient background (màu riêng) + Animation
- Bấm vào → Navigate tới trang danh sách sản phẩm

### 📦 Màn hình danh sách sản phẩm
- **ListView** hiển thị ProductCard (row layout)
- **Mỗi Card chứa**:
  - Hình ảnh: 90×90 px, `BoxFit.contain`
  - Tên + Badge danh mục + Mô tả (cắt gọn 2 dòng)
  - **Giá + % giảm giá**
  - **Rating ⭐ + Stock** (Còn X / Hết hàng)
- **Pull-to-refresh**: Kéo tải lại dữ liệu

---

## 2. Xử lý 3 trạng thái dữ liệu

| Trạng thái | Chi tiết |
|---|---|
| **Loading** | `CircularProgressIndicator` + text "Đang tải dữ liệu..." |
| **Success** | Dữ liệu map từ API → hiển thị ListView ProductCard |
| **Error + Retry** | Thông báo lỗi + nút "Thử lại" → gọi lại API |

**Giả lập lỗi**: Lần đầu mỗi danh mục → throw "Không có kết nối mạng" → UI Error → Bấm "Thử lại" → Gọi API thật → Success

---

## 3. Tổ chức code và xử lý API

### 📂 Cấu trúc
```
lib/
├── main.dart                  (Entry point, MaterialApp)
├── models/product.dart        (Model + fromJson())
├── services/
│   └── product_service.dart   (Gọi API, try-catch, giả lập lỗi)
├── screens/
│   ├── home_screen.dart       (GridView 4 danh mục)
│   └── product_list_screen.dart (ListView + 3 states)
└── widgets/product_card.dart  (Thẻ sản phẩm)
```

### 🔌 Xử lý API
```dart
// ProductService.fetchProductsByCategory()
try {
  if (_simulateError && !_failedOnce.contains(category))
    throw Exception('Không có kết nối mạng');  // Giả lập lỗi 1 lần
  
  final response = await http.get(...).timeout(15s);
  if (response.statusCode == 200) {
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }
} catch (e) => throw Exception('Không thể tải dữ liệu: $e');
```

### 🎯 Luồng xử lý
```
User bấm category 
  → setState isLoading=true 
  → Giả lập lỗi 1 lần → Error UI 
  → Bấm "Thử lại" → Gọi API thật 
  → setState products[] → Success UI
```

### ✅ Yêu cầu đã xử lý
- ✅ Try-catch bắt exception an toàn
- ✅ 3 trạng thái: Loading, Success, Error
- ✅ Nút "Thử lại" + Pull-to-refresh
- ✅ Tách file riêng biệt
- ✅ Giả lập lỗi (chỉ 1 lần/danh mục)

---

**Để chạy**: `flutter pub get` → `flutter run`
