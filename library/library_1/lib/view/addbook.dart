import 'dart:io'; // Import to use File
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'package:image_picker/image_picker.dart'; // For image picking

class AddBooksPage extends StatefulWidget {
  const AddBooksPage({super.key});

  @override
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
  final _bookNoController = TextEditingController(); // Added for book number
  File? _selectedImage; // File to store the selected image
  double? _uploadProgress; // Track upload progress

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Firebase Storage instance

  // Method to save book data to Firestore
  Future<void> _saveBookData() async {
    final bookName = _bookNameController.text;
    final authorName = _authorNameController.text;
    final bookNo = _bookNoController.text; // Get book number
    final category = _selectedCategory;

    if (bookName.isEmpty ||
        authorName.isEmpty ||
        bookNo.isEmpty || // Ensure book number is not empty
        category == null ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select an image.')),
      );
      return;
    }

    try {
      // Upload image to Firebase Storage
      String imageUrl = await _uploadImageToStorage(_selectedImage!);

      // Save book data along with image URL
      await _firestore.collection('books').add({
        'bookName': bookName,
        'authorName': authorName,
        'bookNo': bookNo, // Save book number
        'category': category,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added successfully!')),
      );

      _bookNameController.clear();
      _authorNameController.clear();
      _bookNoController.clear(); // Clear book number field
      setState(() {
        _selectedCategory = null;
        _selectedImage = null;
        _uploadProgress = null; // Reset progress
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add book: $e')),
      );
    }
  }

  // Method to upload image to Firebase Storage and get the URL with progress indication
  Future<String> _uploadImageToStorage(File image) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('book_images/$fileName');

      // Use putFile with a callback to track progress
      UploadTask uploadTask = ref.putFile(image);

      // Show a progress indicator while uploading
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() {
          _uploadProgress = progress; // Update the progress
        });
      });

      await uploadTask; // Await the completion of the upload
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Method to pick an image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Update book number when category changes
  void _updateBookNo() {
    if (_selectedCategory != null) {
      final prefix = _selectedCategory!.substring(0, 2).toUpperCase();
      final currentText = _bookNoController.text;
      // If bookNo is empty or doesn't start with prefix, initialize or update it
      if (currentText.isEmpty || !currentText.startsWith(prefix)) {
        _bookNoController.text = '$prefix-';
      } else {
        // Update book number with new prefix if it changes
        _bookNoController.text =
            currentText.replaceFirst(RegExp(r'^[A-Z]{2}-'), '$prefix-');
      }
      // Move cursor to the end of the text field
      _bookNoController.selection = TextSelection.fromPosition(
        TextPosition(offset: _bookNoController.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body: SingleChildScrollView(
        // Wrap the content in SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  _updateBookNo(); // Update book number when category changes
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
            TextFormField(
              controller: _bookNoController,
              decoration: InputDecoration(
                labelText: 'Book Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 16),
            // Image Picker Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Pick from Gallery'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: const Text('Pick from Camera'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    height: 150,
                  )
                : const Text('No image selected.'),
            const SizedBox(height: 16),
            _uploadProgress != null
                ? LinearProgressIndicator(value: _uploadProgress)
                : Container(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadProgress != null && _uploadProgress! < 1
                  ? null // Disable button during upload
                  : _saveBookData,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: Text(
                _uploadProgress != null && _uploadProgress! < 1
                    ? 'Uploading ${(_uploadProgress! * 100).toStringAsFixed(0)}%'
                    : 'Save & Submit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
