part of 'edit_liquor_category_bloc.dart';

abstract class EditLiquorCategoryEvent extends Equatable {
  EditLiquorCategoryEvent();

  @override
  List<Object> get props => [];
}

class EditLiquorCategoryAddEvent extends EditLiquorCategoryEvent {
  final Map<String, dynamic> editLiquorCategoryData;

  EditLiquorCategoryAddEvent({
    required this.editLiquorCategoryData,
  });
}
