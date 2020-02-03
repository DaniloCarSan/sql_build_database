// import 'package:sql_build_database/sql_build_database.dart';

import '../lib/sql_build_database.dart';

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
    ],
    initialInserts: [
        {'USER_CODE':1,'USER_NAME':'Danilo Dos Satos Carreiro','USER_EMAIL':'danilocarsan@gmail.com','USER_ACTIVE':1},
    ],
    execInitialInserts: true
    ),
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
