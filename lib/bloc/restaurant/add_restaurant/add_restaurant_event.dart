part of 'add_restaurant_blocs.dart';

abstract class AddRestaurantEvent extends Equatable {
  AddRestaurantEvent();

  @override
  List<Object> get props => [];
}

class AddRestaurantAddEvent extends AddRestaurantEvent {
  final Map<String, dynamic> addRestaurantData;

  AddRestaurantAddEvent({
    required this.addRestaurantData,
  });
}
