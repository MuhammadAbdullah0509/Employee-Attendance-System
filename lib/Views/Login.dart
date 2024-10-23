import 'dart:convert';

import 'package:attendance_system/Models/ProfileInfo.dart';
import 'package:attendance_system/Views/Admin/AdminDashBoard.dart';
import 'package:attendance_system/Views/Employee/EmployeeDashBoard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Components/CustomButton.dart';
import '../Resources/CustomColor.dart';
import '../Resources/CustomSize.dart';
import '../Services/ApiHandler.dart';
import '../Utilis/FlushBar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Utilis/Routes/RouteName.dart';
import '../viewModel/LoginViewModel.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController _userName = TextEditingController();

  final TextEditingController _password = TextEditingController();

  FocusNode username = FocusNode();

  FocusNode password = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColor().customGreyColor(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: CustomSize().customHeight(context) / 100,
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  height: CustomSize().customHeight(context) / 1.8,
                  width: CustomSize().customWidth(context) / 1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        CustomSize().customHeight(context) / 70),
                    color: CustomColor().customWhiteColor(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                        CustomSize().customHeight(context) / 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          focusNode: username,
                          onFieldSubmitted: (e) {
                            FocusScope.of(context).requestFocus(password);
                          },
                          controller: _userName,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            icon: Icon(Icons.person),
                            labelText: 'UserName',
                            hintText: 'UserName',
                          ),
                        ),
                        SizedBox(
                          height: CustomSize().customHeight(context) / 100,
                        ),
                        Consumer<LoginViewModel>(
                          builder: (context, value, child) {
                            return TextFormField(
                              controller: _password,
                              focusNode: password,
                              onFieldSubmitted: (e) {
                                FocusScope.of(context).unfocus();
                              },
                              obscureText: value.isObscure,
                              decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  labelText: 'Password',
                                  hintText: 'Password',
                                  icon: const Icon(Icons.password),
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        value.setIsObscure(!value.isObscure);
                                      },
                                      child: value.isObscure
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility))),
                            );
                          },
                        ),
                        SizedBox(
                          height: CustomSize().customHeight(context) / 100,
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                              CustomSize().customHeight(context) / 100),
                          child: Consumer<LoginViewModel>(
                            builder: (BuildContext context,
                                LoginViewModel value, Widget? child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    title: 'Login',
                                    loading: value.loading,
                                    onTap: () async {
                                        value.setLoading(true);
                                        Response res = await ApiHandler().login(
                                            _userName.text, _password.text);
                                        if (res.statusCode == 200 &&
                                            context.mounted) {
                                          dynamic obj =
                                          jsonDecode(res.body.toString());
                                          if (int.parse(
                                              obj[0]["role"].toString()) ==
                                              1) {
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return AdminDashBoard(
                                                      image: obj[0]['profile_image'],
                                                      name: obj[0]['name'],
                                                      nic: obj[0]['nic'],
                                                      pId: obj[0]['profile_id']
                                                          .toString(),
                                                      email: obj[0]['email'],
                                                    );
                                                  },
                                                ));
                                          } else if (int.parse(
                                              obj[0]["role"].toString()) ==
                                              2) {
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return EmployeeDashBoard(
                                                      image: obj[0]['profile_image'],
                                                      name: obj[0]['name'],
                                                      nic: obj[0]['nic'],
                                                      pId: obj[0]['profile_id']
                                                          .toString(),
                                                      email: obj[0]['email'],
                                                    );
                                                  },
                                                ));
                                          }
                                          value.setLoading(false);
                                        } else if (res.statusCode == 404) {
                                          if (context.mounted) {
                                            Utilis.flushBarMessage(
                                                'Invalid Credentials', context);
                                          }
                                          value.setLoading(false);
                                        } else {
                                          if (context.mounted) {
                                            Utilis.flushBarMessage(
                                                'Server not responding', context);
                                          }
                                          value.setLoading(false);
                                        }
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                              CustomSize().customHeight(context) / 100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '''don't have an account''',
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) /
                                            60),
                              ),
                              SizedBox(
                                width: CustomSize().customWidth(context) / 100,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteName.signUp);
                                },
                                child: Text(
                                  'Signup!',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize:
                                          CustomSize().customHeight(context) /
                                              50),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
