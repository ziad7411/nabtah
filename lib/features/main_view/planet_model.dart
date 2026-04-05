class PlantModel {
  final String nameAr;
  final String nameEn;
  final String category;
  final String region;
  final String imageUrl;
  final String description;

  PlantModel({
    required this.nameAr,
    required this.nameEn,
    required this.category,
    required this.region,
    required this.imageUrl,
    required this.description,
  });

  factory PlantModel.fromFirestore(Map<String, dynamic> data) {
    return PlantModel(
      nameAr: data['nameAr'] ?? '',
      nameEn: data['nameEn'] ?? '',
      category: data['category'] ?? '',
      region: data['region'] ?? '',
      imageUrl: data['image'] ?? '',
      description: data['description'] ?? '',
    );
  }
}