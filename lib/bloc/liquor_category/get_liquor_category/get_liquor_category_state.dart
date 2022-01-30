part of 'get_liquor_category_bloc.dart';

abstract class GetLiquorCategoryState extends Equatable {
  const GetLiquorCategoryState();

  @override
  List<Object> get props => [];
}

class GetLiquorCategoryInitialState extends GetLiquorCategoryState {}

class GetLiquorCategoryLoadingState extends GetLiquorCategoryState {
  GetLiquorCategoryLoadingState();
}

class GetLiquorCategoryLoadingItemState extends GetLiquorCategoryState {
  GetLiquorCategoryLoadingItemState();
}

class GetLiquorCategorySuccessState extends GetLiquorCategoryState {
  final List<LiquorCategory> liquorCategoryList;
  final String message;

  GetLiquorCategorySuccessState(
    this.liquorCategoryList,
    this.message,
  );
}

class GetLiquorCategoryFailedState extends GetLiquorCategoryState {
  final List<LiquorCategory> liquorCategoryList;
  final String message;

  GetLiquorCategoryFailedState(
    this.liquorCategoryList,
    this.message,
  );
}

class GetLiquorCategoryExceptionState extends GetLiquorCategoryState {
  final List<LiquorCategory> liquorCategoryList;
  final String message;

  GetLiquorCategoryExceptionState(
    this.liquorCategoryList,
    this.message,
  );
}
