import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainScreen.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/main.dart';


// ignore: must_be_immutable
class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:  [
              const SizedBox(height: 55.0,),

              //appLogo
              const Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),

              // Label of login
              const SizedBox(height: 1.0,),
              const Text(
                "Register as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand-Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    //Name text field
                    const SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand-Regular",


                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Regular"),
                    ),

                    //Email text field
                    const SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand-Regular",

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Regular"),
                    ),

                    //password text field
                    const SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand-Regular",

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Regular"),
                    ),
                    const SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand-Regular",

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Regular"),
                    ),



                    const SizedBox(height: 30.0,),
                    ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.blue)
                              )
                          )

                      ),
                      child: Container(
                        height: 50.0,
                        child: const Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),
                          ),

                        ),

                      ),
                      onPressed: () {
                        if (nameTextEditingController.text.length < 3) {
                          displayToastMessage("Name must be at least 3 characters", context);
                        }
                        else if (!emailTextEditingController.text.contains("@")){
                          displayToastMessage("Email is invalid", context);
                        }
                        else if (phoneTextEditingController.text.isEmpty){
                          displayToastMessage("Phone number is mandatory", context);
                        }
                        else if (passwordTextEditingController.text.length <6){
                          displayToastMessage("Password must be at least 6 characters", context);
                        }
                        else {
                          registerNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Register user button
              TextButton(
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);

                },
                child: const Text(
                  "Already have an account ? Login Here.",
                  style: TextStyle(fontFamily: "Brand-Bold"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async{

    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
      return ProgressDialog(message: "Registering, Please wait !",);
    });

    final User? firebaseUser = ( await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: $errMsg", context);
    })).user;

    if(_firebaseAuth != null) { //user create
      //save user info to database

      Map userDataMap = {
        "name" : nameTextEditingController.text.trim(),
        "email" : emailTextEditingController.text.trim(),
        "password" : passwordTextEditingController.text.trim(),
        "phone" : phoneTextEditingController.text.trim(),
      };
      usersRef.child(firebaseUser!.uid).set(userDataMap);
      // ignore: use_build_context_synchronously
      displayToastMessage("Congratulations ! Your account has been created successfully.", context);
      
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    }
    else {
      Navigator.pop(context);
      displayToastMessage("New user account has not been created", context);
    }
  }
}
displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}