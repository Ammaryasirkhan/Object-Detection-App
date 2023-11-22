import 'package:flutter/material.dart';
import 'package:project5/Splashpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'CAMERA.dart';
import 'cam.dart';
import 'constant/constant.dart';
 /*void*/Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch:
           Colors.green
      ),
      home: SplashScreen(),
    );
  }
}
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
  final String title;
  int _counter = 0;
  get children => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        width: double.infinity,
        height: double.infinity,
         color: Colors.white,
        child: Column(
          children: [
           Image.asset('assets/images/ii.jpg',),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(75, 0, 65, 12),
                child: Text('THE BEST APP FOR YOUR GINGER PLANTS',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
                    color: Colors.green ),),
              ),
            ),
           Container(
              width: 300,
             padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
             child: ElevatedButton(
               style: ButtonStyle(
                 shape: MaterialStateProperty.all(
                   RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20),
                   )
                 )
               ),
                 child: Text('SignUp',style: TextStyle(fontSize: 22),), onPressed: (){
               Navigator.push(context, MaterialPageRoute(
                   builder: (context)  => SIGNUP() ) );
               }),),
              Container(
                width: 300,
               padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ElevatedButton(
                style: ButtonStyle(
                shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20),
               )
               )
               ),
               child: Text('Login',style: TextStyle(fontSize: 22),), onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                  builder: (context)  => LOGIN()));
              }
              ) )
    ],
        ),
       )
    );
  }
}
class LOGIN extends StatefulWidget {
   get controller => null;
   @override
   State<LOGIN> createState() => _LOGINState();
 }
class _LOGINState extends State<LOGIN> {
  var obscureText = true;
  var globalKey = GlobalKey<FormState>();
  TextEditingController eC = TextEditingController();
  TextEditingController pC = TextEditingController();
  @override
  Widget build(BuildContext context) {
   // throw UnimplementedError();
     return Scaffold(
         backgroundColor: Colors.white,
        body: Container(
         decoration: BoxDecoration(
         image: DecorationImage(image: AssetImage('assets/images/aa.png'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
    Colors.cyanAccent.withOpacity(0.1),
    BlendMode.overlay,
    )
    ),),
    child: Container(
    decoration: BoxDecoration(
    image: DecorationImage(image: AssetImage('assets/images/aa.png'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
    Colors.cyanAccent.withOpacity(0.1),
    BlendMode.overlay,
    )
    ),),
          child: Center(
           child:SingleChildScrollView(
             child: Form(
              // key: globalKey,
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const Icon(Icons.account_circle, color: Colors.green,size: 100,),
                      /*  Container(
                           child: Text('Login',style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,color: Colors.green),)
                        ),*/
                    Container(
                      margin: EdgeInsets.only(top:21),
                      width: 300,
                      child: TextFormField(
                     controller: eC,
                         keyboardType:  TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Email',
                          hintStyle: TextStyle(fontSize: 12),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2
                            )
                        ),
                      ),
                    )
                    ),
                    Container(
                        margin: EdgeInsets.only(top:21),
                        width: 300,
                        child: TextFormField(
                          controller: pC,
                          //controller: widget.controller,
                          obscureText: obscureText,
                           keyboardType:  TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '   Password',
                            hintStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21),
                                borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2
                                )
                            ),
    suffixIcon: GestureDetector(
    onTap: (){
    setState(() {
    obscureText = !obscureText;
    });
    },
    child: obscureText
    ? const Icon(
    Icons.visibility_off,
    color: Colors.grey,
    )
          : const Icon(
    Icons.visibility,
    color: Colors.grey,
    )
    )
                          ),
                        )
                    ),
                    Container(
                        width: 300,
                        margin: EdgeInsets.only(top:50),
                        padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                              )
                          ),
                          child: Text('Login',style: TextStyle(fontSize: 22),), onPressed: () async{
                        final message = await AuthService().login(
                            email: eC.text,
                            password: pC.text,
                          );
                          if (message!.contains('Success')) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)  => CAMERA(title: 'CAMERA')));
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                            ),
                         );
                        },
                        ),
                      ),
                    const SizedBox(
                      height: 30.0,
                    ),
                       TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>  SIGNUP(),
                            ),
                          );
                        },
                        child: const Text('Create Account'),
                      ),
                  ],
                ),
             ),
           ),
          ),
        ),
       // Text('Login',style: TextStyle(fontSize: 22),)
  ));
  }
 }
class SIGNUP extends StatefulWidget {
  get controller => null;
  @override
  State<SIGNUP> createState() => _SIGNUPState();
}
class _SIGNUPState extends State<SIGNUP> {
 var obscureText = true;
 var globalKey = GlobalKey<FormState>();
 TextEditingController eC = TextEditingController();
 TextEditingController pC = TextEditingController();
 TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // throw UnimplementedError();
    return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/aa.png'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
    Colors.cyanAccent.withOpacity(0.1),
    BlendMode.overlay,
    )
    ),),
            child: Container(
    decoration: BoxDecoration(
    image: DecorationImage(image: AssetImage('assets/images/aa.png'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
    Colors.cyanAccent.withOpacity(0.1),
    BlendMode.overlay,
    )
    ),),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                   // key: globalKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Icon(Icons.account_circle, color: Colors.green, size: 100,),
                       /*Container(
                          height: 60,
                            child: Text('Signup', style: TextStyle(fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff70d581)),)
                        ),*/
                       Container(
                          margin: EdgeInsets.only(top: 21),
                          width: 300,
                          child: TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'Name',
                                hintText: 'Name',
                                hintStyle: TextStyle(fontSize: 12),
                                //suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye_outlined)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21),
                                    borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2
                                    )
                                )
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 21),
                            width: 300,
                            child: TextFormField(
                              controller: eC,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Email',
                                hintStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21),
                                    borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2
                                    )
                                ),
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 21),
                            width: 300,
                            child: TextFormField(
                              controller: pC,
                              obscureText: obscureText,
                              keyboardType:  TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: '   Password',
                                hintStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21),
                                    borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2
                                    )
                                ),
                               suffixIcon: GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     obscureText = !obscureText;
                                   });
                                 },
                                 child: obscureText
                                 ? const Icon(
                                   Icons.visibility_off,
                                   color: Colors.grey,
                                 )
                                     : const Icon(
                                   Icons.visibility,
                                   color: Colors.grey,
                                 )
                               )
                              ),
                            ),
                        ),
                         Container(
                            width: 300,
                            margin: EdgeInsets.only(top: 50),
                            padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                            child: ElevatedButton(
                              style:
                            ButtonStyle(
                                shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )
                                  ),
                              ),
                              child: Text('Signup', style: TextStyle(fontSize: 22,),
                              ),
                              onPressed: ()  async {

                               final message = await AuthService().registration(
                                 name: nameController.text,
                                  email: eC.text,
                                  password: pC.text,
                                );
                                if (message!.contains('Success')) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) =>  LOGIN()));
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        // Text('Login',style: TextStyle(fontSize: 22),)
    );
  }
}