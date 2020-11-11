import 'package:bloc/bloc.dart';
import 'package:notifytest/blocs/auth/auth_bloc.dart';
import 'package:notifytest/blocs/auth/auth_events.dart';
import 'package:notifytest/blocs/login/login_events.dart';
import 'package:notifytest/blocs/login/login_states.dart';
import 'package:notifytest/repositories/user_repos.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final BaseUserRepository userRepository;
  final AuthBloc authBloc;

  LoginBloc({this.userRepository, this.authBloc}) : assert(userRepository != null), assert(authBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final user = await userRepository.authenticate(
          username: event.username,
          email: event.email,
          password: event.password,
        );

        if (user != null) {
          authBloc.dispatch(LoggedIn(user: user));
        } else {
          yield LoginFailure(error: 'Login Failed');
        }
        
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
  
}