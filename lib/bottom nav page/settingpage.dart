import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:project5/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
class SettingsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      print("Logged out successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LOGIN()),
      );
    } catch (e) {
      print("Error during logout: $e");
    }
  }
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch URL: $url");
    }
  }
  void _showAppInfo(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("App Info"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("App Version: ${packageInfo.version}"),
              SizedBox(height: 16),
              Text("Welcome to our CropsAI App!. Our app focuses on accurately identifying diseases affecting ginger plants, assisting users in making informed decisions for better cultivation outcomes. It is our goal to provide with advanced technology to detect diseases early, enabling them to mitigate risks and enhance their yield. We aim to contribute to sustainable agriculture by minimizing losses caused by plant diseases and optimizing resource usage. Our app utilizes state-of-the-art image recognition technology to analyze photos of ginger plants. Farmers can simply take a photo of a ginger plant leaf or affected area using their smartphone's camera or gallery, and our app will quickly identify if the plant is afflicted by disease."),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff34c54c),
              Color(0xff79e08a),
            ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)
        ),
      ),
    ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.share,  color: Color(0xff5ac043),),
            title: Text("Share"),
            onTap: (){
              Share.share("com.example.project5");
            }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Color(0xff5ac043),),
            title: Text("App Info", ),
            onTap: () => _showAppInfo(context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Color(0xff5ac043),),
            title: Text("Logout",  ),
            onTap: () => _logout(context),//_signOut(context)

          ),
          Divider(),
        ],
      ),
    );
  }
}


