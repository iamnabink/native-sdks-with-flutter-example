import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// The actual content displayed by the module.
///
/// This widget displays a Lottie animated background with a black background.
/// It can optionally show exit functionality.
class Contents extends StatelessWidget {
  final bool showExit;

  const Contents({super.key, this.showExit = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Black background
          Positioned.fill(
            child: Container(
              color: Colors.black,
            ),
          ),
          // Lottie animated background
          Positioned.fill(
            child: Lottie.asset(
              'assets/lottie/be_bold.json',
              fit: BoxFit.contain,
              repeat: true,
              options: LottieOptions(
                enableMergePaths: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
