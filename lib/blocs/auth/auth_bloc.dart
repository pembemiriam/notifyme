

import 'package:bloc/bloc.dart';
import 'package:notifytest/blocs/auth/auth_events.dart';
import 'package:notifytest/blocs/auth/auth_states.dart';
import 'package:notifytest/repositories/user_repos.dart';
import 'package:meta/meta.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final BaseUserRepository userRepository;

  AuthBloc({@required this.userRepository}) : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      var user = await userRepository.currentUser();
      if (user != null) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationUnauthenticated();
    }
  }

}