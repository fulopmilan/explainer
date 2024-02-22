import 'dart:io';

import 'package:client/functions/crop_image.dart';
import 'package:client/functions/image_to_text.dart';
import 'package:client/widgets/after_scan_sheet.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/camera/button.dart';

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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 66, 66, 66),
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.photo_camera,
                            color: Color.fromARGB(255, 28, 28, 28),
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () async {
                  try {
                    final returnedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (returnedImage != null) {
                      cropImage(returnedImage.path, context).then((path) =>
                          imageToText(File(path!))
                              .then((text) => showText(text)));
                    }
                  } catch (error) {
                    print(error);
                  }
                },
                child: button(Alignment.bottomRight, Icons.image),
              ),
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
