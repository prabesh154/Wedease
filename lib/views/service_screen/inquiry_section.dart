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
  String? inquiryName;
  String? inquiryEmail;
  String? inquiryLocation;
  String? inquiryPhone;
  String? inquiryMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      print("Fetching user data..."); 
      try {
        // Fetch user data from Firestore "users" collection
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await FirebaseFirestore.instance
                .collection("users") 
                .doc(user.uid) 
                .get();

        if (userDoc.exists) {
          print(
              "Document exists: ${userDoc.data()}"); 
          setState(() {
            inquiryName =
                userDoc['name']; 
            inquiryEmail =
                userDoc['email']; 
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> _sendInquiry() async {
    if (_formKey.currentState!.validate()) {
      // Generate a unique inquiry code
      String inquiryCode = const Uuid().v4();

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
        await _firestore.collection('inquiry').add(inquiryData);
        _showConfirmationMessage();
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
                    initialValue: inquiryName,
                    decoration: const InputDecoration(labelText: 'Name'),
                    readOnly: true,
                  ),
                  TextFormField(
                    initialValue: inquiryEmail,
                    decoration: const InputDecoration(labelText: 'Email'),
                    readOnly: true,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        inquiryLocation = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone'),
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
                    decoration: const InputDecoration(labelText: 'Message'),
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
