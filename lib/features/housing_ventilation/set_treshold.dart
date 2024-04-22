import 'package:flutter/material.dart';

class VentilationSetThreshold extends StatefulWidget {
  const VentilationSetThreshold({Key? key}) : super(key: key);

  @override
  _VentilationSetThresholdState createState() => _VentilationSetThresholdState();
}

class _VentilationSetThresholdState extends State<VentilationSetThreshold> {
  final _formKey = GlobalKey<FormState>();
  String? _humidity;
  String? _temperature;
  String? _luminosity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Threshold'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Humidity',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter humidity';
                  }
                  return null;
                },
                onSaved: (value) {
                  _humidity = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Temperature',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter temperature';
                  }
                  return null;
                },
                onSaved: (value) {
                  _temperature = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Luminosity',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter luminosity';
                  }
                  return null;
                },
                onSaved: (value) {
                  _luminosity = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Use the values here
                    print('Humidity: $_humidity, Temperature: $_temperature, Luminosity: $_luminosity');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}