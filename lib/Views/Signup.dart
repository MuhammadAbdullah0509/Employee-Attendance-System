
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../Components/CustomButton.dart';
import '../Resources/CustomColor.dart';
import '../Resources/CustomSize.dart';
import '../Services/ApiHandler.dart';
import 'package:image_picker/image_picker.dart';
import '../Utilis/FlushBar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Utilis/Routes/RouteName.dart';
import '../viewModel/LoginViewModel.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _nic = TextEditingController();

  final TextEditingController _name = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FocusNode email = FocusNode();

  FocusNode password = FocusNode();

  FocusNode nic = FocusNode();

  FocusNode name = FocusNode();

  File? pickedImage;

  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Future<void> getImage() async {
      XFile?  image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage = File(image.path);
        setState(() {});
      }
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: CustomColor().customGreyColor(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: CustomSize().customHeight(context) /11,
                ),
                Center(
                  child: Container(
                    height: CustomSize().customHeight(context) /1.2,
                    width: CustomSize().customWidth(context) /1.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(CustomSize().customHeight(context) /70),
                      color: CustomColor().customWhiteColor(),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(CustomSize().customHeight(context) /100),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: CustomSize().customHeight(context) / 20,
                            ),
                            GestureDetector(
                              onTap: (){
                                getImage();
                              },
                              child: CircleAvatar(
                                radius:CustomSize().customWidth(context)/10,
                                child:pickedImage!=null?Container(
                                  width: CustomSize().customWidth(context)/10,
                                  height: CustomSize().customHeight(context)/10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/10),
                                    image: DecorationImage(
                                        image:FileImage(pickedImage!.absolute),
                                      filterQuality: FilterQuality.high,
                                      fit: BoxFit.fill
                                    )
                                  ),
                                ) :const Icon(Icons.person),
                              ),
                            ),
                            TextFormField(
                              validator: (String? val){
                                if(val!.isEmpty){
                                  return "Enter name";
                                }
                                return null;
                              },
                              focusNode: name,
                              onFieldSubmitted: (e) {
                                FocusScope.of(context).requestFocus(email);
                              },
                              controller: _name,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.person),
                                labelText: 'Name',
                                hintText: 'Name',
                              ),
                            ),
                            SizedBox(
                              height: CustomSize().customHeight(context) / 100,
                            ),
                            TextFormField(
                              validator: (String? val){
                                if(val!.isEmpty){
                                  return "Enter email";
                                }
                                return null;
                              },
                              focusNode: email,
                              onFieldSubmitted: (e) {
                                FocusScope.of(context).requestFocus(password);
                              },
                              controller: _email,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.person),
                                labelText: 'email',
                                hintText: 'email',
                              ),
                            ),
                            SizedBox(
                              height: CustomSize().customHeight(context) / 100,
                            ),
                            Consumer<LoginViewModel>(
                              builder: (context, value, child) {
                                return TextFormField(
                                  validator: (String? val){
                                    if(val!.isEmpty){
                                      return "Enter password";
                                    }
                                    return null;
                                  },
                                  controller: _password,
                                  focusNode: password,
                                  onFieldSubmitted: (e) {
                                    FocusScope.of(context).requestFocus(nic);
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
                              height: CustomSize().customHeight(context) /100,
                            ),
                            TextFormField(
                              validator: (String? val){
                                if(val!.isEmpty){
                                  return "Enter nic";
                                }
                                return null;
                              },
                              focusNode: nic,
                              onFieldSubmitted: (e) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _nic,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.person),
                                labelText: 'Cnic',
                                hintText: 'cnic',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(CustomSize().customHeight(context) /100),
                              child: Consumer<LoginViewModel>(
                                builder: (BuildContext context,
                                    LoginViewModel value, Widget? child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomButton(
                                        title: 'SignUp',
                                        loading: value.loading,
                                        onTap: () async{
                                          if(_formKey.currentState!.validate()){
                                            if(pickedImage != null)
                                            {
                                              value.setLoading(true);
                                              int code = await ApiHandler().createAccount(_name.text.toString(),_password.text.toString(),_email.text,pickedImage!.absolute,_nic.text);
                                              if(code==200 && context.mounted)
                                              {
                                                Navigator.pushReplacementNamed(context, RouteName.login);
                                                value.setLoading(false);
                                              }else if(context.mounted)
                                              {
                                                Navigator.pushReplacementNamed(context, RouteName.signUp);
                                                Utilis.flushBarMessage('Try again later', context);
                                                value.setLoading(false);
                                              }
                                            }
                                            }else
                                            {
                                              Utilis.flushBarMessage("Select picture", context);
                                            }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(CustomSize().customHeight(context) /100),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('''Already have an account''',style: TextStyle(fontSize: CustomSize().customHeight(context)/60),),
                                  SizedBox(
                                    width: CustomSize().customWidth(context) / 100,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RouteName.login);
                                    },
                                    child: Text(
                                      'Login!',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: CustomSize().customHeight(context) /50),
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
        ),
      ),
    );
  }
}

