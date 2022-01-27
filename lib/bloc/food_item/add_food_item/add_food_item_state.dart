part of 'add_food_item_bloc.dart';

abstract class AddFoodItemState extends Equatable {
  const AddFoodItemState();

  @override
  List<Object> get props => [];
}

class AddFoodItemInitialState extends AddFoodItemState {}

class AddFoodItemLoadingState extends AddFoodItemState {
  AddFoodItemLoadingState();
}

class AddFoodItemSuccessState extends AddFoodItemState {
  final FoodItem? foodCategory;
  final String message;

  AddFoodItemSuccessState(
    this.foodCategory,
    this.message,
  );
}

class AddFoodItemFailureState extends AddFoodItemState {
  final String message;

  AddFoodItemFailureState(
    this.message,
  );
}

class AddFoodItemExceptionState extends AddFoodItemState {
  final String message;

  AddFoodItemExceptionState(
    this.message,
  );
}
