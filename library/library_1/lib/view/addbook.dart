import 'package:flutter/material.dart';

class AddBooksPage extends StatefulWidget {
  const AddBooksPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddBooksPageState createState() => _AddBooksPageState();
}

class _AddBooksPageState extends State<AddBooksPage> {
  String? _selectedCategory;
  final _categories = [
    'Civil',
    'Criminal',
    'Family',
    'Property',
    'NI act',
    'Constitution',
    'Jmfc',
    'Student',
    'Other'
  ];
  final _bookNameController = TextEditingController();
  final _authorNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        // Positioned.fill(
        //   child: Image.network(
        //     'https://i.pinimg.com/564x/fe/05/c3/fe05c3a8e7c0bdbbeb587c73e5205508.jpg',
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // Foreground content
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Book Name TextFormField
              TextFormField(
                controller: _bookNameController,
                decoration: InputDecoration(
                  labelText: 'Book Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Author Name TextFormField
              TextFormField(
                controller: _authorNameController,
                decoration: InputDecoration(
                  labelText: 'Author Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Category DropdownButtonFormField
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Image Picker Button with Icon
              ElevatedButton(
                onPressed: () {
                  // Implement image picker functionality
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade400, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Select Image'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Save & Submit Button
              ElevatedButton(
                onPressed: () {
                  // Implement save & submit functionality
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade400, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Save & Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
