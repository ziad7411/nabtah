import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nabtah/core/theme/app_colors.dart';
import 'package:nabtah/l10n/app_localizations.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String? _name;
  String? _email;
  String? _phone;
  String? _location;
  String? _joinDate;
  String? _imageUrl;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// ================= LOAD USER =================
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>  LoginScreen()));
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
  final Timestamp? createdAt = doc.data()?["createdAt"];
    setState(() {
      _name = doc.data()?["name"] ?? "";
      _email = doc.data()?["email"] ?? "";
      _phone = doc.data()?["phone"] ?? "";
      _location = doc.data()?["region"] ?? "";
      _joinDate = createdAt != null
        ? "${createdAt.toDate().year}-${createdAt.toDate().month}-${createdAt.toDate().day}"
        : "";
      _imageUrl = doc.data()?["image"];
      _isLoading = false;
    });
  }

  /// ================= PICK IMAGE =================
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    File file = File(picked.path);
    await _uploadImage(file);
  }

  /// ================= UPLOAD IMAGE =================
  Future<void> _uploadImage(File file) async {
    final user = FirebaseAuth.instance.currentUser;

    final ref = FirebaseStorage.instance
        .ref()
        .child("profile_images")
        .child("${user!.uid}.jpg");

    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({"image": url});

    setState(() {
      _imageUrl = url;
    });
  }

  /// ================= LOGOUT =================
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) =>  LoginScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
              color: AppColors.primaryGreen),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// ================= HEADER =================
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 50),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [

                  /// Logout Icon
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout,
                          color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Profile Image + Animation
                  AnimatedSwitcher(
                    duration:
                        const Duration(milliseconds: 400),
                    child: Stack(
                      key: ValueKey(_imageUrl),
                      alignment: Alignment.bottomLeft,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor:
                              Colors.white,
                          backgroundImage:
                              _imageUrl != null
                                  ? NetworkImage(
                                      _imageUrl!)
                                  : null,
                          child: _imageUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors
                                      .primaryGreen,
                                )
                              : null,
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding:
                                const EdgeInsets.all(6),
                            decoration:
                                const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: AppColors
                                    .primaryGreen),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    _name ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "${loc.memberSince} $_joinDate",
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= INFO CARD =================
            Card(
              margin:
                  const EdgeInsets.symmetric(
                      horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow(
                        Icons.email,
                        loc.email,
                        _email),
                    _buildInfoRow(
                        Icons.phone,
                        loc.phone,
                        _phone),
                    _buildInfoRow(
                        Icons.location_on,
                        loc.location,
                        _location),
                    _buildInfoRow(
                        Icons.calendar_today,
                        loc.joinDate,
                        _joinDate),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String title, String? value) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon,
              color: AppColors.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value ?? "",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}