import 'package:bloc/bloc.dart';
import 'package:notifytest/blocs/home/home_events.dart';
import 'package:notifytest/blocs/home/home_states.dart';
import 'package:notifytest/data/models/message.dart';
import 'package:notifytest/repositories/message_repos.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MessageRepository messageRepository;

  HomeBloc({this.messageRepository}) : assert(messageRepository != null);

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

  }
  
}