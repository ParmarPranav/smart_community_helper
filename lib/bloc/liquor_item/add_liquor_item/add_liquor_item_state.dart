part of 'add_liquor_item_bloc.dart';

abstract class AddLiquorItemState extends Equatable {
  const AddLiquorItemState();

  @override
  List<Object> get props => [];
}

class AddLiquorItemInitialState extends AddLiquorItemState {}

class AddLiquorItemLoadingState extends AddLiquorItemState {
  AddLiquorItemLoadingState();
}

class AddLiquorItemSuccessState extends AddLiquorItemState {
  final LiquorItem? liquorItem;
  final String message;

  AddLiquorItemSuccessState(
    this.liquorItem,
    this.message,
  );
}

class AddLiquorItemFailureState extends AddLiquorItemState {
  final String message;

  AddLiquorItemFailureState(
    this.message,
  );
}

class AddLiquorItemExceptionState extends AddLiquorItemState {
  final String message;

  AddLiquorItemExceptionState(
    this.message,
  );
}
