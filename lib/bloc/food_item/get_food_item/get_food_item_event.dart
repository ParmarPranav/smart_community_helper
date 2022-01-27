part of 'get_food_item_bloc.dart';

abstract class GetFoodItemEvent extends Equatable {
  const GetFoodItemEvent();

  @override
  List<Object> get props => [];
}

class GetFoodItemDataEvent extends GetFoodItemEvent {
  final Map<String, dynamic> data;

  GetFoodItemDataEvent({
    required this.data,
  });
}

class GetFoodItemUpdateStatusEvent extends GetFoodItemEvent {
  final Map<String, dynamic> data;

  GetFoodItemUpdateStatusEvent({
    required this.data,
  });
}

class GetFoodItemDeleteEvent extends GetFoodItemEvent {
  final Map<String, dynamic> data;

  GetFoodItemDeleteEvent({
    required this.data,
  });
}

class GetFoodItemDeleteAllEvent extends GetFoodItemEvent {
  final List<Map<String, dynamic>> idList;

  GetFoodItemDeleteAllEvent({
    required this.idList,
  });
}
