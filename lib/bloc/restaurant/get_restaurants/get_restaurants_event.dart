part of 'get_restaurants_bloc.dart';

abstract class GetRestaurantsEvent extends Equatable {
  const GetRestaurantsEvent();

  @override
  List<Object> get props => [];
}

class GetRestaurantsDataEvent extends GetRestaurantsEvent {
  GetRestaurantsDataEvent();
}

class GetRestaurantsDeleteEvent extends GetRestaurantsEvent {
  final String emailId;

  GetRestaurantsDeleteEvent({
    required this.emailId,
  });
}

class GetRestaurantsDeleteAllEvent extends GetRestaurantsEvent {
  final List<Map<String, dynamic>> emailIdList;

  GetRestaurantsDeleteAllEvent({
    required this.emailIdList,
  });
}