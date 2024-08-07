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
        brightness: Brightness.light,
        seedColor: const Color(0xFF0C298B),
        surface: Colors.white,
        onPrimary: const Color(0xFF0C298B),
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
          child: const ChatScreen(),
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
