part of 'add_food_category_bloc.dart';

abstract class AddFoodCategoryEvent extends Equatable {
  AddFoodCategoryEvent();

  @override
  List<Object> get props => [];
}

class AddFoodCategoryAddEvent extends AddFoodCategoryEvent {
  final Map<String, dynamic> addFoodCategoryData;

  AddFoodCategoryAddEvent({
    required this.addFoodCategoryData,
  });
}
