import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nabtah/core/theme/app_colors.dart';
import 'package:nabtah/l10n/app_localizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetectPlantPage extends StatefulWidget {
  final String? userName;

  const DetectPlantPage({super.key, this.userName});

  @override
  State<DetectPlantPage> createState() => _DetectPlantPageState();
}

class _DetectPlantPageState extends State<DetectPlantPage> {
  File? _selectedImage;
  String? _plantName;
  double? _confidence;
  bool _isLoading = false;
  String? _plantDescription;
  String? _plantRegion;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isLoading = true;
        _plantName = null;
      });

      await _detectPlant(_selectedImage!);
    }
  }

  Future<void> _detectPlant(File image) async {
    final url = Uri.parse(
      "https://my-api.plantnet.org/v2/identify/all?api-key=2b10rpZTypqSNMYSKxQDcrrqXe",
    );

    var request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('images', image.path));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final data = jsonDecode(resBody);

        if (data['results'] != null && data['results'].isNotEmpty) {
          final bestMatch = data['results'][0];

          setState(() {
            _plantName = bestMatch['species']['scientificNameWithoutAuthor'];
            _confidence = bestMatch['score'];
            _fetchPlantDetails(_plantName!);
            _isLoading = false;
          });
        } else {
          setState(() {
            _plantName = "Unknown Plant";
            _confidence = 0;
            _isLoading = false;
          });
        }
      } else {
        setState(() => _isLoading = false);
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Exception: $e");
    }
  }

  Future<void> _fetchPlantDetails(String scientificName) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('plants')
        .where('nameEn', isGreaterThanOrEqualTo: scientificName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();

      setState(() {
        _plantName = data['nameAr']; // نعرض العربي
        _confidence = _confidence; // زي ما هي
        // نضيف دول 👇
        _plantDescription = data['description'];
        _plantRegion = data['region'];
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,

      /// ✅ APP BAR مظبوط
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.black,
        title: Text(
          loc.detectPlant,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );
            },
          ),
        ],
      ),

      /// ✅ BODY
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// 🔵 Camera Circle فوق
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryGreen,
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.white,
                  size: 30,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                loc.detectPlant,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                loc.detectInstruction,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// 📦 Upload Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        /// 🔥 Animation Switcher
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                          child: _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  key: ValueKey(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Container(
                                  key: const ValueKey("empty"),
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.upload,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        loc.uploadPlantImage,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        loc.detectInstruction,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: _showImageSourceDialog,
                                        child: Text(loc.chooseImage),
                                      ),
                                    ],
                                  ),
                                ),
                        ),

                        /// 🔥 زرار تغيير الصورة يظهر لما صورة موجودة
                        if (_selectedImage != null)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: _showImageSourceDialog,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (_isLoading) const CircularProgressIndicator(),

              if (_plantName != null && !_isLoading)
                Column(
                  children: [
                    Text(
                      "🌱 $_plantName",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Confidence: ${(_confidence! * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (_plantDescription != null) Text(_plantDescription!),

                    if (_plantRegion != null) Text("📍 $_plantRegion"),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
