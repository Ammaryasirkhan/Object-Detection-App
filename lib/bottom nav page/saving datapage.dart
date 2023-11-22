import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class Savepage extends StatefulWidget {
  @override
  State<Savepage> createState() => _SavepageState();
}
class _SavepageState extends State<Savepage> {

  late List<Map<String, dynamic>> _savedImages = [];
  @override
  void initState() {
    super.initState();
    fetchSavedImages();
  }
  Future<void> fetchSavedImages() async {
    final querySnapshot =
    await FirebaseFirestore.instance.collection('saved_images').get();

    final List<Map<String, dynamic>> images = [];
    for (final doc in querySnapshot.docs) {
      images.add({
        'imageUrl': doc['imageUrl'] as String,
        'timestamp': doc['timestamp'] as Timestamp,
      });
    }
    setState(() {
      _savedImages = images;
    });
  }
  void deleteImage(int index) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('saved_images')
        .where('imageUrl', isEqualTo: _savedImages[index]['imageUrl'])
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final documentId = querySnapshot.docs[0].id;
      await FirebaseFirestore.instance
          .collection('saved_images')
          .doc(documentId)
          .delete();
      setState(() {
        _savedImages.removeAt(index);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Plants"),
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
      body: _savedImages != null
          ? ListView.builder(
        itemCount: _savedImages.length,
        itemBuilder: (context, index) {
          final imageUrl = _savedImages[index]['imageUrl'] as String;
          final timestamp = _savedImages[index]['timestamp'] as Timestamp;
          final formattedDate =
          DateFormat.yMd().add_jm().format(timestamp.toDate());
          return Card(
            margin: EdgeInsets.all(6),
            child: Column(
              children: [
                Image.network(imageUrl),
                Divider(),
                SizedBox(height: 10),
                Text('Plant added at $formattedDate'),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteImage(index),
                ),
              ],
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
