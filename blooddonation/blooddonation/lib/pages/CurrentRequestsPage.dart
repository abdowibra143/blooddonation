import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CurrentRequestsPage extends StatelessWidget {
  final DatabaseReference _requestsRef =
      FirebaseDatabase.instance.ref().child('requests');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Requests'),
      ),
      body: StreamBuilder(
        stream: _requestsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('No requests available'));
          }

          DataSnapshot dataSnapshot = snapshot.data!.snapshot;
          Map<dynamic, dynamic>? requestsData =
              dataSnapshot.value as Map<dynamic, dynamic>?;

          List<Map<dynamic, dynamic>> requestsList = [];

          if (requestsData != null) {
            requestsData.forEach((key, value) {
              if (value['fullName'] != null &&
                  value['bloodGroup'] != null &&
                  value['unitsRequired'] != null &&
                  value['location'] != null &&
                  value['contactNumber'] != null &&
                  value['timestamp'] != null) {
                requestsList.add({
                  'fullName': value['fullName'],
                  'bloodGroup': value['bloodGroup'],
                  'unitsRequired': value['unitsRequired'],
                  'location': value['location'],
                  'contactNumber': value['contactNumber'],
                  'timestamp': value['timestamp'],
                });
              }
            });
          }

          return ListView.builder(
            itemCount: requestsList.length,
            itemBuilder: (context, index) {
              Map<dynamic, dynamic> requestEntry = requestsList[index];

              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name: ${requestEntry['fullName']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Blood Group: ${requestEntry['bloodGroup']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Units Required: ${requestEntry['unitsRequired']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Location: ${requestEntry['location']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Contact Number: ${requestEntry['contactNumber']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Timestamp: ${requestEntry['timestamp']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
