import 'package:flutter/material.dart';
import '../services/product_service.dart';
import 'product_list_screen.dart';
import 'seed_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// true = Firebase, false = DummyJSON API
  bool _useFirebase = false;

  static const List<IconData> _categoryIcons = [
    Icons.laptop_mac,
    Icons.headphones,
    Icons.smartphone,
    Icons.tablet_mac,
  ];

  static const List<Color> _categoryColors = [
    Color(0xFF6C63FF),
    Color(0xFFFF6584),
    Color(0xFF43A047),
    Color(0xFFFF9800),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = ProductService.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TH3 - Nguyễn Anh Quân - 2351160541',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Seed data lên Firestore',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SeedDataScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Danh mục sản phẩm',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Chọn danh mục để xem sản phẩm',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            // Toggle nguồn dữ liệu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _useFirebase ? Icons.cloud : Icons.public,
                    color: _useFirebase ? Colors.orange : Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _useFirebase ? 'Nguồn: Firebase Firestore' : 'Nguồn: DummyJSON API',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Switch(
                    value: _useFirebase,
                    activeColor: Colors.deepPurple,
                    onChanged: (value) {
                      setState(() => _useFirebase = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryCard(
                    context,
                    label: category['label']!,
                    slug: category['slug']!,
                    icon: _categoryIcons[index],
                    color: _categoryColors[index],
                    useFirebase: _useFirebase,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String label,
    required String slug,
    required IconData icon,
    required Color color,
    required bool useFirebase,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductListScreen(
              categorySlug: slug,
              categoryLabel: label,
              useFirebase: useFirebase,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: color.withAlpha(80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withAlpha(200), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
