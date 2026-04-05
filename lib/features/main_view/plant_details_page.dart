import 'package:flutter/material.dart';
import 'package:nabtah/features/main_view/planet_model.dart';

class PlantDetailsPage extends StatelessWidget {
  final PlantModel plant;

  const PlantDetailsPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Localizations.localeOf(context).languageCode == "ar";

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? plant.nameAr : plant.nameEn),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🖼 صورة كبيرة
            Image.network(
              plant.imageUrl.isEmpty
                  ? "https://via.placeholder.com/400"
                  : plant.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🌿 الاسم
                  Text(
                    isArabic ? plant.nameAr : plant.nameEn,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// 🌍 المنطقة
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18),
                      const SizedBox(width: 6),
                      Text(plant.region),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// 🏷 النوع
                  Text(
                    "Category: ${plant.category}",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 16),

                  /// 📄 الوصف
                  Text(
                    plant.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}