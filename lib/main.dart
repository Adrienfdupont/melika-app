import 'package:flutter/material.dart';
import 'package:melika/home.dart';

void main() => runApp(const MelikaApp());

class MelikaApp extends StatelessWidget {
  const MelikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Home(),
    );
  }
}
