part of 'edit_liquor_category_bloc.dart';

abstract class EditLiquorCategoryState extends Equatable {
  const EditLiquorCategoryState();

  @override
  List<Object> get props => [];
}

class EditLiquorCategoryInitialState extends EditLiquorCategoryState {}

class EditLiquorCategoryLoadingState extends EditLiquorCategoryState {
  EditLiquorCategoryLoadingState();
}

class EditLiquorCategorySuccessState extends EditLiquorCategoryState {
  final LiquorCategory? liquorCategory;
  final String message;

  EditLiquorCategorySuccessState(
    this.liquorCategory,
    this.message,
  );
}

class EditLiquorCategoryFailureState extends EditLiquorCategoryState {
  final String message;

  EditLiquorCategoryFailureState(
    this.message,
  );
}

class EditLiquorCategoryExceptionState extends EditLiquorCategoryState {
  final String message;

  EditLiquorCategoryExceptionState(
    this.message,
  );
}
