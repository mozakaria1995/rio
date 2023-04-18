import 'dart:async';

import 'package:auth_manager/new/base/base_bloc.dart';
import 'package:auth_manager/new/base/base_view.dart';
import 'package:auth_manager/new/model/my_reservations_model.dart';
import 'package:auth_manager/new/model/reservation_model.dart';
import 'package:auth_manager/new/model/reservation_request_model.dart';
import 'package:auth_manager/new/model/reservation_response_model.dart';
import 'package:auth_manager/new/network/network_manager.dart';
import 'package:auth_manager/new/repositories/reservation_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../cache/app_cache.dart';
import '../Payment_web_view/payment_screen.dart';

class HomeBloc extends BaseBloc {
  HomeBloc(BaseView view) : super(view);
  bool isLoading=true;

  ReservationRepo reservationRepo = ReservationRepo();
  StreamController<List<ReservationModel>?> reservationsController =
      BehaviorSubject();
  StreamController<ReservationResponse?> appointmentsByServiceIdController =
      BehaviorSubject();

  StreamController<MyReservationsModel?> myReservationsController =
      BehaviorSubject();

  void getReservations() {
    reservationsController.add(null);
    reservationRepo.getReservationsList().then((response) {
      reservationsController.add(response!.data);
    }, onError: (error) {
      handleError(error);
      if (!reservationsController.isClosed) {
        reservationsController.addError(error);
      }
    });
  }

  void getMyReservationsList() {
    myReservationsController.add(null);
    reservationRepo.getMyReservations().then((response) {
      myReservationsController.add(response!);
    }, onError: (error) {
      handleError(error);
      if (!myReservationsController.isClosed) {
        myReservationsController.addError(error);
      }
    });
  }

  void getReservationsByServiceId(int serviceId) {
    isLoading=true;
    appointmentsByServiceIdController.add(null);
    reservationRepo.getReservationById(serviceId).then((response) {


      appointmentsByServiceIdController.add(response);
      isLoading=false;
    }, onError: (error) {
      if(error is DioError){
        isLoading=false;
      }
      print(error);
      handleError(error);
      if (!appointmentsByServiceIdController.isClosed) {
        isLoading=false;

        appointmentsByServiceIdController.addError(error);
      }
    });
  }

  Future<ReservationResponseModel?> requestCashOnDeliverReservation(
      ReservationRequestModel requestModel) async {
    try {
      view.showProgress();
      final response =
          await reservationRepo.reserveCashOnDeliverReservation(requestModel);
      view.hideProgress();
      if (response != null) {
        return response;
      }
    } catch (error) {
      print(error);
      handleError(error);
    }
    return null;
  }


  Future<ReservationResponseModel?> requestCreditReservation(
      ReservationRequestModel requestModel,context) async {
    try {
      view.showProgress();
      final response =
      await reservationRepo.reserveCreditReservation(requestModel);
      view.hideProgress();
      if (response != null) {
        print(url);
        Navigator.pop(context);
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PaymentScreen(requestModel: requestModel);
        }));
      }
    } catch (error) {
      print(error);
      handleError(error);
    }
    return null;
  }

  Future<bool> cancelReservation(int reservationId) async {
    try {
      view.showProgress();
      final response = await reservationRepo.cancelReservation(reservationId);

      view.hideProgress();
      if (response != null) {
        return true;
      }
    } catch (error) {
      print(error);
      handleError(error);
    }
    return false;
  }

  @override
  void onDispose() {
    reservationRepo.dispose();
    reservationsController.close();
    myReservationsController.close() ;
    appointmentsByServiceIdController.close();
  }
}
