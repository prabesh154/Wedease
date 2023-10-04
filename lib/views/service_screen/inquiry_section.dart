import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:wedease/consts/colors.dart';
import 'package:wedease/consts/consts.dart';
import 'package:wedease/widgets_common/normal_text.dart';

class InquirySection extends StatefulWidget {
  const InquirySection({Key? key}) : super(key: key);

  @override
  _InquirySectionState createState() => _InquirySectionState();
}

class _InquirySectionState extends State<InquirySection> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? inquiryName;
  String? inquiryEmail;
  // String? inquiryLocation;
  String? inquiryPhone;
  String? inquiryMessage;
  String? inquiryLocation;

  @override
  void initState() {
    super.initState();

    _fetchUserData();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _nameController.text = inquiryName ?? '';
    _emailController.text = inquiryEmail ?? '';
  }

  void _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      print("Fetching user data...");
      try {
        // Fetch user data from Firestore "users" collection
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          print("Document exists: ${userDoc.data()}");
          setState(() {
            inquiryName = userDoc['name'];
            inquiryEmail = userDoc['email'];
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  // Future<void> _sendInquiry() async {
  //   if (_formKey.currentState!.validate()) {
  //     const int inquiryCodeLimit = 10;

  //     String fullUuid = const Uuid().v4();

  //     String inquiryCode = fullUuid.substring(0, inquiryCodeLimit);

  //     // Prepare inquiry data
  //     Map<String, dynamic> inquiryData = {
  //       'inquiry_name': inquiryName,
  //       'inquiry_email': inquiryEmail,
  //       'inquiry_location': inquiryLocation,
  //       'inquiry_phone': inquiryPhone,
  //       'inquiry_message': inquiryMessage,
  //       'inquiry_date': _dateController.text,
  //       'inquiry_code': inquiryCode,
  //     };

  //     try {
  //       // Fetch service information based on 's_name' (assuming 's_name' is a unique identifier).
  //       DocumentSnapshot<Map<String, dynamic>> serviceDoc =
  //           await FirebaseFirestore.instance
  //               .collection('services')
  //               .doc('s_name')
  //               .get();

  //       if (serviceDoc.exists) {
  //         String vendorId = serviceDoc['vendor_id'];

  //         // Retrieve the vendor's information using the 'vendorId'.
  //         DocumentSnapshot<Map<String, dynamic>> vendorDoc =
  //             await FirebaseFirestore.instance
  //                 .collection('seller_vendors')
  //                 .doc(vendorId)
  //                 .get();

  //         if (vendorDoc.exists) {
  //           Map<String, dynamic>? vendorData = vendorDoc.data();
  //           Map<String, dynamic>? serviceData = serviceDoc.data();

  //           // Check for null values and then add 's_name' and 'vendor_id' to the inquiry data.
  //           if (vendorData != null && serviceData != null) {
  //             inquiryData['inquired_service_name'] = serviceData['s_name'];
  //             inquiryData['vendor_id'] = vendorId;

  //             // Store the inquiryData in Firestore.
  //             await _firestore
  //                 .collection('inquiry')
  //                 .doc(inquiryCode)
  //                 .set(inquiryData);

  //             _showConfirmationMessage();
  //             print(inquiryData);
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       _showErrorMessage('Error sending inquiry: $e');
  //     }
  //   }
  // }

  Future<void> _sendInquiry() async {
    if (_formKey.currentState!.validate()) {
      const int inquiryCodeLimit = 10;

      String fullUuid = const Uuid().v4();

      String inquiryCode = fullUuid.substring(0, inquiryCodeLimit);

      // Prepare inquiry data
      Map<String, dynamic> inquiryData = {
        'inquiry_name': inquiryName,
        'inquiry_email': inquiryEmail,
        'inquiry_location': inquiryLocation,
        'inquiry_phone': inquiryPhone,
        'inquiry_message': inquiryMessage,
        'inquiry_date': _dateController.text,
        'inquiry_code': inquiryCode,
      };

      try {
        await _firestore
            .collection('inquiry')
            .doc(inquiryCode)
            .set(inquiryData);
        _showConfirmationMessage();
        print(inquiryData);
      } catch (e) {
        _showErrorMessage('Error sending inquiry: $e');
      }
    }
  }

  void _showConfirmationMessage() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Barrier color
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Inquiry sent successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  boldText(text: 'Fill the Form', size: 18.0, color: blueColor),
                  10.heightBox,

                  TextFormField(
                    controller: _nameController..text = inquiryName ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Name'),
                    readOnly: false,
                  ),

                  TextFormField(
                    controller: _emailController..text = inquiryEmail ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Email'),
                    readOnly: false,
                  ),

                  // TextFormField(
                  //   decoration: const InputDecoration(labelText: 'Location'),
                  //   controller: _locationController..text =inquiryLocation??_locationController.text,
                  //   readOnly: false,
                  // ),

                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone'),
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        inquiryPhone = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Location'),
                    controller: _locationController,
                    onChanged: (value) {
                      setState(() {
                        inquiryLocation =
                            value; // Update the inquiryLocation variable
                      });
                    },
                  ),

                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Message'),
                    controller: _messageController,
                    maxLines: 3,
                    onChanged: (value) {
                      setState(() {
                        inquiryMessage = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _sendInquiry,
                    child: const Text('Send Inquiry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


