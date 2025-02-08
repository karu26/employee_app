import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../model/employee.dart';

class EmployeeCubit extends Cubit<List<Employee>> {
  final Box<Employee> _employeeBox = Hive.box<Employee>('employees');

  EmployeeCubit() : super([]) {
    loadEmployees();
  }

  void loadEmployees() {
    emit(_employeeBox.values.toList());
  }

  void addEmployee(Employee employee) {
    _employeeBox.add(employee);
    loadEmployees();
  }

  void updateEmployee(int index, Employee employee) {
    _employeeBox.putAt(index, employee);
    loadEmployees();
  }

  void deleteEmployee(int index) {
    _employeeBox.deleteAt(index);
    loadEmployees();
  }


}



