part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeSummaryEntity? summary;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.summary,
    this.errorMessage,
  });

  const HomeState.initial()
    : status = HomeStatus.initial,
      summary = null,
      errorMessage = null;

  HomeState copyWith({
    HomeStatus? status,
    HomeSummaryEntity? summary,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage];
}
