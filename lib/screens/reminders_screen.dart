import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:table_calendar/table_calendar.dart';

import '../main.dart';

// 🎨 Si ya tienes estos colores globales, borra estas líneas y usa tu import
const kPrimaryColor = Color(0xFF1B4965);
const kSecondaryColor = Color(0xFF5FA8D3);
const kBackgroundColor = Color(0xFFF4F6FA);

class Reminder {
  String title;
  DateTime date;
  int daysBefore;

  Reminder({
    required this.title,
    required this.date,
    required this.daysBefore,
  });
}

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final List<Reminder> reminders = [];

  // Día enfocado y seleccionado en el calendario
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<Reminder> get _remindersForSelectedDay {
    return reminders
        .where((r) =>
            r.date.year == _selectedDay.year &&
            r.date.month == _selectedDay.month &&
            r.date.day == _selectedDay.day)
        .toList();
  }

  // ---------- NUEVO RECORDATORIO ----------

  void _addReminderDialog() {
    final titleController = TextEditingController();
    DateTime? selectedDate = _selectedDay; // por defecto el día del calendario
    int daysBefore = 1;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo recordatorio'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fecha
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'Sin fecha seleccionada'
                                : 'Fecha: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: kPrimaryColor),
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? now,
                              firstDate: now,
                              lastDate: DateTime(now.year + 2),
                            );
                            if (picked != null) {
                              setDialogState(() => selectedDate = picked);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Días antes
                    Row(
                      children: [
                        const Text('Recordar antes:'),
                        const SizedBox(width: 10),
                        DropdownButton<int>(
                          value: daysBefore,
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('1 día')),
                            DropdownMenuItem(value: 2, child: Text('2 días')),
                            DropdownMenuItem(value: 3, child: Text('3 días')),
                            DropdownMenuItem(value: 7, child: Text('1 semana')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() => daysBefore = value);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              onPressed: () async {
                if (titleController.text.isNotEmpty && selectedDate != null) {
                  final newReminder = Reminder(
                    title: titleController.text,
                    date: selectedDate!,
                    daysBefore: daysBefore,
                  );

                  setState(() {
                    reminders.add(newReminder);
                  });

                  // Fecha de notificación
                  final scheduledDate = newReminder.date
                      .subtract(Duration(days: newReminder.daysBefore));

                  await flutterLocalNotificationsPlugin.zonedSchedule(
                    DateTime.now().millisecondsSinceEpoch.remainder(100000),
                    'Recordatorio: ${newReminder.title}',
                    'Para el ${DateFormat('dd/MM/yyyy').format(newReminder.date)}',
                    tz.TZDateTime.from(scheduledDate, tz.local),
                    const NotificationDetails(
                      android: AndroidNotificationDetails(
                        'reminders_channel',
                        'Recordatorios',
                        channelDescription:
                            'Canal de notificaciones de recordatorios',
                        importance: Importance.max,
                        priority: Priority.high,
                      ),
                    ),
                    androidScheduleMode:
                        AndroidScheduleMode.exactAllowWhileIdle,
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          'Recordatorios',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: kPrimaryColor),
            onPressed: _addReminderDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // 📅 Calendario tipo Apple
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: TableCalendar<Reminder>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) =>
                    day.year == _selectedDay.year &&
                    day.month == _selectedDay.month &&
                    day.day == _selectedDay.day,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                // Marca días con recordatorios
                eventLoader: (day) => reminders
                    .where((r) =>
                        r.date.year == day.year &&
                        r.date.month == day.month &&
                        r.date.day == day.day)
                    .toList(),
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: kSecondaryColor.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: kSecondaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // Título de la lista de eventos del día
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE d \'de\' MMMM', 'es_ES')
                      .format(_selectedDay),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addReminderDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nuevo'),
                  style: TextButton.styleFrom(
                    foregroundColor: kSecondaryColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // 📋 Lista de recordatorios del día seleccionado
          Expanded(
            child: _remindersForSelectedDay.isEmpty
                ? const Center(
                    child: Text(
                      'No hay recordatorios para este día.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _remindersForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final reminder = _remindersForSelectedDay[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.notifications_active,
                            color: kPrimaryColor,
                          ),
                          title: Text(reminder.title),
                          subtitle: Text(
                            'Fecha: ${DateFormat('dd/MM/yyyy').format(reminder.date)}\n'
                            'Recordar ${reminder.daysBefore} día(s) antes',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              setState(() {
                                reminders.remove(reminder);
                              });
                              // (Opcional: cancelar la notificación si guardas el ID)
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
