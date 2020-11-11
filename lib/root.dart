import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifytest/blocs/auth/auth_bloc.dart';
import 'package:notifytest/blocs/auth/auth_states.dart';
import 'package:notifytest/blocs/home/home_bloc.dart';
import 'package:notifytest/blocs/home/home_events.dart';
import 'package:notifytest/blocs/login/login_bloc.dart';
import 'package:notifytest/repositories/message_repos.dart';
import 'package:notifytest/repositories/user_repos.dart';
import 'package:notifytest/screens/home.dart';
import 'package:notifytest/screens/login.dart';

class Root extends StatefulWidget {

  final UserRepository userRepository;

  Root({Key key, this.userRepository}) : super(key:key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return BlocProvider<HomeBloc>(
            builder: (context) {
              return HomeBloc(messageRepository: MessageRepository())
                      ..dispatch(HomeStarted());
            },
            child: HomeScreen(),
          );
        }

        if (state is AuthenticationUnauthenticated) {
          return BlocProvider<LoginBloc>(
            builder: (context) {
              return LoginBloc(
                authBloc: BlocProvider.of<AuthBloc>(context),
                userRepository: widget.userRepository,
              );
            },
            child: LoginScreen(),
          );
        }
        
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}