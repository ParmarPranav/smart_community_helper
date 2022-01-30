part of 'edit_liquor_item_bloc.dart';

abstract class EditLiquorItemState extends Equatable {
  const EditLiquorItemState();

  @override
  List<Object> get props => [];
}

class EditLiquorItemInitialState extends EditLiquorItemState {}

class EditLiquorItemLoadingState extends EditLiquorItemState {
  EditLiquorItemLoadingState();
}

class EditLiquorItemSuccessState extends EditLiquorItemState {
  final LiquorItem? liquorItem;
  final String message;

  EditLiquorItemSuccessState(
    this.liquorItem,
    this.message,
  );
}

class EditLiquorItemFailureState extends EditLiquorItemState {
  final String message;

  EditLiquorItemFailureState(
    this.message,
  );
}

class EditLiquorItemExceptionState extends EditLiquorItemState {
  final String message;

  EditLiquorItemExceptionState(
    this.message,
  );
}
