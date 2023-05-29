import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/screens/admin/home_screen/home_screen.dart';
import 'package:ecommerce_app/screens/client/client_login_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.aBeeZeeTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: kIsWeb ? const AdminPage() : const CheckAuthentication(),
    );
  }
}
