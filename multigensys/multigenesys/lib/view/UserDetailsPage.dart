import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import CachedNetworkImage
import '../model/model.dart'; // Import the User model

class UserDetailsPage extends StatelessWidget {
  final User user; // Accept User object from HomePage

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: CachedNetworkImageProvider(
                    user.avatar), // Use CachedNetworkImageProvider for caching
                // Adding placeholder and error handling
                child: CachedNetworkImage(
                  imageUrl: user.avatar,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 80,
                    backgroundImage: imageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Container around employee details only
              Container(
                padding: const EdgeInsets.all(16.0), // Inner padding
                decoration: BoxDecoration(
                  color:
                      Colors.deepPurple[50], // Background color for user info
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text('ID: ${user.id}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Email: ${user.emailId}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Mobile: ${user.mobile}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Country: ${user.country}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('State: ${user.state}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('District: ${user.district}',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
