import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/phoneAuth/otpscreen.dart';
import 'package:flutter_firebase/main.dart';


class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneState();
}

class _PhoneState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Authentication"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter your phone number",
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              if (phoneController.text.isEmpty || phoneController.text.length < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a valid phone number')),
                );
                return;
              }

              await FirebaseAuth.instance.verifyPhoneNumber(
                verificationCompleted: (PhoneAuthCredential credential) {
                  FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MyHomePage(title: "My Home Page"),
                    ));
                  });
                },
                verificationFailed: (FirebaseAuthException ex) {},
                codeSent: (String verificationId, int? resendtoken) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen(verificationid: verificationId,)));
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
                phoneNumber: phoneController.text.toString(),
                // phoneNumber : '+91${phoneController.text.trim()}',

              );
            },
            child: Text("Verify Phone"),
          ),
        ],
      ),
    );
  }
}
