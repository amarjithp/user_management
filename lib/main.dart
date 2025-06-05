import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart'; // 🐝 Required for Flutter integration
import 'logic/bloc/user/user_bloc.dart';
import 'logic/cubit/theme_cubit.dart';
import 'data/services/user_service.dart';
import 'presentation/screens/user_list_screen.dart';
import 'data/models/user_model.dart'; // ✅ Import your model

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapter
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter()); // Make sure UserAdapter is generated

  // Create and initialize your UserService (opens box internally)
  final userService = UserService();
  await userService.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserBloc(userService: userService)),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'User Management',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const UserListScreen(),
        );
      },
    );
  }
}
