import 'package:bg_remover/constant/image_path.dart';
import 'package:bg_remover/constant/my_text.dart';
import 'package:bg_remover/screens/home_screen.dart';
import 'package:bg_remover/widgets/grsdisnt_container.dart';
import 'package:bg_remover/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          Get.offAll(() => const HomeScreen(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 500));
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: GradientContainer(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              ImagePath.introImage,
              fit: BoxFit.cover,
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingIndicator(),
                SizedBox(height: 15),
                MyText.introText,
                SizedBox(height: 60),
              ],
            ),
          )
        ],
      )),
    );
  }
}
