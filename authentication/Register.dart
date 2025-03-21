import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadaf7/authentication/Loginpage.dart';

import '../pages/fst.dart';
import 'auth.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // get auth service
  final authService = AuthService();

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void SignUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
          const SnackBar(content: Text("Passwords dont ,match!!!")));
      return;
    }
    // attempt signup
    try{
      await authService.signUpWithEmailPassword(email, password);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
    catch (e){
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor:  Color(0xFF9e9575),),
      backgroundColor: Color(0xFF9e9575),
      body: SafeArea(
        child: Center(child:Column( mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.airplane_ticket, size: 37, color: Color(0xFF156c73),),
            SizedBox(height: 25,),
            //hello again
            Text('H A D A F',
              style: GoogleFonts.bebasNeue(fontSize: 53),
            ),
            Text('هدف',
                style: TextStyle(
                  fontSize:30,
                )),
            Text('Enter your login credentials!',
                style: TextStyle(
                  fontSize:20,
                )),
            SizedBox(height: 10,),

            SizedBox(height: 50,),
            //username
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color:Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child:  Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border:InputBorder.none,
                        hintText: 'enter Username or E-mail'
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10,),
            //password

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color:Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child:  Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border:InputBorder.none,
                        hintText: 'enter your password'
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color:Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child:  Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border:InputBorder.none,
                        hintText: 're-enter your password to confirm'
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            // sign in button
            SizedBox(
              width: 370,
              height: 45,// Adjust the width here
              child: ElevatedButton(
                onPressed: SignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF156c73), // Background color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0), // Padding inside the button
                ),
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background, // Text color
                    fontWeight: FontWeight.bold, // Bold text
                    fontSize: 17, // Font size
                  ),
                ),
              ),
            ),


            SizedBox(height: 10,),
          ],
        ),
        ),
      ),
    );
  }
}