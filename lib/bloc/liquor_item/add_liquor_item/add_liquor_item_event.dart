part of 'add_liquor_item_bloc.dart';

abstract class AddLiquorItemEvent extends Equatable {
  AddLiquorItemEvent();

  @override
  List<Object> get props => [];
}

class AddLiquorItemAddEvent extends AddLiquorItemEvent {
  final Map<String, dynamic> addLiquorItemData;

  AddLiquorItemAddEvent({
    required this.addLiquorItemData,
  });
}
