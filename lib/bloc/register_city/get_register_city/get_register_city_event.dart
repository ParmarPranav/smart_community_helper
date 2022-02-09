part of 'get_register_city_bloc.dart';

abstract class GetRegisterCityEvent extends Equatable {
  const GetRegisterCityEvent();

  @override
  List<Object> get props => [];
}

class GetRegisterCityDataEvent extends GetRegisterCityEvent {
  GetRegisterCityDataEvent();
}

class GetRegisterCityDeleteEvent extends GetRegisterCityEvent {
  final Map<String, dynamic> emailId;

  GetRegisterCityDeleteEvent({
    required this.emailId,
  });
}

class GetRegisterCityDeleteAllEvent extends GetRegisterCityEvent {
  final List<Map<String, dynamic>> emailIdList;

  GetRegisterCityDeleteAllEvent({
    required this.emailIdList,
  });
}
