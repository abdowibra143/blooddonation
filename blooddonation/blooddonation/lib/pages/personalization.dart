import 'package:flutter/material.dart';

class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: ListView(
        children: [
          _buildFontSizeSection(context),
          Divider(),
          _buildColorSection(context),
        ],
      ),
    );
  }

  Widget _buildFontSizeSection(BuildContext context) {
    double _fontSize = 16.0; // Initial font size

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.text_fields),
          title: Text('Font Size'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Slider(
            value: _fontSize,
            min: 10,
            max: 40,
            divisions: 30,
            label: _fontSize.round().toString(),
            onChanged: (double value) {
              _fontSize = value;
              // Implement logic for changing font size if needed
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text('Color'),
          trailing: IconButton(
            icon: Icon(Icons.colorize),
            onPressed: () {
              // Open color picker or implement color selection logic
            },
          ),
        ),
      ],
    );
  }
}
