library sql_build_database;

enum SBDColumnDataType { INTEGER, TEXT, REAL, BLOB }

class SBDColumn<T1> {
  final types = ['INTEGER', 'TEXT', 'REAL', 'BLOB'];
  String name;
  final SBDColumnDataType type;
  final bool isUnique;
  final bool isNotNull;
  final T1 defaultValue;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final List<String> foreignKey;

  SBDColumn({
    this.name,
    this.type = SBDColumnDataType.TEXT,
    this.isPrimaryKey = false,
    this.isUnique = false,
    this.isNotNull = false,
    this.defaultValue,
    this.isAutoIncrement = false,
    this.foreignKey,
  });

  String get getType => types[this.type.index];

  void setName(String name) {
    this.name = name;
  }

  build() {
    List<String> column = [];

    column.add(name);

    column.add(types[type.index]);

    if (isPrimaryKey) {
      column.add('PRIMARY KEY');
    } else {
      column.add(isNotNull ? 'NOT NULL' : 'NULL');
    }

    if (isUnique) {
      column.add('UNIQUE');
    }

    if (isAutoIncrement) {
      column.add('AUTOINCREMENT');
    }

    if (defaultValue != null) {
      column.add('DEFAULT $defaultValue');
    }

    if (foreignKey != null) {
      column.add("REFERENCES " + foreignKey[0] + '(' + foreignKey[1] + ')');
    }

    return column.join(' ');
  }
}

class SBDTable {
  final String name;

  final String primaryKeyName;

  final SBDColumn primaryKey = SBDColumn<int>(
    name: 'primaryKey',
    type: SBDColumnDataType.INTEGER,
    isPrimaryKey: true,
    isNotNull: false,
    isAutoIncrement: true,
    isUnique: false,
  );

  final List<SBDColumn> columns;

  SBDTable({this.name, this.primaryKeyName, this.columns});

  List<String> columnsFields() {
    List<String> columnsFields = [];
    List<String> foreignKeys = [];

    if (this.primaryKeyName != null) {
      this.primaryKey.setName(this.primaryKeyName);
    }

    columnsFields.add(this.primaryKey.build());

    this.columns.forEach((column) {
      columnsFields.add(column.build());

      if (column.foreignKey != null) {
        foreignKeys.add("FOREIGN KEY (${column.name}) REFERENCES " +
            column.foreignKey[0] +
            " (" +
            column.foreignKey[1] +
            ")");
      }
    });

    foreignKeys.forEach((v) => columnsFields.add(v));

    return columnsFields;
  }

  build() {
    String table = "CREATE TABLE $name (";

    table += this.columnsFields().join(',');

    table += ");";

    return table;
  }
}

class SBD {
  final List<SBDTable> tables;

  SBD(this.tables);

  build() {
    List<String> sqls = [];

    this.tables.forEach((table) {
      sqls.add(table.build());
    });

    return sqls.join('');
  }
}
