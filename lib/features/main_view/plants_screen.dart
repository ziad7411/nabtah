import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nabtah/core/theme/app_colors.dart';
import 'package:nabtah/features/main_view/planet_model.dart';
import 'package:nabtah/features/main_view/plant_details_page.dart';
import 'package:nabtah/l10n/app_localizations.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  String selectedCategory = "all";
  String searchQuery = "";

  final List<String> categories = ["all", "trees", "medical", "aromatic"];

  final List<PlantModel> plants = [
    PlantModel(
      nameAr: "النخيل",
      nameEn: "Phoenix dactylifera",
      region: "الرياض",
      imageUrl:
          "https://29.co.th/wp-content/uploads/2021/11/20160922_1474552523-968-large.jpeg",
      category: "trees",
      description: "نبات رعوي يستخدم في الطب الشعبي.",
    ),
    PlantModel(
      nameAr: "السمر",
      nameEn: "Acacia tortilis",
      region: "الرياض",
      imageUrl:
          "https://29.co.th/wp-content/uploads/2021/10/%D8%B4%D8%AC%D8%B1%D8%A9-%D8%A7%D9%84%D8%B3%D9%85%D8%B1-%D8%A7%D9%84%D8%B3%D9%86%D8%B7-%D8%A7%D9%84%D9%85%D9%84%D8%AA%D9%88%D9%8A-Acacia-tortilis-4.jpg",
      category: "trees",
      description: "نبات رعوي يستخدم في الطب الشعبي.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == "ar";

    final filteredPlants = plants.where((plant) {
      final matchesCategory =
          selectedCategory == "all" || plant.category == selectedCategory;

      final matchesSearch =
          plant.nameAr.contains(searchQuery) ||
          plant.nameEn.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.black,
        centerTitle: true,
        title: Text(loc.plants),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔎 Search
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: loc.searchPlant,
                prefixIcon: const Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 15),

            /// 🏷 Categories
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          cat == "all"
                              ? loc.all
                              : cat == "trees"
                              ? loc.trees
                              : cat == "medical"
                              ? loc.medicalPlants
                              : loc.aromaticPlants,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// 🌿 Grid
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('plants')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final plants = snapshot.data!.docs
                      .map((doc) => PlantModel.fromFirestore(doc.data()))
                      .toList();

                  final query = searchQuery.toLowerCase();

                  final filteredPlants = plants.where((plant) {
                    final matchesCategory =
                        selectedCategory == "all" ||
                        plant.category == selectedCategory;

                    final matchesSearch =
                        plant.nameAr.toLowerCase().contains(query) ||
                        plant.nameEn.toLowerCase().contains(query);

                    return matchesCategory && matchesSearch;
                  }).toList();

                  return GridView.builder(
                    itemCount: filteredPlants.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      final plant = filteredPlants[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlantDetailsPage(plant: plant),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 🖼 صورة من Firebase
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.network(
                                  plant.imageUrl,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,

                                  /// Loading
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const SizedBox(
                                      height: 120,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },

                                  /// Error
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      "https://via.placeholder.com/150",
                                      height: 120,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isArabic ? plant.nameAr : plant.nameEn,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isArabic ? plant.nameEn : plant.nameAr,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            plant.region,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.description,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            plant.description,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
