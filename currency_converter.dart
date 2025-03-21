import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hadaf7/pages/fst.dart';
import 'package:hadaf7/pages/profile.dart';
import 'package:hadaf7/sign_board/upload.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Booking/bookings.dart';
import 'Speech_translation/translation.dart';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final String apiKey = 'YOUR_API_KEY'; // Replace with your API key from ExchangeRate API
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  TextEditingController _amountController = TextEditingController();
  double _convertedAmount = 0.0;
  String _selectedBaseCurrency = 'USD';
  String _selectedTargetCurrency = 'EUR';
  bool _isLoading = false;
  int _currentIndex = 1;

  // Fetch exchange rates from external API
  Future<Map<String, dynamic>> fetchExchangeRates(String baseCurrency) async {
    final url = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/$baseCurrency';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the rates data as a Map
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  // Convert amount based on exchange rate
  double convertCurrency(double amount, double rate) {
    return amount * rate;
  }

  // Save exchange rates to Supabase
  Future<void> saveConversionRatesToSupabase(Map<String, dynamic> ratesData) async {
    try {
      for (String currency in ratesData['conversion_rates'].keys) {
        final rate = ratesData['conversion_rates'][currency];
        await _supabaseClient.from('exchange_rates').upsert({
          'base_currency': ratesData['base'],
          'target_currency': currency,
          'rate': rate,
          'timestamp': DateTime.now().toUtc(),
        });
      }
    } catch (e) {
      print('Error saving conversion rates: $e');
    }
  }

  // Get conversion rate from API, save to Supabase, and convert the amount
  Future<void> _getConversionRate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch exchange rates from the API
      final ratesData = await fetchExchangeRates(_selectedBaseCurrency);

      // Save rates to Supabase
      saveConversionRatesToSupabase(ratesData);

      // Get the conversion rate for the target currency
      final rate = ratesData['conversion_rates'][_selectedTargetCurrency];
      setState(() {
        _convertedAmount = convertCurrency(
          double.tryParse(_amountController.text) ?? 0.0,
          rate,
        );
      });
    } catch (e) {
      // Handle errors
      setState(() {
        _convertedAmount = 0.0;
      });
      print('Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('C U R R E N C Y   C O N V E R T E R',  style: TextStyle(color: Color(0xa08f6d5a), fontWeight: FontWeight.bold),), backgroundColor: Colors.white, leading: Icon(Icons.currency_exchange,color: Color(0xa08f6d5a)),),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Input field for the amount to convert
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter Amount'),
              ),
              SizedBox(height: 10),

              // Currency selection dropdowns for base and target currency
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedBaseCurrency,
                      onChanged: (value) {
                        setState(() {
                          _selectedBaseCurrency = value!;
                        });
                      },
                      items: ['USD', 'EUR', 'GBP', 'INR', 'SAR', 'CNY']
                          .map((currency) {
                        return DropdownMenuItem(
                          child: Text(currency),
                          value: currency,
                        );
                      }).toList(),
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedTargetCurrency,
                      onChanged: (value) {
                        setState(() {
                          _selectedTargetCurrency = value!;
                        });
                      },
                      items: ['USD', 'EUR', 'GBP', 'INR', 'SAR', 'CNY']
                          .map((currency) {
                        return DropdownMenuItem(
                          child: Text(currency),
                          value: currency,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Convert button
              ElevatedButton(
                onPressed: _getConversionRate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,  // Set the background color to black
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Convert', style: TextStyle(color: Color(0xa0b79c8d), fontWeight: FontWeight.bold, fontSize: 17 ),),
              ),

              SizedBox(height: 20),

              // Display the converted amount
              Text(
                'Converted Amount: $_convertedAmount $_selectedTargetCurrency',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
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
            Icon(Icons.currency_exchange_sharp, size: 30),
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
