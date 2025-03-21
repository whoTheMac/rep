import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadaf7/admin/entry.dart';
import 'package:hadaf7/pages/Log.dart';
import 'package:hadaf7/authentication/auth.dart';
import '../admin/booking management.dart';
import '../pages/fst.dart';
import 'Register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // get auth service
  final authService = AuthService();

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //login button pressed
  void login() async {
    final email= _emailController.text;
    final password = _passwordController.text;
    try{
      await authService.signInWithEmailPassword(email, password);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    }
    catch(e) {
      if(mounted){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.transparent, // Transparent AppBar background
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined), // Icon for your leading button (e.g., login icon)
            onPressed: () {
              // Navigate to the LogPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()), // Navigate to LogPage
              );
            },
          ),
        ),
        backgroundColor: Color(0xFF9e9575),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top:90.0),
              child: Center(child:Column
                ( mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(height: 30,),
                  // sign in button
                  SizedBox(
                    width: 370,
                    height: 45,// Adjust the width here
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF156c73), // Background color of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.0), // Padding inside the button
                      ),
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background, // Text color
                          fontWeight: FontWeight.bold, // Bold text
                          fontSize: 17, // Font size
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 10,),
                  //not a member(register)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('NOt a member?'),
                      GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage(),
                              )),
                          child: Text(' Register now!',style:TextStyle(color: Color(0xFF156c73)))),
                    ],
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the second page when text is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CodeVerificationPage()),
                        );
                      },
                      child: Text(
                        'A D M I N? ',
                        style: TextStyle(fontSize: 18, color: Color(0xFF156c73),),
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

