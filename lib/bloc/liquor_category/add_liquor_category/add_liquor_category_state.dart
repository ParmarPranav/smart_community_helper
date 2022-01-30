part of 'add_liquor_category_bloc.dart';

abstract class AddLiquorCategoryState extends Equatable {
  const AddLiquorCategoryState();

  @override
  List<Object> get props => [];
}

class AddLiquorCategoryInitialState extends AddLiquorCategoryState {}

class AddLiquorCategoryLoadingState extends AddLiquorCategoryState {
  AddLiquorCategoryLoadingState();
}

class AddLiquorCategorySuccessState extends AddLiquorCategoryState {
  final LiquorCategory? foodCategory;
  final String message;

  AddLiquorCategorySuccessState(
    this.foodCategory,
    this.message,
  );
}

class AddLiquorCategoryFailureState extends AddLiquorCategoryState {
  final String message;

  AddLiquorCategoryFailureState(
    this.message,
  );
}

class AddLiquorCategoryExceptionState extends AddLiquorCategoryState {
  final String message;

  AddLiquorCategoryExceptionState(
    this.message,
  );
}
