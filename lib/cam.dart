


/*import 'dart:async';
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bottom nav page/profilepage.dart';
import 'bottom nav page/saving datapage.dart';
import 'bottom nav page/settingpage.dart';

class CAMERA extends StatefulWidget {
  const CAMERA({Key? key, required this.title});

  final String title;
  @override
  State<CAMERA> createState() => _CAMERAState();
}

class _CAMERAState extends State<CAMERA> {
  File? image;
  int _currentIndex = 1;
  bool isUploading = false;

  Future pickImage(source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    setState(() {
      this.image = File(image.path);
    });
  }

  Future<String> _uploadImage(File imageFile) async {
    setState(() {
      isUploading = true;
    });

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');

    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('images').add({
      'imageUrl': downloadURL,
      'timestamp': FieldValue.serverTimestamp(),
      'savedDate': FieldValue.serverTimestamp(),
    });

    setState(() {
      isUploading = false;
    });

    return downloadURL;
  }

  void _navigateToNextPage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextPage(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.white,
        color: Color(0x88e4fce4),
        animationDuration: Duration(milliseconds: 300),
        items: <Widget>[
          _buildNavItem(Icons.person, 'Profile'),
          _buildNavItem(Icons.local_florist, 'My Plants'),
          _buildNavItem(Icons.settings, 'Settings'),
        ],
        onTap: (index) {
          setState(() {
            _navigateToPage(index);
          });
        },
      ),
      appBar: AppBar(
        title: const Text("CropsAI"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white70,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/aa.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.cyanAccent.withOpacity(0.1),
                  BlendMode.overlay,
                ),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 150),
                Center(
                  child: Column(
                    children: [
                      if (image != null) Image.file(image!),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: isUploading
                            ? CircularProgressIndicator(
                          color: Colors.green, // Customize color
                        )
                            : image != null
                            ? Image.file(
                          image!,
                          height: 80,
                          width: 100,
                        )
                            : const Padding(
                          padding: EdgeInsets.all(45.0),
                          child: Text(
                            'Use Camera or Gallery to Know the disease of your Ginger plant',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      if (!isUploading)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final imageFile = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (imageFile != null) {
                                  String imageUrl =
                                  await _uploadImage(File(imageFile.path));
                                  _navigateToNextPage(imageUrl);
                                }
                              },
                              icon: Icon(Icons.image),
                              tooltip: 'Gallery',
                              color: Color(0xff5ac043),
                              iconSize: 80,
                            ),
                            IconButton(
                              onPressed: () async {
                                final imageFile = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                if (imageFile != null) {
                                  String imageUrl =
                                  await _uploadImage(File(imageFile.path));
                                  _navigateToNextPage(imageUrl);
                                }
                              },
                              icon: Icon(Icons.camera_alt),
                              tooltip: 'Camera',
                              color: Color(0xff5ac043),
                              iconSize: 80,
                            ),
                          ],
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
         // if (isUploading)
         //   CircularProgressIndicator(
           //   color: Colors.green,
          //  ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String text) {
    return FractionallySizedBox(
      alignment: Alignment.center,
      widthFactor: 2.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 27,
            color: Colors.green,
          ),
          SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Savepage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
    }
  }
}

class NextPage extends StatefulWidget {
  final String imageUrl;

  NextPage({required this.imageUrl});
  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  Future<void> saveImage() async {
    await FirebaseFirestore.instance.collection('saved_images').add({
      'imageUrl': widget.imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'savedDate': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("CropsAI"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff34c54c),
                Color(0xff79e08a),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 550,
            width: 380,
            child: Center(
              child: Image.network(widget.imageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff5ac043),
              ),
              onPressed: () {
                saveImage();
              },
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}*/



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'package:image_picker/image_picker.dart';


class ObjectDetectionPage extends StatefulWidget {
  @override
  _ObjectDetectionPageState createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  File? _image;
  List? _recognitions;
  String _model = 'your_model.tflite';
  String _labels = 'labels.txt';

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: _model,
        labels: _labels,
      );
      print("Model loaded: $res");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> _performObjectDetection() async {
    final imagePicker = ImagePicker();
    final imageFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (imageFile == null) return;

    File file = File(imageFile.path);
    var recognitions = await Tflite.detectObjectOnImage(
      path: file.path,
      numResultsPerClass: 1,
    );
    setState(() {
      _image = file;
      _recognitions = recognitions;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Object Detection App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null) Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performObjectDetection,
              child: Text("Select Image for Object Detection"),
            ),
            SizedBox(height: 20),
            if (_recognitions != null)
              Column(
                children: _recognitions!
                    .map((result) => Text(
                  '${result["detectedClass"]} ${(result["confidence"] * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 16),
                ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
