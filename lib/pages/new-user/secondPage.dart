import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

import 'package:learn_1/pages/new-user/corePage.dart';

enum Gender { male, female }

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Identitas Anda',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 35, 38),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 24, 57, 96),
              Color.fromARGB(255, 38, 32, 36),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: MyForm(),
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  Gender _selectedGender = Gender.male;
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silahkan masukkan nama Anda';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silakan masukkan email Anda';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'No. Telepon',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silakan masukkan no.telepon Anda';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<Gender>(
            value: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: Gender.male,
                child: Text(
                  'Laki-laki',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              DropdownMenuItem(
                value: Gender.female,
                child: Text(
                  'Perempuan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            decoration: const InputDecoration(
              labelText: 'Jenis Kelamin',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null) {
                return 'Silakan pilih jenis kelamin';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Alamat',
              hintText: 'Masukkan alamat Anda',
              labelStyle: const TextStyle(color: Colors.white),
              hintStyle: const TextStyle(color: Colors.white70),
              errorStyle: const TextStyle(color: Colors.red),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              errorText: _validate ? 'Silakan masukkan alamat Anda' : null,
            ),
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState != null) {
                  setState(() {
                    _validate = _addressController.text.isEmpty;
                  });
                  if (_formKey.currentState!.validate()) {
                    Fluttertoast.showToast(
                        msg: "Berhasil Daftar!",
                        backgroundColor: Colors.green,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2);
                    Timer(const Duration(seconds: 2), () {
                      _submitForm();
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Tolong lengkapi form yang masih kosong!",
                        backgroundColor: Colors.red,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3);
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  String genderToString(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Laki-laki';
      case Gender.female:
        return 'Perempuan';
      default:
        return '';
    }
  }

  void _submitForm() {
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;
    String gender = genderToString(_selectedGender);

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CorePage(
                name: name,
                email: email,
                phone: phone,
                address: address,
                gender: gender)),
      );
    }
  }
}
