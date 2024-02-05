import 'package:flutter/material.dart';

import '../../../Routes/page_routes.dart';
import 'forgot_password_interactor.dart';


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> implements ForgotPasswordInteractor{
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void forgotPassword() {
    Navigator.pushNamed(context, PageRoutes.homePage);
  }

}
