import 'dart:io';

import 'package:client/utilities/image/crop_image.dart';
import 'package:client/utilities/image/image_to_text.dart';
import 'package:client/screens/main/show_scanned_text/after_scan_sheet.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int cameraIndex = 0;

  late List<CameraDescription> cameras;
  late CameraController cameraController;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) return;
      setState(() {}); //refreshes widget after the camera is initialized
    }).catchError((error) {
      print(error);
    });
  }

  void showText(text) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => AfterScanSheet(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget takePictureButton = GestureDetector(
      onTap: () async {
        try {
          cameraController.takePicture().then(
            (XFile? file) {
              if (mounted) {
                if (file != null) {
                  cropImage(file.path, context).then(
                    (path) => imageToText(File(path!)).then(
                      (text) => showText(text),
                    ),
                  );
                }
              }
            },
          );
        } catch (error) {
          print(error);
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(
            left: 20,
            bottom: 20,
          ),
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.background,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 66, 66, 66),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.photo_camera,
              color: Theme.of(context).colorScheme.primary,
              size: 36,
            ),
          ),
        ),
      ),
    );
    Widget selectPictureButton = GestureDetector(
      onTap: () async {
        try {
          final returnedImage =
              await ImagePicker().pickImage(source: ImageSource.gallery);

          if (returnedImage != null) {
            cropImage(returnedImage.path, context).then((path) =>
                imageToText(File(path!)).then((text) => showText(text)));
          }
        } catch (error) {
          print(error);
        }
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.only(
            left: 20,
            bottom: 20,
          ),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.background,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 66, 66, 66),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );

    if (cameraController.value.isInitialized) {
      return Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(cameraController),
            ),
            Center(
              child: takePictureButton,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: selectPictureButton,
            ),
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.black,
      );
    }
  }
}
