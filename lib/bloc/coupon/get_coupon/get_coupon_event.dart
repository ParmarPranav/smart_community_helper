part of 'get_coupon_bloc.dart';

abstract class GetCouponsEvent extends Equatable {
  const GetCouponsEvent();

  @override
  List<Object> get props => [];
}

class GetCouponsDataEvent extends GetCouponsEvent {
  GetCouponsDataEvent();
}

class GetCouponsDeleteEvent extends GetCouponsEvent {
  final Map<String, dynamic> id;

  GetCouponsDeleteEvent({
    required this.id,
  });
}

class GetCouponsUpdateStatusEvent extends GetCouponsEvent {
  final Map<String, dynamic> data;

  GetCouponsUpdateStatusEvent({
    required this.data,
  });
}

class GetCouponsDeleteAllEvent extends GetCouponsEvent {
  final List<Map<String, dynamic>> idList;

  GetCouponsDeleteAllEvent({
    required this.idList,
  });
}
