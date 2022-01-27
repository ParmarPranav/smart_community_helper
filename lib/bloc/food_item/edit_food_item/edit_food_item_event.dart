part of 'edit_food_item_bloc.dart';

abstract class EditFoodItemEvent extends Equatable {
  EditFoodItemEvent();

  @override
  List<Object> get props => [];
}

class EditFoodItemAddEvent extends EditFoodItemEvent {
  final Map<String, dynamic> editFoodItemData;

  EditFoodItemAddEvent({
    required this.editFoodItemData,
  });
}
