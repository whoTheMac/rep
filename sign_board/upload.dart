import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator/translator.dart';
import '../Booking/bookings.dart';
import '../Speech_translation/translation.dart';
import '../currency_converter.dart';
import '../pages/fst.dart';
import '../pages/profile.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
  String? extractedText;
  String? translatedText;
  String? selectedLanguage;
  int _currentIndex = 3;

  // Updated list of available languages including Arabic and Malayalam
  final Map<String, String> languageMap = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Chinese': 'zh',
    'Arabic': 'ar',      // Arabic language
    'Malayalam': 'ml',   // Malayalam language
  };

  final GoogleTranslator translator = GoogleTranslator();

  // Method to pick an image from the gallery
  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        extractedText = null;
        translatedText = null; // Reset translated text when a new image is picked
      });

      // Extract text from the picked image
      await _extractText(_imageFile!);
    }
  }

  // Method to extract text from the image
  Future<void> _extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    setState(() {
      extractedText = recognizedText.text; // Store the recognized text
    });

    textRecognizer.close();
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
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(leading: Icon(Icons.image,color:Color(
            0xff338181),),
          title: Text(
            'I M A G E   T R A N S L A T O R',
            style: TextStyle(color: Color(0xa08f6d5a), fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display picked image
            Center(
              child: _imageFile != null
                  ? Image.file(_imageFile!, width: 200)
                  : const Text('No image selected'),
            ),

            const SizedBox(height: 20),

            // Button to pick an image from gallery with custom background color
            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9c7e64), // Custom background color for the button
              ),
              child: const Text("Pick Image from Gallery",style: TextStyle(fontSize: 16, color:Colors.white, fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 20),

            // Display extracted text
            extractedText != null
                ? Expanded(
              child: SingleChildScrollView(
                child: Text(
                  extractedText!,
                   style: TextStyle(fontSize: 16, color:Color(
                      0xff338181), fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            )
                : const Text('No text extracted', style: TextStyle(fontSize: 16, color:Color(
                0xff338181), fontWeight: FontWeight.bold),),
            const SizedBox(height: 20),

            // Language dropdown to select translation language with custom background color
            DropdownButton<String>(
              value: selectedLanguage,
              hint: Text('Select Language', style: TextStyle(fontSize: 16, color:Color(
                  0xff338181), fontWeight: FontWeight.bold), ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue;
                  // Translate the text when language is selected
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
              // Custom background color for the dropdown
              dropdownColor: Color(0xFF9c7e64),
              iconEnabledColor: Colors.white,  // Change icon color to white
            ),

            const SizedBox(height: 20),

            // Display the translated text
            translatedText != null
                ? Expanded(
              child: SingleChildScrollView(
                child: Text(
                  translatedText!,
                  style: TextStyle(fontSize: 20, color:Color(
                      0xff338181), fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            )
                : const Text('No translation yet', style: TextStyle(fontSize: 20, color:Color(
                0xff338181), fontWeight: FontWeight.bold),),

            const SizedBox(height: 30),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 60.0,
          index: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // If the "Booking" icon (index 3) is tapped, navigate to the BookingPage
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            }
            if (index == 5) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            }
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingPage()),
              );
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyConverterPage()),
              );
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadPage()),
              );
            }
          },
          backgroundColor: Colors.transparent,  // Set background color to transparent
          color: Color(0xFF9c7e64),  // Color of the curved navigation bar
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.mic, size: 30),
            Icon(Icons.g_translate, size: 30),
            Icon(Icons.translate_sharp,size:30),
            Icon(Icons.favorite, size: 30),
            Icon(Icons.person, size: 30),
          ],
        ),
      ),
    );
  }
}
