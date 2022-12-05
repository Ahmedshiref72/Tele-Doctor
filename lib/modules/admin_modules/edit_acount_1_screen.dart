import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teledoctor/models/user_model.dart';
import 'package:teledoctor/modules/admin_modules/edit_account_screen.dart';
import 'package:teledoctor/shared/component/components.dart';
import '../../shared/constants/constants.dart';




class EditScreen1 extends StatefulWidget {
  const EditScreen1({Key? key}) : super(key: key);

  @override
  State<EditScreen1> createState() => _EditScreen1State();
}

class _EditScreen1State extends State<EditScreen1> {
  String name = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //addData();
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
                  Container(
                    decoration: BoxDecoration(
                        color: blue5,
                        borderRadius: BorderRadius.circular(25)),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 25,
                        )),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 7.0, left: size.width * .1),
                    child: Text(
                      'Search ',
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
                stream: FirebaseFirestore.instance.collection('admins').snapshots(),
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
                        UserModel model=UserModel.fromJson(data);

                        if (name.isEmpty) {
                          return Container();
                        }
                        if (data['name']
                            .toString()
                            .toLowerCase()
                            .startsWith(name.toLowerCase())
                            &&(data['type']=='DOCTOR'||data['type']=='NURSE')) {
                          return InkWell(
                            onTap: (){
                              navigateTo(context, EditAccountScreen(model:model,));
                            },
                            child: ListTile(
                              title: Text(
                                data['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                data['email'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('images/profile.png'
                                ),
                              ),
                            ),
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