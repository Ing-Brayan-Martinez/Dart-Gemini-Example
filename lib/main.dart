import 'package:dart_gemini_example/presentation/screen/api_key_screen.dart';
import 'package:dart_gemini_example/presentation/screen/chat_screen.dart';
import 'package:dart_gemini_example/presentation/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const GenerativeAISample());
}

class GenerativeAISample extends StatelessWidget {
  const GenerativeAISample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter + Generative AI',
      theme: _lightTheme(),
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: _route,
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color.fromARGB(255, 171, 222, 244),
        surface: Colors.white,
      ),
      useMaterial3: true,
    );
  }

  Route<dynamic>? _route(RouteSettings settings) {
    switch (settings.name) {
      //splash
      case SplashScreen.routeName:
        return PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.fade,
          settings: settings,
        );

      //chat
      case ChatScreen.routeName:
        return PageTransition(
          child: const ChatScreen(title: 'Flutter + Generative AI'),
          type: PageTransitionType.bottomToTop,
          settings: settings,
        );

      //api-key
      case ApiKeyScreen.routeName:
        return PageTransition(
          child: const ApiKeyScreen(),
          type: PageTransitionType.bottomToTop,
          settings: settings,
        );

      default:
        return null;
    }
  }
}
