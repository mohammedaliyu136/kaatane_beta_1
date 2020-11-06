import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorSignup extends StatefulWidget {

  @override
  _VendorSignupState createState() => _VendorSignupState();
}

class _VendorSignupState extends State<VendorSignup> {
  int _Page = 1;
  bool restaurantType = false;
  bool deliveryOption = true;
  bool _isLoading = false;
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _rNameController = TextEditingController();
  final TextEditingController _rAddressController = TextEditingController();
  final TextEditingController _deliveryFeeController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Errors"),
      content: Text("please check there are missing values"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading?Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
                )),
            Container(
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Please wait, loading...",
                    style: TextStyle(fontSize: 20,
                        color: Color.fromRGBO(128, 0, 128, 1)),),
                )),
          ],
        ),
      ),
    ):_Page==1?Scaffold(
      appBar: AppBar(title: Text("Step 1 of 2", style: TextStyle(fontSize: 18, color: Colors.white60,),), elevation: 0,),
      body: ListView(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
            color: Color.fromRGBO(128, 0, 128, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: 15,),
              Text("Welcome!", style:TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.white)),
              SizedBox(height: 10,),
              Text("Lets Get\nYou Started", style:TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: Colors.white)),
              SizedBox(height: 15,),
            ],),
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 5.0, top: 13.0),
          child: Text("Basic Information", style: TextStyle(fontSize: 16),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
          child: TextFormField(
            controller: _fNameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: 'First Name',
            ),
            //onSaved: (input)=>bloc.email=input,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
          child: TextFormField(
            controller: _lNameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: 'Last Name',
            ),
            //onSaved: (input)=>bloc.email=input,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
          child: TextFormField(
            controller: _addressController,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: 'Address',
            ),
            //onSaved: (input)=>bloc.email=input,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
          child: TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: 'Phone Number',
            ),
            //onSaved: (input)=>bloc.email=input,
          ),
        ),
        SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                if(_fNameController.text.isNotEmpty&_lNameController.text.isNotEmpty&_addressController.text.isNotEmpty&_phoneNumberController.text.isNotEmpty){
                  setState(() {
                    _Page=2;
                  });
                }else{
                  showAlertDialog(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(100)),
                  color:Color.fromRGBO(128, 0, 128, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Text("CONTINUE", style:TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 16,)
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],),
    ):_Page==2?Scaffold(
        appBar: AppBar(title: Text("Step 2 of 2", style: TextStyle(fontSize: 18, color: Colors.white60,),), elevation: 0,),
        body: ListView(children: [
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 5.0, top: 13.0),
            child: Text("Restaurant Information", style: TextStyle(fontSize: 16),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
            child: TextFormField(
              controller: _rNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Restaurant Name',
              ),
              //onSaved: (input)=>bloc.email=input,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
            child: TextFormField(
              controller: _rAddressController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Restaurant Address',
              ),
              //onSaved: (input)=>bloc.email=input,
            ),
          ),
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 0.0, top: 15.0),
                child: Text('Vendor Type'),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 21.0, right: 21.0,),
                    child: DropdownButton<bool>(
                      dropdownColor: Colors.white,
                      items: [
                        DropdownMenuItem<bool>(
                          child: Text("Restaurant", style: TextStyle(color: Colors.black,),),
                          value: true,
                        ),
                        DropdownMenuItem<bool>(
                          child: Text("Home Vendor", style: TextStyle(color: Colors.black),),
                          value: false,
                        ),
                      ],
                      onChanged: (bool type) {
                        setState(() {
                          restaurantType=type;
                        });
                      },
                      value: restaurantType,
                      hint: Text("Restaurant Type", style: TextStyle(color: Colors.black),),
                      //value: _value,
                    ),
                  ),
                ],
              ),
            ],),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 21.0, bottom: 0.0, top: 15.0),
                child: Text('Delivery option'),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 21.0,),
                    child: DropdownButton<bool>(
                      dropdownColor: Colors.white,
                      items: [
                        DropdownMenuItem<bool>(
                          child: Text("Delivery", style: TextStyle(color: Colors.black,),),
                          value: true,
                        ),
                        DropdownMenuItem<bool>(
                          child: Text("PickUp", style: TextStyle(color: Colors.black),),
                          value: false,
                        ),
                      ],
                      onChanged: (bool type) {
                        setState(() {
                          deliveryOption=type;
                        });
                      },
                      value: deliveryOption,
                      hint: Text("Restaurant Type", style: TextStyle(color: Colors.black),),
                      //value: _value,
                    ),
                  ),
                ],
              ),
            ],),
          ],),
          deliveryOption?Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
            child: TextFormField(
              controller: _deliveryFeeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Delivery Fee',
              ),
              //onSaved: (input)=>bloc.email=input,
            ),
          ):Container(),
          Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
            child: TextFormField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Account Number',
              ),
              //onSaved: (input)=>bloc.email=input,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
            child: TextFormField(
              controller: _accountNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Account Name',
              ),
              //onSaved: (input)=>bloc.email=input,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 10.0, top: 5.0),
            child: TextFormField(
              controller: _bankController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Bank',
              ),
              //onSaved: (input)=>bloc.email=input,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 0.0, top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text("Your bank detail will be used to forward", textAlign: TextAlign.justify,),
                    Text("your online payments from online transactions", textAlign: TextAlign.justify,),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GestureDetector(
                    onTap: () async {
                      if(_rNameController.text.isNotEmpty&_rAddressController.text.isNotEmpty){
                        setState(() {
                          _isLoading=true;
                        });
                        await Firestore.instance.collection('new_restaurant_request').document()
                            .setData({
                          'firstName': _fNameController.text,
                          'lastName': _lNameController.text,
                          'address': _addressController.text,
                          'phoneNumber': _phoneNumberController.text,
                          'restaurantName':_rNameController.text,
                          'restaurantAddress':_rAddressController.text,
                          'restaurantType':restaurantType?"Restaurant":"Home Vendor",
                          'deliveryOption':deliveryOption?"Delivery":"pickup",
                          'deliveryFee':deliveryOption?_deliveryFeeController.text:0,
                          'accountNumber':_accountNumberController.text,
                          'accountName':_accountNameController.text,
                          'bank':_bankController.text,
                        });
                        setState(() {
                          _isLoading=false;
                          _Page=3;
                        });
                      }else{
                        showAlertDialog(context);
                      }

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(100), right: Radius.circular(100)),
                        color:Color.fromRGBO(128, 0, 128, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10,),
                            Icon(Icons.send, color: Colors.white, size: 16,),
                            SizedBox(width: 10,),
                            Text("GET LISTED", style:TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(width: 10,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        ],),
          SizedBox(height: 50,),
    ])):Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check_circle, size: 100, color: Colors.teal,),
            SizedBox(height: 10,),
            Text("Success", style:TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(height: 20,),
            Text("Your registration is complete.", style:TextStyle(fontSize: 16)),
            SizedBox(height: 4,),
            Text("We will contact you with your login details.", style:TextStyle(fontSize: 16)),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(100), right: Radius.circular(100)),
                      color:Color.fromRGBO(128, 0, 128, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Text("Back Home", style:TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          SizedBox(width: 10,),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],),
      ),
    );
  }
}
