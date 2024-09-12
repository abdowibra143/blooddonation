import 'package:blooddonation/pages/personalization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Donation App',
      theme: ThemeData.dark(), // Using the dark theme
      home: UserSettings(),
    );
  }
}

class UserSettings extends StatelessWidget {
  const UserSettings({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _buildProfileSection(),
            _buildThemeSection(
                context), // Use theme section from personalization.dart
            _buildStorageSection(context),
            _buildOtherSettingsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    final user = FirebaseAuth.instance.currentUser!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text('Logged in As: '),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.email!),
            ],
          ),
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text('Theme & Personalization'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThemeSettingsPage()),
            );
          },
        ),
        Divider(),
      ],
    );
  }

  Widget _buildStorageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.storage),
          title: Text('Storage'),
          onTap: () {
            // Navigate to storage settings
          },
        ),
        ListTile(
          leading: Icon(Icons.data_usage),
          title: Text('User Data'),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildOtherSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Terms & Conditions'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TermsAndConditionsScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.person_add),
          title: Text('Invite Users'),
          onTap: () {
            _inviteUsers(context);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Tutorials'),
          onTap: () {
            // Navigate to tutorials
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('User Materials'),
          onTap: () {
            // Navigate to user materials
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }

  void _inviteUsers(BuildContext context) async {
    await FlutterShare.share(
      title: 'Blood donation app',
      text: 'Check out this blood donation app I did as my final year project ^Ibra!',
      linkUrl: 'https://drive.google.com/drive/folders/1rVooV6eWeX5Ffl8MtNt4sZxyG3yzRwTf?usp=drive_link',
    );
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          // Place the terms and conditions text here
          "Terms and Conditions for blood donation App\n\n1. Introduction and Definitions:\n\n1.1 Parties Involved: These Terms and Conditions ('Agreement') constitute a legal agreement between IBRAHIMRASHID, referred to as 'the App Owner' or 'we', and the users of the blood donation app, referred to as 'users' or 'you'.\n1.2 Key Terms:\n-App: Refers to the blood donation application owned and operated by IBRAHIMRASHID.\n-User: Any individual who registers and uses the App.\n- Google Account: Refers to the Google account required for user registration and access to the App.\n- Content: Refers to any documents, files, or information shared by users through the App.\n\n2. User Registration:\n2.1 Requirement for Registration:\nBy using the App, you agree to register using your Google account and provide additional user details as required by the registration process.\n2.2 Registration Process:\nYou must follow the registration process outlined in the App, which may include providing personal information and verifying your Google account.\n\n3. User Responsibilities:\n\n3.1 Compliance with Laws:\nYou are responsible for complying with all applicable Kenyan laws and regulations while using the App.\n\n3.2 Confidentiality:\nYou are responsible for maintaining the confidentiality of your account information, including your Google account credentials.\n\n4. Data Protection and Privacy:\n4.1 Collection and Use of User Data:\nWe collect and use your personal information in accordance with Kenyan data protection laws. By using the App, you consent to the collection, storage, and use of your data as described in our Privacy Policy.\n4.2 Safeguarding User Information:We take measures to safeguard and protect user information to prevent unauthorized access or disclosure.\n\n5. Intellectual Property Rights:\n5.1 Ownership of Content:Users retain ownership of the content they share through the App.\n5.2 License to App Owner:By sharing content through the App, users grant IBRAHIMRASHID a non-exclusive license to use, reproduce, and distribute the content within the App.\n\n6. Termination of Account:\n6.1 Conditions for Termination:We reserve the right to terminate user accounts in case of violation of these Terms and Conditions or prolonged inactivity.\n6.2 Process for Termination:\nAccount termination may occur at our discretion, and we will notify you via email or through the App.\n\n7. Dispute Resolution:\n7.1 Resolution of Disputes:\nAny disputes between users and IBRAHIMRASHID shall be resolved through arbitration in Kenya.\n7.2 Governing Law:These Terms and Conditions shall be governed by and construed in accordance with the laws of Kenya.\n\n8. Liability:\n8.1 Limitation of Liability:\nIBRAHIMRASHID shall not be liable for any damages incurred by users while using the App.\n8.2 Assumption of Risk:\nUsers accept any risks associated with the use of the App.\n\n9. Updates to Terms and Conditions:\n9.1 Right to Update:\nWe reserve the right to update these Terms and Conditions as needed without prior notice.\n9.2 Notification of Changes:\nWe will notify users of any changes to these Terms and Conditions through the App or via email.\nBy using the App, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please refrain from using the App.",
        ),
      ),
    );
  }
}
