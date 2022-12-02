abstract class AppState {}

class AppInitial extends AppState {}

class ChangeVisibilityState extends AppState{}

class ChangeOnBoardingState extends AppState{}

class AddUserRegisterLoadingState extends AppState{}

class AddUserRegisterSuccessState extends AppState{}

class AddUserErrorState extends AppState{
  final error;
  AddUserErrorState(this.error);
}

class CreateUserSuccessState extends AppState{}

class CreateUserErrorState extends AppState{
  final error;

  CreateUserErrorState(this.error);
}

class GetAdminsLoadingState extends AppState{}

class GetAdminsSuccessState extends AppState{}

class GetAdminsErrorState extends AppState{
  final error;
  GetAdminsErrorState(this.error);
}

class UpdateAdminDataLoadingState extends AppState{}

class UpdateAdminDataSuccessState extends AppState{}

class UpdateAdminDataErrorState extends AppState{
  final error;
  UpdateAdminDataErrorState(this.error);
}

class DeleteAdminDataLoadingState extends AppState{}

class DeleteAdminDataSuccessState extends AppState{}

class DeleteAdminDataErrorState extends AppState{
  final error;
  DeleteAdminDataErrorState(this.error);
}

class BottomNavigationBarChangedState extends AppState{}


class AddNewRoomSuccessState extends AppState{}

class AddNewRoomErrorState extends AppState{
  final error;
  AddNewRoomErrorState(this.error);
}

class GetAllRoomsLoadingState extends AppState{}

class GetAllRoomsSuccessState extends AppState{}

class GetAllRoomsErrorState extends AppState{
  final error;
  GetAllRoomsErrorState(this.error);
}

class ChangeSelectedRoomState extends AppState{}