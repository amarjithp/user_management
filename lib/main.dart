import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/bloc/user/user_bloc.dart';
import 'logic/cubit/theme_cubit.dart';
import 'data/services/user_service.dart'; // ✅ Import this
import 'presentation/screens/user_list_screen.dart';

void main() {
  final userService = UserService(); // ✅ Create the service

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserBloc(userService: userService)), // ✅ Pass it
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
