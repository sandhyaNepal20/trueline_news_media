part of 'myprofile_bloc.dart';

sealed class MyprofileState extends Equatable {
  const MyprofileState();
  
  @override
  List<Object> get props => [];
}

final class MyprofileInitial extends MyprofileState {}
