import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'myprofile_event.dart';
part 'myprofile_state.dart';

class MyprofileBloc extends Bloc<MyprofileEvent, MyprofileState> {
  MyprofileBloc() : super(MyprofileInitial()) {
    on<MyprofileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
