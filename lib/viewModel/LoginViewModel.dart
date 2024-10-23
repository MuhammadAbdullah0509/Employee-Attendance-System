
 import 'package:flutter/cupertino.dart';

class LoginViewModel with ChangeNotifier{
  bool _loading = false;

  get loading=>_loading;

  setLoading(bool isTrue){
   _loading=isTrue;
   notifyListeners();
  }

  bool _isObscure=true;

  get isObscure=>_isObscure;

  setIsObscure(bool isTrue){
    _isObscure=isTrue;
    notifyListeners();
  }

}