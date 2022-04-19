
import 'package:contactbookoff/viewpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'DbHelper.dart';

class insertpage extends StatefulWidget {
  const insertpage({Key? key}) : super(key: key);

  @override
  _insertpageState createState() => _insertpageState();
}

class _insertpageState extends State<insertpage> {

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

    DbHelper dbHelper = DbHelper();

    dbHelper.createdatabase().then((value) {
      db = value;
    });

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text("create contact"),
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
                String name = tname.text;
                String contact= tcontact.text;
                String email= temail.text;
                String password= tpassword.text;

                if(email.isEmpty)
                {
                  setState(() {
                    message = "please enter email";
                    emailerror = true;
                  });
                }
                else if(! RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email))
                {
                  setState(() {
                    message = "please enter valid email";
                    emailerror = true;
                  });
                }
                else
                {
                  String qry = "insert into contactbook (name,contact,email,password) values ('$name','$contact','$email','$password')";
                  int i = await db!.rawInsert(qry);
                  print(i);

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return viewpage();
                  },));
                }
              }, child: Text("save"))
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
