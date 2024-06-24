import 'dart:io';

import 'package:dart_gemini_example/domain/config/enums.dart';
import 'package:dart_gemini_example/domain/config/type_helper.dart';
import 'package:dart_gemini_example/domain/controller/splash_controller.dart';
import 'package:dart_gemini_example/domain/model/device.dart';
import 'package:dart_gemini_example/presentation/screen/api_key_screen.dart';
import 'package:dart_gemini_example/presentation/screen/chat_screen.dart';
import 'package:dart_gemini_example/presentation/widget/image/done.dart';
import 'package:dart_gemini_example/presentation/widget/image/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/";

  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Double? _heightTop;
  Double? _heightBottom;
  Double? _heightBottom2;

  @override
  void initState() {
    super.initState();
    _heightTop = 0;
    _heightBottom = 0;
    _heightBottom2 = 0;
    //
    Get.put(SplashController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var maxHeight = MediaQuery.of(context).size.height;

    //vertical
    if (context.isPortrait) {
      if (Platform.isAndroid) {
        _heightTop = maxHeight * 30 / 100;
        _heightBottom = maxHeight * 17 / 100;
        _heightBottom2 = maxHeight * 17 / 100;
      }

      if (Platform.isIOS) {
        _heightTop = maxHeight * 30 / 100;
        _heightBottom = maxHeight * 20 / 100;
        _heightBottom2 = maxHeight * 15 / 100;
      }

      if (Platform.isWindows) {
        _heightTop = maxHeight * 44 / 100;
        _heightBottom = maxHeight * 42 / 100;
        _heightBottom2 = maxHeight * 15 / 100;
      }

      if (Platform.isLinux) {
        _heightTop = maxHeight * 44 / 100;
        _heightBottom = maxHeight * 42 / 100;
        _heightBottom2 = maxHeight * 15 / 100;
      }

      if (Platform.isMacOS) {
        _heightTop = maxHeight * 44 / 100;
        _heightBottom = maxHeight * 42 / 100;
        _heightBottom2 = maxHeight * 15 / 100;
      }
    }
    //horizontal
    else {
      if (Platform.isAndroid) {
        _heightTop = maxHeight * 42 / 100;
        _heightBottom = maxHeight * 42 / 100;
        _heightBottom2 = maxHeight * 15 / 100;
      }

      if (Platform.isIOS) {
        _heightTop = maxHeight * 42 / 100;
        _heightBottom = maxHeight * 42 / 100;
        _heightBottom2 = maxHeight * 15 / 100;
      }

      if (Platform.isWindows) {
        _heightTop = maxHeight * 25 / 100;
        _heightBottom = maxHeight * 25 / 100;
        _heightBottom2 = maxHeight * 8 / 100;
      }

      if (Platform.isLinux) {
        _heightTop = maxHeight * 25 / 100;
        _heightBottom = maxHeight * 25 / 100;
        _heightBottom2 = maxHeight * 8 / 100;
      }

      if (Platform.isMacOS) {
        _heightTop = maxHeight * 25 / 100;
        _heightBottom = maxHeight * 25 / 100;
        _heightBottom2 = maxHeight * 8 / 100;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: _heightTop),
            const Logo(),
            SizedBox(height: _heightBottom),
            GetBuilder<SplashController>(
              initState: (state) {
                SplashController.to.getDeviceStatus();
              },
              builder: (result) {
                return StreamBuilder<Device>(
                  stream: result.status,
                  builder: (context, AsyncSnapshot<Device> snapshot) {
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
            SizedBox(height: _heightBottom2),
          ],
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
              'Error',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 18,
                fontFamily: 'OpenSans',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataWidget(BuildContext context, Device data) {
    Future.delayed(const Duration(seconds: 1), () {
      switch (data.status) {
        case DeviceStatus.chat:
          Navigator.of(context).pushNamedAndRemoveUntil(
              ChatScreen.routeName, (Route route) => false);
          break;

        case DeviceStatus.apikey:
          Navigator.of(context).pushNamedAndRemoveUntil(
              ApiKeyScreen.routeName, (Route route) => false);
          break;
      }
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SmallDoneImage(),
        const SizedBox(height: 5),
        Center(
          child: Text(
            'Successful'.tr,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
