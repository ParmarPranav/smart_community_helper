part of 'get_liquor_item_bloc.dart';

abstract class GetLiquorItemEvent extends Equatable {
  const GetLiquorItemEvent();

  @override
  List<Object> get props => [];
}

class GetLiquorItemDataEvent extends GetLiquorItemEvent {
  final Map<String, dynamic> data;

  GetLiquorItemDataEvent({
    required this.data,
  });
}

class GetLiquorItemUpdateStatusEvent extends GetLiquorItemEvent {
  final Map<String, dynamic> data;

  GetLiquorItemUpdateStatusEvent({
    required this.data,
  });
}

class GetLiquorItemDeleteEvent extends GetLiquorItemEvent {
  final Map<String, dynamic> data;

  GetLiquorItemDeleteEvent({
    required this.data,
  });
}

class GetLiquorItemDeleteAllEvent extends GetLiquorItemEvent {
  final List<Map<String, dynamic>> idList;

  GetLiquorItemDeleteAllEvent({
    required this.idList,
  });
}
