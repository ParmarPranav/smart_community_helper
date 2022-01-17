part of 'get_restaurants_bloc.dart';

abstract class GetRestaurantsState extends Equatable {
  const GetRestaurantsState();

  @override
  List<Object> get props => [];
}

class GetRestaurantsInitialState extends GetRestaurantsState {}

class GetRestaurantsLoadingState extends GetRestaurantsState {
  GetRestaurantsLoadingState();
}

class GetRestaurantsLoadingItemState extends GetRestaurantsState {
  GetRestaurantsLoadingItemState();
}

class GetRestaurantsSuccessState extends GetRestaurantsState {
  final List<Restaurant> restaurantList;
  final String message;

  GetRestaurantsSuccessState(
    this.restaurantList,
    this.message,
  );
}

class GetRestaurantsFailedState extends GetRestaurantsState {
  final List<Restaurant> restaurantList;
  final String message;

  GetRestaurantsFailedState(
    this.restaurantList,
    this.message,
  );
}

class GetRestaurantsExceptionState extends GetRestaurantsState {
  final List<Restaurant> restaurantList;
  final String message;

  GetRestaurantsExceptionState(
    this.restaurantList,
    this.message,
  );
}
