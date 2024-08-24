import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showBookDetails(BuildContext context, String bookName,
      String authorName, String bookNo, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(bookName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 200),
                    )
                  : const Icon(Icons.book, size: 200),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, DocumentSnapshot document) {
    final bookNameController =
        TextEditingController(text: document['bookName']);
    final authorNameController =
        TextEditingController(text: document['authorName']);
    final bookNoController = TextEditingController(text: document['bookNo']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bookNameController,
                decoration: const InputDecoration(labelText: 'Book Name'),
              ),
              TextField(
                controller: authorNameController,
                decoration: const InputDecoration(labelText: 'Author Name'),
              ),
              TextField(
                controller: bookNoController,
                decoration: const InputDecoration(labelText: 'Book No'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                await _firestore.collection('books').doc(document.id).update({
                  'bookName': bookNameController.text,
                  'authorName': authorNameController.text,
                  'bookNo': bookNoController.text,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteBook(String documentId) async {
    await _firestore.collection('books').doc(documentId).delete();
  }

  void _showContextMenu(BuildContext context, DocumentSnapshot document) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Update'),
              onTap: () {
                Navigator.pop(context);
                _showUpdateDialog(context, document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteBook(document.id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('books')
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
              final category = book['category'] ?? 'Unknown Category';

              return GestureDetector(
                onLongPress: () => _showContextMenu(context, books[index]),
                onTap: () {
                  _showBookDetails(
                      context, bookName, authorName, bookNo, imageUrl);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 2),
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      "Name: $bookName",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Author: $authorName',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Category: $category',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Book No: $bookNo',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    trailing: imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, size: 50),
                            ),
                          )
                        : const Icon(Icons.book, size: 50),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
