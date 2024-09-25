import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  LoadingIndicatorState createState() => LoadingIndicatorState();
}

class LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];
  late AnimationController _controller;
  late Animation<int> _colorIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _colorIndex =
        IntTween(begin: 0, end: colors.length - 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _colorIndex,
        builder: (context, child) {
          return SizedBox(
            width: 35, // Increase the width
            height: 35,
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(colors[_colorIndex.value]),
              strokeWidth: 5.0,
            ),
          );
        },
      ),
    );
  }
}
