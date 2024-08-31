// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryImagesPage extends StatelessWidget {
  final String category;

  const CategoryImagesPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text(
          category,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Firestore error: ${snapshot.error}');
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No images found.'));
          }

          List<String> imageUrls = [];

          // Iterate through each book document and collect image URLs
          for (var doc in snapshot.data!.docs) {
            final book = doc.data() as Map<String, dynamic>;

            // Add the main image URL if it exists
            if (book['imageUrl'] != null && book['imageUrl'].isNotEmpty) {
              imageUrls.add(book['imageUrl']);
            }

            // Add index image URLs if they exist
            for (int i = 1; i <= 4; i++) {
              final indexImageUrl = book['index${i}Url'];
              if (indexImageUrl != null && indexImageUrl.isNotEmpty) {
                imageUrls.add(indexImageUrl);
              }
            }
          }

          if (imageUrls.isEmpty) {
            return const Center(child: Text('No images found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Display 2 images per row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 3 / 4, // Adjust to fit image size
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 50);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
