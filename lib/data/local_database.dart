/*
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
part 'local_database.g.dart';

@DataClassName("Employee")
class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get role => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
}

@DriftDatabase(tables: [Employees])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Employee>> getAllEmployees() => select(employees).get();

  Future<int> insertEmployee(EmployeesCompanion employee) =>
      into(employees).insert(employee);

  Future<int> updateEmployee(Employee employee) async {
    return await (update(employees)..where((t) => t.id.equals(employee.id)))
        .write(EmployeesCompanion(
      name: Value(employee.name),
      role: Value(employee.role),
      startDate: Value(employee.startDate),
      endDate: employee.endDate != null ? Value(employee.endDate!) : const Value.absent(),
    ));
  }

  Future<int> deleteEmployee(int id) =>
      (delete(employees)..where((e) => e.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'employees.sqlite'));
    return NativeDatabase(file);
  });
}
*/
