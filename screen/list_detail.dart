import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screen/add_detail.dart';

class ListDetail extends StatefulWidget {
  const ListDetail({Key? key}) : super(key: key);

  @override
  State<ListDetail> createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {

  final Stream<QuerySnapshot> detailsStream =
  FirebaseFirestore.instance.collection('detail').snapshots();

  // For Deleting User
  CollectionReference detail =
  FirebaseFirestore.instance.collection('detail');

   final  nameController = TextEditingController();
  final  emailController = TextEditingController();
   final  phoneController = TextEditingController();



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("List Detail"),
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        width: double.infinity,

        child: Center(
          child:StreamBuilder<QuerySnapshot>(
              stream: detailsStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('Something went Wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final List detaildocs = [];
                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map a = document.data() as Map<String, dynamic>;
                  detaildocs.add(a);
                  a['id'] = document.id;
                }).toList();

                return ListView.builder(

                    itemCount: detaildocs.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>Container(
                      height: MediaQuery.of(context).size.height/4,
                      child: InkWell(
                        onTap: (){
                          nameController.text=detaildocs[index]['name'];
                          emailController.text=detaildocs[index]['email'];
                          phoneController.text=detaildocs[index]['phone'];
                          print(detaildocs[index]['name']);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddDetail(
                            flag: true,name: nameController,email:emailController,phone:phoneController,)));


                        },
                        child: Card(
                          elevation: 10,

                          margin: const EdgeInsets.all(15),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(Icons.account_circle,color: Colors.orange,),
                                title:Text(detaildocs[index]['name'],style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                    fontSize: 20
                                ),) ,

                              ),
                              ListTile(
                                leading: Icon(Icons.email,color: Colors.orange,),
                                title:Text(detaildocs[index]['email'],style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                    fontSize: 20
                                ),) ,
                              ),

                              ListTile(
                                leading: Icon(Icons.phone,color: Colors.orange,),
                                title:Text(detaildocs[index]['phone'],style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                    fontSize: 20
                                ),) ,
                              ),

                            ],
                          ),


                        ),
                      ),
                    ) );
              }
          ),

        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddDetail(
          flag: false,name:nameController ,email:emailController ,phone: phoneController,)))

      ),
    );


  }


}
