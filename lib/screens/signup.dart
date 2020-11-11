import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifytest/blocs/home/home_bloc.dart';
import 'package:notifytest/blocs/home/home_events.dart';
import 'package:notifytest/blocs/signup/signup_bloc.dart';
import 'package:notifytest/blocs/signup/signup_events.dart';
import 'package:notifytest/blocs/signup/signup_states.dart';
import 'package:notifytest/data/validators/email_validator.dart';
import 'package:notifytest/data/validators/name_validator.dart';
import 'package:notifytest/data/validators/password_validator.dart';
import 'package:notifytest/widgets/button_widget.dart';
import 'package:flutter/material.dart';


const String MIN_DATETIME = '1970-01-01';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isShowPwd = false;
  String _email, _password, _username;
  SignupBloc _signupBloc;
  HomeBloc _homeBloc;



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _signupBloc = BlocProvider.of<SignupBloc>(context);

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        bloc: _signupBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: null,
            body: Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextFormField(
                            key: Key('Username'),
                            validator: NameFieldValidator.validate,
                            onSaved: (value) => _username = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Username',
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 13)),
                          ),
                        ),

                      SizedBox(
                        height: 20,
                      ),
                      Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextFormField(
                          key: Key('Email'),
                          validator: EmailFieldValidator.validate,
                          onSaved: (value) => _email = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius:
                                BorderRadius.all(Radius.circular(30)),
                                child: Icon(
                                  Icons.email,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                          ),
                        ),

                      SizedBox(
                        height: 20,
                      ),
                      Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 8,
                              child: TextFormField(
                                key: Key('Password'),
                                validator: PasswordFieldValidator.validate,
                                onSaved: (value) => _password = value,
                                obscureText: (_isShowPwd) ? false : true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Your Password',
                                    prefixIcon: Material(
                                      elevation: 0,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 13)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 30,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  border: Border.all(color: Color(0xFFF5F5F5)),
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isShowPwd = !_isShowPwd;
                                      });
                                    },
                                    child: Text(
                                      'SHOW',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF003BFF),
                                      ),
                                    ),
                                  ), 
                                ),
                              ), 
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ButtonWidget(
                        onPressed: _handleSignup, 
                        title: 'SIGN UP',
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(context).textTheme.display1,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign in', 
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );  
  }

  bool _validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _handleSignup() {
    if (_validateAndSave()) {
      _signupBloc.dispatch(SignupButtonPressed(
        username: _username,
        email: _email,
        password: _password,
      ));
      _homeBloc.dispatch(SendMessagePressed(message:"I have signed up"));

    }
  }
}