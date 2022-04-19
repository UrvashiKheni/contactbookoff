
import 'package:contactbookoff/updatepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'DbHelper.dart';
import 'insertpage.dart';

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  _viewpageState createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {


  Database? db;

  List<Map> list = [];

  List<Map> searchlist = [];

  bool ready = false ;

  bool search = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getalldata();

  }

  getalldata()
  {
    DbHelper dbHelper = DbHelper();

    dbHelper.createdatabase().then((value)
    async
    {

      db = value;

      String qry = "select * from contactbook";
      list = await db!.rawQuery(qry);
      ready = true;
      setState(() {

      });
      print(list);

      searchlist = list;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: search
          ? AppBar(
        title: TextField(
          onChanged: (value) {
            if(value.isEmpty)
            {
              searchlist = list;
            }
            else
            {
              searchlist = [];
              for(int i = 0;i<list.length;i++)
              {
                Map m = list[i];
                if(m['name'].toString().toLowerCase().contains(value.toLowerCase().trim())
                    ||
                    m['contact'].toString().toLowerCase().contains(value.toLowerCase().trim()))
                {
                  searchlist.add(m);
                }
              }
            }
            setState(() {});
          },
          autofocus: true,
          decoration: InputDecoration(
              prefix: Icon(Icons.search),
              suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      search = false;
                    });
                  }, icon: Icon(Icons.close))
          ),
        ),
      ) : AppBar(
        title: Text("search"),
        actions: [
          IconButton(onPressed: () {
            setState(() {
              search = true;
            });
          }, icon: Icon(Icons.search))
        ],
      ),
      body: ready ? ListView.builder(
        itemCount: search ? searchlist.length : list.length,
        itemBuilder: (context, index) {
          Map m = search ? searchlist[index] : list[index];
          return Container(
            padding: EdgeInsets.all(6),
            child: ListTile(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Update or Delete"),
                      content: Text("Please select your choice..."),
                      actions: [
                        TextButton.icon(onPressed: ()  {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return updatepage(m);
                          },));
                        },
                            icon: Icon(Icons.edit),
                            label: Text("Update")),
                        TextButton.icon(onPressed: () async {
                          Navigator.pop(context);

                          int id = m['id'];

                          String qry = "delete from contactbook where id  = '$id'";
                          await db!.rawDelete(qry);

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return viewpage();
                          },));

                        },
                            icon: Icon(Icons.delete),
                            label: Text("Delete")),
                      ],
                    );
                  },);
              },
              tileColor: Colors.black12,
              leading: Text("${m['id']}"),
              title: Text("${m['name']}"),
              subtitle: Text("${m['contact']}"),
            ),
          );
        },
      ) : Center(
          child: CircularProgressIndicator()
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return insertpage();
        },));
      },
        child: Icon(Icons.add),
      ),
    );
  }
}
