part of 'add_restaurant_bloc.dart';

abstract class AddRestaurantState extends Equatable {
  const AddRestaurantState();

  @override
  List<Object> get props => [];
}

class AddRestaurantInitialState extends AddRestaurantState {}

class AddRestaurantLoadingState extends AddRestaurantState {
  AddRestaurantLoadingState();
}

class AddRestaurantSuccessState extends AddRestaurantState {
  final Restaurant? restaurant;
  final String message;

  AddRestaurantSuccessState(
    this.restaurant,
    this.message,
  );
}

class AddRestaurantFailureState extends AddRestaurantState {
  final String message;

  AddRestaurantFailureState(
    this.message,
  );
}

class AddRestaurantExceptionState extends AddRestaurantState {
  final String message;

  AddRestaurantExceptionState(
    this.message,
  );
}
