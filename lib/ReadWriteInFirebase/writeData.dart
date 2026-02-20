import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Writedata extends StatefulWidget {
  const Writedata({super.key});

  @override
  State<Writedata> createState() => _WritedataState();
}

class _WritedataState extends State<Writedata> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> addData(String name, String email) async {
    await FirebaseFirestore.instance.collection("Users").add({
      'name': name,
      'email': email,
      'timestamp': FieldValue.serverTimestamp(),
    });
    nameController.clear();
    emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("write in database"), centerTitle: true),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            autofillHints: null,
            decoration: InputDecoration(
              hintText: "name",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: emailController,
            // autofillHints: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Email",
              suffixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                addData(nameController.text, emailController.text),
            child: Text("send data"),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      // scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(child: Text("${index+1}"),),
                          title: Text("${snapshot.data!.docs[index]["name"]}"),
                          subtitle: Text(
                            "${snapshot.data!.docs[index]["email"]}",
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.red),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.hasError}"));
                  } else {
                    return Center(child: Text("Error!!!"));
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
