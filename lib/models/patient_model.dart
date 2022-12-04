class PatientModel
{
  String? name,age,roomNo,selectedDoctorUID,selectedNurseUID,gender,id,registeredDate;

  PatientModel({
    required this.name,
    required this.age,
    required this.roomNo,
    required this.selectedDoctorUID,
    required this.selectedNurseUID,
    required this.gender,
    required this.id,
    required this.registeredDate,
    //required this.registeredDate

  });

  PatientModel.fromJson(Map <String,dynamic> json)
  {
    name =json['name'];
    age =json['age'];
    roomNo =json['roomNo'];
    selectedDoctorUID =json['selectedDoctorUID'];
    selectedNurseUID =json['selectedNurseUID'];
    gender =json['gender'];
    id =json['id'];
    registeredDate =json['registeredDate'];
  }

  Map <String,dynamic> toMap()
  {
    return {
    'name' :name,
    'age' :age,
    'roomNo':roomNo,
    'selectedDoctorUID':selectedDoctorUID,
    'selectedNurseUID':selectedNurseUID,
    'gender' :gender,
    'id' :id,
    'registeredDate' :registeredDate,

    };
  }

}