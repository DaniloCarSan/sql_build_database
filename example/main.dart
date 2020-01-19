import 'package:sql_build_database/sql_build_database.dart';

main() {
  var db = SBD([
    SBDTable(name: 'users', primaryKeyName: 'USER_CODE', columns: [
      SBDColumn(
        name: 'USER_NAME',
        type: SBDColumDataType.TEXT,
        isNotNull: true,
      ),
      SBDColumn(
        name: 'USER_EMAIL',
        type: SBDColumDataType.TEXT,
        isNotNull: true,
        isUnique: true,
      ),
      SBDColumn(
        name: 'USER_ACTIVE',
        type: SBDColumDataType.INTEGER,
        isNotNull: true,
        defaultValue: 1,
      ),
    ]),
    SBDTable(name: 'logs', primaryKeyName: 'LOG_CODE', columns: [
      SBDColumn(
        name: 'MESSAGE',
        type: SBDColumDataType.TEXT,
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
