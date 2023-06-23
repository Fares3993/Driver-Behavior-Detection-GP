import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserData {
  final String name;
  final int age;
  final String phone;
  final String email;

  UserData({required this.name, required this.age, required this.phone, required this.email});

  // Convert User object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'phone': phone,
      'email': email,
    };
  }

  // Create User object from a Firestore document snapshot
  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserData(
      name: data['name'],
      age: data['age'],
      phone: data['phone'],
      email: data['email'],
    );
  }
}

class UserService {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserData user) async {
    await usersCollection.doc(user.email).set(user.toMap());
  }

  Future<List<UserData>> getUsers() async {
    final querySnapshot = await usersCollection.get();
    return querySnapshot.docs.map((doc) => UserData.fromSnapshot(doc)).toList();
  }

  Future<UserData?> getUserByEmail(String email) async {
    final docSnapshot = await usersCollection.doc(email).get();
    if (docSnapshot.exists) {
      return UserData.fromSnapshot(docSnapshot);
    }
    return null;
  }
}


class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);
  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final UserService userService = UserService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void addUser() {
    final user = UserData(
      name: nameController.text,
      age: int.parse(ageController.text),
      phone: phoneController.text,
      email: emailController.text,
    );
    userService.addUser(user);
  }

  Future<UserData?> getUserByEmail(String email) async {
    final user = await userService.getUserByEmail(email);
    if (user != null) {
      print('Name: ${user.name}');
      print('Age: ${user.age}');
      print('Phone: ${user.phone}');
      print('Email: ${user.email}');
      return user;
    } else {
      print('User not found');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('User Data'),
    ),
    body: Padding(
    padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          ElevatedButton(
            onPressed: addUser,
            child: Text('Save User'),
          ),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text;
              getUserByEmail(email);
            },
            child: Text('Get User by Email'),
          ),
          FutureBuilder<List<UserData>>(
            future: userService.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                final users = snapshot.data!;
                return Column(
                  children: users.map((user) {
                    return ListTile(
                      title: Text('Name: ${user.name}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age: ${user.age}'),
                          Text('Phone: ${user.phone}'),
                          Text('Email: ${user.email}'),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Text('No users found.');
            },
          ),
        ],
      ),
    ),
    );
  }
}