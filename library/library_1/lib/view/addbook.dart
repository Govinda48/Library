import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
    'Bare Act',
    'Other'
  ];
  final _bookNameController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _bookNoController = TextEditingController();
  File? _selectedImage;
  File? _index1Image; // New field for index1 image
  File? _index2Image; // New field for index2 image
  File? _index3Image; // New field for index3 image
  File? _index4Image; // New field for index4 image
  double? _uploadProgress;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _saveBookData() async {
    final bookName = _bookNameController.text;
    final authorName = _authorNameController.text;
    final bookNo = _bookNoController.text;
    final category = _selectedCategory;

    if (bookName.isEmpty ||
        authorName.isEmpty ||
        bookNo.isEmpty ||
        category == null ||
        _selectedImage == null) {
      _showAwesomeSnackbar(
          'Error', 'Please fill in all fields and select the main image.');
      return;
    }

    try {
      final existingBooks = await _firestore
          .collection('books')
          .where('bookNo', isEqualTo: bookNo)
          .get();

      if (existingBooks.docs.isNotEmpty) {
        _showAwesomeSnackbar('Error',
            'A book with this number already exists. Please check the book number.');
        return;
      }

      String mainImageUrl = await _uploadImageToStorage(_selectedImage!);
      String? index1Url;
      String? index2Url;
      String? index3Url;
      String? index4Url;

      // Upload additional images if they are selected
      if (_index1Image != null) {
        index1Url = await _uploadImageToStorage(_index1Image!);
      }
      if (_index2Image != null) {
        index2Url = await _uploadImageToStorage(_index2Image!);
      }
      if (_index3Image != null) {
        index3Url = await _uploadImageToStorage(_index3Image!);
      }
      if (_index4Image != null) {
        index4Url = await _uploadImageToStorage(_index4Image!);
      }

      await _firestore.collection('books').add({
        'bookName': bookName,
        'authorName': authorName,
        'bookNo': bookNo,
        'category': category,
        'imageUrl': mainImageUrl,
        'index1Url': index1Url, // Store additional image URLs if available
        'index2Url': index2Url,
        'index3Url': index3Url,
        'index4Url': index4Url,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showAwesomeSnackbar('Success', 'Book added successfully!');

      _bookNameController.clear();
      _authorNameController.clear();
      _bookNoController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedImage = null;
        _index1Image = null;
        _index2Image = null;
        _index3Image = null;
        _index4Image = null;
        _uploadProgress = null;
      });
    } catch (e) {
      _showAwesomeSnackbar('Error', 'Failed to add book: $e');
    }
  }

  Future<String> _uploadImageToStorage(File image) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('book_images/$fileName');

      UploadTask uploadTask = ref.putFile(image);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() {
          _uploadProgress = progress;
        });
      });

      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _pickImage(
      ImageSource source, ValueChanged<File?> onImagePicked) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        onImagePicked(File(pickedFile.path));
      } else {
        _showAwesomeSnackbar('Error', 'No image selected.');
      }
    } catch (e) {
      _showAwesomeSnackbar('Error', 'Failed to pick image: $e');
    }
  }

  void _updateBookNo() {
    if (_selectedCategory != null) {
      final prefix = _selectedCategory!.substring(0, 2).toUpperCase();
      final currentText = _bookNoController.text;
      if (currentText.isEmpty || !currentText.startsWith(prefix)) {
        _bookNoController.text = '$prefix-';
      } else {
        _bookNoController.text =
            currentText.replaceFirst(RegExp(r'^[A-Z]{2}-'), '$prefix-');
      }
      _bookNoController.selection = TextSelection.fromPosition(
        TextPosition(offset: _bookNoController.text.length),
      );
    }
  }

  Widget _buildImagePicker(
      String label, File? image, Function(File?) onImagePicked) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery, onImagePicked),
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera, onImagePicked),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        image != null
            ? Image.file(
                image,
                height: 150,
              )
            : const Text('No image selected.'),
      ],
    );
  }

  void _showAwesomeSnackbar(String title, String message) {
    final snackBar = SnackBar(
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType:
            title == 'Success' ? ContentType.success : ContentType.failure,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Books',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                  borderSide: const BorderSide(color: Colors.black),
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
                  borderSide: const BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _updateBookNo();
                });
              },
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: _categories
                  .map((category) =>
                      DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bookNoController,
              onChanged: (_) => _updateBookNo(),
              decoration: InputDecoration(
                labelText: 'Book No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Upload Book Cover Photo",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildImagePicker('Select Main Image', _selectedImage,
                (file) => setState(() => _selectedImage = file)),
            const SizedBox(height: 16),
            const Text(
              "Upload Book Index Photos",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildImagePicker('Select Index Image 1', _index1Image,
                (file) => setState(() => _index1Image = file)),
            const SizedBox(height: 16),
            _buildImagePicker('Select Index Image 2', _index2Image,
                (file) => setState(() => _index2Image = file)),
            const SizedBox(height: 16),
            _buildImagePicker('Select Index Image 3', _index3Image,
                (file) => setState(() => _index3Image = file)),
            const SizedBox(height: 16),
            _buildImagePicker('Select Index Image 4', _index4Image,
                (file) => setState(() => _index4Image = file)),
            const SizedBox(height: 16),
            if (_uploadProgress != null)
              LinearProgressIndicator(value: _uploadProgress),
            ElevatedButton(
              onPressed: _saveBookData,
              child: const Text('Add Book'),
            ),
          ],
        ),
      ),
    );
  }
}
