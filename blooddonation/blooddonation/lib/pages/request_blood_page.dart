import 'package:blooddonation/pages/CurrentRequestsPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RequestBloodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Blood'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: RequestBloodForm(),
      ),
    );
  }
}

class RequestBloodForm extends StatefulWidget {
  @override
  _RequestBloodFormState createState() => _RequestBloodFormState();
}

class _RequestBloodFormState extends State<RequestBloodForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DatabaseReference _requestsRef; // Declare DatabaseReference

  @override
  void initState() {
    super.initState();
    // Initialize _requestsRef in initState
    _requestsRef = FirebaseDatabase.instance.ref().child('requests');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              icon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _bloodGroupController,
            decoration: InputDecoration(
              labelText: 'Blood Group',
              icon: Icon(Icons.favorite),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your blood group';
              }
              return null;
            },
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _unitsController,
            decoration: InputDecoration(
              labelText: 'Units Required',
              icon: Icon(Icons.format_list_numbered),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the number of units required';
              }
              return null;
            },
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Hospital/Clinic Location',
              icon: Icon(Icons.location_on),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the hospital/clinic location';
              }
              return null;
            },
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _contactController,
            decoration: InputDecoration(
              labelText: 'Contact Number',
              icon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your contact number';
              }
              return null;
            },
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _submitRequest();
              }
            },
            child: Text('Request Blood'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrentRequestsPage()),
              );
            },
            child: Text('Current Requests'),
          ),
        ],
      ),
    );
  }

  void _submitRequest() {
    // Implement logic to submit blood request
    String fullName = _nameController.text.trim();
    String bloodGroup = _bloodGroupController.text.trim();
    int unitsRequired = int.parse(_unitsController.text.trim());
    String location = _locationController.text.trim();
    String contactNumber = _contactController.text.trim();

    // Save data to Firebase Realtime Database
    _requestsRef.push().set({
      'fullName': fullName,
      'bloodGroup': bloodGroup,
      'unitsRequired': unitsRequired,
      'location': location,
      'contactNumber': contactNumber,
      'timestamp': DateTime.now().toIso8601String(),
    }).then((_) {
      // Reset form fields after successful submission
      _nameController.clear();
      _bloodGroupController.clear();
      _unitsController.clear();
      _locationController.clear();
      _contactController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blood request submitted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit blood request: $error')),
      );
    });
  }
}
