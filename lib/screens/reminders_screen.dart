import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

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

  void _addReminderDialog() {
    final titleController = TextEditingController();
    DateTime? selectedDate;
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
                    // Campo título
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selector de fecha
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
                              color: Colors.teal),
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: now,
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

                    // Recordar días antes
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
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    selectedDate != null) {
                  // Crear recordatorio
                  final newReminder = Reminder(
                    title: titleController.text,
                    date: selectedDate!,
                    daysBefore: daysBefore,
                  );

                  // Guardar en la lista
                  setState(() {
                    reminders.add(newReminder);
                  });

                  // === Programar notificación ===
                  final scheduledDate = newReminder.date
                      .subtract(Duration(days: newReminder.daysBefore));

                  await flutterLocalNotificationsPlugin.zonedSchedule(
                    DateTime.now().millisecondsSinceEpoch.remainder(100000), // id único
                    'Recordatorio: ${newReminder.title}',
                    'Para el ${DateFormat('dd/MM/yyyy').format(newReminder.date)}',
                    tz.TZDateTime.from(scheduledDate, tz.local),
                    const NotificationDetails(
                      android: AndroidNotificationDetails(
                        'reminders_channel',
                        'Recordatorios',
                        channelDescription: 'Canal de notificaciones de recordatorios',
                        importance: Importance.max,
                        priority: Priority.high,
                      ),
                    ),
                    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                  );

                  // Cerrar el diálogo
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordatorios'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addReminderDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: reminders.isEmpty
            ? const Center(
                child: Text(
                  'No hay recordatorios aún.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active,
                          color: Colors.teal),
                      title: Text(reminder.title),
                      subtitle: Text(
                        'Fecha: ${DateFormat('dd/MM/yyyy').format(reminder.date)}\n'
                        'Recordar ${reminder.daysBefore} día(s) antes',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() {
                            reminders.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
