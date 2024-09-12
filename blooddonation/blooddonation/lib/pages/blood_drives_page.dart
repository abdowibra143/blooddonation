import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Drives',
      theme: ThemeData.dark(),
      home: BloodDrivesPage(),
    );
  }
}

class BloodDrivePost {
  final String title;
  final String description;
  final String author;
  final String key; // Add the key field

  BloodDrivePost({
    required this.title,
    required this.description,
    required this.author,
    required this.key, // Add the key field
  });

  factory BloodDrivePost.fromMap(Map<String, dynamic> map, String key) {
    return BloodDrivePost(
      title: map['title'],
      description: map['description'],
      author: map['author'],
      key: key, // Add the key field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'author': author,
    };
  }
}

class BloodDrivesPage extends StatefulWidget {
  @override
  _BloodDrivesPageState createState() => _BloodDrivesPageState();
}

class _BloodDrivesPageState extends State<BloodDrivesPage> {
  final List<BloodDrivePost> bloodDrivePosts = [];
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('blooddrives');
  final DatabaseReference rsvpReference = FirebaseDatabase.instance
      .ref()
      .child('rsvp'); // Reference to 'rsvp' collection
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  late Timer timer;
  int _loadedItems = 0;
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchBloodDrives();
    // Set up timer to fetch updates every 2 seconds
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _fetchBloodDrives();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreBloodDrives();
      }
    });
  }

  @override
  void dispose() {
    // Dispose timer to prevent memory leaks
    timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchBloodDrives() async {
    setState(() {
      isLoading = true;
    });
    DataSnapshot snapshot =
        await databaseReference.limitToFirst(_itemsPerPage).get();
    final List<BloodDrivePost> loadedPosts = [];
    final data = snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      data.forEach((key, value) {
        loadedPosts
            .add(BloodDrivePost.fromMap(Map<String, dynamic>.from(value), key));
      });
    }

    setState(() {
      bloodDrivePosts.clear();
      bloodDrivePosts.addAll(loadedPosts);
      isLoading = false;
      _loadedItems = bloodDrivePosts.length;
    });
  }

  void _fetchMoreBloodDrives() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    DataSnapshot snapshot = await databaseReference
        .orderByKey()
        .startAt(bloodDrivePosts.last.key)
        .limitToFirst(_itemsPerPage)
        .get();

    final List<BloodDrivePost> loadedPosts = [];
    final data = snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      data.forEach((key, value) {
        loadedPosts
            .add(BloodDrivePost.fromMap(Map<String, dynamic>.from(value), key));
      });
    }

    setState(() {
      bloodDrivePosts.addAll(loadedPosts);
      isLoading = false;
      _loadedItems = bloodDrivePosts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Drives'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: bloodDrivePosts.length + 1,
            itemBuilder: (context, index) {
              if (index == bloodDrivePosts.length) {
                return _buildLoadingIndicator();
              } else {
                final post = bloodDrivePosts[index];
                return _buildPostItem(post, index);
              }
            },
          ),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBloodDriveDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPostItem(BloodDrivePost post, int index) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(post.title),
            subtitle: Text(post.description),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Author: ${post.author}'),
          ),
          ElevatedButton(
            onPressed: () {
              _rsvpToBloodDrive(post);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              textStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text('RSVP'),
          ),
        ],
      ),
    );
  }

  void _showAddBloodDriveDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Blood Drive'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                _submitBloodDrive(
                  titleController.text,
                  descriptionController.text,
                );

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitBloodDrive(String title, String description) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final newPost = BloodDrivePost(
        title: title,
        description: description,
        author: user.email!,
        key: '', // Initially empty, Firebase will generate the key
      );

      final newPostRef = databaseReference.push();
      await newPostRef.set(newPost.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blood drive posted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post blood drive: $e')),
      );
    }
  }

  Future<void> _rsvpToBloodDrive(BloodDrivePost post) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final rsvpData = {
        'email': user.email!,
        'bloodDriveTitle': post.title,
        'timestamp': DateTime.now().toUtc().toString(),
      };

      // Save RSVP to 'rsvp' collection
      await rsvpReference.push().set(rsvpData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('RSVP successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to RSVP: $e')),
      );
    }
  }
}

void main() {
  runApp(MyApp());
}
