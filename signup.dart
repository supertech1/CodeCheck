import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth.dart';
import '../../../utils/shared/custom_textformfield.dart';
import '../../../utils/shared/rounded_raisedbutton.dart';
import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  String selectedUser;
  SignUpScreen({this.selectedUser = "user"});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _signupFormKey = GlobalKey();
  TextEditingController _passwordController = TextEditingController();
  String _fullName, _email, _phoneNumber, _password;
  String _selectedUser;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _termsAndCondition = false;
  bool _isLoading = false;

  Future<void> signup(BuildContext context) async {
    if (!_signupFormKey.currentState.validate()) {
      return;
    } else if (_termsAndCondition == false) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Theme.of(context).accentColor,
            content: Text(
              "Agree to the terms and conditions to continue",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )),
      );
      return;
    }
    _signupFormKey.currentState.save();

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .signUp(_fullName, _phoneNumber, _email, _password);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Success",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text("Your account has been successfully created."),
              actions: [
                FlatButton(
                  child: Text("Proceed to Login",
                      style: TextStyle(color: Colors.white)),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(kLoginScreen);
                  },
                ),
              ],
            );
          });
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text("$error"),
              actions: [
                FlatButton(
                  child: Text("OK", style: TextStyle(color: Colors.white)),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _selectedUser = widget.selectedUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Text(
                  //   "As a User or as an Author",
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Expanded(
                  //         child: RadioListTile(
                  //           controlAffinity: ListTileControlAffinity.trailing,
                  //           // contentPadding: EdgeInsets.all(0),
                  //           activeColor: kBlackColor,
                  //           value: "user",
                  //           groupValue: _selectedUser,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               _selectedUser = value;
                  //             });
                  //           },
                  //           title: Text(
                  //             "User",
                  //             style: TextStyle(
                  //               fontSize: 18,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: RadioListTile(
                  //           controlAffinity: ListTileControlAffinity.trailing,
                  //           // contentPadding: EdgeInsets.all(0),
                  //           activeColor: kBlackColor,
                  //           groupValue: _selectedUser,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               _selectedUser = value;
                  //             });
                  //           },
                  //           value: "author",
                  //           title: Text(
                  //             "Author",
                  //             style: TextStyle(
                  //               fontSize: 18,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  Form(
                    key: _signupFormKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          labelText: "Enter Full Name",
                          icon: Icon(Icons.person_outline),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Full name is required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _fullName = value;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          labelText: "Enter Email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email is required";
                            } else if (!value.contains("@") ||
                                !value.contains(".")) {
                              return "Enter a valid email address";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _email = value;
                          },
                          icon: Icon(Icons.email_outlined),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          labelText: "Enter Phone Number",
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Phone number is required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _phoneNumber = value;
                          },
                          icon: Icon(Icons.phone),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password can't be empty";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value;
                          },
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
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          labelText: "Confirm Password",
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return "Password does not match";
                            }
                            return null;
                          },
                          icon: _hideConfirmPassword
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          iconPressed: () {
                            setState(() {
                              _hideConfirmPassword = !_hideConfirmPassword;
                            });
                          },
                          obscureText: _hideConfirmPassword,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: CheckboxListTile(
                            title: Row(
                              children: [
                                Text(
                                  "I Agree with the ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Terms & Conditions",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).accentColor,
                                  ),
                                )
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _termsAndCondition,
                            onChanged: (value) {
                              setState(() {
                                _termsAndCondition = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Already have an account?"),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed(kLoginScreen);
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                )
                              ],
                            ),
                            RoundedRaisedButton(
                              isLoading: _isLoading,
                              title: "Sign Up",
                              onPress: () async {
                                await signup(context);
                                // Navigator.of(context)
                                //     .pushNamed(kTermsAndConditionsScreen);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
