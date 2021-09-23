library sql_build_database;

enum SBDColumnDataType { INTEGER, TEXT, REAL, BLOB }

class SBDColumn<T1> {
  final types = ['INTEGER', 'TEXT', 'REAL', 'BLOB'];
  String name;
  final SBDColumnDataType type;
  final bool isUnique;
  final bool isNotNull;
  final T1? defaultValue;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final List<String>? foreignKey;

  SBDColumn({
    required this.name,
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

    if (foreignKey != null)
    {
  
      column.add("REFERENCES " + (foreignKey?.elementAt(0)??'') + '(' + ( foreignKey?.elementAt(1)??'' ) + ')');
    }

    return column.join(' ');
  }
}

class SBDTable {
  final String name;

  final String primaryKeyName;

  final List<Map<String, dynamic>>? initialInserts;

  final execInitialInserts;

  final SBDColumn primaryKey = SBDColumn<int>(
    name: 'primaryKey',
    type: SBDColumnDataType.INTEGER,
    isPrimaryKey: true,
    isNotNull: false,
    isAutoIncrement: true,
    isUnique: false,
  );

  final List<SBDColumn>? columns;

  SBDTable(
      { required this.name,
      required this.primaryKeyName,
      this.columns,
      this.initialInserts,
      this.execInitialInserts = true});

  List<String> columnsFields() {
    List<String> columnsFields = [];
    List<String> foreignKeys = [];

    this.primaryKey.setName(this.primaryKeyName);
    
    columnsFields.add(this.primaryKey.build());

    this.columns?.forEach((column) {
      columnsFields.add(column.build());

      if (column.foreignKey != null) {
        foreignKeys.add("FOREIGN KEY (${column.name}) REFERENCES " +
            (column.foreignKey?.elementAt(0)??'') +
            " (" +
            (column.foreignKey?.elementAt(1)??'') +
            ")");
      }
    });

    foreignKeys.forEach((v) => columnsFields.add(v));

    return columnsFields;
  }

  String buildInsert(Map<String, dynamic> map) {
    return "INSERT INTO ${this.name}(" +
        map.keys.join(',') +
        ")VALUES('" +
        map.values.join("','") +
        "');";
  }

  List<String> buildInserts() {
    List<String> inserts = [];

    for (var map in initialInserts??[]) {
      inserts.add(this.buildInsert(map));
    }

    return inserts;
  }

  build() {
    String table = "CREATE TABLE $name (";

    table += this.columnsFields().join(',');

    table += ");";

    if (this.initialInserts != null) {
      if (this.execInitialInserts) {
        table += this.buildInserts().join('');
      }
    }

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
