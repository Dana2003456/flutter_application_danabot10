import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataInitial()) {
    on<FetchCommentsEvent>(_onFetchCommentsEvent);
  }

  Future<void> _onFetchCommentsEvent(
      FetchCommentsEvent event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      var url =
          Uri.parse('https://jsonplaceholder.typicode.com/posts/1/comments');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> comments = json.decode(response.body);
        emit(DataLoaded(comments));
      } else {
        emit(DataError('Error loading comments'));
      }
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }
}
