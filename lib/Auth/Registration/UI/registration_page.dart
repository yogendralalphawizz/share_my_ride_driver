import 'package:flutter/material.dart';
import '../../login_navigator.dart';
import 'registration_interactor.dart';
import 'registration_ui.dart';

class RegisterPage extends StatelessWidget {


  RegisterPage();
  @override
  Widget build(BuildContext context) {
    return RegistrationBody();
  }
}

class RegistrationBody extends StatefulWidget {




  @override
  _RegistrationBodyState createState() => _RegistrationBodyState();
}

class _RegistrationBodyState extends State<RegistrationBody>
    implements RegistrationInteractor {
  @override
  Widget build(BuildContext context) {
    return RegistrationUI("");
  }

  @override
  void register(String name, String email) {
    Navigator.pushNamed(context, LoginRoutes.verification);
  }
}
