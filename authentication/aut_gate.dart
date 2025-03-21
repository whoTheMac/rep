import 'package:flutter/material.dart';
import 'package:hadaf7/authentication/Loginpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/fst.dart';
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder:(context, snapshot){
          //loading...
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          //check for valid session
          final session= snapshot.hasData ? snapshot.data!.session : null;
          if (session != null){
            return SearchPage();
          }else{
            return LoginPage();
          }
        },
    );
  }
}
