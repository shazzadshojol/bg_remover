import 'package:bg_remover/constant/image_path.dart';
import 'package:bg_remover/constant/my_text.dart';
import 'package:bg_remover/controller/home_controller.dart';
import 'package:bg_remover/widgets/grsdisnt_container.dart';
import 'package:bg_remover/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyText.homeTitle,
          Column(
            children: [
              GetBuilder<HomeController>(builder: (homeController) {
                return Container(
                  height: 400,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 5.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: homeController.isLoading
                        ? const Center(
                            child: LoadingIndicator(),
                          )
                        : homeController.removedImage != null
                            ? Image.memory(
                                homeController.removedImage!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                ImagePath.demoImage,
                                fit: BoxFit.cover,
                              ),
                  ),
                );
              }),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GetBuilder<HomeController>(builder: (homeController) {
                    return homeController.removedImage == null
                        ? ElevatedButton(
                            onPressed: () async {
                              final imageData = await controller.pickImage();

                              if (imageData == null) {
                                return;
                              }

                              controller.removeBg(imageData);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue),
                            child: MyText.btnText,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Save to Phone Button
                              SizedBox(
                                width: 160,
                                height: 80,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (controller.removedImage != null) {
                                      controller.saveToLocal(
                                          controller.removedImage!);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  child: MyText.saveText,
                                ),
                              ),
                              SizedBox(height: 15),
                              // Upload Again Button
                              SizedBox(
                                width: 160,
                                height: 80,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final imageData =
                                        await controller.pickImage();
                                    if (imageData != null) {
                                      controller.removeBg(imageData);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange),
                                  child: MyText.reUplodeText,
                                ),
                              ),
                            ],
                          );
                  }),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
