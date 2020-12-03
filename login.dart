import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../providers/auth.dart';
import '../../../utils/shared/custom_textformfield.dart';
import '../../../utils/shared/rounded_raisedbutton.dart';
import '../../../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _loginFormKey = GlobalKey();
  String userEmail, password, errMsg;
  bool _isLoading = false;
  bool _hidePassword = true;

  Future<void> login(BuildContext context) async {
    if (!_loginFormKey.currentState.validate()) {
      return;
    }
    _loginFormKey.currentState.save();
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      errMsg = null;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .signIn(userEmail, password);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil(kDashboard, (route) => false);
    } catch (error) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Theme.of(context).accentColor,
            content: Text(
              "$error",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )),
      );
      setState(() {
        errMsg = error.toString();
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          labelText: "Enter Email",
                          icon: Icon(Icons.email_outlined),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email can't be empty";
                            }
                          },
                          onSaved: (value) {
                            userEmail = value;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          labelText: "Enter Password",
                          icon: _hidePassword
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          iconPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          obscureText: _hidePassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password can't be empty";
                            }
                          },
                          onSaved: (value) {
                            password = value;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        errMsg != null
                            ? Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  "${errMsg}",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(),
                        Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(kForgotPassword);
                            },
                            child: Text("Forgot Password?"),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Don't have an account?"),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed(kSignupScreen);
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                )
                              ],
                            ),
                            RoundedRaisedButton(
                              isLoading: _isLoading,
                              title: "Sign In",
                              onPress: () async {
                                await login(context);
                                // Navigator.of(context).pushNamed(kDashboard);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
