import 'package:employee_managemnet/data/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../bloc/employee_cubic.dart';
import '../model/employee.dart';
import 'employee_add_edit_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown, // Ensures text resizes within the AppBar
          child: Text(
            "Employee List",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: ColorManager.whiteColor,
              fontSize: MediaQuery.of(context).size.width > 600 ? 13.sp : 18.sp, // Ensure this is responsive
            ),
          ),
        ),
        backgroundColor: ColorManager.blutColor,
      ),

      body:
      BlocBuilder<EmployeeCubit, List<Employee>>(
        builder: (context, employees) {
          if (employees.isEmpty) {
            return Center(

              child: Image.asset(
                "assest/images/nodataimage.png",
                width: 200.w,
              ),
            );
          }

          // Separate current and previous employees
          List<Employee> currentEmployees =
          employees.where((emp) => emp.isCurrent).toList();
          List<Employee> previousEmployees =
          employees.where((emp) => !emp.isCurrent).toList();

          return Column(
            children: [
              Expanded(

                child: ListView(
                  children: [
                    if (currentEmployees.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                        child: Text(
                          "Current Employees",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,

                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey.withOpacity(0.3), thickness: 0.5),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: currentEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = currentEmployees[index];
                            return _buildDismissibleItem(context, employee,index);
                          },
                        ),
                      ),
                    ],

                    if (previousEmployees.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                        child: Text(
                          "Previous Employees",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey.withOpacity(0.3), thickness: 0.5),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: previousEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = previousEmployees[index];
                            return _buildDismissibleItem(context, employee,index);
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            ],
          );
        },
      ),
      floatingActionButton: Container(
        //padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // Adjust padding as needed
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r), // Rounded corners
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min, // To fit content tightly
          children: [
            //SizedBox(width: 2.w), // Space between text and button

            Padding(
              padding:  EdgeInsets.only(left: 26.w),
              child: Text(
                  "Swipe left to delete",
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorManager.swipeColor,
                  )
              ),
            ),
            //SizedBox(width: 10.w), // Space between text and button
            Padding(
              padding:  EdgeInsets.only(right: 14.w),
              child: FloatingActionButton(
                backgroundColor: ColorManager.blutColor, // Blue button
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeFormScreen()),
                  );
                },
                child: Icon(Icons.add, color: ColorManager.whiteColor),
              ),
            ),
          ],
        ),
      ),




    );
  }





  Widget _buildDismissibleItem(BuildContext context, Employee employee, int index) {
    return Dismissible(
      key: Key(employee.name),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: Colors.red,
        child: Image.asset("assest/images/deleteIcon.png"),
      ),
      onDismissed: (direction) {
        final employeeCubit = context.read<EmployeeCubit>();
        final deletedEmployee = employeeCubit.state[index]; // Store deleted employee

        // Remove employee
        employeeCubit.deleteEmployee(index);

        // Show snackbar with "Undo" option
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Employee data has been deleted"),
            action: SnackBarAction(
              label: "Undo",
              textColor: Colors.blue,
              onPressed: () {
                employeeCubit.addEmployee(deletedEmployee);
              },
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeFormScreen(employee: employee, index: index),
            ),
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          title: Text(
            employee.name,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.textColorMaiOne,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.role,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: ColorManager.textColorOne,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                employee.endDate == null
                    ? "From ${_formatDate(employee.startDate)}"
                    : "${_formatDate(employee.startDate)} - ${_formatDate(employee.endDate!)}",
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: ColorManager.textColorOne,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("d MMM yyyy").format(date);
  }


   showCustomSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Employee data has been deleted",
          style: GoogleFonts.roboto(fontSize: 14.sp,
            color: ColorManager.whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.black87, // Dark background color
        behavior: SnackBarBehavior.fixed, // Sticks to the bottom
        action: SnackBarAction(
          label: "Undo",
          textColor: ColorManager.blutColor, // Blue "Undo" button
          onPressed: () {
            // Undo action logic here
          },
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }



}
