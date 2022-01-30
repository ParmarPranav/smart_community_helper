part of 'edit_liquor_item_bloc.dart';

abstract class EditLiquorItemEvent extends Equatable {
  EditLiquorItemEvent();

  @override
  List<Object> get props => [];
}

class EditLiquorItemAddEvent extends EditLiquorItemEvent {
  final Map<String, dynamic> editLiquorItemData;

  EditLiquorItemAddEvent({
    required this.editLiquorItemData,
  });
}
