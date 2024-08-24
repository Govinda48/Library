import 'package:flutter/material.dart';
import 'package:library_1/view/categorybook.dart'; // Import your new page

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Civil',
        'image':
            'https://i.pinimg.com/564x/11/7a/de/117ade2af80eb9722818c6f2344c476c.jpg',
        'page': const CategoryBooksPage(category: 'Civil'),
      },
      {
        'name': 'Criminal',
        'image':
            'https://i.pinimg.com/564x/0a/78/65/0a78651a49a8053c31b9ed571bfe6278.jpg',
        'page': const CategoryBooksPage(category: 'Criminal'),
      },
      {
        'name': 'Family',
        'image':
            'https://i.pinimg.com/474x/04/ea/77/04ea773a4cb886cf1d3b08551619a60e.jpg',
        'page': const CategoryBooksPage(category: 'Family'),
      },
      {
        'name': 'Property',
        'image':
            'https://i.pinimg.com/474x/81/bd/7d/81bd7d8cf2d418e92c3c12cdb13bc724.jpg',
        'page': const CategoryBooksPage(category: 'Property'),
      },
      {
        'name': 'NI Act',
        'image':
            'https://i.pinimg.com/564x/ae/19/dd/ae19dd40fe84b7f988dc3bdb087673a7.jpg',
        'page': const CategoryBooksPage(category: 'NI Act'),
      },
      {
        'name': 'Constitution',
        'image':
            'https://i.pinimg.com/474x/fe/3b/96/fe3b963286321968a580da4c0d545681.jpg',
        'page': const CategoryBooksPage(category: 'Constitution'),
      },
      {
        'name': 'JMFC',
        'image':
            'https://i.pinimg.com/564x/95/ea/87/95ea87633b22855626e6598481466372.jpg',
        'page': const CategoryBooksPage(category: 'JMFC'),
      },
      {
        'name': 'Student',
        'image':
            'https://i.pinimg.com/474x/3a/e9/84/3ae984b45b22e9faea5e9e8bdab22304.jpg',
        'page': const CategoryBooksPage(category: 'Student'),
      },
      {
        'name': 'Other',
        'image':
            'https://i.pinimg.com/564x/6d/c6/78/6dc6784f75b3fc94a68cd948baeed425.jpg',
        'page': const CategoryBooksPage(category: 'Other'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1, // Adjusts the grid items to be square
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => category['page'],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 0), // Shadow position
                      blurRadius: 6, // Shadow blur radius
                      spreadRadius: 1, // Shadow spread radius
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Background image
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10)),
                        child: Image.network(
                          category['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    // Name container with grey background
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 134, 134, 134),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
