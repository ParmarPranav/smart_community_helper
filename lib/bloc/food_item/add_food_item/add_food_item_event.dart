part of 'add_food_item_bloc.dart';

abstract class AddFoodItemEvent extends Equatable {
  AddFoodItemEvent();

  @override
  List<Object> get props => [];
}

class AddFoodItemAddEvent extends AddFoodItemEvent {
  final Map<String, dynamic> addFoodItemData;

  AddFoodItemAddEvent({
    required this.addFoodItemData,
  });
}
