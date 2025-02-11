import 'package:employee_managemnet/screen/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bloc/employee_cubic.dart';
import 'model/employee.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  await Hive.openBox<Employee>('employees');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeCubit(),

        child:  ScreenUtilInit(
        builder: (context, child) {
      return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee List',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: EmployeeListScreen(),
      );
    },
    ),

    );
  }
}
