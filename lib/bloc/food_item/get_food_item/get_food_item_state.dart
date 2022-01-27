part of 'get_food_item_bloc.dart';

abstract class GetFoodItemState extends Equatable {
  const GetFoodItemState();

  @override
  List<Object> get props => [];
}

class GetFoodItemInitialState extends GetFoodItemState {}

class GetFoodItemLoadingState extends GetFoodItemState {
  GetFoodItemLoadingState();
}

class GetFoodItemLoadingItemState extends GetFoodItemState {
  GetFoodItemLoadingItemState();
}

class GetFoodItemSuccessState extends GetFoodItemState {
  final List<FoodItem> foodItemList;
  final String message;

  GetFoodItemSuccessState(
    this.foodItemList,
    this.message,
  );
}

class GetFoodItemFailedState extends GetFoodItemState {
  final List<FoodItem> foodCategoryList;
  final String message;

  GetFoodItemFailedState(
    this.foodCategoryList,
    this.message,
  );
}

class GetFoodItemExceptionState extends GetFoodItemState {
  final List<FoodItem> foodCategoryList;
  final String message;

  GetFoodItemExceptionState(
    this.foodCategoryList,
    this.message,
  );
}
