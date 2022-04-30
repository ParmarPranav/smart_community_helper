// import 'dart:html';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dotted_decoration/dotted_decoration.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:food_hunt_admin_app/bloc/delivery_boy/update_status_delivery_boy/update_delivery_boy_bloc.dart';
// import 'package:food_hunt_admin_app/bloc/order/get_today_order/get_today_order_bloc.dart';
// import 'package:food_hunt_admin_app/models/delivery_boy.dart';
// import 'package:food_hunt_admin_app/screens/order/manage_order_delivery_boy_screen.dart';
// import 'package:food_hunt_admin_app/utils/project_constant.dart';
// import 'package:food_hunt_admin_app/utils/string_extension.dart';
// import 'package:food_hunt_admin_app/widgets/back_button.dart';
// import 'package:food_hunt_admin_app/widgets/image_error_widget.dart';
// import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';
// import 'package:intl/intl.dart';
//
// import '../../models/order.dart';
// import '../responsive_layout.dart';
//
// class ViewDeliveryBoyScreen extends StatefulWidget {
//   static const routeName = '/view-delivery-boy';
//
//   ViewDeliveryBoyScreen({Key? key}) : super(key: key);
//
//   @override
//   _ViewDeliveryBoyScreenState createState() => _ViewDeliveryBoyScreenState();
// }
//
// class _ViewDeliveryBoyScreenState extends State<ViewDeliveryBoyScreen> {
//   bool _isInit = true;
//   Vendor? deliveryBoy;
//   final UpdateDeliveryBoyBloc _updateDeliveryBoyBloc = UpdateDeliveryBoyBloc();
//   final GetTodayOrderBloc _getTodayOrderBloc = GetTodayOrderBloc();
//
//
//   var _deliverTipTotal = 0.0;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_isInit) {
//       deliveryBoy = ModalRoute.of(context)!.settings.arguments as Vendor?;
//       _isInit = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ResponsiveLayout(
//         smallScreen: _buildMobileTabletView(),
//         mediumScreen: _buildMobileTabletView(),
//         largeScreen: _buildWebView(),
//       ),
//     );
//   }
//
//   Widget _buildMobileTabletView() {
//     return Container();
//   }
//
//   Widget _buildWebView() {
//     return BlocConsumer<UpdateDeliveryBoyBloc, UpdateDeliveryBoyState>(
//       bloc: _updateDeliveryBoyBloc,
//       listener: (context, state) {
//         if (state is UpdateDeliveryBoySuccessState) {
//           setState(() {
//             deliveryBoy = state.deliveryBoy;
//           });
//           _showSnackMessage(state.message, Colors.green);
//         } else if (state is UpdateDeliveryBoyFailureState) {
//           _showSnackMessage(state.message, Colors.red);
//         } else if (state is UpdateDeliveryBoyExceptionState) {
//           _showSnackMessage(state.message, Colors.red);
//         }
//       },
//       builder: (context, state) {
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 5,
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Container(
//                   margin: EdgeInsets.only(left: 10),
//                   child: BackButtonNew(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 25.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           deliveryBoy!.name,
//                           style: ProjectConstant.WorkSansFontBoldTextStyle(
//                             fontSize: 26,
//                             fontColor: Colors.black,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           '${deliveryBoy!.address}, ${deliveryBoy!.city}, ${deliveryBoy!.country},',
//                           style: ProjectConstant.WorkSansFontRegularTextStyle(
//                             fontSize: 16,
//                             fontColor: Colors.grey.shade600,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           deliveryBoy!.mobileNo,
//                           style: ProjectConstant.WorkSansFontRegularTextStyle(
//                             fontSize: 16,
//                             fontColor: Colors.grey.shade600,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               alignment: Alignment.centerLeft,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.amberAccent),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               padding: EdgeInsets.all(2.0),
//                               child: Row(
//                                 children: [
//                                   RatingBar.builder(
//                                     initialRating: 4,
//                                     direction: Axis.horizontal,
//                                     allowHalfRating: true,
//                                     itemCount: 5,
//                                     unratedColor: Colors.grey.shade400,
//                                     itemSize: 14,
//                                     glow: true,
//                                     glowColor: Colors.amberAccent,
//                                     itemPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
//                                     itemBuilder: (context, _) => Icon(
//                                       Icons.star,
//                                       color: Colors.amber,
//                                     ),
//                                     onRatingUpdate: (rating) {},
//                                   ),
//                                   SizedBox(width: 5),
//                                   Text(
//                                     '15',
//                                     style: ProjectConstant.WorkSansFontRegularTextStyle(
//                                       fontSize: 16,
//                                       fontColor: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Divider(
//                   thickness: 1.0,
//                   color: Colors.grey,
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               BlocConsumer<GetTodayOrderBloc, GetTodayOrderState>(
//                 bloc: _getTodayOrderBloc,
//                 listener: (context, state) {
//                   if (state is GetTodayOrderSuccessState) {
//                     _todayOrderList = state.orderList;
//                     _deliverTipTotal = 0.0;
//                     _todayOrderList.forEach((element) {
//                       _deliverTipTotal += element.deliveryTip;
//                     });
//                   } else if (state is GetTodayOrderFailedState) {
//                     //_showSnackMessage(state.message, Colors.red);
//                   } else if (state is GetTodayOrderExceptionState) {
//                     _showSnackMessage(state.message, Colors.red);
//                   }
//                 },
//                 builder: (context, state) {
//                   return Column(
//                     children: [
//                       Column(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 15),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   width: 350,
//                                   padding: EdgeInsets.all(15),
//                                   decoration: DottedDecoration(
//                                     shape: Shape.box,
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 25,
//                                         backgroundColor: Colors.orange.shade700,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(5.0),
//                                           child: FittedBox(
//                                             child: Text(
//                                               _todayOrderList.length.toString(),
//                                               style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//                                                 fontSize: 16,
//                                                 fontColor: Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                         'Today\'s Order Count',
//                                         style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//                                           fontSize: 13,
//                                           fontColor: Colors.black,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Container(
//                                   width: 350,
//                                   padding: EdgeInsets.all(15),
//                                   decoration: DottedDecoration(
//                                     shape: Shape.box,
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 25,
//                                         backgroundColor: Colors.cyan,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(5.0),
//                                           child: FittedBox(
//                                             child: Text(
//                                               '\$${NumberFormat.decimalPattern().format(_deliverTipTotal)}',
//                                               style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//                                                 fontSize: 16,
//                                                 fontColor: Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                         'Delivery Tip',
//                                         style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//                                           fontSize: 13,
//                                           fontColor: Colors.black,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(horizontal: 16),
//                         child: Card(
//                           color: Colors.grey.shade100,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           elevation: 5,
//                           child: ExpansionTile(
//                             initiallyExpanded: true,
//                             title: Text(
//                               'Today\'s Order',
//                               style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//                                 fontSize: 16,
//                                 fontColor: Colors.black,
//                               ),
//                             ),
//                             expandedCrossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: double.infinity,
//                                 child: DataTable(
//                                   showCheckboxColumn: true,
//                                   columns: [
//                                     DataColumn(
//                                       label: Text('Order No'),
//                                     ),
//                                     DataColumn(
//                                       label: Text('Delivery Tip'),
//                                     ),
//                                     DataColumn(
//                                       label: Text('Payment Type'),
//                                     ),
//                                     DataColumn(
//                                       label: Text('Order Status'),
//                                     ),
//                                   ],
//                                   rows: _todayOrderList.map((todayOrderList) {
//                                     return DataRow(
//                                       key: ValueKey(todayOrderList.id),
//                                       cells: [
//                                         DataCell(Text('#${todayOrderList.orderNo}')),
//                                         DataCell(Text('\$${NumberFormat.decimalPattern().format(todayOrderList.deliveryTip)}')),
//                                         DataCell(Text(todayOrderList.paymentMode == 'cod' ? 'Cash On Delivery' : todayOrderList.paymentMode.capitalize())),
//                                         DataCell(Text(todayOrderList.orderStatus.replaceAll("_", " ").capitalize())),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(horizontal: 16),
//                         child: Card(
//                           color: Colors.grey.shade100,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           elevation: 5,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Order',
//                                   style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//                                     fontSize: 16,
//                                     fontColor: Colors.black,
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pushNamed(ManageOrderDeliveryBoyScreen.routeName, arguments: deliveryBoy);
//                                   },
//                                   child: Text(
//                                     'Manage',
//                                     style: ProjectConstant.WorkSansFontRegularTextStyle(
//                                       fontSize: 16,
//                                       fontColor: Colors.red,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                     ],
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16),
//                 child: Card(
//                   color: Colors.grey.shade100,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   elevation: 5,
//                   child: ExpansionTile(
//                     initiallyExpanded: true,
//                     title: Text(
//                       'Driving License',
//                       style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//                         fontSize: 16,
//                         fontColor: Colors.black,
//                       ),
//                     ),
//                     subtitle: Row(
//                       children: [
//                         Text(
//                           'License No :',
//                           style: ProjectConstant.WorkSansFontRegularTextStyle(
//                             fontSize: 13,
//                             fontColor: Colors.grey,
//                           ),
//                         ),
//                         Text(
//                           '${deliveryBoy!.drivingLicenseDetails.licenseNo}',
//                           style: ProjectConstant.WorkSansFontRegularTextStyle(
//                             fontSize: 14,
//                             fontColor: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           showImage(ProjectConstant.driving_license_images_path + deliveryBoy!.drivingLicenseDetails.licenseFrontSide);
//                                         },
//                                         child: _buildItemWidget(
//                                           'View Front Side',
//                                           Icons.image,
//                                           Colors.pink,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           downloadFile(ProjectConstant.driving_license_images_path + deliveryBoy!.drivingLicenseDetails.licenseFrontSide);
//                                         },
//                                         child: _buildItemWidget(
//                                           'Download Front Side',
//                                           Icons.cloud_download,
//                                           Colors.blue,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     width: 30,
//                                   ),
//                                   Row(
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           showImage(ProjectConstant.driving_license_images_path + deliveryBoy!.drivingLicenseDetails.licenseBackSide);
//                                         },
//                                         child: _buildItemWidget(
//                                           'View Back Side',
//                                           Icons.image,
//                                           Colors.pink,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           downloadFile(ProjectConstant.driving_license_images_path + deliveryBoy!.drivingLicenseDetails.licenseBackSide);
//                                         },
//                                         child: _buildItemWidget(
//                                           'Download Back Side',
//                                           Icons.cloud_download,
//                                           Colors.blue,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             if (deliveryBoy!.drivingLicenseDetails.isApproved == '0')
//                               Row(
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       _updateDeliveryBoyBloc.add(UpdateDrivingLicenseEvent(editDeliveryBoyData: {'mobile_no': deliveryBoy!.mobileNo, 'status': '1'}));
//                                     },
//                                     child: _buildItemWidget(
//                                       'Approve',
//                                       Icons.check_circle,
//                                       Colors.green,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       _updateDeliveryBoyBloc.add(UpdateDrivingLicenseEvent(editDeliveryBoyData: {'mobile_no': deliveryBoy!.mobileNo, 'status': '2'}));
//                                     },
//                                     child: _buildItemWidget(
//                                       'Disapprove',
//                                       Icons.cancel,
//                                       Colors.red,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             else if (deliveryBoy!.drivingLicenseDetails.isApproved == '1')
//                               Row(
//                                 children: [
//                                   _buildItemWidget(
//                                     'Approved',
//                                     Icons.done_all,
//                                     Colors.green,
//                                   ),
//                                 ],
//                               )
//                             else if (deliveryBoy!.drivingLicenseDetails.isApproved == '2')
//                               Row(
//                                 children: [
//                                   _buildItemWidget(
//                                     'Disapproved',
//                                     Icons.cancel,
//                                     Colors.red,
//                                   ),
//                                 ],
//                               )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               if (deliveryBoy!.deliveryType != 'food')
//                 Column(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 16),
//                       child: Card(
//                         color: Colors.grey.shade100,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         elevation: 5,
//                         child: ExpansionTile(
//                           initiallyExpanded: true,
//                           title: Text(
//                             'Liquor License',
//                             style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//                               fontSize: 16,
//                               fontColor: Colors.black,
//                             ),
//                           ),
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           showImage(ProjectConstant.liquor_license_images_path + deliveryBoy!.liquorLicenseDetails!.licenseFrontSide);
//                                         },
//                                         child: _buildItemWidget(
//                                           'View Image',
//                                           Icons.image,
//                                           Colors.pink,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           downloadFile(ProjectConstant.liquor_license_images_path + deliveryBoy!.liquorLicenseDetails!.licenseFrontSide);
//                                         },
//                                         child: _buildItemWidget(
//                                           'Download Image',
//                                           Icons.cloud_download,
//                                           Colors.blue,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   if (deliveryBoy!.liquorLicenseDetails!.isApproved == '0')
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             _updateDeliveryBoyBloc.add(UpdateLiquorLicenseEvent(editDeliveryBoyData: {'mobile_no': deliveryBoy!.mobileNo, 'status': '1'}));
//                                           },
//                                           child: _buildItemWidget(
//                                             'Approve',
//                                             Icons.check_circle,
//                                             Colors.green,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         InkWell(
//                                           onTap: () {
//                                             _updateDeliveryBoyBloc.add(UpdateLiquorLicenseEvent(editDeliveryBoyData: {'mobile_no': deliveryBoy!.mobileNo, 'status': '2'}));
//                                           },
//                                           child: _buildItemWidget(
//                                             'Disapprove',
//                                             Icons.cancel,
//                                             Colors.red,
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   else if (deliveryBoy!.liquorLicenseDetails!.isApproved == '1')
//                                     Row(
//                                       children: [
//                                         _buildItemWidget(
//                                           'Approved',
//                                           Icons.done_all,
//                                           Colors.green,
//                                         ),
//                                       ],
//                                     )
//                                   else if (deliveryBoy!.liquorLicenseDetails!.isApproved == '2')
//                                     Row(
//                                       children: [
//                                         _buildItemWidget(
//                                           'Disapproved',
//                                           Icons.cancel,
//                                           Colors.red,
//                                         ),
//                                       ],
//                                     )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                   ],
//                 ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16),
//                 child: Card(
//                   color: Colors.grey.shade100,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   elevation: 5,
//                   child: ExpansionTile(
//                     initiallyExpanded: true,
//                     title: Text(
//                       'Vehicle Details',
//                       style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//                         fontSize: 16,
//                         fontColor: Colors.black,
//                       ),
//                     ),
//                     subtitle: Row(
//                       children: [
//                         Text(
//                           'Registration No :',
//                           style: ProjectConstant.WorkSansFontRegularTextStyle(
//                             fontSize: 13,
//                             fontColor: Colors.grey,
//                           ),
//                         ),
//                         Text(
//                           '${deliveryBoy!.vehicleDetails.registrationNo}',
//                           style: ProjectConstant.WorkSansFontRegularTextStyle(
//                             fontSize: 14,
//                             fontColor: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     childrenPadding: EdgeInsets.symmetric(horizontal: 12.0),
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 'Vehicle Name: ',
//                                 style: ProjectConstant.WorkSansFontRegularTextStyle(
//                                   fontSize: 14,
//                                   fontColor: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 deliveryBoy!.vehicleDetails.vehicleName,
//                                 style: ProjectConstant.WorkSansFontMediumTextStyle(
//                                   fontSize: 15,
//                                   fontColor: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 'Vehicle Model: ',
//                                 style: ProjectConstant.WorkSansFontRegularTextStyle(
//                                   fontSize: 14,
//                                   fontColor: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 deliveryBoy!.vehicleDetails.vehicleModel,
//                                 style: ProjectConstant.WorkSansFontMediumTextStyle(
//                                   fontSize: 15,
//                                   fontColor: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 'Vehicle Color: ',
//                                 style: ProjectConstant.WorkSansFontRegularTextStyle(
//                                   fontSize: 14,
//                                   fontColor: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 deliveryBoy!.vehicleDetails.vehicleColor,
//                                 style: ProjectConstant.WorkSansFontMediumTextStyle(
//                                   fontSize: 15,
//                                   fontColor: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             showImage(ProjectConstant.vehicle_images_path + deliveryBoy!.vehicleDetails.frontRegistCerti);
//                                           },
//                                           child: _buildItemWidget(
//                                             'View Front Side',
//                                             Icons.image,
//                                             Colors.pink,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         InkWell(
//                                           onTap: () {
//                                             downloadFile(ProjectConstant.vehicle_images_path + deliveryBoy!.vehicleDetails.frontRegistCerti);
//                                           },
//                                           child: _buildItemWidget(
//                                             'Download Front Side',
//                                             Icons.cloud_download,
//                                             Colors.blue,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       width: 30,
//                                     ),
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             showImage(ProjectConstant.vehicle_images_path + deliveryBoy!.vehicleDetails.backRegistCerti);
//                                           },
//                                           child: _buildItemWidget(
//                                             'View Back Side',
//                                             Icons.image,
//                                             Colors.pink,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         InkWell(
//                                           onTap: () {
//                                             downloadFile(ProjectConstant.vehicle_images_path + deliveryBoy!.vehicleDetails.backRegistCerti);
//                                           },
//                                           child: _buildItemWidget(
//                                             'Download Back Side',
//                                             Icons.cloud_download,
//                                             Colors.blue,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               if (deliveryBoy!.vehicleDetails.isApproved == '0')
//                                 Row(
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         _updateDeliveryBoyBloc.add(UpdateVehicleCertificateEvent(editDeliveryBoyData: {'mobile_no': deliveryBoy!.mobileNo, 'status': '1'}));
//                                       },
//                                       child: _buildItemWidget(
//                                         'Approve',
//                                         Icons.check_circle,
//                                         Colors.green,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         _updateDeliveryBoyBloc.add(UpdateVehicleCertificateEvent(editDeliveryBoyData: {'mobile_no': deliveryBoy!.mobileNo, 'status': '2'}));
//                                       },
//                                       child: _buildItemWidget(
//                                         'Disapprove',
//                                         Icons.cancel,
//                                         Colors.red,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               else if (deliveryBoy!.vehicleDetails.isApproved == '1')
//                                 Row(
//                                   children: [
//                                     _buildItemWidget(
//                                       'Approved',
//                                       Icons.done_all,
//                                       Colors.green,
//                                     ),
//                                   ],
//                                 )
//                               else if (deliveryBoy!.vehicleDetails.isApproved == '2')
//                                 Row(
//                                   children: [
//                                     _buildItemWidget(
//                                       'Disapproved',
//                                       Icons.cancel,
//                                       Colors.red,
//                                     ),
//                                   ],
//                                 )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _showSnackMessage(String message, Color color, [int seconds = 3]) {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         duration: Duration(seconds: seconds),
//       ),
//     );
//   }
//
//   Container _buildItemWidget(String text, IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.all(15),
//       decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         children: [
//           Icon(
//             icon,
//             size: 28,
//             color: color,
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Text(
//             text,
//             style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
//               fontSize: 15,
//               fontColor: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showImage(String imageFile) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenHeight = mediaQuery.size.height;
//     final screenWidth = mediaQuery.size.width;
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           titlePadding: EdgeInsets.zero,
//           insetPadding: EdgeInsets.zero,
//           contentPadding: EdgeInsets.zero,
//           buttonPadding: EdgeInsets.zero,
//           actionsPadding: EdgeInsets.zero,
//           backgroundColor: Colors.transparent,
//           content: Container(
//             padding: EdgeInsets.symmetric(vertical: 8),
//             height: screenHeight,
//             width: screenWidth,
//             child: Stack(
//               clipBehavior: Clip.antiAlias,
//               children: [
//                 SizedBox(
//                   height: screenHeight,
//                   width: screenWidth,
//                   child: CachedNetworkImage(
//                     imageUrl: '../$imageFile',
//                     placeholder: (context, url) => SkeletonView(),
//                     errorWidget: (context, url, error) => ImageErrorWidget(),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 Positioned(
//                   top: -5,
//                   right: 0,
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: IconButton(
//                       onPressed: () {
//                         Navigator.of(ctx).pop();
//                       },
//                       icon: Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void downloadFile(String url) {
//     AnchorElement anchorElement = new AnchorElement(href: url);
//     anchorElement.download = url;
//     anchorElement.click();
//   }
// }
