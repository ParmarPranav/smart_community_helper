part of 'get_food_category_bloc.dart';

abstract class GetFoodCategoryEvent extends Equatable {
  const GetFoodCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetFoodCategoryDataEvent extends GetFoodCategoryEvent {
  GetFoodCategoryDataEvent();
}

class GetFoodCategoryDeleteEvent extends GetFoodCategoryEvent {
  final Map<String, dynamic> data;

  GetFoodCategoryDeleteEvent({
    required this.data,
  });
}

class GetFoodCategoryDeleteAllEvent extends GetFoodCategoryEvent {
  final List<Map<String, dynamic>> idList;

  GetFoodCategoryDeleteAllEvent({
    required this.idList,
  });
}
