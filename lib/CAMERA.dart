import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:developer' as dlog;
import 'dart:io';

class CAMERA extends StatefulWidget {
  const CAMERA({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CAMERAState createState() => _CAMERAState();
}

class _CAMERAState extends State<CAMERA> {
  File? image;
  int _currentIndex = 1;
  bool isUploading = false;
  List? _output;

  late Future<String?>
      modelLoadStatus; // A future to check model loading status

  @override
  void initState() {
    super.initState();
    // Load the model during initialization and assign its loading status to the future.
    modelLoadStatus = loadModel();
  }

  // Function to check if the TFLite model exists and is not empty.
  Future<bool> doesModelExist() async {
    try {
      final ByteData data = await rootBundle.load('assets/model.tflite');
      if (data.buffer.asUint8List().isNotEmpty) {
        return true; // Model file exists and is not empty.
      }
    } catch (e) {
      return false; // Model file doesn't exist or is empty.
    }
    return false; // Model file doesn't exist or is empty.
  }

  // Function to load the TFLite model.
  Future<String?> loadModel() async {
    final bool modelExists = await doesModelExist();

    if (modelExists) {
      try {
        // Close any previously loaded models (if any).
        await Tflite.close();

        // Load the TFLite model and labels.
        String? res = await Tflite.loadModel(
          model: 'assets/model.tflite',
          labels: 'assets/labelmap.txt',
        );

        return 'Success'; // Return 'Success' indicating model is loaded.
      } catch (e) {
        print('Error loading model: $e');
        return 'Error'; // Return 'Error' on failure.
      }
    } else {
      print('Model file does not exist or is empty.');
      return 'Error'; // Return 'Error' if model file doesn't exist.
    }
  }

  // Function to classify the loaded image using the TFLite model.
  classifyImage(File image) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );
      setState(() {
        _output = output;
        dlog.log(_output.toString(), name: "mylog");
      });
    } catch (e) {
      print('Error classifying image: $e');
    }
  }

  // Function to pick an image from the gallery or camera.
  Future pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;
    setState(() {
      image = File(pickedImage.path);
    });
  }

  // Function to upload an image to Firebase Storage.
  Future<String> _uploadImage(File imageFile) async {
    setState(() {
      isUploading = true;
    });

    // Define the Firebase Storage reference.
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');

    // Upload the image to Firebase Storage.
    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    // Add the download URL to Firestore.
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

  // Function to navigate to the next page after classifying the image.
  Future<void> _navigateToNextPage(String imageUrl) async {
    if (image != null) {
      await classifyImage(image!);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextPage(imageUrl: imageUrl, output: _output),
      ),
    );
  }

  // Build the user interface.
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
            _currentIndex = index;
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
      body: FutureBuilder<String?>(
        future: modelLoadStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('loading'));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load model: ${snapshot.error}'));
          } else if (snapshot.data == 'Success') {
            return _buildMainContent();
          } else {
            return Center(child: Text('Failed to load model.'));
          }
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return Stack(
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
              // Display the image or a message if no image is selected.
              Center(
                child: Column(
                  children: [
                    if (image != null) Image.file(image!),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: isUploading
                          ? CircularProgressIndicator(
                              color: Colors.green,
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
                            onPressed: () => pickImage(ImageSource.gallery),
                            icon: Icon(Icons.image),
                            tooltip: 'Gallery',
                            color: Color(0xff5ac043),
                            iconSize: 80,
                          ),
                          IconButton(
                            onPressed: () => pickImage(ImageSource.camera),
                            icon: Icon(Icons.camera_alt),
                            tooltip: 'Camera',
                            color: Color(0xff5ac043),
                            iconSize: 80,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Function to create navigation items.
  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(icon, size: 30),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class NextPage extends StatelessWidget {
  final String imageUrl;
  final List? output;

  NextPage({required this.imageUrl, required this.output});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
      ),
      body: Column(
        children: <Widget>[
          Image.network(imageUrl),
          if (output != null)
            Column(
              children: <Widget>[
                Text('Results:'),
                Text('Label: ${output![0]['label']}'),
                Text('Confidence: ${output![0]['confidence']}'),
              ],
            ),
        ],
      ),
    );
  }
}
