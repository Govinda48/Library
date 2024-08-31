// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:library_1/screen/signin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool isError = false; // Track if there's an error

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppLifecycleState changed: $state");
    if (state == AppLifecycleState.resumed) {
      // Resume the video when the app is resumed
      if (chewieController != null) {
        chewieController!.videoPlayerController.play();
      }
    } else if (state == AppLifecycleState.paused) {
      // Pause the video when the app is paused
      if (chewieController != null) {
        chewieController!.videoPlayerController.pause();
      }
    }
  }

  // Initialize the video player and handle errors gracefully
  Future<void> initializeVideoPlayer() async {
    try {
      videoPlayerController =
          VideoPlayerController.asset("assets/video/login.mp4");

      await videoPlayerController.initialize();
      setState(() {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          aspectRatio: videoPlayerController.value.aspectRatio,
          autoPlay: true,
          looping: true,
          showControls: false,
        );
        isError = false; // Reset error state
      });
    } catch (error) {
      setState(() {
        isError = true;
      });
      print("Error initializing video: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isError
          ? const Center(
              child: Text(
                'Failed to load video. Please check your file and try again.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          : chewieController != null &&
                  chewieController!.videoPlayerController.value.isInitialized
              ? Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Chewie(
                      controller: chewieController!,
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const Text(
                              'Elevate Your Strength at Gymmax CRM Where Fitness Meets Innovation',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 22,
                                letterSpacing: 0.2,
                                wordSpacing: 0.2,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  width: 150, // Adjust the width as needed
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Rounded corners
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0), // Height of button
                                    ),
                                    onPressed: () {
                                      // Handle Sign Up
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150, // Adjust the width as needed
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Rounded corners
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0), // Height of button
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }
}
