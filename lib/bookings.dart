import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:hotel_search/model.dart';
import 'package:secure_random/secure_random.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';



class BookScreen extends StatefulWidget {
  @override
  book createState() => book();
}

class book extends State<BookScreen> with AutomaticKeepAliveClientMixin {
Future data1;
Future data2;
Future  data3;
var user_email22;

Future<String> updatemail()async {
 
 SharedPreferences user_info = await SharedPreferences.getInstance();
    user_email22 = user_info.getString('user_email');

    print("============================================================== after ================"+ user_email22);
 
    return user_email22;
}
 

  @override
  void initState() {
    super.initState();

 data1 =  updatemail() ;
 user_email22 =  updatemail() ;

  }

   
  String userId;
  var secureRandom = SecureRandom();
    checkPreparing()    {

    var docSnapshot = FirebaseFirestore.instance
        .collection('bookings')
        .where('customer', isEqualTo: user_email22.toString());

    var docSnapshot2 =
        docSnapshot.where('status2', isEqualTo: 'preparing').snapshots();

    return docSnapshot2;
  }

  checkCancelled() {
    var docSnapshot = FirebaseFirestore.instance
        .collection('bookings')
        .where('customer', isEqualTo:  user_email22.toString()); 

    var docSnapshot2 =
        docSnapshot.where('status2', isEqualTo: 'cancelled').snapshots();

    return docSnapshot2;
  }

  checkPast() { 
    var docSnapshot = FirebaseFirestore.instance
        .collection('bookings')
        .where('customer', isEqualTo:  user_email22.toString());

    var docSnapshot2 =
        docSnapshot.where('status2', isEqualTo: 'past').snapshots();

    return docSnapshot2;
  }

  @override
  Widget build(BuildContext context) {
      super.build(context);

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              labelColor: Colors.black,
              indicatorColor: Color(0xff008d4b),
              labelStyle: TextStyle(fontSize: 13, fontFamily: 'Montserrat'),
              tabs: [
                Tab(
                  text: "Upcoming",
                ),
                Tab(text: "Cancelled"),
                Tab(text: "Past"),
              ],
            ),
            title: Text('My Bookings',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                )),
          ),
          body: TabBarView(
            children: [
              Container(
                  color: Colors.grey[100],
                  child: StreamBuilder<dynamic>(
                      stream: checkPreparing(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.documents.isEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<MyModel>(
                                    builder: (context, myModel, children) {
                                  userId = myModel.customer;

                                  return Container(
                                      child: Container(
                                          child: Image.asset(
                                    "assets/images/sunbird_white.png",
                                    width: 300,
                                    height: 80,
                                    fit: BoxFit.contain,
                                  )));
                                }),
                                SizedBox(height: 25),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                      "You currently dont have \n any upcoming stays at our Hotels",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Montserrat'),
                                    )))
                              ],
                            );
                          } else if (snapshot.data.documents.isNotEmpty) {
                            return SingleChildScrollView(
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.of(context).size.height -
                                              160,
                                    ),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.all(24),
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    DocumentSnapshot
                                                        thesnapshot = snapshot
                                                            .data.docs[index];

                                                    return Dismissible(
                                                      key: ObjectKey(snapshot
                                                          .data.documents
                                                          .elementAt(index)),
                                                      onDismissed: (direction) {
                                                        // Remove the item from the data source.

                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "bookings")
                                                            .doc(thesnapshot
                                                                .reference.id)
                                                              .update({"status2" :"cancelled"});
                                                        setState(() {
                                                          snapshot
                                                              .data.documents
                                                              .removeAt(index);
                                                        });

                                                        // Then show a snackbar.
                                                        // Scaffold.of(context)
                                                        //.showSnackBar(SnackBar(content: Text(thesnapshot.data()["first_name"] + ' ' + thesnapshot.data()["last_name"] + ' ' + 'was removed')));
                                                      },
                                                      background: Container(
                                                        color:
                                                            Colors.orangeAccent,
                                                        height: 150,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                      ),
                                                      child: ShowUpAnimation(
  delayStart: Duration(seconds: 0),
  animationDuration: Duration(seconds: 1),
  child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset: Offset(
                                                                    0,
                                                                    1), // changes position of shadow
                                                              )
                                                            ], borderRadius: BorderRadius.circular(10)),
                                                        child: Row(
                                                            children: <Widget>[

                                                             Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <
                                                                      Widget>[
                                                                   
                                                                   
                                                                    Container( padding: EdgeInsets.all(15),
                                                                      decoration: BoxDecoration(
   
  ),

                                                                  child:Image.asset("img/hotel.png", width:50, height:50, fit:BoxFit.cover,color: Color(0xff008d4b))





                                                                    )
                                                                    
                                                                    
                                                                    
                                                                    ]
                                                                    )
                                                                    ,


                                                               Container(     padding: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                10,
                                                                            bottom:
                                                                                0)    ,      
                                                              child:Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <
                                                                      Widget>[
                                                                    Container( 
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          thesnapshot
                                                                              .data()["hotel_name"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          "" +
                                                                              thesnapshot.data()["booking_dates"].toString(),
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.w500,
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontSize:
                                                                                13,
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                        width:
                                                                            200,
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        child: thesnapshot.data()["status1"] ==
                                                                                'pending'
                                                                            ? Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: <
                                                                      Widget>[
                                                                   
                                                                        Container(child: Text(
                                                                                "Status: ",
                                                                                style: TextStyle(color: Colors.grey[900], fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600),
                                                                              )),
                                                                        Container(
                                                                          padding: EdgeInsets.all(2),
                                                                             decoration: BoxDecoration(color:Colors.orangeAccent,
    borderRadius: BorderRadius.all(
        Radius.circular(5.0) //                 <--- border radius here
    ),
  ),
                                                                          
                                                                          
                                                                          
                                                                          child:Text(
                                                                                 "waiting for confirmation",
                                                                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600),
                                                                              ))
                                                                        
                                                                        
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      ]
                                                                      
                                                                      
                                                                      
                                                                      )
                                                                            :  Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: <
                                                                      Widget>[
                                                                   
                                                                        Container(child: Text(
                                                                                "Status: ",
                                                                                style: TextStyle(color: Colors.grey[900], fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600),
                                                                              )),
                                                                        Container(
                                                                          padding: EdgeInsets.all(2),
                                                                             decoration: BoxDecoration(color:Colors.green,   
    borderRadius: BorderRadius.all(
        Radius.circular(5.0) //                 <--- border radius here
    ),
  ),
                                                                          
                                                                          
                                                                          
                                                                          child:Text(
                                                                                 "Confirmed",
                                                                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600),
                                                                              ))
                                                                        
                                                                        
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      ]
                                                                      
                                                                      
                                                                      
                                                                      ))
                                                                  ])),
                                                              Spacer(),
                                                               Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <
                                                                      Widget>[
                                                                   
                                                                   
                                                                    Container( padding: EdgeInsets.all(15),
                                                                      decoration: BoxDecoration(
   
  ),

                                                                  child:Image.asset("img/right-arrow.png", width:15, height:15, fit:BoxFit.cover,color: Color(0xff008d4b))





                                                                    )
                                                                    
                                                                    
                                                                    
                                                                    ]
                                                                    )
                                                            ]),
                                                      ),
                                                    key: Key('Slo Mo')));
                                                  }))
                                        ])));
                          }
                        }
                      return Container();})),
              Container(
                color: Colors.grey[100],
                child: StreamBuilder<dynamic>(
                    stream: checkCancelled(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Consumer<MyModel>(
                                  builder: (context, myModel, children) {
                                userId = myModel.customer;

                                return Container(
                                    child: Container(
                                        child: Image.asset(
                                  "assets/images/sunbird_white.png",
                                  width: 300,
                                  height: 80,
                                  fit: BoxFit.contain,
                                )));
                              }),
                              SizedBox(height: 25),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Text(
                                    "You currently dont have \n any cancelled stays at our Hotels",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'Montserrat'),
                                  )))
                            ],
                          );
                        } else if (snapshot.data.documents.isNotEmpty) {
                          return SingleChildScrollView(
                              child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height -
                                            160,
                                  ),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.all(24),
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: snapshot
                                                    .data.documents.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  DocumentSnapshot thesnapshot =
                                                      snapshot.data.docs[index];

                                                  return Dismissible(
                                                    key: ObjectKey(snapshot
                                                        .data.documents
                                                        .elementAt(index)),
                                                    onDismissed: (direction) {
                                                      // Remove the item from the data source.

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "bookings")
                                                          .doc(thesnapshot
                                                              .reference.id)
                                                          .delete();
                                                      setState(() {
                                                        snapshot.data.documents
                                                            .removeAt(index);
                                                      });

                                                      // Then show a snackbar.
                                                      // Scaffold.of(context)
                                                      //.showSnackBar(SnackBar(content: Text(thesnapshot.data()["first_name"] + ' ' + thesnapshot.data()["last_name"] + ' ' + 'was removed')));
                                                    },
                                                    background: Container(
                                                      color:
                                                          Colors.orangeAccent,
                                                      height: 150,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                    ),
                                                    child: ShowUpAnimation(
  delayStart: Duration(seconds: 0),
  animationDuration: Duration(seconds: 1),
  child:Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset: Offset(
                                                                    0,
                                                                    1), // changes position of shadow
                                                              )
                                                            ], borderRadius: BorderRadius.circular(10)),
                                                        child: Row(
                                                            children: <Widget>[

                                                             Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <
                                                                      Widget>[
                                                                   
                                                                   
                                                                    Container( padding: EdgeInsets.all(15),
                                                                      decoration: BoxDecoration(
   
  ),

                                                                  child:Image.asset("img/hotel-cancelled.png", width:50, height:50, fit:BoxFit.cover,)





                                                                    )
                                                                    
                                                                    
                                                                    
                                                                    ]
                                                                    )
                                                                    ,


                                                               Container(     padding: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                10,
                                                                            bottom:
                                                                                0)    ,      
                                                              child:Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <
                                                                      Widget>[
                                                                    Container( 
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          thesnapshot
                                                                              .data()["hotel_name"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          "" +
                                                                              thesnapshot.data()["booking_dates"].toString(),
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.w500,
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontSize:
                                                                                13,
                                                                          ),
                                                                        )),
                                                                    Container( width:200,
                                                                                                                                          padding: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        child: 
                                                                         Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: <
                                                                      Widget>[
                                                                   
                                                                        Container(child: Text(
                                                                                "Status: ",
                                                                                style: TextStyle(color: Colors.grey[900], fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600),
                                                                              )),
                                                                        Container(
                                                                          padding: EdgeInsets.all(2),
                                                                             decoration: BoxDecoration(color:Colors.red,
    borderRadius: BorderRadius.all(
        Radius.circular(5.0) //                 <--- border radius here
    ),
  ),
                                                                          
                                                                          
                                                                          
                                                                          child:Text(
                                                                                 "Cancelled",
                                                                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600),
                                                                              ))
                                                                        
                                                                        
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      ]
                                                                      
                                                                      
                                                                      
                                                                      )
                                                               )])),
                                                              Spacer(),
                                                               Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <
                                                                      Widget>[
                                                                   
                                                                   
                                                                    Container( padding: EdgeInsets.all(15),
                                                                      decoration: BoxDecoration(
   
  ),

                                                                  child:Image.asset("img/right-arrow.png", width:15, height:15, fit:BoxFit.cover,color: Color(0xff008d4b))





                                                                    )
                                                                    
                                                                    
                                                                    
                                                                    ]
                                                                    )
                                                            ]),
                                                      ),
                                                  key: Key('Slo Mo')));
                                                }))
                                      ])));
                        }
                      }
                   return Container(); } 
                    
                    ),
              ),
              Container(
                color: Colors.grey[100],
                child: StreamBuilder<dynamic>(
                    stream: checkPast(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Consumer<MyModel>(
                                  builder: (context, myModel, children) {
                                userId = myModel.customer;

                                return Container(
                                    child: Container(
                                        child: Image.asset(
                                  "assets/images/sunbird_white.png",
                                  width: 300,
                                  height: 80,
                                  fit: BoxFit.contain,
                                )));
                              }),
                              SizedBox(height: 25),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Text(
                                    "You currently dont have \n any past stays at our Hotels",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'Montserrat'),
                                  )))
                            ],
                          );
                        } else if (snapshot.data.documents.isNotEmpty) {
                          return SingleChildScrollView(
                              child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height -
                                            160,
                                  ),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.all(24),
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: snapshot
                                                    .data.documents.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  DocumentSnapshot thesnapshot =
                                                      snapshot.data.docs[index];

                                                  return Dismissible(
                                                    key: ObjectKey(snapshot
                                                        .data.documents
                                                        .elementAt(index)),
                                                    onDismissed: (direction) {
                                                      // Remove the item from the data source.

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "bookings")
                                                          .doc(thesnapshot
                                                              .reference.id)
                                                          .delete();
                                                      setState(() {
                                                        snapshot.data.documents
                                                            .removeAt(index);
                                                      });

                                                      // Then show a snackbar.
                                                      // Scaffold.of(context)
                                                      //.showSnackBar(SnackBar(content: Text(thesnapshot.data()["first_name"] + ' ' + thesnapshot.data()["last_name"] + ' ' + 'was removed')));
                                                    },
                                                    background: Container(
                                                      color:
                                                          Colors.orangeAccent,
                                                      height: 150,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                    ),
                                                    child: ShowUpAnimation(
  delayStart: Duration(seconds: 0),
  animationDuration: Duration(seconds: 1),
  child:Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset: Offset(
                                                                    0,
                                                                    1), // changes position of shadow
                                                              )
                                                            ], borderRadius: BorderRadius.circular(10)),
                                                        child: Row(
                                                            children: <Widget>[

                                                             Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <
                                                                      Widget>[
                                                                   
                                                                   
                                                                    Container( padding: EdgeInsets.all(15),
                                                                      decoration: BoxDecoration(
   
  ),

                                                                  child:Image.asset("img/hotel.png", width:50, height:50, fit:BoxFit.cover,color: Color(0xff008d4b))





                                                                    )
                                                                    
                                                                    
                                                                    
                                                                    ]
                                                                    )
                                                                    ,


                                                               Container(     padding: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                10,
                                                                            bottom:
                                                                                0)    ,      
                                                              child:Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <
                                                                      Widget>[
                                                                    Container( 
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          thesnapshot
                                                                              .data()["hotel_name"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Text(
                                                                          "" +
                                                                              thesnapshot.data()["booking_dates"].toString(),
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.w500,
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontSize:
                                                                                13,
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                        width:
                                                                            200,
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        child: thesnapshot.data()["status1"] ==
                                                                                'pending'
                                                                            ? Text(
                                                                                "Status: " + "Pending",
                                                                                style: TextStyle(color: Colors.grey[900], fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600),
                                                                              )
                                                                            : Text(
                                                                                "Status: " + "Confirmed",
                                                                                style: TextStyle(color: Colors.grey[900], fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600),
                                                                              ))
                                                                  ])),
                                                              Spacer(),
                                                               Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <
                                                                      Widget>[
                                                                   
                                                                   
                                                                    Container( padding: EdgeInsets.all(15),
                                                                      decoration: BoxDecoration(
   
  ),

                                                                  child:Image.asset("img/right-arrow.png", width:15, height:15, fit:BoxFit.cover,color: Color(0xff008d4b))





                                                                    )
                                                                    
                                                                    
                                                                    
                                                                    ]
                                                                    )
                                                            ]),
                                                      ),
                                                  key: Key('Slo Mo')));
                                                }))
                                      ])));
                        }
                      } else {
                        return Container(width: 0.0, height: 0.0);
                      }
                    return Container(); }),
              ),
            ],
          ),
        ),
      ),
    );
  }
@override
   bool get wantKeepAlive => true;}
