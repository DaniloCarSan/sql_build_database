import 'package:sql_build_database/sql_build_database.dart';

main() {
  var db = SBD([
    SBDTable(name: 'users', primaryKeyName: 'USER_CODE', columns: [
      SBDColumn(
        name: 'USER_NAME',
        type: SBDColumnDataType.TEXT,
        isNotNull: true,
      ),
      SBDColumn(
        name: 'USER_EMAIL',
        type: SBDColumnDataType.TEXT,
        isNotNull: true,
        isUnique: true,
      ),
      SBDColumn(
        name: 'USER_ACTIVE',
        type: SBDColumnDataType.INTEGER,
        isNotNull: true,
        defaultValue: 1,
      ),
    ]),
    SBDTable(name: 'logs', primaryKeyName: 'LOG_CODE', columns: [
      SBDColumn(
        name: 'MESSAGE',
        type: SBDColumnDataType.TEXT,
        isNotNull: true,
      ),
      SBDColumn(
          name: 'LOG_USER_CODE',
          isNotNull: true,
          foreignKey: ['users', 'USER_CODE'])
    ])
  ]);

  print(db.build());
}
