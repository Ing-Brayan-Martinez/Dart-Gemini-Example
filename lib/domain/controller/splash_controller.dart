import 'package:dart_gemini_example/data/database/repository/device_repository.dart';
import 'package:dart_gemini_example/domain/config/device_helper.dart';
import 'package:dart_gemini_example/domain/config/enums.dart';
import 'package:dart_gemini_example/domain/model/device.dart';
import 'package:dart_gemini_example/domain/model/device_model.dart';
import 'package:get/get.dart';
import 'package:optional/optional.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();
  late DeviceRepository _deviceRepository;
  late BehaviorSubject<Device> _subject;

  SplashController() {
    _deviceRepository = DeviceRepositoryImpl();
    _subject = BehaviorSubject<Device>();
  }

  void getDeviceStatus() async {
    final result = await DeviceHelper.getDevice();

    final select = GetDevice(result.name, result.code);

    final Optional<Device> optionalDefault =
        await _deviceRepository.findDefaultDevice(select);

    if (optionalDefault.isEmpty) {
      final documentId = const Uuid().v4().toString();

      final Device device = Device(documentId, true, DateTime.now(),
          DateTime.now(), result.name, result.code, DeviceStatus.apikey, null);

      final Optional<Device> optionalCreate =
          await _deviceRepository.create(device);

      if (optionalCreate.isPresent) {
        final Device device = optionalCreate.value;

        _subject.sink.add(device);
      }
    } else {
      final Device device = optionalDefault.value;

      _subject.sink.add(device);
    }

    // FIN
    update();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
  }

  Stream<Device> get status => _subject.stream;
}
