import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teledoctor/cubit/app_cubit.dart';
import 'package:teledoctor/cubit/app_state.dart';
import 'package:teledoctor/shared/component/components.dart';
import 'package:teledoctor/shared/constants/constants.dart';

class EditAccountScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var idController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var jopController = TextEditingController();
  var accountTypeController=TextEditingController();
  var formKey = GlobalKey<FormState>();

  final List<String> types = [
    'Doctor',
    'Nurse',
  ];
  String? typeSelectedValue;



  @override
  Widget build(BuildContext context) {

    return  BlocConsumer<AppCubit,AppState>(
        listener:(context,state){} ,
        builder:(context,state)
        {

          var cubit=AppCubit.get(context);
          Size size=MediaQuery.of(context).size;
          return Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.white,
                  child: Stack(

                    alignment: Alignment.topCenter,
                    children:
                    [
                      Container(
                        height: size.height*.43,
                        width: double.infinity,
                        child: Stack(
                          children:
                          [
//background
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset('images/doctor.jpg', fit: BoxFit.cover),
                                  ClipRRect( // Clip it cleanly.
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                      child: Container(
                                        color:blue5.withOpacity(0.3),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:10,
                                        vertical: 70
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration
                                            (
                                              color:blue5,
                                              borderRadius: BorderRadius.circular(25)
                                          ),
                                          child: IconButton(
                                              onPressed: ()
                                              {
                                                Navigator.pop(context);
                                              },
                                              icon:Icon(Icons.arrow_back,
                                                color: Colors.white,
                                                size: 25,)
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0,left: 65),
                                          child: Text('Edit Account',style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:FontWeight.w600 ,
                                              fontSize: 22

                                          ),),
                                        ),
                                      ],
                                    ),
                                  ),



                                ],
                              ),
                            ),

//image
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: size.height*.22),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50) ,
                                      topLeft: Radius.circular(50)
                                  )
                              ),
                            ),





                          ],
                        ),
                      ),
                      //image
                      Padding(
                        padding:EdgeInsets.only(top:size.height*.14 ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 73.0,
                            backgroundImage:AssetImage('images/profile.jpeg'),
                          ),
                        ),
                      ),

                      //Email Form Fields
                      Padding(
                          padding:EdgeInsets.only(top:size.height*.34,
                              left:size.width*.08 ,
                              right:size.width*.08   ),
                          child: defaultFormFeild1(
                              validatorText: 'Email must not be empty',
                              controller: emailController,
                              inputType: TextInputType.emailAddress,
                              labelText: 'Email'
                          )

                      ),
                      //Name Form Fields
                      Padding(
                          padding:EdgeInsets.only(top:size.height*.43,
                              left:size.width*.08 ,
                              right:size.width*.08   ),
                          child: defaultFormFeild1(
                              validatorText: 'Name must not be empty',
                              controller: nameController,
                              inputType: TextInputType.name,
                              labelText: 'Name'
                          )

                      ),

                      //Phone Form Fields
                      Padding(
                          padding:EdgeInsets.only(top:size.height*.53,
                              left:size.width*.08 ,
                              right:size.width*.08   ),
                          child: defaultFormFeild1(
                              validatorText: 'Phone Number must not be empty',
                              controller: phoneController,
                              inputType: TextInputType.phone,
                              labelText: 'Phone Number'
                          )

                      ),

                      //Password Form Fields
                      Padding(
                          padding:EdgeInsets.only(top:size.height*.63,
                              left:size.width*.08 ,
                              right:size.width*.08   ),
                          child: defaultFormFeild1(
                              controller: passwordController,
                              validatorText: 'Please enter your password',
                              isObsecured:cubit.isObsecured ,
                              suffixIcon: IconButton(
                                  color: Colors.white,
                                  icon: cubit.isObsecured?Icon(Icons.visibility,color: primaryColor,):Icon(Icons.visibility_off,color: primaryColor,),
                                  onPressed: (){
                                    cubit.changeVisibility();
                                  }),
                              inputType: TextInputType.visiblePassword,
                              labelText: 'Password'
                          )

                      ),

                      //Account Type Form Fields
                      Padding(
                        padding:EdgeInsets.only(top:size.height*.73,
                            left:size.width*.08 ,
                            right:size.width*.08   ),
                        child: DropdownButtonFormField2(
                          focusColor: primaryColor,

                          decoration: InputDecoration(

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color:primaryColor,
                                width:2,
                              ),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color:primaryColor,
                                width:3,
                              ),),
                            //Add isDense true and zero Padding.
                            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          isExpanded: true,
                          hint: Text(
                            'Select Account Type',
                            style: TextStyle(fontSize: 22,color:primaryColor,
                            ),

                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color:primaryColor,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: types
                              .map((item) =>
                              DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: primaryColor
                                  ),
                                ),
                              ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select type';
                            }
                          },
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                          },
                          onSaved: (value) {
                            typeSelectedValue = value.toString();
                          },
                        ),


                      ),

                      //Jop Form Fields
                      Padding(
                          padding:EdgeInsets.only(top:size.height*.82,
                              left:size.width*.08 ,
                              right:size.width*.08   ),
                          child: defaultFormFeild1(
                              validatorText: 'Jop must not be empty',
                              controller: jopController,
                              inputType: TextInputType.text,
                              labelText: 'Jop'
                          )

                      ),

                      //buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:EdgeInsets.only(top:size.height*.92,
                                  left:size.width*.05 ,
                                  right:size.width*.03  ),
                              child:defaultButton3(
                                width:170,
                                  string: 'Delete Account',
                                  function: ()
                                  {

                                  }
                              )

                          ),
                          Padding(
                              padding:EdgeInsets.only(
                                left: size.width*.01,
                                  top:size.height*.92,
                                   ),
                              child:defaultButton4(
                                  width:170,
                                  string: 'Save changes',
                                  function: ()
                                  {

                                  }
                              )

                          ),

                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top:size.height*1.2),
                          child:SizedBox(
                            width: 100,
                            height: 10,

                          )                      )






                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}


