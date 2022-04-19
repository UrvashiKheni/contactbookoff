
import 'package:contactbookoff/viewpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'DbHelper.dart';

class updatepage extends StatefulWidget {

  Map<dynamic, dynamic> m;

  updatepage(this.m);


  @override
  _updatepageState createState() => _updatepageState();
}

class _updatepageState extends State<updatepage> {

  TextEditingController tname = TextEditingController();
  TextEditingController tcontact = TextEditingController();
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();


  Database? db;

  bool emailerror = false;

  bool hidepass = true;

  String message = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tname.text = widget.m['name'];
    tcontact.text = widget.m['contact'];
    temail.text = widget.m['email'];
    tpassword.text = widget.m['password'];


    DbHelper dbHelper = DbHelper();

    dbHelper.createdatabase().then((value) {
      db = value;
    });

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("update contact"),
          ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: tname,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter name",
                      labelText: "name"
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  maxLength: 10,
                  controller: tcontact,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter contact",
                      helperText: "Number only",
                      labelText: "contact"
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      emailerror = false;
                    });
                  },
                  controller: temail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText: emailerror ? message : null,
                      hintText: "Enter email",
                      labelText: "email"
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  obscureText: hidepass,
                  maxLength: 8,
                  controller: tpassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidepass = !hidepass;
                            });
                          }, icon: hidepass
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off)),
                      hintText: "Enter paasword",
                      labelText: "password"
                  ),
                ),
              ),
              ElevatedButton(onPressed: ()
              async
              {
                int id = widget.m['id'];
                String newname = tname.text;
                String newcontact= tcontact.text;
                String newemail= temail.text;
                String newpassword= tpassword.text;
                if(newemail.isEmpty)
                {
                  setState(() {
                    message = "please enter email";
                    emailerror = true;
                  });
                }
                else if(!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(newemail))
                {
                  setState(() {
                    message = "Invalid email";
                    emailerror = true;
                  });
                }
                else
                {
                  String qry = "insert into contactbook (name,contact,email,password) values ('$newname','$newcontact','$newemail','$newpassword')";
                  int i = await db!.rawInsert(qry);
                  print(i);

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return viewpage();
                  },));
                }


              }, child: Text("update"))
            ],
          ),
        ), onWillPop: goback);


  }

  Future<bool> goback()
  {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return viewpage();
    },
    ));
    return Future.value();
  }
}
