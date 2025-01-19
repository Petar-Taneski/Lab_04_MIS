import 'package:flutter/material.dart';
import '../models/exam.dart';
import 'map_screen.dart';

class AddExamScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Function(Exam) onExamAdded;

  const AddExamScreen({
    super.key,
    required this.selectedDate,
    required this.onExamAdded,
  });

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDateTime;
  final _subjectController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.selectedDate;
  }

  void _saveExam() {
    if (_formKey.currentState!.validate()) {
      final exam = Exam(
        subject: _subjectController.text,
        dateTime: _selectedDateTime,
        location: _locationController.text,
      );
      widget.onExamAdded(exam);
    }
  }

  Future<void> _selectLocation() async {
    final selectedLocation = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    if (selectedLocation != null) {
      setState(() {
        _locationController.text = selectedLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: _selectLocation,
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        _selectedDateTime.year,
                        _selectedDateTime.month,
                        _selectedDateTime.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
                child: const Text('Select Time'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveExam,
                child: const Text('Save Exam'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}