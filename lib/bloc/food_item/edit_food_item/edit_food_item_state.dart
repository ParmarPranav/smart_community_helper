part of 'edit_food_item_bloc.dart';

abstract class EditFoodItemState extends Equatable {
  const EditFoodItemState();

  @override
  List<Object> get props => [];
}

class EditFoodItemInitialState extends EditFoodItemState {}

class EditFoodItemLoadingState extends EditFoodItemState {
  EditFoodItemLoadingState();
}

class EditFoodItemSuccessState extends EditFoodItemState {
  final FoodItem? foodItem;
  final String message;

  EditFoodItemSuccessState(
    this.foodItem,
    this.message,
  );
}

class EditFoodItemFailureState extends EditFoodItemState {
  final String message;

  EditFoodItemFailureState(
    this.message,
  );
}

class EditFoodItemExceptionState extends EditFoodItemState {
  final String message;

  EditFoodItemExceptionState(
    this.message,
  );
}
