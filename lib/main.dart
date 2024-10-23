import 'package:attendance_system/viewModel/AdminViewModel.dart';
import 'package:attendance_system/viewModel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Utilis/Routes/RouteName.dart';
import 'Utilis/Routes/RouteNavigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>LoginViewModel()),
        ChangeNotifierProvider(create: (_)=>AdminViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: RouteName.login,
        onGenerateRoute: RoutesNavigation.generateRoute,
      ),
    );
  }
}