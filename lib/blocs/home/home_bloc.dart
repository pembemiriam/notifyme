import 'package:bloc/bloc.dart';
import 'package:notifytest/blocs/auth/auth_bloc.dart';
import 'package:notifytest/blocs/auth/auth_events.dart';
import 'package:notifytest/blocs/home/home_events.dart';
import 'package:notifytest/blocs/home/home_states.dart';
import 'package:notifytest/data/models/message.dart';
import 'package:notifytest/repositories/message_repos.dart';
import 'package:notifytest/repositories/user_repos.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MessageRepository messageRepository;
  final BaseUserRepository userRepository;
  final AuthBloc authBloc;


  HomeBloc({this.messageRepository, this.userRepository, this.authBloc}) : assert
  (messageRepository != null);

  @override
  HomeState get initialState => HomeLoading();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is SendMessagePressed) {
      yield HomeLoading();
      try {
        bool result = await messageRepository.sendMessage(
          message: event.message,
        );

        if (result) {
          yield SendMessageSuccess();
          
        } else {
          yield Failure(error: 'Send message Failed');
        }
        
      } catch (error) {
        yield Failure(error: error.toString());
      }
    }

    if (event is HomeStarted) {
      yield HomeLoading();
      try {
        List<Message> result = await messageRepository.loadAllMessages();
        yield HomeLoaded(lstMessages: result);
        
      } catch (error) {
        yield Failure(error: error.toString());
      }
    }

    if (event is LogoutButtonPressed) {
      yield LogoutLoading();
      try {
        final user = await userRepository.logout();

        if (user == true) {
          authBloc.dispatch(LoggedOut());
        } else {
          yield LogoutFailure(error: 'Logout Failed');
        }

      } catch (error) {
        yield LogoutFailure(error: error.toString());
      }
    }

  }
  
}