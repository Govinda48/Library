import 'package:flutter/material.dart';
import 'package:library_1/view/addbook.dart';
import 'package:library_1/view/category.dart';
import 'package:library_1/view/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const CategoryPage(),
    const SearchScreen(),
    const AddBooksPage(),
    const LikePage(),
    const AccountPage(),
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
        // Show About Us page or dialog
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
        title: const Text(
          "Library",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.blue.shade300,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle notification button press here
            },
          ),
          PopupMenuButton(
            color: Colors.white,
            onSelected: _onMenuSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Dark Mode',
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Dark Mode'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Language',
                  child: Row(
                    children: [
                      Icon(Icons.language, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Language'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'About Us',
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.black),
                      SizedBox(width: 8),
                      Text('About Us'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'More',
                  child: Row(
                    children: [
                      Icon(Icons.more_horiz, color: Colors.black),
                      SizedBox(width: 8),
                      Text('More'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
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
        backgroundColor: Colors.blue.shade300,
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
            icon:
                Icon(Icons.account_circle, size: _currentIndex == 4 ? 30 : 24),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// Placeholder pages for each tab

class LikePage extends StatelessWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Like Page'));
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Account Page'));
  }
}
