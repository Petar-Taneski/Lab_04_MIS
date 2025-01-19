import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/exam.dart';
import 'add_exam_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  final List<Exam> _exams = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  List<Exam> _getExamsForDay(DateTime day) {
    return _exams.where((exam) {
      return exam.dateTime.year == day.year &&
          exam.dateTime.month == day.month &&
          exam.dateTime.day == day.day;
    }).toList();
  }

  void _addExam(Exam exam) {
    setState(() {
      _exams.add(exam);
    });
  }

  void _navigateToAddExam() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExamScreen(
          selectedDate: _selectedDay,
          onExamAdded: (exam) {
            _addExam(exam);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedExams = _getExamsForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab04'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: selectedExams.isEmpty
                ? const Center(
                    child: Text('No exams scheduled for this day'),
                  )
                : ListView.builder(
                    itemCount: selectedExams.length,
                    itemBuilder: (context, index) {
                      final exam = selectedExams[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(exam.subject),
                          subtitle: Text(
                            '${exam.dateTime.hour}:${exam.dateTime.minute.toString().padLeft(2, '0')} - ${exam.location}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _exams.remove(exam);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExam,
        child: const Icon(Icons.add),
      ),
    );
  }
}