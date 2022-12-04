import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teledoctor/models/patient_model.dart';
import 'package:teledoctor/models/room_model.dart';
import 'package:teledoctor/modules/doctor_nurse_modules/doctor_nurse_home_screen.dart';
import '../models/admin_model.dart';
import '../models/user_model.dart';
import '../modules/admin_modules/add_patient_screen.dart';
import '../modules/admin_modules/home_screen.dart';
import '../modules/admin_modules/profile_screen.dart';
import '../modules/admin_modules/receipt_screen.dart';
import '../modules/doctor_nurse_modules/doctor_nurse_notification_screen.dart';
import '../modules/doctor_nurse_modules/doctor_nurse_profile_screen.dart';
import '../modules/doctor_nurse_modules/search_for_petient_screen.dart';
import '../modules/start_modules/login/login_screen.dart';
import '../shared/component/components.dart';
import '../shared/constants/constants.dart';
import '../shared/local/shared_preference.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  //add new user
  void addNewUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String id,
    required String type,
    required String jop,


  }) {
    emit(AddUserRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);
      userCreate(email: email,
          name: name,
          phone: phone,
          uId: value.user?.uid,
          id: id,
          jop: jop,
          type: type,
          password: password);
      emit(AddUserRegisterSuccessState());
    }).catchError((onError) {
      emit(AddUserErrorState(onError.toString()));
    });
  }

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String? uId,
    required String id,
    required String jop,
    required String type,
    required String password


  }) {
    UserModel model = UserModel(
        uId: uId,
        id: id,
        email: email,
        phone: phone,
        name: name,
        jop: jop,
        password: password,
        type: type);
    FirebaseFirestore.instance
        .collection('admins')
        .doc(uId)
        .set(model.toMap()).then((value) {
      emit(CreateUserSuccessState());
    }).catchError((onError) {
      emit(CreateUserErrorState(onError.toString()));
    });
  }


//get user data

  Future<void> getUserData() async {
    emit(GetAdminsLoadingState());

    await FirebaseFirestore.instance.collection('admins').doc(uId).get()
        .then((value) async {
      isSuper = CacheHelper.getData(key: 'isSuper');
      isDoctor = CacheHelper.getData(key: 'isDoctor');
      isAdmin = CacheHelper.getData(key: 'isAdmin');
      isNurse = CacheHelper.getData(key: 'isNurse');
      //if user is Admin
      print(isAdmin);
      print(isDoctor);
      print(isNurse);
      if (isAdmin!) {
        adminModel = AdminModel.fromJson(value.data()!);
        CacheHelper.saveData(key: 'userType', value: adminModel!.type).then((
            value) {
          userType = value.toString().toUpperCase();
          print(userType);
        });
      }
      //if user is Doctor or Nurse
      if (isDoctor! || isNurse!) {
        userModel = UserModel.fromJson(value.data()!);
        print(value.data());
        CacheHelper.saveData(key: 'userType', value: userModel!.type)
            .then((value) {
          userType = value.toString().toUpperCase();
          print(userType);
        });
      }


      emit(GetAdminsSuccessState());
    })
        .catchError((onError) {
      emit(GetAdminsErrorState(onError.toString()));
    });
  }

//
//update admin data
  Future<void> updateUserData({
    required String email,
    required String name,
    required String phone,
    required String uId,
    required String id,
    required String password,
    required String jop,
    required String type,



  }) async {
    emit(UpdateUserDataLoadingState());
    UserModel model = UserModel(
        uId: uId,
        id: id,
        email: email,
        phone: phone,
        name: name,
        jop: jop,
        password: password,
        type: type);



    FirebaseFirestore.instance.collection('admins').doc(uId).update(
        model.toMap())
        .then((value) async
    {
      getAllUsers();
      emit(UpdateUserDataSuccessState());
    }).catchError((onError) {
      emit(UpdateUserDataErrorState(onError.toString()));
    });
  }


//delete admin data
  Future<void> deleteUserData({
    required String uId,
    required String email,
    required String password
  }) async {

    emit(DeleteUserDataLoadingState());
    FirebaseFirestore.instance.collection('admins').doc(uId).delete()
        .then((value)async
    {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.delete();

      getAllUsers();
      emit(DeleteUserDataSuccessState());

    }).catchError((onError)
    {
      emit(DeleteUserDataErrorState(onError.toString()));

    });

  }


  void logOut(context) {
    CacheHelper.removeData(key: 'uId');
    navigateAndEnd(context, LoginScreen());
  }

//get doctors and nurses
  List<UserModel> users = [];
  List<UserModel> doctors = [];
  List<UserModel> nurses = [];

  Future<void> getAllUsers() async {
    users = [];
    doctors = [];
    nurses = [];
    emit(GetAllUsersLoadingState());
    await FirebaseFirestore.instance.collection('admins').get()
        .then((value) async {
      value.docs.forEach((element) {
        users.add(UserModel.fromJson(element.data()));
      });
      users.forEach((element) {
        if (element.type.toString().toUpperCase() == 'DOCTOR') {
          doctors.add(element);
        }
        else if (element.type.toString().toUpperCase() == 'NURSE') {
          nurses.add(element);
        }
      });

      emit(GetAllUsersSuccessState());
    })
        .catchError((onError) {
      emit(GetAllUsersErrorState(onError.toString()));
    });
  }


  bool? isExist = false;

  Future<void> addNewRoom({
    required roomNo,
    required floorNumber,
    required bedsNo,
    required pricePerNight,


  }) async {
    RoomModel model = RoomModel(
        roomNo: roomNo,
        floorNumber: floorNumber,
        bedsNo: bedsNo,
        pricePerNight: pricePerNight,
        roomType: 'EMPTY',
        patientList: []

    );

    try {
      final snapShot = await FirebaseFirestore.instance.collection('rooms')
          .doc(roomNo).get();

      if (snapShot.exists) {
        emit(AddNewRoomErrorState('This room is already exist'));

        isExist = false;
      } else {
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomNo)
            .set(model.toMap())
            .then((value) {
          emit(AddNewRoomSuccessState());
        }).catchError((onError) {
          emit(AddNewRoomErrorState(onError.toString()));
        });
        isExist = true;
      }
    } catch (e) {

    }
  }

  List<RoomModel> rooms = [];
  List<RoomModel> floorNumber1 = [];
  List<RoomModel> floorNumber2 = [];
  List<RoomModel> fullRooms1 = [];
  List<RoomModel> fullRooms2 = [];


  Future<void> getAllRooms() async {
    rooms = [];
    floorNumber1 = [];
    floorNumber2 = [];
    fullRooms1 = [];
    fullRooms2 = [];

    emit(GetAllRoomsLoadingState());
    FirebaseFirestore.instance.collection('rooms').get()
        .then((value) async {
      value.docs.forEach((element) {
        rooms.add(RoomModel.fromJson(element.data()));
      });
      rooms.forEach((element) {
        if (element.floorNumber.toString() == '1'
            &&element.roomType!.toUpperCase().toString() == 'EMPTY') {
          floorNumber1.add(element);
        }
        else if (element.floorNumber.toString() == '2'
            &&element.roomType!.toUpperCase().toString() == 'EMPTY') {
          floorNumber2.add(element);
        }
        else if (element.floorNumber.toString() == '1'
            &&element.roomType!.toUpperCase().toString() == 'FULL') {
          fullRooms1.add(element);
        }
        else if (element.floorNumber.toString() == '2'
            &&element.roomType!.toUpperCase().toString() == 'FULL') {
          fullRooms2.add(element);
        }
      });
      print(floorNumber1[0].roomType);
      emit(GetAllRoomsSuccessState());
    })
        .catchError((onError) {
      emit(GetAllRoomsErrorState(onError.toString()));
    });
  }

  List patientList=[];


  Future<void> addNewPatient({
    required name,
    required age,
    required roomNo,
    required selectedDoctorUID,
    required selectedNurseUID,
    required gender,
    required id,
    required registeredDate,
    required newPatient,


  }) async {
    patientList=[];
    rooms.forEach((element) {
      if (element.roomType.toString().toUpperCase() == 'EMPTY'
          &&element.roomNo.toString() == roomNo) {
        patientList=element.patientList!;



      }

    });
    if(patientList.isNotEmpty)
    {
      patientList.insert(patientList.length,newPatient);


      rooms.forEach((element) async {
        if (element.roomType.toString().toUpperCase() == 'EMPTY'
            &&element.roomNo.toString() == roomNo
            &&element.bedsNo==(patientList.length).toString()) {

          await FirebaseFirestore.instance.collection('rooms')
              .doc(roomNo).update({'roomType':'FULL'});

          // print('${element.bedsNo},,,,:${patientList.length}');

        }

      });

    }
    else
    {
      patientList.insert(0,newPatient);

    }
    print('patientList: ${patientList}');

    await FirebaseFirestore.instance.collection('rooms')
        .doc(roomNo).update({'patientList':patientList});
    PatientModel model = PatientModel(
        name: name,
        age: age,
        roomNo: roomNo,
        selectedDoctorUID: selectedDoctorUID,
        selectedNurseUID: selectedNurseUID,
        gender: gender,
        id: id,
        registeredDate: registeredDate);



    try {
      final snapShot = await FirebaseFirestore.instance.collection('patients')
          .doc(id).get();

      if (snapShot.exists) {
        emit(AddNewPatientErrorState('This patient is already exist'));

        isExist = false;
      } else {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(id)
            .set(model.toMap())
            .then((value) async {

          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(roomNo).update({'patientList':patientList}).then((value)
          {
            print(patientList);

            getAllRooms();
            emit(AddNewPatientSuccessState());

          }).catchError((onError)
          {
            emit(AddNewPatientErrorState(onError.toString()));
          });

        }).catchError((onError) {
          emit(AddNewPatientErrorState(onError.toString()));
        });


        isExist = true;
      }
    } catch (e) {

    }
  }


  List<PatientModel> patients=[];

  Future<void> getAllPatients() async {
    patients = [];

    emit(GetAllPatientsLoadingState());
    await FirebaseFirestore.instance.collection('patients').get()
        .then((value) async {


      value.docs.forEach((element) {


        patients.add(PatientModel.fromJson(element.data()));


      });

      print('patients length${patients.length}');
      emit(GetAllPatientsSuccessState());
    })
        .catchError((onError) {
      emit(GetAllPatientsErrorState(onError.toString()));
    });
  }







  String? floorSelectedValue;

  void changeSelectedRoom({
    required floorSelectedVal
  }) {
    floorSelectedValue = floorSelectedVal;
    print(floorSelectedValue);
    emit(ChangeSelectedRoomState());
  }


  List<Widget> adminLayOutScreens =
  [
    HomeScreen(),
    ReceiptScreen(),
    AddNewPatientScreen(),
    ProfileScreen(),

  ];

  List<Widget> doctorAndNurseLayOutScreens =
  [
    DoctorAndNurseHomeScreen(),
    SearchForPatientScreen(),
    DoctorAndNurseNotificationScreen(),
    DoctorAndNurseProfileScreen(),

  ];

  int currentIndex = 0;

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(BottomNavigationBarChangedState());
  }


  bool isObsecured = true;

  void changeVisibility() {
    isObsecured = !isObsecured;
    emit(ChangeVisibilityState());
  }

  bool isLast = false;

  void changeOnBoarding(index, boardingLength) {
    if (index == boardingLength - 1) {
      isLast = true;
      emit(ChangeOnBoardingState());
    } else {
      isLast = false;
      emit(ChangeOnBoardingState());
    }
  }


  void submit(context) {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value == true) {
        navigateAndEnd(
          context,
          LoginScreen(),
        );
      }
    });
  }


  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

}