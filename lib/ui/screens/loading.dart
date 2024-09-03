import "package:flutter/material.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.twistingDots(
            leftDotColor: Colors.red,
            rightDotColor: Colors.blue,
            size: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            "Waiting for other players...",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    ));
  }
}
