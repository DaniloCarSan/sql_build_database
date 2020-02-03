# sql_build_database

A new Flutter package to create a database structure simply and quickly.


# Example use  

Add  depencencies
      
````
  dependencies:
    sql_build_database:^1.0.4
````

## SBDColumnDataType

  - **INTEGER** 
  - **TEXT** 
  - **REAL** 
  - **BLOB** 
````
enum SBDColumnDataType {INTEGER,TEXT,REAL,BLOB}

````

## SBDColum
  - **name**
  - **type**
  - **isUnique**
  - **isNoNull**
  - **defaultValue**
  - **isPrimaryKey**
  - **isAutoIncrement**
  - **foreignKey**

````
SBDColumn(   
  name: 'COLUMN_NAME',
  type: SBDColumnDataType.INTEGER,
  isUnique:true,
  isNotNull:true,
  defaultValue:1,
  isPrimaryKey:true,
  isAutoIncrement:true,
  foreignKey:['table1','COLUM_NAME']
);
````
## SBDTable
  - **name**
  - **primaryKeyName**
  - **columns**
````
 SBDTable(
    name: 'users',
    primaryKeyName: 'USER_CODE',
    columns: [
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
 )
````
## print(tb.build());
````
CREATE TABLE users (USER_CODE INTEGER PRIMARY KEY AUTOINCREMENT,USER_NAME TEXT NOT NULL,USER_EMAIL TEXT NOT NULL UNIQUE,USER_ACTIVE INTEGER NOT NULL DEFAULT 1);

INSERT INTO users(USER_CODE,USER_NAME,USER_EMAIL,USER_ACTIVE)VALUES('1','Danilo Dos Satos Carreiro','danilocarsan@gmail.com','1');
````

## print(tb.initialInserts())
`````
[
  INSERT INTO users(USER_CODE,USER_NAME,USER_EMAIL,USER_ACTIVE)VALUES('1','Danilo Dos Satos Carreiro','danilocarsan@gmail.com','1');
]
`````

#SBD
````
   SBD([
     SBDTable(
       name: 'users',
       primaryKeyName: 'USER_CODE',
       columns: [
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
       ]
     ),
     SBDTable(
      name: 'logs',
      primaryKeyName: 'LOG_CODE',
      columns: [
        SBDColumn(
          name: 'MESSAGE',
          type: SBDColumnDataType.TEXT,
          isNotNull: true,
        ),
        SBDColumn(
           name: 'LOG_USER_CODE',
           isNotNull: true,
           foreignKey: ['users', 'USER_CODE']
        )
      ]
     )
   ]);
````
# print(db.build());

````
CREATE TABLE users (
   USER_CODE INTEGER PRIMARY KEY AUTOINCREMENT,
   USER_NAME TEXT NOT NULL,
   USER_EMAIL TEXT NOT NULL UNIQUE,
   USER_ACTIVE INTEGER NOT NULL DEFAULT 1
 );
 
 CREATE TABLE logs (
   LOG_CODE INTEGER PRIMARY KEY AUTOINCREMENT,
   MESSAGE TEXT NOT NULL,
   LOG_USER_CODE TEXT NOT NULL REFERENCES users(USER_CODE),
   FOREIGN KEY (LOG_USER_CODE) REFERENCES users (USER_CODE)
 );
````
## Getting Started

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
