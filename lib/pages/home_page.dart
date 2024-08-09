import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/add_contact_page.dart';
import 'package:flutter_application_3/pages/edit_contact_page.dart';
import 'package:iconly/iconly.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final contactCollection = FirebaseFirestore.instance.collection("contacts").snapshots();

  void deleteContact(String id) async
  {
    await FirebaseFirestore.instance.collection('contacts').doc(id).delete();
    if(mounted)
    {
      ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text("Contact deleted Successfully")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: const Text("My Contacts"),
      ),
      body: StreamBuilder(
        stream: contactCollection,
        builder: (context, snapshot) {
          if(snapshot.hasData){
             final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
             if(documents.isEmpty){
              return Center(
                child: Text("No Contacts Available",
                style: Theme.of(context).textTheme.headlineMedium,),
                
              );
             }
             return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context,index){
                final contact = documents[index].data() as Map<String, dynamic>;
                final contactId = documents[index].id;
                final String name = contact['name'];
                final String email = contact['email'];
                final String phone = contact['phone'];
                final String avatar = "https://static.vecteezy.com/system/resources/thumbnails/027/951/137/small_2x/stylish-spectacles-guy-3d-avatar-character-illustrations-png.png"; 

                return ListTile(
                  title: Text(name),
                  subtitle: Text("$phone \n$email"),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: 
                          (context)=>EditContactPage(
                            name:name,
                            phone: phone,
                            email: email,
                            id: contactId,
                          )));
                        },
                        icon: Icon(IconlyBroken.edit),
                        splashRadius: 24,
                      ),
                      IconButton(
                        onPressed: (){
                          deleteContact(contactId);
                        },
                        icon: Icon(IconlyBroken.delete),
                        splashRadius: 24,

                      )
                    ],
                  ),
                );
              });
          }
          else if(snapshot.hasError)
          {
            return Center( 
              child: Text("There was an error"),
            );
          }
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
      },),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
          const AddContactPage()));
        },
        label: const Text("Add Contact"),
        icon: const Icon(IconlyBroken.document),
        ),
    );
  }
}