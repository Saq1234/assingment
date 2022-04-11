import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screen/list_detail.dart';

class AddDetail extends StatefulWidget {
  AddDetail({Key? key,required this.flag
    ,required this.name,required this.email,required this.phone}) : super(key: key);

  bool flag;


  TextEditingController name;
  TextEditingController email;
  TextEditingController phone;



  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddDetail> {
  final _formKey = GlobalKey<FormState>();

  var name = "";
  var email = "";
  var phone = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
  }

  // Adding Student
  CollectionReference detail =
  FirebaseFirestore.instance.collection('detail');

  Future<void> addUser() {
    return detail
        .add({'name': name, 'email': email, 'phone': phone})
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to Add user: $error'));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:widget.flag==false? Text("Add Detail"):Text("Details"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  enabled: widget.flag==false?true:false,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Name: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                    TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: widget.flag==false?nameController:widget.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  enabled: widget.flag==false?true:false,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Email: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                    TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: widget.flag==false?emailController:widget.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    } else if (!value.contains('@')) {
                      return 'Please Enter Valid Email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  enabled: widget.flag==false?true:false,
                  maxLengthEnforced: true,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  autofocus: false,
                 // obscureText: true,
                  decoration: InputDecoration(
                    counterText: '',

                    hintText: 'Phone: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(

                    ),
                    errorStyle:
                    TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: widget.flag==false?phoneController:widget.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter phone Number';
                    }
                    return null;
                  },
                ),
              ),
              widget.flag==false?Container(
                margin: EdgeInsets.symmetric(vertical: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        name = nameController.text;
                        email = emailController.text;
                        phone = phoneController.text;
                        addUser();
                        clearText();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListDetail()));

                      });
                    }
                  },
                  child:
                  Text(
                    'Add',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ):Container(),
              Container(
                child: Text(""),
              ),

            ],
          ),
        ),
      ),
    );
  }
}