import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_book/custom_exception.dart';
import 'package:pro_book/pages/home_page.dart';
import 'package:pro_book/pages/login_page.dart';
import 'package:pro_book/services/auth_service.dart';

final authStreamProvider = StreamProvider.autoDispose<User?>((ref) {
  ref.maintainState = true;

  final userStream = ref.read(authServiceProvider).userChanges;

  return userStream;
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends HookConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStreamProvider);

    return _authState.when(
      data: (data) {
        if (data != null) {
          return const MyHomePage();
        } else {
          return const LoginPage();
        }
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, _) => Text(error is CustomExeption
          ? error.message!
          : "Something Went wrong, try again"),
    );
  }
}
