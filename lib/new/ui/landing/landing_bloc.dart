import 'dart:async';

import 'package:auth_manager/new/base/base_bloc.dart';
import 'package:auth_manager/new/base/base_view.dart';
import 'package:auth_manager/new/model/spicialties_response_model.dart';
import 'package:auth_manager/new/repositories/specialties_repo.dart';
import 'package:rxdart/rxdart.dart';

class LandingBloc extends BaseBloc {
  LandingBloc(BaseView view) : super(view);
  SpecialtiesRepo specialtiesRepo = SpecialtiesRepo();
  StreamController<SpecialtiesResponse?> specialtiesController = BehaviorSubject();



  void getSpecialties() {
    print("hello there");
    specialtiesRepo.getSpecialtiesList().then((response) {
      print("ziko"+response.toString());
      specialtiesController.add(response);
    }, onError: (error) {
      print("zzzzzzzzzz");
      handleError(error);
      if (!specialtiesController.isClosed) {
        specialtiesController.addError(error);
      }
    });
  }

  @override
  void onDispose() {
    specialtiesController.close();
    specialtiesRepo.dispose();
  }
}
