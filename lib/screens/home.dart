import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifytest/blocs/home/home_bloc.dart';
import 'package:notifytest/blocs/home/home_events.dart';
import 'package:notifytest/blocs/home/home_states.dart';
import 'package:notifytest/data/models/message.dart';
import 'package:notifytest/data/validators/name_validator.dart';
import 'package:notifytest/repositories/user_repos.dart';
import 'package:notifytest/screens/login.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _message;
  HomeBloc _homeBloc;
  List<Message> lst;
  UserRepository userRepository;

  @override
  void initState() {
    lst = List<Message>();
    _handleLiveQuery();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    _homeBloc = BlocProvider.of<HomeBloc>(context);

    return BlocBuilder<HomeBloc, HomeState>(
      bloc: _homeBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: ListTile(
              trailing: FlatButton(
                  onPressed: () async{
                    Navigator.pop(context);
                    ParseUser user = await ParseUser.currentUser();
                    var result = await user.logout();
                    return result.success;
                  },
                  child: Text("Logout")),
            ),
            elevation: 0.5,
          ),
        );
      },
    );
  }

  void _handleLiveQuery() async {
    final LiveQuery liveQuery = LiveQuery(debug: true);
    QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Messages'));

    print('LiveQueryURL ${ParseCoreData().liveQueryURL}');

    liveQuery.on(LiveQueryEvent.create, (value) {
      print('*** CREATE ***: ${DateTime.now().toString()}\n $value ');
      Message m = Message.clone().fromJson(jsonDecode(value.toString()));
      lst.add(m);
      setState(() {
      });
    });

    liveQuery.on(LiveQueryEvent.update, (value) {
      print('*** UPDATE ***: ${DateTime.now().toString()}\n $value ');
    });

    liveQuery.on(LiveQueryEvent.delete, (value) {
      print('*** DELETE ***: ${DateTime.now().toString()}\n $value ');
    });

    await liveQuery.subscribe(query);
    print('Subscribe done');
  }

  bool _validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _sendMessage() {
    if(_validateAndSave()) {
      _homeBloc.dispatch(SendMessagePressed(message:_message));
    }
  }
}