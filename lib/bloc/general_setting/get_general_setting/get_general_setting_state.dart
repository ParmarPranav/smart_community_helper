part of 'get_general_setting_bloc.dart';

abstract class GetGeneralSettingState extends Equatable {
  const GetGeneralSettingState();

  @override
  List<Object> get props => [];
}

class GetGeneralSettingInitialState extends GetGeneralSettingState {}

class GetGeneralSettingLoadingState extends GetGeneralSettingState {
  GetGeneralSettingLoadingState();
}

class GetGeneralSettingLoadingItemState extends GetGeneralSettingState {
  GetGeneralSettingLoadingItemState();
}

class GetGeneralSettingSuccessState extends GetGeneralSettingState {
  final GeneralSetting? generalSetting;
  final String message;

  GetGeneralSettingSuccessState(
    this.generalSetting,
    this.message,
  );
}

class GetGeneralSettingFailedState extends GetGeneralSettingState {
  final GeneralSetting? generalSetting;
  final String message;

  GetGeneralSettingFailedState(
    this.generalSetting,
    this.message,
  );
}

class GetGeneralSettingExceptionState extends GetGeneralSettingState {
  final GeneralSetting? generalSetting;
  final String message;

  GetGeneralSettingExceptionState(
    this.generalSetting,
    this.message,
  );
}
