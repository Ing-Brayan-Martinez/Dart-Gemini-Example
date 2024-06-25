import 'package:dart_gemini_example/domain/controller/api_key_controller.dart';
import 'package:dart_gemini_example/presentation/screen/chat_screen.dart';
import 'package:dart_gemini_example/presentation/widget/image/done.dart';
import 'package:dart_gemini_example/presentation/widget/textfield/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/link.dart';

class ApiKeyScreen extends StatefulWidget {
  static const routeName = "/api_key";

  const ApiKeyScreen({super.key});

  @override
  State<ApiKeyScreen> createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('API Key'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (context.isPortrait) {
                //Vertical
                if (context.isPhone) {
                  return _getLayout();
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 400,
                        child: _getLayout(),
                      ),
                    ],
                  );
                }
              } else {
                //Horizontal
                if (context.isPhone) {
                  return _getLayout();
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 400,
                        child: _getLayout(),
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _getLayout() {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(minWidth: 400),
          child: const Text(
            'To use the Gemini API, you\'ll need an API key. '
            'If you don\'t already have one, '
            'create a key in Google AI Studio.',
          ),
        ),
        const SizedBox(height: 50),
        Container(
          constraints: const BoxConstraints(minWidth: 400),
          child: Link(
            uri: Uri.https('makersuite.google.com', '/app/apikey'),
            target: LinkTarget.blank,
            builder: (context, followLink) => TextButton(
              onPressed: followLink,
              child: const Text('Get an API Key'),
            ),
          ),
        ),
        const SizedBox(height: 50),
        Container(
          constraints: const BoxConstraints(minWidth: 400),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration:
                      textFieldDecoration(context, 'Enter your API key'),
                  controller: _textController,
                  onSubmitted: (value) {
                    //onSubmitted(value);
                  },
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  String apiKey = _textController.value.text;

                  if (apiKey.isNotEmpty) {
                    ApiKeyController.to.assignApiKey(apiKey);

                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext buildContext,
                          Animation animation, Animation secondaryAnimation) {
                        return const _RequestDialog();
                      },
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RequestDialog extends StatelessWidget {
  const _RequestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.background,
        child: Container(
          height: 340,
          width: 340,
          padding: const EdgeInsets.only(left: 35, right: 35, top: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: GetBuilder<ApiKeyController>(
              builder: (result) {
                return StreamBuilder<String>(
                  stream: result.apiKeyStream,
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    //Si esta esperando data para el stream
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingWidget(context);

                      //Si hay data en el stream
                    } else if (snapshot.connectionState ==
                            ConnectionState.active &&
                        !snapshot.hasError) {
                      return _buildDataWidget(context, snapshot.data!);

                      //Si hay un error en el stream
                    } else if (snapshot.hasError) {
                      return _buildErrorWidget(context, snapshot.error);

                      //Si se completo el stream
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return _buildCompleteWidget(context);
                    } else {
                      return _buildLoadingWidget(context);
                    }
                  },
                );
              },
            ),
          ),
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
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
      Navigator.of(context).pushNamedAndRemoveUntil(
          ChatScreen.routeName, (Route route) => false);
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const DoneImage(),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Successful'.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: 'OpenSans',
                fontSize: 32,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
