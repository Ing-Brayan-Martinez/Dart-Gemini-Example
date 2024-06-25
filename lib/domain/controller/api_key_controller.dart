import 'package:dart_gemini_example/data/database/repository/device_repository.dart';
import 'package:dart_gemini_example/domain/config/device_helper.dart';
import 'package:dart_gemini_example/domain/config/enums.dart';
import 'package:dart_gemini_example/domain/model/device.dart';
import 'package:dart_gemini_example/domain/model/device_model.dart';
import 'package:get/get.dart';
import 'package:optional/optional.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ApiKeyController extends GetxController {
  static ApiKeyController get to => Get.find();
  late DeviceRepository _deviceRepository;
  late BehaviorSubject<String> _subject;

  ApiKeyController() {
    _deviceRepository = DeviceRepositoryImpl();
    _subject = BehaviorSubject<String>();
  }

  void assignApiKey(String apiKey) async {
    final result = await DeviceHelper.getDevice();

    final select = GetDevice(result.name, result.code);

    final Optional<Device> optionalDefault =
        await _deviceRepository.findDefaultDevice(select);

    if (optionalDefault.isEmpty) {
      final documentId = const Uuid().v4().toString();

      final Device device = Device(documentId, true, DateTime.now(),
          DateTime.now(), result.name, result.code, DeviceStatus.chat, apiKey);

      await _deviceRepository.create(device);

      _subject.sink.add(apiKey);
    } else {
      final Device device = optionalDefault.value;
      device.updated = DateTime.now();
      device.status = DeviceStatus.chat;
      device.passKeyID = apiKey;

      await _deviceRepository.update(device);

      _subject.sink.add(apiKey);
    }
    update();
  }

  void getApiKey() async {
    final result = await DeviceHelper.getDevice();

    final select = GetDevice(result.name, result.code);

    final Optional<Device> optionalDefault =
        await _deviceRepository.findDefaultDevice(select);

    if (optionalDefault.isNotEmpty) {
      final Device device = optionalDefault.value;

      _subject.sink.add(device.passKeyID!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
  }

  Stream<String> get apiKeyStream => _subject.stream;
}
