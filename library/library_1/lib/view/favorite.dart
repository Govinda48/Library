import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final List<Color> backgroundColors = [
    Colors.red.shade50,
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.orange.shade50,
    Colors.purple.shade50,
    Colors.yellow.shade50,
    Colors.cyan.shade50,
    Colors.pink.shade50,
    Colors.teal.shade50,
    Colors.lime.shade50,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('wishlist').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Firestore error: ${snapshot.error}');
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favorite books found.'));
          }

          final favoriteBooks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favoriteBooks.length,
            itemBuilder: (context, index) {
              final favoriteBook =
                  favoriteBooks[index].data() as Map<String, dynamic>;

              print('Favorite Book Data: $favoriteBook');

              final bookName = favoriteBook['bookName'] ?? 'Unknown Book';
              final authorName = favoriteBook['authorName'] ?? 'Unknown Author';
              final bookNo = favoriteBook['bookNo'] ?? 'Unknown Number';
              final imageUrl = favoriteBook['imageUrl'] ?? '';

              final bgColor = backgroundColors[index % backgroundColors.length];

              return GestureDetector(
                onTap: () {
                  // Show dialog with the image
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: imageUrl.isNotEmpty
                            ? Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.black),
                                ),
                              )
                            : const SizedBox(
                                width: 200,
                                height: 200,
                                child: Icon(
                                  Icons.book,
                                  size: 100,
                                ),
                              ),
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: bgColor,
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
                        fontSize: 18,
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
