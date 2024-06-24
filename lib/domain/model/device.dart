import 'package:dart_gemini_example/domain/config/enums.dart';
import 'package:dart_gemini_example/domain/config/sqlite3_helper.dart';
import 'package:dart_gemini_example/domain/config/type_helper.dart';

class Device extends BaseDocument {
  String deviceID;
  Boolean isActive;
  DateTime created;
  DateTime updated;
  String name;
  String code;
  DeviceStatus status;

  String? passKeyID;

  Device(this.deviceID, this.isActive, this.created, this.updated, this.name,
      this.code, this.status, this.passKeyID);

  Device.fromJson(Map<String, dynamic> json)
      : deviceID = json['deviceID'],
        isActive = Sqlite3Helper.sqliteToBoolean(json['isActive']),
        created = Sqlite3Helper.sqliteToDate(json['created']),
        updated = Sqlite3Helper.sqliteToDate(json['updated']),
        name = json['name'],
        code = json['code'],
        status = DeviceStatus.values
            .byName((json['status'] as String).toLowerCase()),
        passKeyID = json['passKeyID'];

  @override
  List toListSave() {
    return [
      deviceID,
      Sqlite3Helper.booleanToSqlite(isActive),
      Sqlite3Helper.dateToSqlite(created),
      Sqlite3Helper.dateToSqlite(updated),
      name,
      code,
      status.name.toUpperCase(),
      passKeyID,
    ];
  }

  @override
  List toListUpdate() {
    return [
      Sqlite3Helper.booleanToSqlite(isActive),
      Sqlite3Helper.dateToSqlite(created),
      Sqlite3Helper.dateToSqlite(updated),
      name,
      code,
      status.name.toUpperCase(),
      passKeyID,
      deviceID
    ];
  }

  @override
  String toString() {
    return 'Device{'
        'deviceID: $deviceID, '
        'isActive: $isActive, '
        'created: $created, '
        'updated: $updated, '
        'name: $name, '
        'code: $code, '
        'status: $status, '
        'passKeyID: $passKeyID}';
  }
}
