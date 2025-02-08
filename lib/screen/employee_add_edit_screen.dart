/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employee_cubic.dart';
import '../model/employee.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;
  final int? index;

  EmployeeFormScreen({this.employee, this.index});

  @override
  _EmployeeFormScreenState createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name);
    _roleController = TextEditingController(text: widget.employee?.role);
    _startDate = widget.employee?.startDate;
    _endDate = widget.employee?.endDate;
  }

  void _pickDate(bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.employee == null ? "Add Employee" : "Edit Employee")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
              TextFormField(controller: _roleController, decoration: InputDecoration(labelText: "Role")),
              Row(
                children: [
                  TextButton(onPressed: () => _pickDate(true), child: Text("Start Date: ${_startDate ?? 'Select'}")),
                  TextButton(onPressed: () => _pickDate(false), child: Text("End Date: ${_endDate ?? 'Select'}")),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final employee = Employee(
                      name: _nameController.text,
                      role: _roleController.text,
                      startDate: _startDate ?? DateTime.now(),
                      endDate: _endDate,
                    );
                    if (widget.employee == null) {
                      context.read<EmployeeCubit>().addEmployee(employee);
                    } else {
                      context.read<EmployeeCubit>().updateEmployee(widget.index!, employee);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/employee_cubic.dart';
import '../data/color.dart';
import '../data/custome_date_picker.dart';
import '../model/employee.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;
  final int? index;

  const EmployeeFormScreen({super.key, this.employee, this.index});

  @override
  _EmployeeFormScreenState createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController= TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.employee?.name??"";
    _roleController.text =  widget.employee?.role??"";
    _startDate = widget.employee?.startDate;
    _endDate = widget.employee?.endDate;
    print("kkk   ${widget.index}");


  }






  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      appBar: AppBar(
          title: Text(
            widget.index==null?"Add Employee Details": "Edit Employee Details",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: ColorManager.whiteColor,
              fontSize: 18.sp,
            ),
          ),
          actions: [
            Padding(
              padding:  EdgeInsets.only(right: 10.w),
              child: GestureDetector(
                onTap: (){
                  context.read<EmployeeCubit>().deleteEmployee(context.read<EmployeeCubit>().state.indexOf(widget.employee!));
                  showCustomSnackBar(context);
                  Navigator.pop(context);
                },
                  child: Image.asset("assest/images/deleteIcon.png")),
            ),
          ],
          backgroundColor: ColorManager.blutColor,
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(

              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee Name Input
                  TextFormField(
                      readOnly: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) { // ✅ Correct Condition
                          return 'Please enter employee name';
                        }
                        return null; // ✅ No error when valid input
                      },
                      style: GoogleFonts.roboto(
                        color:ColorManager.textCOlor,
                          fontWeight: FontWeight.w400, fontSize: 13.sp),
                      controller: _nameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Image.asset(
                          "assest/images/person.png",
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: ColorManager.blutColor, width: 1)),
                        hintText: "Employee name",
                        hintStyle: GoogleFonts.roboto(
                            color: ColorManager.hintClor,
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: ColorManager.borderColor, width: 1)),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.red,
                          ),
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.red,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        errorStyle: GoogleFonts.ibmPlexSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorManager.red,
                        ),
                      )),

                  SizedBox(height: 16),

                  TextFormField(
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) { // ✅ Correct Condition
                          return 'Please select role';
                        }
                        return null; // ✅ No error when valid input
                      },
                      style: GoogleFonts.roboto(
                          color:ColorManager.textCOlor,
                          fontWeight: FontWeight.w400, fontSize: 13.sp),
                      controller: _roleController,
                      decoration: InputDecoration(
                        prefixIcon: Image.asset(
                          "assest/images/bag.png",
                        ),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            _showRoleSelectionSheet();
                          },
                          child: Image.asset(
                            "assest/images/dropdown.png",
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: ColorManager.borderColor, width: 1)),
                        hintText: "Select Role",
                        hintStyle: GoogleFonts.roboto(
                            color: ColorManager.hintClor,
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: Theme.of(context).splashColor, width: 1)),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.red,
                          ),
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.red,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        errorStyle: GoogleFonts.ibmPlexSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorManager.red,
                        ),
                      )),

                  // Role Dropdown
                  /* DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      //contentPadding: EdgeInsets.only(top: 20,bottom: 20),
                      labelText: "Select role",

                      prefixIcon: Image.asset("assest/images/bag.png",),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ["Manager", "Developer", "Designer", "Tester"]
                        .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                  ),*/
                  SizedBox(height: 16),

                  // Date Pickers
                  Row(
                    children: [
                      // Start Date

                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            print("_startDate    $_startDate");


                            showDialog(


                              context: context,
                              builder: (context) {
                                return CustomDatePickerDialog(
                                  comeFrom: "1",
                                  fromDateCome: _startDate,
                                  endDateCoem: _endDate,
                                  onDateSelected: (selectedDate) {
                                    setState(() {
                                      _startDate = selectedDate;
                                    });
                                  },
                                );
                              },
                            );
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              // labelText: "Start Date",
                              prefixIcon: Image.asset(
                                "assest/images/calender.png",
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: ColorManager.borderColor, width: 1)),
                              //hintText: "Td",
                              hintStyle: GoogleFonts.roboto(
                                  color: ColorManager.hintClor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).splashColor,
                                      width: 1)),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: ColorManager.red,
                                ),
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: ColorManager.red,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              errorStyle: GoogleFonts.ibmPlexSans(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorManager.red,
                              ),
                            ),
                            child: Text(
                              _startDate == null
                                  ? "Today"
                                  : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}",
                    style: GoogleFonts.roboto(
                                color:ColorManager.textCOlor,
                                fontWeight: FontWeight.w400, fontSize: 13.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: ColorManager.blutColor),
                      SizedBox(width: 8),
                      // End Date
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            if(_startDate!=null) {
                              showDialog(


                                context: context,
                                builder: (context) {
                                  return CustomDatePickerDialog(
                                    comeFrom: "2",
                                    fromDateCome: _startDate,
                                    endDateCoem: _endDate,
                                    onDateSelected: (selectedDate) {
                                      setState(() {
                                        _endDate = selectedDate;
                                      });
                                    },
                                  );
                                },
                              );
                            }else{

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please select start date first",
                                      style: GoogleFonts.roboto(fontSize: 14.sp,
                                        color: ColorManager.whiteColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    backgroundColor: Colors.black87, // Dark background color
                                    behavior: SnackBarBehavior.fixed, // Sticks to the bottom

                                    duration: Duration(seconds: 2),
                                  ),
                                );



                            }

                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              // labelText: "Start Date",
                              prefixIcon: Image.asset(
                                "assest/images/calender.png",
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: ColorManager.borderColor, width: 1)),
                              hintStyle: GoogleFonts.roboto(
                                  color: ColorManager.hintClor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).splashColor,
                                      width: 1)),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: ColorManager.red,
                                ),
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: ColorManager.red,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              errorStyle: GoogleFonts.ibmPlexSans(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorManager.red,
                              ),
                            ),
                            child: Text(
                              _endDate == null
                                  ? "No date"
                                  : "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}",
                              style: GoogleFonts.roboto(
                                  color:ColorManager.textCOlor,
                                  fontWeight: FontWeight.w400, fontSize: 13.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Buttons (Cancel & Save)

                ],
              ),
            ),
            Column(
              children: [
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Add your cancel functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.cancelButton, // Light blue background
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: ColorManager.blutColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16), // Space between buttons

                    // Save Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final employee = Employee(
                            name: _nameController.text,
                            role: _roleController.text,
                            startDate: _startDate ?? DateTime.now(),
                            endDate: _endDate,
                          );
                          if (widget.employee == null) {
                            context.read<EmployeeCubit>().addEmployee(employee);
                          } else {
                            context
                                .read<EmployeeCubit>()
                                .updateEmployee(widget.index!, employee);
                          }
                          Navigator.pop(context);
                        }
                        // Add your save functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.blutColor, // Blue background
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: ColorManager.whiteColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                )


              ],
            ),
          ],
        ),
      ),
    );
  }


  // List of roles
  final List<String> _roles = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner"
  ];

  void _showRoleSelectionSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return  Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _roles.length,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey, thickness: 0.5),
            itemBuilder: (context, index) {
              final role = _roles[index];
              return ListTile(
                title: Text(
                  role,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: ColorManager.textCOlor,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _roleController.text = role;
                  });
                  Navigator.pop(context); // Close the bottom sheet
                },
              );
            },
          ),
        );

      },
    );
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
