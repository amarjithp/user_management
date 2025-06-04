import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/services/user_service.dart';
import 'logic/bloc/user/user_bloc.dart';
import 'presentation/screens/user_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Manager',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: RepositoryProvider(
        create: (_) => UserService(),
        child: BlocProvider(
          create: (context) => UserBloc(userService: context.read<UserService>()),
          child: const UserListScreen(),
        ),
      ),
    );
  }
}
