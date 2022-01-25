part of 'edit_restaurant_bloc.dart';

abstract class EditRestaurantEvent extends Equatable {
  EditRestaurantEvent();

  @override
  List<Object> get props => [];
}

class EditRestaurantEditEvent extends EditRestaurantEvent {
  final Map<String, dynamic> editRestaurantData;

  EditRestaurantEditEvent({
    required this.editRestaurantData,
  });
}
