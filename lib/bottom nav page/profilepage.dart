import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
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
      /*  actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],*/
      ),
      body: FutureBuilder<User?>(
        future: _loadUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User not logged in.'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                 // CircleAvatar(
                   // radius: 70,
                    //backgroundImage: NetworkImage(user.photoURL ?? ''),
                 // ),
                  const SizedBox(height: 30),
                  itemprofile('Name', user.displayName ?? 'N/A', Icons.person),
                  const SizedBox(height: 20),
                  itemprofile('Email', user.email ?? 'N/A', Icons.mail),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff5ac043),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfileScreen(user: user),
                      ));
                    },
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  Future<User?> _loadUser() async {
    return FirebaseAuth.instance.currentUser;
  }
  itemprofile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.deepOrange.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        //trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }

  /*void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      print('Error signing out: $e');
    }
  }*/
}

class EditProfileScreen extends StatefulWidget {
  final User user;
  EditProfileScreen({required this.user});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}
class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  //TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.displayName ?? '';
   // _emailController.text = widget.user.email ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 80),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              /*const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),*/
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff5ac043),
              ),
                onPressed: () {
                  _updateProfile();
                },
                child: Text('Save '),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _updateProfile() async {
    try {
      await widget.user.updateDisplayName(_nameController.text);
      //await widget.user.updateEmail(_emailController.text);
      if (_passwordController.text.isNotEmpty) {
        await widget.user.updatePassword(_passwordController.text);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
}
