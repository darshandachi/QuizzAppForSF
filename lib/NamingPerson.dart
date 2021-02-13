

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'View1.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';


class NamingPerson extends StatefulWidget {
  @override
  _NamingPersonState createState() => _NamingPersonState();
}

class _NamingPersonState extends State<NamingPerson> {
 TextEditingController name = TextEditingController();
   bool _isLoading = false;
 // for message pop code
 simpleMessage(String message){
   return showDialog(context: context,
       builder: (BuildContext context){
         return SimpleDialog(
           children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text(message.toString()),
             ),
             TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))
           ],
         );
       }
   );
 }


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Hive.box<String>("PersonName").clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body:_isLoading == true ? Container(
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your login credentials are processing"),
              CircularProgressIndicator(),
            ],
          ),
        )
      ) : Center(
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Quiz",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
                      Text("App",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.blue),)
                    ],
                  ),
                  SizedBox(height: 100,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Hi , Let's start quizz.Please add your name to proceed further.",style: TextStyle(color:Colors.black,fontSize: 20),),
                    ),
                  ),
                  SizedBox(height:20),
                  TextFormField(


                    decoration: InputDecoration(

                        icon: Icon(Icons.person),
                        hintText:"Enter your name"
                    ),
                    onChanged: (value){
                      this.name.text = value;
                    },
                  ),
                  SizedBox(height:20),
                  FlatButton(onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      if(name.text.length != 0){
                        try{
                          final result = await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

                            await FirebaseAuth.instance.signInAnonymously();
                            Hive.box<String>("PersonName").add(name.text.toString());
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => View1()), (route) => false);
                          }
                        }on SocketException catch (_) {
                          setState(() {
                            _isLoading = false;
                          });
                          simpleMessage("No internet connection please try after connecting on internet.");
                        }



                      }else{
                        simpleMessage("Please add your name and continue.");
                      }

                    }catch(e){
                      setState(() {
                        _isLoading = false;
                      });
                      simpleMessage(e.toString());
                    }

                  }, child: Text("Start Quiz"),color: Colors.orange,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)
                ],
              )
            ),
          ),
        ),
      )
    );
  }
}
