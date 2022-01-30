part of 'get_liquor_item_bloc.dart';

abstract class GetLiquorItemState extends Equatable {
  const GetLiquorItemState();

  @override
  List<Object> get props => [];
}

class GetLiquorItemInitialState extends GetLiquorItemState {}

class GetLiquorItemLoadingState extends GetLiquorItemState {
  GetLiquorItemLoadingState();
}

class GetLiquorItemLoadingItemState extends GetLiquorItemState {
  GetLiquorItemLoadingItemState();
}

class GetLiquorItemSuccessState extends GetLiquorItemState {
  final List<LiquorItem> liquorItemList;
  final String message;

  GetLiquorItemSuccessState(
    this.liquorItemList,
    this.message,
  );
}

class GetLiquorItemFailedState extends GetLiquorItemState {
  final List<LiquorItem> liquorCategoryList;
  final String message;

  GetLiquorItemFailedState(
    this.liquorCategoryList,
    this.message,
  );
}

class GetLiquorItemExceptionState extends GetLiquorItemState {
  final List<LiquorItem> liquorCategoryList;
  final String message;

  GetLiquorItemExceptionState(
    this.liquorCategoryList,
    this.message,
  );
}
