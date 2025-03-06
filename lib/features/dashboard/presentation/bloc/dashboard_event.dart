part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

final class LoadNews extends DashboardEvent {}

final class AddNews extends DashboardEvent {}

final class DeleteNews extends DashboardEvent {}
