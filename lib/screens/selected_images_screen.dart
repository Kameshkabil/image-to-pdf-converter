import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:image_to_pdf_converter/screens/home_screen.dart';

class SelectedImagesScreen extends StatefulWidget {
  final List<File> images;  // List of selected images
  const SelectedImagesScreen({Key? key, required this.images}) : super(key: key);

  @override
  State<SelectedImagesScreen> createState() => _SelectedImagesScreenState();
}

class _SelectedImagesScreenState extends State<SelectedImagesScreen> {
  late List<File> selectedImages;
  bool isLoading = false;
  File? generatedPdf;

  @override
  void initState() {
    super.initState();
    selectedImages = List.from(widget.images);
  }

  void removeImage(int index) {
    setState(() => selectedImages.removeAt(index));
  }

  Future<void> generatePDF() async {

    if (selectedImages.isEmpty) return;

    String? filename = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String inputFilename = '';
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title:  Text(
            'Enter PDF Filename',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: TextField(
            onChanged: (value) => inputFilename = value,
            decoration:  InputDecoration(
              hintText: 'Filename',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
            ),
            style:  TextStyle(color: Colors.black),
            cursorColor: Colors.red,
          ),
          actions: [
            ElevatedButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, null),
              label:  Text('Cancel',style: TextStyle(
                  fontWeight: FontWeight.w600,
              ),),
              icon:  Icon(Icons.cancel),
            ),
            ElevatedButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (inputFilename.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:  Text(
                        '⚠️ Filename cannot be empty',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      backgroundColor: Colors.black,
                      duration:  Duration(seconds: 3),
                      padding:  EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                  return;
                }
                Navigator.pop(context, inputFilename);
              },
              label:  Text('Generate',style: TextStyle(
                fontWeight: FontWeight.w600,
              ),),
              icon:  Icon(Icons.picture_as_pdf),
            ),
          ],
        );
      },
    );

    if (filename == null || filename.trim().isEmpty) return;

    setState(() => isLoading = true);

    final pdf = pw.Document();
    for (var img in selectedImages) {
      final image = pw.MemoryImage(img.readAsBytesSync());
      pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Image(image),
        ),
      ));
    }

    final dir = await getApplicationDocumentsDirectory();
    generatedPdf = File('${dir.path}/$filename.pdf');
    await generatedPdf!.writeAsBytes(await pdf.save());

    setState(() => isLoading = false);

    showShareDialog();
  }

  Future<void> sharePDF() async {
    if (generatedPdf == null) return;

    try {
      await Share.shareXFiles([XFile(generatedPdf!.path)], text: 'Check out this PDF!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share: $e')),
      );
    }

  }


  void showShareDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title:  Text(
            'PDF Generated Successfully!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          content:  Text(
            'Share with your connections or save it for later.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          actions: [
            // ✅ Share Button
            ElevatedButton.icon(
              onPressed: sharePDF,  // Share PDF function
              icon:  Icon(Icons.share, color: Colors.white),
              label:  Text(
                'Share PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,  // Button color
                padding:  EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Selected Images (${selectedImages.length})',),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: isLoading
            ?  Center(child: CircularProgressIndicator())
            : selectedImages.isEmpty
            ?  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animation/NoImagesSelected.json',
                width: 200,
                height: 200,
                // fit: BoxFit.cover,
                repeat: true,
              ),

             // SizedBox(height: 30,),

              Text(
                'No Images Selected!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        )
            : GridView.builder(
          padding:  EdgeInsets.all(10),
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: selectedImages.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      selectedImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => removeImage(index),
                    child: Container(
                      padding:  EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child:  Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: selectedImages.isNotEmpty
            ? FloatingActionButton.extended(
          onPressed: generatePDF,
          label:  Text('Generate PDF',style: TextStyle(
            fontWeight: FontWeight.w700,
          ),),
          icon:  Icon(Icons.picture_as_pdf),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
        )
            : null,
      ),
    );
  }
}
