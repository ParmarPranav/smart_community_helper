part of 'get_general_setting_bloc.dart';

abstract class GetGeneralSettingEvent extends Equatable {
  const GetGeneralSettingEvent();

  @override
  List<Object> get props => [];
}

class GetGeneralSettingDataEvent extends GetGeneralSettingEvent {


}

class EditGeneralSettingEvent extends GetGeneralSettingEvent {
  final Map<String, dynamic> data;

  EditGeneralSettingEvent({
    required this.data,
  });
}

