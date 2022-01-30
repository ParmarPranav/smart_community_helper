part of 'add_liquor_category_bloc.dart';

abstract class AddLiquorCategoryEvent extends Equatable {
  AddLiquorCategoryEvent();

  @override
  List<Object> get props => [];
}

class AddLiquorCategoryAddEvent extends AddLiquorCategoryEvent {
  final Map<String, dynamic> addLiquorCategoryData;

  AddLiquorCategoryAddEvent({
    required this.addLiquorCategoryData,
  });
}
