
import 'package:auth_manager/new/base/base_bloc.dart';
import 'package:auth_manager/new/base/base_view.dart';
import 'package:auth_manager/new/cache/app_cache.dart';
import 'package:auth_manager/new/model/doctor_info_model.dart';
import 'package:auth_manager/new/repositories/doctor_details_repo.dart';

class SplashBloc extends BaseBloc {
  SplashBloc(BaseView view) : super(view);

  ClinicDetailsRepo clinicDetailsRepo = ClinicDetailsRepo();
  void getClinicInfo(Function(bool loaded) onLoadedSuccessfully ) {
    clinicDetailsRepo.getClinicBasicInfo().then((response) {
      if (response != null) {
        print(response.data!.clinicName);
        print("hey");

        AppCache.instance.setClinicInfo(response);
        onLoadedSuccessfully(true);
      } else {
        AppCache.instance.setClinicInfo(ClinicInfoModel(
            data: Data(
              address: "",
              clinicInfo: "",
              clinicName: "",
              email: "",
              id: -1,
              imagesGallery:[],
              introVideo: "",
              lat: "",
              lng: "",
              number1: "",
              number2: "",
              whatsapp: "",
              specialty1: "",
              number3: "",
              number4: "",
              specialty2: "",
              specialty3: "",
              specialty4: "",
            )));
      }
    }, onError: (error) {
      print("there is error");
      print(error);
      handleError(error);
    });
  }
  @override
  void onDispose() {
    clinicDetailsRepo.dispose();
  }

}