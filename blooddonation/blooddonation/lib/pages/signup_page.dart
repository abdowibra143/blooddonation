import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String? selectedAge;
  String? selectedBloodGroup;

  final List<String> ageRanges = [
    '0-13',
    '14-18',
    'Young adult (18-25 age)',
    'Adult (26-44 age)',
    'Middle-age (45-59 age)',
    'Old age (60+ age)',
  ];

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  Future<void> _registerUser() async {
    try {
      // Register the user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the user ID
      String uid = userCredential.user!.uid;

      // Save additional details in Firebase Realtime Database
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(uid);
      await userRef.set({
        'name': nameController.text,
        'age': selectedAge,
        'blood_group': selectedBloodGroup,
        'weight': weightController.text,
      });

      // Navigate to home page on successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      String message;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            message = 'The email address is already in use by another account.';
            break;
          case 'invalid-email':
            message = 'The email address is not valid.';
            break;
          case 'weak-password':
            message = 'The password provided is too weak.';
            break;
          default:
            message = 'Failed to register: ${e.message}';
        }
      } else {
        message = 'An unexpected error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Age Range',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                value: selectedAge,
                items: ageRanges.map((ageRange) {
                  return DropdownMenuItem<String>(
                    value: ageRange,
                    child: Text(ageRange),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAge = value;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Blood Group',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bloodtype),
                ),
                value: selectedBloodGroup,
                items: bloodGroups.map((bloodGroup) {
                  return DropdownMenuItem<String>(
                    value: bloodGroup,
                    child: Text(bloodGroup),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBloodGroup = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _registerUser,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Navigate back to the previous screen
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
