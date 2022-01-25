part of 'edit_restaurant_bloc.dart';

abstract class EditRestaurantState extends Equatable {
  const EditRestaurantState();

  @override
  List<Object> get props => [];
}

class EditRestaurantInitialState extends EditRestaurantState {}

class EditRestaurantLoadingState extends EditRestaurantState {
  EditRestaurantLoadingState();
}

class EditRestaurantSuccessState extends EditRestaurantState {
  final Restaurant? restaurant;
  final String message;

  EditRestaurantSuccessState(
    this.restaurant,
    this.message,
  );
}

class EditRestaurantFailureState extends EditRestaurantState {
  final String message;

  EditRestaurantFailureState(
    this.message,
  );
}

class EditRestaurantExceptionState extends EditRestaurantState {
  final String message;

  EditRestaurantExceptionState(
    this.message,
  );
}
