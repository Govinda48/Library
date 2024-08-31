import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:library_1/screen/about.dart';
import 'package:library_1/view/account.dart';
import 'package:library_1/view/addbook.dart';
import 'package:library_1/view/category.dart';
import 'package:library_1/view/favorite.dart';
import 'package:library_1/view/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const CategoryPage(),
    const SearchScreen(),
    const AddBooksPage(),
    const FavoriteScreen(),
    const CategoryWiseBookCountPage(),
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  void _onMenuSelected(String choice) {
    switch (choice) {
      case 'Dark Mode':
        // Toggle dark mode here
        break;
      case 'Language':
        // Handle language selection here
        break;
      case 'About Us':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutUsScreen()),
        );
        break;
      case 'More':
        // Handle more actions
        break;
    }
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
                'Library Book',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ),
              );
            },
          ),
        ],
        elevation: 10.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.deepPurple.shade300,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category, size: _currentIndex == 0 ? 30 : 24),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: _currentIndex == 1 ? 30 : 24),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, size: _currentIndex == 2 ? 30 : 24),
            label: 'Add Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: _currentIndex == 3 ? 30 : 24),
            label: 'Like',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined, size: _currentIndex == 4 ? 30 : 24),
            label: 'Books',
          ),
        ],
      ),
    );
  }
}
