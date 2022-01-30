part of 'get_liquor_category_bloc.dart';

abstract class GetLiquorCategoryEvent extends Equatable {
  const GetLiquorCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetLiquorCategoryDataEvent extends GetLiquorCategoryEvent {
  final Map<String, dynamic> data;

  GetLiquorCategoryDataEvent({
    required this.data,
  });
}

class GetLiquorCategoryUpdateStatusEvent extends GetLiquorCategoryEvent {
  final Map<String, dynamic> data;

  GetLiquorCategoryUpdateStatusEvent({
    required this.data,
  });
}

class GetLiquorCategoryDeleteEvent extends GetLiquorCategoryEvent {
  final Map<String, dynamic> data;

  GetLiquorCategoryDeleteEvent({
    required this.data,
  });
}

class GetLiquorCategoryDeleteAllEvent extends GetLiquorCategoryEvent {
  final List<Map<String, dynamic>> idList;

  GetLiquorCategoryDeleteAllEvent({
    required this.idList,
  });
}
