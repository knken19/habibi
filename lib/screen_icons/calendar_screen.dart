import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();
  DateTime focusedDay = DateTime.now();
  Set<DateTime> selectedDays = {};
  Set<DateTime> fertileDays = {};
  DateTime? ovulationDay;
  bool isSelecting = false;
  Database? _database;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _initializeDatabase().then((_) => _loadSelectedDates());
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'period_dates.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS period_dates(id INTEGER PRIMARY KEY, date TEXT)',
        );
      },
    );
  }

  Future<void> _loadSelectedDates() async {
    if (_database == null) return;
    final List<Map<String, dynamic>> maps =
        await _database!.query('period_dates');
    setState(() {
      selectedDays = maps.map((map) => DateTime.parse(map['date'])).toSet();
    });
    _calculateFertileWindow();
  }

  Future<void> _saveSelectedDates() async {
    if (_database == null) return;
    await _database!.delete('period_dates');
    for (final date in selectedDays) {
      await _database!.insert('period_dates', {'date': date.toIso8601String()});
    }
    setState(() {
      _calculateFertileWindow();
    });
  }

  void _calculateFertileWindow() {
    fertileDays.clear();
    ovulationDay = null;

    if (selectedDays.isEmpty) {
      setState(() {});
      return;
    }

    List<DateTime> sortedDates = selectedDays.toList()..sort();
    int cycleLength = 28;

    if (sortedDates.length > 1) {
      cycleLength = sortedDates.last
          .difference(sortedDates[sortedDates.length - 2])
          .inDays;
    }

    DateTime lastPeriodStart = sortedDates.last;
    ovulationDay = lastPeriodStart.add(Duration(days: cycleLength - 14));

    DateTime fertileStart = lastPeriodStart.add(Duration(days: 11));
    for (int j = 0; j < 7; j++) {
      fertileDays.add(fertileStart.add(Duration(days: j)));
    }

    setState(() {});
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
      this.focusedDay = focusedDay;

      if (isSelecting) {
        if (selectedDays.any((d) => isSameDay(d, selectedDay))) {
          selectedDays.removeWhere((d) => isSameDay(d, selectedDay));
        } else {
          selectedDays.add(selectedDay);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBE5985),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Column(
      children: [
        TableCalendar(
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          headerStyle: const HeaderStyle(
              formatButtonVisible: false, titleCentered: true),
          rowHeight: 60.0,
          focusedDay: focusedDay,
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2040, 12, 31),
          selectedDayPredicate: (day) =>
              selectedDays.any((d) => isSameDay(d, day)),
          onDaySelected: _onDaySelected,
          calendarBuilders:
              CalendarBuilders(defaultBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              child: Text(
                day.day.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            );
          }, selectedBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 238, 125, 162),
              ),
              child: Text(
                day.day.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }, todayBuilder: (context, day, focusedDay) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.pink,
                      width: 2.0,
                    ),
                  ),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }, markerBuilder: (context, day, events) {
            if (fertileDays.any((d) => isSameDay(d, day))) {
              return Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.cyan,
                    width: 2.0,
                  ),
                ),
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }
            return null;
          }),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isSelecting = true;
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 238, 125, 162),
          ),
          child: const Text("Select Period Dates"),
        ),
        if (isSelecting) ...[
          ElevatedButton(
            onPressed: () async {
              await _saveSelectedDates();
              setState(() {
                isSelecting = false;
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 238, 125, 162),
            ),
            child: const Text("Save Period Dates"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isSelecting = false;
                selectedDays.clear();
                fertileDays.clear();
                ovulationDay = null;
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 238, 125, 162),
            ),
            child: const Text("Cancel"),
          ),
        ],
      ],
    );
  }
}
