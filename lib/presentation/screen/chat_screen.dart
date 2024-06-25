import 'package:dart_gemini_example/domain/controller/api_key_controller.dart';
import 'package:dart_gemini_example/presentation/widget/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chat";

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Flutter + Generative AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: GetBuilder<ApiKeyController>(
          initState: (state) {
            ApiKeyController.to.getApiKey();
          },
          builder: (result) {
            return StreamBuilder<String>(
              stream: result.apiKeyStream,
              builder: (context, AsyncSnapshot<String> snapshot) {
                //Si esta esperando data para el stream
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingWidget(context);

                  //Si hay data en el stream
                } else if (snapshot.connectionState == ConnectionState.active &&
                    !snapshot.hasError) {
                  return _buildDataWidget(context, snapshot.data!);

                  //Si hay un error en el stream
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(context, snapshot.error);

                  //Si se completo el stream
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return _buildCompleteWidget(context);
                } else {
                  return _buildLoadingWidget(context);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompleteWidget(BuildContext context) {
    return Center(
      child: Text('Done!'.tr),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object? error) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
    return Column(
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.error,
          size: 100,
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error'.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 18,
                fontFamily: 'OpenSans',
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Try again'.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontFamily: 'OpenSans',
                fontSize: 36,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataWidget(BuildContext context, String apiKey) {
    return ChatWidget(apiKey: apiKey);
  }
}
