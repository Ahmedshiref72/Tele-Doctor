import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:teledoctor/cubit/app_cubit.dart';
import 'package:teledoctor/models/patient_model.dart';
import 'package:teledoctor/models/user_model.dart';
import 'package:teledoctor/modules/admin_modules/edit_account_screen.dart';
import 'package:teledoctor/shared/component/components.dart';
import '../../shared/constants/constants.dart';
import 'checkout_screen.dart';




class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String name = "";

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body:
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    EdgeInsets.only(top: 7.0, left: size.width * .1),
                    child: Text(
                      'Check Out ',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '    Search... ',
                  suffixIcon: Icon(
                    Icons.search,
                  ),
                  suffixStyle: TextStyle(
                      color: primaryColor
                  ),
                  suffixIconColor:primaryColor ,

                  labelStyle: GoogleFonts.laila(
                    fontSize: 22,
                    color:primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
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
                    ),
                  ),
                ),

                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('patients').snapshots(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                        PatientModel model=PatientModel.fromJson(data);



                        if (name.isEmpty) {
                          return Container();

                        }
                        if (
                        data['name']
                            .toString()
                            .toLowerCase()
                            .startsWith(name.toLowerCase())) {
                          return InkWell(
                              onTap: (){
                                navigateTo(context,
                                    CheckOutScreen(model:model,
                                    ));
                              },
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder:(context,index)=>
                                    buildItem(context,model,index),
                                separatorBuilder:(context,index)=>SizedBox(height:8,) ,
                              )
                          );
                        }
                        return Container();
                      });
                },
              ),
            ),
          ],
        ));
  }
}

Widget buildItem(context,PatientModel model,index)=>InkWell(
  onTap: (){
    navigateTo(context,
        CheckOutScreen(model:model,
        ));
  },
  child:   Card(
    color: Colors.grey[100],

    elevation: 5,

    shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.all(

            Radius.circular(15))),

    //  color: Colors.blue,

    child: Padding(

      padding: const EdgeInsets.only(

        right: 12, left:12,),

      child: Container(

        child: Row(

          children: [
            //image
            Container(

              width:80 ,

              height:85 ,

              decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(6),

                  border: Border.all(

                    width: 6,

                    color:Colors.white,

                  )

              ),

              child:Center(

                child: Image(image: AssetImage('images/profile.jpeg',),
                  fit: BoxFit.fill,

                  width:100 ,

                  height:100 ,

                ),

              ),

            ),

            SizedBox(

              width: 10.0,

            ),

            Expanded(

              child: Column(

                crossAxisAlignment:

                CrossAxisAlignment.start,

                children: [

                  SizedBox(

                    height: 5,

                  ),

                  Text(

                    model.name.toString(),

                    style: TextStyle(

                        fontSize: 16.0,

                        fontWeight:

                        FontWeight

                            .bold),

                    maxLines: 1,

                    overflow: TextOverflow

                        .ellipsis,

                  ),

                  Text(

                    '${DateFormat("yyyy-MM-dd").format(DateTime.parse(model.registeredDate.toString()))}',

                    style: TextStyle(

                      color: Colors.grey,

                      fontSize: 13.0,

                      fontWeight:

                      FontWeight.w200,

                    ),

                    maxLines: 1,

                    overflow: TextOverflow

                        .ellipsis,

                  ),

                  Row(

                    children: [

                      Text(

                      ' Room No : ${model.roomNo.toString()}',

                        style: TextStyle(color:primaryColor),

                      ),

                      Spacer(),

                      TextButton(

                        child:

                        Text('Check Out'),

                        onPressed: () {

                          navigateTo(context,
                              CheckOutScreen(model:model,
                              ));

                        },

                      ),
                    ],
                  ),
                ],

              ),

            ),

          ],

        ),

      ),

    ),

  ),
);