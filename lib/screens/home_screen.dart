import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_pdf_converter/screens/selected_images_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<File> selectedImages = [];

  Future<void> selectImages() async {
    final List<XFile>? images = await ImagePicker().pickMultiImage();
    if (images != null) {
      setState(() {
        selectedImages = images.map((image) => File(image.path)).toList();
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return SelectedImagesScreen(images: selectedImages);
            }
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.picture_as_pdf, color: Colors.white, size: 30,),
        title: Text('Image to PDF Converter', style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),),
        backgroundColor: Colors.red,
      ),

      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding:  EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text(
                  'Welcome to Image to PDF Converter!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                 SizedBox(height: 15),
                 Text(
                  'Select images from your gallery to create a PDF file instantly.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: 32,),

          GestureDetector(
            onTap: () {
              selectImages();
            },
            child: DottedBorder(
              color: Colors.red,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              // Rounded border
              radius:  Radius.circular(16),
              dashPattern:  [10, 6],
              // Dotted pattern (length, space)
              child: Container(
                width: 250,
                height: 250,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(
                      Icons.drive_folder_upload,
                      size: 80,
                      color: Colors.red,
                    ),
                     SizedBox(height: 16),
                     Text(
                      'Upload Files',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding:  EdgeInsets.symmetric(vertical: 16),
        color: Colors.black, // Background color
        child:  Text(
          '© 2025 Kamesh Developer. All Rights Reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    ),
    );
  }
}
