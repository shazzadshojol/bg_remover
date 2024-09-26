import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bg_remover/constant/url.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? removedImage;
  bool isLoading = false;

  Future<Uint8List?> pickImage() async {
    try {
      XFile? pickedImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) {
        return null;
      } else {
        Uint8List imageBytes = await pickedImage.readAsBytes();
        return imageBytes;
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Image upload failed');
    }
    return null;
  }

  Future<void> removeBg(Uint8List imageBytes) async {
    try {
      isLoading = true;
      update();
      String base64Image = base64Encode(imageBytes);

      final response = await http.post(Uri.parse(Url.removeBgUrl),
          headers: {
            'X-API-Key': Url.apiKey,
            'Content-type': 'application/json'
          },
          body: jsonEncode({'image_file_b64': base64Image}));

      if (response.statusCode == 200) {
        log('Response: ${response.statusCode}');
        removedImage = response.bodyBytes;
        update();
      } else {
        log("Error: ${response.statusCode} - ${response.body}");
        Get.snackbar(
            'Error', 'Failed to remove background: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
      Get.snackbar('Error', 'Removing failed');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> saveToLocal(Uint8List imageBytes) async {
    final request = await Permission.storage.request();

    if (request.isGranted) {
      try {
        Directory? directory = await getExternalStorageDirectory();

        directory ??= await getApplicationDocumentsDirectory();

        String filePath =
            '${directory.path}/saved_image_${DateTime.now().microsecondsSinceEpoch}.png';
        File imageFile = File(filePath);
        await imageFile.writeAsBytes(imageBytes);
        log('Image is saved to: $filePath');
        Get.snackbar('Success', 'Image saved to: $filePath');
      } catch (e) {
        log('Error: $e');
        Get.snackbar('Error', 'Failed to save image');
      }
    } else {
      Get.snackbar('Permission Denied', 'Storage permission denied');
    }
  }
}
