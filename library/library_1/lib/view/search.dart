import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:library_1/view/bookindex.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = "";

  void _showBookDetails(BuildContext context, Map<String, dynamic> book) {
    final List<String> imageUrls = [
      if (book['imageUrl'] != null) book['imageUrl'],
      if (book['index1Url'] != null) book['index1Url'],
      if (book['index2Url'] != null) book['index2Url'],
      if (book['index3Url'] != null) book['index3Url'],
      if (book['index4Url'] != null) book['index4Url'],
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          bookName: book['bookName'] ?? 'Unknown Book',
          authorName: book['authorName'] ?? 'Unknown Author',
          bookNo: book['bookNo'] ?? 'Unknown Number',
          imageUrls: imageUrls,
        ),
      ),
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
                try {
                  await _firestore.collection('books').doc(document.id).update({
                    'bookName': bookNameController.text,
                    'authorName': authorNameController.text,
                    'bookNo': bookNoController.text,
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Success',
                        message: 'Book updated successfully',
                        contentType: ContentType.success,
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AwesomeSnackbarContent(
                        title: 'Error',
                        message: 'Failed to update book',
                        contentType: ContentType.failure,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteBook(String documentId) async {
    try {
      await _firestore.collection('books').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: 'Book deleted successfully',
            contentType: ContentType.failure,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: 'Failed to delete book',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
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
    final List<Color> colors = [
      Colors.red.shade50,
      Colors.green.shade50,
      Colors.blue.shade50,
      Colors.orange.shade50,
      Colors.purple.shade50,
      Colors.yellow.shade50,
      Colors.teal.shade50,
      Colors.pink.shade50,
      Colors.cyan.shade50,
      Colors.lime.shade50,
    ];
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: 'Search for a book',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('books')
                  .where('bookName', isGreaterThanOrEqualTo: _searchQuery)
                  .where('bookName',
                      isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                  .orderBy('bookName')
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
                      onLongPress: () =>
                          _showContextMenu(context, books[index]),
                      onTap: () {
                        _showBookDetails(context, book);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: colors[index %
                              colors
                                  .length], // Cyclhange the background color here
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
                                    width: 60,
                                    height: 80,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      print(
                                          'Image load error: $error'); // Log the error
                                      return const Icon(Icons.error,
                                          size: 50); // Display fallback icon
                                    },
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
          ),
        ],
      ),
    );
  }
}
