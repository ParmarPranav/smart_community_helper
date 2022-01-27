part of 'edit_food_category_bloc.dart';

abstract class EditFoodCategoryEvent extends Equatable {
  EditFoodCategoryEvent();

  @override
  List<Object> get props => [];
}

class EditFoodCategoryAddEvent extends EditFoodCategoryEvent {
  final Map<String, dynamic> editFoodCategoryData;

  EditFoodCategoryAddEvent({
    required this.editFoodCategoryData,
  });
}
