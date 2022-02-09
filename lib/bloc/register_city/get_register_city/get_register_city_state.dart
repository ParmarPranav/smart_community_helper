part of 'get_register_city_bloc.dart';

abstract class GetRegisterCityState extends Equatable {
  const GetRegisterCityState();

  @override
  List<Object> get props => [];
}

class GetRegisterCityInitialState extends GetRegisterCityState {}

class GetRegisterCityLoadingState extends GetRegisterCityState {
  GetRegisterCityLoadingState();
}

class GetRegisterCityLoadingItemState extends GetRegisterCityState {
  GetRegisterCityLoadingItemState();
}

class GetRegisterCitySuccessState extends GetRegisterCityState {
  final List<RegisterCity> registerCityList;
  final String message;

  GetRegisterCitySuccessState(
    this.registerCityList,
    this.message,
  );
}

class GetRegisterCityFailedState extends GetRegisterCityState {
  final List<RegisterCity> registerCityList;
  final String message;

  GetRegisterCityFailedState(
    this.registerCityList,
    this.message,
  );
}

class GetRegisterCityExceptionState extends GetRegisterCityState {
  final List<RegisterCity> registerCityList;
  final String message;

  GetRegisterCityExceptionState(
    this.registerCityList,
    this.message,
  );
}
