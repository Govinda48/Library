import 'package:flutter/material.dart';
import 'package:library_1/view/categorybook.dart'; // Import your CategoryBooksPage

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Civil',
        'image': 'assets/images/civil.png',
        'page': const CategoryBooksPage(category: 'Civil'),
      },
      {
        'name': 'Criminal',
        'image': 'assets/images/criminal.png',
        'page': const CategoryBooksPage(category: 'Criminal'),
      },
      {
        'name': 'Family',
        'image': 'assets/images/family.png',
        'page': const CategoryBooksPage(category: 'Family'),
      },
      {
        'name': 'Property',
        'image': 'assets/images/property.png',
        'page': const CategoryBooksPage(category: 'Property'),
      },
      {
        'name': 'NI act',
        'image': 'assets/images/ni.png',
        'page': const CategoryBooksPage(category: 'NI act'),
      },
      {
        'name': 'Constitution',
        'image': 'assets/images/consti.png',
        'page': const CategoryBooksPage(category: 'Constitution'),
      },
      {
        'name': 'Jmfc',
        'image': 'assets/images/jmfc.png',
        'page': const CategoryBooksPage(category: 'Jmfc'),
      },
      {
        'name': 'Student',
        'image': 'assets/images/student.png',
        'page': const CategoryBooksPage(category: 'Student'),
      },
      {
        'name': 'Bare Act',
        'image': 'assets/images/bare.png',
        'page': const CategoryBooksPage(category: 'Bare Act'),
      },
      {
        'name': 'Other',
        'image': 'assets/images/more.png',
        'page': const CategoryBooksPage(category: 'Other'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 2 items per row
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
                      offset: const Offset(0, 2), // Shadow position
                      blurRadius: 2, // Shadow blur radius
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
                        child: Image.asset(
                          category['image']!,
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    // Name container with grey background
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
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
                          color: Colors.black,
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
