import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DonationHistoryPage extends StatelessWidget {
  final DatabaseReference _rsvpReference =
      FirebaseDatabase.instance.ref().child('rsvp');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation History'),
      ),
      body: StreamBuilder(
        stream: _rsvpReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('No data available'));
          }

          DataSnapshot dataSnapshot = snapshot.data!.snapshot;
          Map<dynamic, dynamic>? rsvpData =
              dataSnapshot.value as Map<dynamic, dynamic>?;

          List<Map<dynamic, dynamic>> rsvpList = [];

          if (rsvpData != null) {
            rsvpData.forEach((key, value) {
              // Assuming your rsvp structure has 'bloodDriveTitle', 'email', and 'timestamp'
              if (value['bloodDriveTitle'] != null &&
                  value['email'] != null &&
                  value['timestamp'] != null) {
                rsvpList.add({
                  'bloodDriveTitle': value['bloodDriveTitle'],
                  'email': value['email'],
                  'timestamp': value['timestamp'],
                });
              }
            });
          }

          return ListView.builder(
            itemCount: rsvpList.length,
            itemBuilder: (context, index) {
              Map<dynamic, dynamic> rsvpEntry = rsvpList[index];

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
                      'Blood Drive Title: ${rsvpEntry['bloodDriveTitle']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Email: ${rsvpEntry['email']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Timestamp: ${rsvpEntry['timestamp']}',
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
