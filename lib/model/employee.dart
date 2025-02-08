import 'package:hive/hive.dart';

part 'employee.g.dart'; // Required for Hive adapter generation

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  String name;

  @HiveField(1)
  String role;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime? endDate;

  Employee({
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });

  /// Determines if the employee is currently working
  @HiveField(4) // Adding a new Hive field, remember to regenerate the adapter
  bool get isCurrent => endDate == null || endDate!.isAfter(DateTime.now());
}
