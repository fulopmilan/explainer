import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> imageToText(File image) async {
  final inputImage = InputImage.fromFile(image);
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
  String text = recognizedText.text;

  textRecognizer.close();
  return text;
}
