part of 'edit_food_category_bloc.dart';

abstract class EditFoodCategoryState extends Equatable {
  const EditFoodCategoryState();

  @override
  List<Object> get props => [];
}

class EditFoodCategoryInitialState extends EditFoodCategoryState {}

class EditFoodCategoryLoadingState extends EditFoodCategoryState {
  EditFoodCategoryLoadingState();
}

class EditFoodCategorySuccessState extends EditFoodCategoryState {
  final FoodCategory? foodCategory;
  final String message;

  EditFoodCategorySuccessState(
    this.foodCategory,
    this.message,
  );
}

class EditFoodCategoryFailureState extends EditFoodCategoryState {
  final String message;

  EditFoodCategoryFailureState(
    this.message,
  );
}

class EditFoodCategoryExceptionState extends EditFoodCategoryState {
  final String message;

  EditFoodCategoryExceptionState(
    this.message,
  );
}
