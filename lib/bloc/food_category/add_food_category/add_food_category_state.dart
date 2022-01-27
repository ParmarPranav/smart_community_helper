part of 'add_food_category_bloc.dart';

abstract class AddFoodCategoryState extends Equatable {
  const AddFoodCategoryState();

  @override
  List<Object> get props => [];
}

class AddFoodCategoryInitialState extends AddFoodCategoryState {}

class AddFoodCategoryLoadingState extends AddFoodCategoryState {
  AddFoodCategoryLoadingState();
}

class AddFoodCategorySuccessState extends AddFoodCategoryState {
  final FoodCategory? foodCategory;
  final String message;

  AddFoodCategorySuccessState(
    this.foodCategory,
    this.message,
  );
}

class AddFoodCategoryFailureState extends AddFoodCategoryState {
  final String message;

  AddFoodCategoryFailureState(
    this.message,
  );
}

class AddFoodCategoryExceptionState extends AddFoodCategoryState {
  final String message;

  AddFoodCategoryExceptionState(
    this.message,
  );
}
