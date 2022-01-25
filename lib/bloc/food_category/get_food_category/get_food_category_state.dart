part of 'get_food_category_bloc.dart';

abstract class GetFoodCategoryState extends Equatable {
  const GetFoodCategoryState();

  @override
  List<Object> get props => [];
}

class GetFoodCategoryInitialState extends GetFoodCategoryState {}

class GetFoodCategoryLoadingState extends GetFoodCategoryState {
  GetFoodCategoryLoadingState();
}

class GetFoodCategoryLoadingItemState extends GetFoodCategoryState {
  GetFoodCategoryLoadingItemState();
}

class GetFoodCategorySuccessState extends GetFoodCategoryState {
  final List<FoodCategory> foodCategoryList;
  final String message;

  GetFoodCategorySuccessState(
    this.foodCategoryList,
    this.message,
  );
}

class GetFoodCategoryFailedState extends GetFoodCategoryState {
  final List<FoodCategory> foodCategoryList;
  final String message;

  GetFoodCategoryFailedState(
    this.foodCategoryList,
    this.message,
  );
}

class GetFoodCategoryExceptionState extends GetFoodCategoryState {
  final List<FoodCategory> foodCategoryList;
  final String message;

  GetFoodCategoryExceptionState(
    this.foodCategoryList,
    this.message,
  );
}
