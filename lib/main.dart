import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:muzik_local/cubit/theme_cubit.dart';
import 'package:muzik_local/ui/screens/skeleton_screen.dart';
import 'package:muzik_local/ui/screens/splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  final tmpDir = await getTemporaryDirectory();
  Hive.init(tmpDir.toString());
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: tmpDir,
  );

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Muzik Local',
            theme: state.themeData,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }
}
