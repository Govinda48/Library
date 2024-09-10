import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:multigenesys/utils/servic.dart';
import 'package:multigenesys/view/UserDetailsPage.dart';
import '../model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<User> filteredUsers = [];
  List<User> allUsers = [];
  final FocusNode _searchFocusNode = FocusNode();
  final ApiService apiService = ApiService();
  final List<Color> cardColors = [
    Colors.red.shade50,
    Colors.green.shade50,
    Colors.blue.shade50,
    Colors.yellow.shade50,
    Colors.purple.shade50,
    Colors.orange.shade50,
    Colors.cyan.shade50,
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(_filterUsers);
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await apiService.fetchUsers();
      print('Fetched users: $response'); // Debug print
      setState(() {
        allUsers = response;
        filteredUsers = response;
      });
    } catch (e) {
      print('Failed to load users: $e'); // Debug print
    }
  }

  void _filterUsers() {
    String searchQuery = _searchController.text.toLowerCase();
    setState(() {
      if (searchQuery.isEmpty) {
        filteredUsers = allUsers;
      } else {
        filteredUsers = allUsers.where((user) {
          return user.id.toLowerCase().contains(searchQuery) ||
              user.name.toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search by ID or Name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final User user = filteredUsers[index];

                return Card(
                  color: cardColors[index % cardColors.length],
                  margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.04,
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.grey,
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: user.avatar,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 30,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: Text("Name : ${user.name}"),
                    subtitle: Text('ID: ${user.id} \nEmail: ${user.emailId}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(user: user),
                        ),
                      ).then((_) {
                        _searchFocusNode.unfocus();
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
