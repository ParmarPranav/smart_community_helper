part of 'add_restaurant_bloc.dart';

abstract class AddRestaurantEvent extends Equatable {
  AddRestaurantEvent();

  @override
  List<Object> get props => [];
}

class AddRestaurantAddEvent extends AddRestaurantEvent {
  final Map<String, String> addRestaurantData;
  final dynamic businessLogo;
  final dynamic coverPhoto;
  final List<dynamic> photoGallery;

  AddRestaurantAddEvent({
    required this.addRestaurantData,
    required this.businessLogo,
    required this.coverPhoto,
    required this.photoGallery,
  });
}
