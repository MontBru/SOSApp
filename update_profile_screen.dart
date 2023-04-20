import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../users.dart';

class UpdatedProfileScreen extends StatefulWidget {
  @override
  State<UpdatedProfileScreen> createState() => _UpdatedProfileScreenState();
}

class _UpdatedProfileScreenState extends State<UpdatedProfileScreen> {
  bool flag = true;
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> changePasswordAndUsername() async {
    await FirebaseAuth.instance.currentUser!.updatePassword(_controllerPassword.text);
    await user!.changeUsername(FirebaseAuth.instance.currentUser!.uid, _controllerUsername.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                          'assets/images/Avatar-Profile-Vector.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue.withOpacity(0.2),
                      ),
                      child:
                      const Icon(Icons.edit, size: 20),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controllerUsername,
                      decoration: const InputDecoration(
                        label: Text("Username"),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    TextFormField(
                        obscureText: flag,
                        controller: _controllerPassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_open_outlined),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  flag = !flag;
                                });
                              },
                              icon: flag? const Icon(Icons.visibility_off): const Icon(Icons.visibility)
                          ),
                        )
                    ),
                  ]
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      await changePasswordAndUsername();
                      Navigator.pop(context, 'reload');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text(
                      'Save',
                      style: TextStyle(),
                    ),
                  ),
                ),
              ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
