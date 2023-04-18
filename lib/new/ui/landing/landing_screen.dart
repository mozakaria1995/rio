import 'package:auth_manager/new/base/base_state.dart';
import 'package:auth_manager/new/model/spicialties_response_model.dart';
import 'package:auth_manager/new/ui/drawer/drawer_screen.dart';
import 'package:auth_manager/new/ui/home/home_screen.dart';
import 'package:auth_manager/new/ui/landing/landing_bloc.dart';
import 'package:auth_manager/new/ui/previous_transactions/previous_transactions_screen.dart';
import 'package:auth_manager/new/ui/staff_list/staff_list_screen.dart';
import 'package:auth_manager/new/ui/videos/videos_screen.dart';
import 'package:auth_manager/new/utils/resoures/color_manager.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../_profile/profile_screen.dart';
import '../../widgets/Custom_appBar_widget.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends BaseState<LandingScreen, LandingBloc> {
  @override
  void initBloc() {
    bloc = LandingBloc(this);
  }

  @override
  void initState() {
    super.initState();
    assignSpecialtiesList();
  }

  int tabIndex = 0;
  final titles = [
    "الرئيسية",
    "تعرف علي طاقمنا الطبي",
    "الحجوزات و المعاملات",
    "فيديوهات و مقالات خاصة ب",
    "أخري"
  ];
  var items = [
    HomeScreen(),
    StaffListScreen(),
     PreviousTransactionsScreen(),
    ProfileScreen(),
  ];
  List<Specialty>? specialtiesList = [];

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.scaffoldBackGround,
      key: _key,
      appBar: CustomAppBar(
        title: titles[tabIndex],
        onDrawerIconClicked: () => _key.currentState!.openDrawer(),
        onSearchClicked: () {
          print("ss");
        },
      ),
      bottomNavigationBar:BottomNavigationBar(
        backgroundColor: ColorManager.white,
        selectedItemColor: ColorManager.primary,
        unselectedItemColor: ColorManager.secondary,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clinicMedical),
            label: 'Clinic',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.hospitalUser),
            label: 'Hospital',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.fileMedicalAlt),
            label: 'File',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.video),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userEdit),
            label: 'Edit',
          ),
        ],
        currentIndex: tabIndex,
        onTap: (int i) => changeTabIndex(i),
      ),
      body: items[tabIndex],
      drawer: Drawer(
        child: CustomDrawer(specialtiesList: specialtiesList ?? []),
      ),
    );
  }

  void changeTabIndex(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  void assignSpecialtiesList() {
    bloc.getSpecialties();
    print("XXXXXX");

    bloc.specialtiesController.stream.listen((event) {
      setState(() {
        print("qwqwqwqwq");

        specialtiesList = event?.specialtiesList ?? [];
        print("ZZZ"+specialtiesList.toString());
        items.insert(3, VideosScreen(specialtiesList: specialtiesList));
      });
    });
  }
}
class Style extends StyleHook {
  @override
  double get activeIconSize => 30;

  @override
  double get activeIconMargin => 5;

  @override
  double get iconSize => 20;


  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 20, color: color);
  }
}