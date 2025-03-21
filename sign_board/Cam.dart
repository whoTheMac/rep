import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator/translator.dart';

class CamPage extends StatefulWidget {
  const CamPage({super.key});

  @override
  State<CamPage> createState() => _CamPageState();
}

class _CamPageState extends State<CamPage> {
  File? _imageFile;
  String? extractedText;
  String? translatedText;
  List<TextBlockDetails> blocksDetails = [];
  String? selectedLanguage;

  // Translator instance
  final GoogleTranslator translator = GoogleTranslator();

  // Language map for the dropdown
  final Map<String, String> languageMap = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Chinese': 'zh',
  };

  // Method to pick an image from the gallery
  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        extractedText = null;
        translatedText = null;
        blocksDetails.clear(); // Clear previous block details when a new image is picked
      });

      // Extract text from the picked image
      await _extractText(_imageFile!);
    }
  }

  // Method to extract text from the image
  Future<void> _extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        extractedText = recognizedText.text; // Store the recognized text
        blocksDetails = _extractTextBlockDetails(recognizedText);
      });
    } catch (e) {
      print('Error extracting text: $e');
    } finally {
      textRecognizer.close();
    }
  }

  // Extract details from text blocks
  List<TextBlockDetails> _extractTextBlockDetails(RecognizedText recognizedText) {
    List<TextBlockDetails> details = [];
    for (TextBlock block in recognizedText.blocks) {
      final String blockText = block.text;
      final Rect boundingBox = block.boundingBox ?? Rect.zero;

      // Convert corner points from Point<int> to Offset
      final List<Offset> cornerPoints = block.cornerPoints
          .map((point) => Offset(point.x.toDouble(), point.y.toDouble())) // Convert Point<int> to Offset
          .toList();

      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          details.add(TextBlockDetails(
            blockText: blockText,
            boundingBox: boundingBox,
            cornerPoints: cornerPoints,
            recognizedLanguages: block.recognizedLanguages,
            lineText: line.text,
            elementText: element.text,
          ));
        }
      }
    }
    return details;
  }

  // Method to translate the text
  Future<void> _translateText(String text, String languageCode) async {
    final translation = await translator.translate(text, to: languageCode);
    setState(() {
      translatedText = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Text Recognition')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display picked image
          _imageFile != null
              ? Image.file(_imageFile!, width: 200)
              : const Text('No image selected'),

          const SizedBox(height: 20),

          // Display extracted text
          extractedText != null
              ? Expanded(
            child: SingleChildScrollView(
              child: Text(
                extractedText!,
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          )
              : const Text('No text extracted'),

          const SizedBox(height: 20),

          // Dropdown for language selection
          DropdownButton<String>(
            value: selectedLanguage,
            hint: Text('Select Language'),
            onChanged: (String? newValue) {
              setState(() {
                selectedLanguage = newValue;
                // Translate text when a language is selected
                if (extractedText != null && selectedLanguage != null) {
                  _translateText(extractedText!, languageMap[selectedLanguage]!);
                }
              });
            },
            items: languageMap.keys.map<DropdownMenuItem<String>>((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Display translated text
          translatedText != null
              ? Expanded(
            child: SingleChildScrollView(
              child: Text(
                translatedText!,
                style: TextStyle(fontSize: 16, color: Colors.blue),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          )
              : const Text('No translation yet'),

          const SizedBox(height: 20),

          // Button to pick an image
          ElevatedButton(
            onPressed: pickImage,
            child: const Text("Pick Image from Gallery"),
          ),
        ],
      ),
    );
  }
}

// A model class to hold details of a text block
class TextBlockDetails {
  final String blockText;
  final Rect boundingBox;
  final List<Offset> cornerPoints;
  final List<String> recognizedLanguages;
  final String lineText;
  final String elementText;

  TextBlockDetails({
    required this.blockText,
    required this.boundingBox,
    required this.cornerPoints,
    required this.recognizedLanguages,
    required this.lineText,
    required this.elementText,
  });
}
