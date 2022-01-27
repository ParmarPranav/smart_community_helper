part of 'get_food_category_bloc.dart';

abstract class GetFoodCategoryEvent extends Equatable {
  const GetFoodCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetFoodCategoryDataEvent extends GetFoodCategoryEvent {
  final Map<String, dynamic> data;

  GetFoodCategoryDataEvent({
    required this.data,
  });
}

class GetFoodCategoryUpdateStatusEvent extends GetFoodCategoryEvent {
  final Map<String, dynamic> data;

  GetFoodCategoryUpdateStatusEvent({
    required this.data,
  });
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
