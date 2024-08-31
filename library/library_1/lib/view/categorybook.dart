// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CategoryBooksPage extends StatelessWidget {
  final String category;

  const CategoryBooksPage({super.key, required this.category});

  void _addToWishlist(
      Map<String, dynamic> bookData, BuildContext context) async {
    try {
      final bookId = bookData['bookId'];

      // Check if the book is already in the wishlist
      final wishlistRef =
          FirebaseFirestore.instance.collection('wishlist').doc(bookId);
      final snapshot = await wishlistRef.get();

      if (!snapshot.exists) {
        // Add the book to the wishlist
        await wishlistRef.set(bookData);
        _showAwesomeSnackBar(
          context,
          'Success!',
          'Book added to favorites!',
          ContentType.success,
        );
      } else {
        // If the book is already in the wishlist, remove it
        await wishlistRef.delete();
        _showAwesomeSnackBar(
          context,
          'Removed!',
          'Book removed from favorites!',
          ContentType.warning,
        );
      }
    } catch (e) {
      _showAwesomeSnackBar(
        context,
        'Error!',
        'Failed to add to favorites: $e',
        ContentType.failure,
      );
    }
  }

  void _showAwesomeSnackBar(
      BuildContext context, String title, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AnimationConfiguration.staggeredList(
          position: 0,
          duration: Duration(seconds: 1),
          child: SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(
              child: Text(
                'Category Book',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // Add search action
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const AboutUsScreen(),
              //   ),
              // );
            },
          ),
        ],
        elevation: 10.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('category', isEqualTo: category)
            .orderBy('timestamp', descending: true)
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
            return const Center(child: Text('No books found.'));
          }

          final books = snapshot.data!.docs;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index].data() as Map<String, dynamic>;

              final bookName = book['bookName'] ?? 'Unknown Book';
              final authorName = book['authorName'] ?? 'Unknown Author';
              final bookNo = book['bookNo'] ?? 'Unknown Number';
              final imageUrl = book['imageUrl'] ?? '';
              final bookId =
                  books[index].id; // Getting the document ID for wishlist

              // Add the bookId to the book data
              book['bookId'] = bookId;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to another page if needed
                    },
                    onDoubleTap: () {
                      _addToWishlist(
                          book, context); // Call the function on double-tap
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 2),
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  imageUrl,
                                  width: 70,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error, size: 50),
                                ),
                              )
                            : const Icon(Icons.book, size: 50),
                        title: Text(
                          "Name : $bookName",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Increased font size
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Author : $authorName',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Book No : $bookNo',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('wishlist')
                              .doc(bookId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            bool isInWishlist =
                                snapshot.hasData && snapshot.data!.exists;

                            return IconButton(
                              icon: Icon(
                                isInWishlist
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isInWishlist ? Colors.red : Colors.black,
                              ),
                              onPressed: () {
                                _addToWishlist(book, context);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
