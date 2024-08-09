import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/theme/theme.dart';
import 'package:iconly/iconly.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  void addContact() async {
    if(_formKey.currentState!.validate()){
      try{
        await FirebaseFirestore.instance.collection("contacts").add({
          "name":nameController.text.trim(),
          "phone":phoneController.text.trim(),
          "email":emailController.text.trim(),
        });
        if (mounted)
          {
            Navigator.pop(context);
          }
      } on FirebaseException {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to Add Contact"))
      );
      }

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are Required!"))
      );
    } 
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
        title: const Text("Add Contact"),
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
                onPressed: addContact,
                icon: const Icon(IconlyBroken.add_user),
                 label: const Text("Add Contact")))
              
            ],))
        ],
      ),
    );
  }
}