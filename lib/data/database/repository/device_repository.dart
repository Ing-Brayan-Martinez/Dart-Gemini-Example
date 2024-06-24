import 'package:dart_gemini_example/data/database/configuration/repository.dart';
import 'package:dart_gemini_example/domain/config/type_helper.dart';
import 'package:dart_gemini_example/domain/model/device.dart';
import 'package:dart_gemini_example/domain/model/device_model.dart';
import 'package:optional/optional.dart';
import 'package:sqlite3/sqlite3.dart';

abstract interface class DeviceRepository {
  Future<Optional<Device>> create(Device param);

  Future<Optional<Device>> update(Device param);

  Future<Void> truncate();

  Future<Integer> isEmpty();

  Future<Optional<Device>> findDefaultDevice(GetDevice select);
}

final class DeviceRepositoryImpl extends Repository
    implements DeviceRepository {
  @override
  Future<Optional<Device>> create(Device param) async {
    // Get connection
    final Database db = await getDbConnection();

    // Create query
    const String query = '''
    INSERT INTO Device (deviceID, isActive, created, updated, name, code,
      status, passKeyID) VALUES (?,?,?,?,?,?,?,?)
    ''';

    // Prepare a statement to run it multiple times:
    db.prepare(query).execute(param.toListSave());

    // Create query
    const String query2 = '''
    SELECT * FROM Device w
      WHERE w.deviceID = ? AND w.isActive = 1
    ''';

    // Get row inserted
    final ResultSet resultSet = db.prepare(query2).select([param.deviceID]);

    if (resultSet.isEmpty) {
      return const Optional.empty();
    }

    // Get data
    final Row snapshot = resultSet[0];

    final Device entity = Device.fromJson(snapshot);

    return Optional.of(entity);
  }

  @override
  Future<Optional<Device>> update(Device param) async {
    // Get connection
    final Database db = await getDbConnection();

    // Create query
    const String query = '''
    UPDATE Device SET isActive = ?, created = ?, updated = ?, name = ?,
      code = ?, status = ?, passKeyID = ?
      WHERE deviceID = ?
    ''';

    // Prepare a statement to run it multiple times:
    db.prepare(query).execute(param.toListUpdate());

    // Create query
    const String query2 = '''
    SELECT * FROM Device w
      WHERE w.deviceID = ? AND w.isActive = 1
    ''';

    // Get row inserted
    final ResultSet resultSet = db.prepare(query2).select([param.deviceID]);

    if (resultSet.isEmpty) {
      return const Optional.empty();
    }

    // Get data
    final Row snapshot = resultSet[0];

    final Device entity = Device.fromJson(snapshot);

    return Optional.of(entity);
  }

  @override
  Future<Void> truncate() async {
    // Get connection
    final Database db = await getDbConnection();

    // Create query
    const String query = '''
    DELETE FROM Device;
    VACUUM;
    ''';

    // Prepare a statement to run it multiple times:
    final delete = db.prepare(query).execute();

    return delete;
  }

  @override
  Future<Integer> isEmpty() async {
    // Get connection
    final Database db = await getDbConnection();

    // Create query
    const String query = '''
    SELECT COUNT(*) FROM Device
    ''';

    // Get row inserted
    final ResultSet resultSet = db.prepare(query).select();

    // Exit if is empty
    if (resultSet.isEmpty) {
      return 0;
    }

    // Get data
    final Row snapshot = resultSet[0];

    final Integer result = snapshot['COUNT(*)'];

    return result;
  }

  @override
  Future<Optional<Device>> findDefaultDevice(GetDevice select) async {
    // Get connection
    final Database db = await getDbConnection();

    // Create query
    const String query = '''
    SELECT * FROM Device w
      WHERE w.name = ? AND w.code = ? AND w.isActive = 1
    ''';

    // Get row inserted
    final ResultSet resultSet =
        db.prepare(query).select([select.name, select.code]);

    if (resultSet.isEmpty) {
      return const Optional.empty();
    }

    // Get data
    final Row snapshot = resultSet[0];

    final Device entity = Device.fromJson(snapshot);

    return Optional.of(entity);
  }
}
