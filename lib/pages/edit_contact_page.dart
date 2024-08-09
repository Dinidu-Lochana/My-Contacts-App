import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/theme/theme.dart';
import 'package:iconly/iconly.dart';

class EditContactPage extends StatefulWidget {
  const EditContactPage({super.key, required this.name, required this.phone, required this.email, required this.id});
  
  final String name;
  final String phone;
  final String email;
  final String id;

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;

  void editContact() async
  {
    if(_formKey.currentState!.validate())
    {
      try{
        await FirebaseFirestore.instance.collection('contacts')
        .doc(widget.id)
        .update({
          "name":nameController.text.trim(),
          "phone":phoneController.text.trim(),
          "email":emailController.text.trim()
        });
        if(mounted)
        {
          Navigator.pop(context);
        }
      }
      on FirebaseException{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to edit Contact")));
      }
    }
  }
  
  @override
  void initState(){
    nameController = TextEditingController(
      text: widget.name
    );
    phoneController = TextEditingController(
      text: widget.phone
    );
    emailController = TextEditingController(
      text: widget.email
    );
  }

  @override
  void dispose()
  {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Contact"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Form(
            key: _formKey,
            child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: nameController,
                textInputAction: TextInputAction.next,
                validator: (value){
                  if(value!.isEmpty)
                  {
                    return "Please enter the Name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Name",
                  contentPadding: inputPadding,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.phone,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: phoneController,
                textInputAction: TextInputAction.next,
                validator: (value){
                  if(value!.isEmpty)
                  {
                    return "Please enter the Contact Number";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Contact Number",
                  contentPadding: inputPadding,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                textInputAction: TextInputAction.next,
                validator: (value){
                  if(value!.isEmpty)
                  {
                    return "Please enter the Email";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Email",
                  contentPadding: inputPadding,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: editContact,
                icon: const Icon(IconlyBroken.edit),
                 label: const Text("Edit Contact")))
              
            ],))
        ],
      ),
    );
  }
}