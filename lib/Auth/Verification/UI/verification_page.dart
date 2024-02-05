import 'package:flutter/material.dart';
import '../../login_navigator.dart';
import 'verification_interactor.dart';


class VerificationPage extends StatefulWidget {
  String mobile,otp;

  VerificationPage(this.mobile, this.otp);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage>
    implements VerificationInteractor {
  @override
  Widget build(BuildContext context) {
   // return VerificationUI(this,widget.mobile,widget.otp);
    return const SizedBox();
  }

  @override
  void notReceived() {
    Navigator.pushNamed(context, LoginRoutes.bankDetails);
  }

  @override
  void verify() {
    Navigator.pushNamed(context, LoginRoutes.bankDetails);
  }
}
