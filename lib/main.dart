// ignore_for_file: prefer_const_constructors

import 'package:camerascreen/providers/imageprovider.dart';
import 'package:camerascreen/widgets/homeScreen.dart';
import 'package:camerascreen/widgets/test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageListProvider()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Times New Roman',
          ),
          home: HomeScreen(),
        );
      }),
    );
  }
}
