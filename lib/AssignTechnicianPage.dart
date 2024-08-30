import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssignTechnicianScreen extends StatefulWidget {
  final int ticketId;
  final String issue;
  final String state;
  final String date;

  AssignTechnicianScreen({
    required this.ticketId,
    required this.issue,
    required this.state,
    required this.date,
  });

  @override
  _AssignTechnicianScreenState createState() => _AssignTechnicianScreenState();
}

class _AssignTechnicianScreenState extends State<AssignTechnicianScreen> {
  String? selectedLab;
  String? selectedDevice;
  String? selectedTechnician;

  Future<List<dynamic>> fetchLabs() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/myprojectt/assign_technician.php?action=getLabs'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load labs');
    }
  }

  Future<List<dynamic>> fetchDevices(int labId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2/myprojectt/assign_technician.php?action=getDevices&lab_id=$labId'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<List<dynamic>> fetchTechnicians() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/myprojectt/assign_technician.php?action=getTechnicians'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load technicians');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Technician'),
        backgroundColor: Color.fromARGB(255, 36, 117, 154),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ticket ID: ${widget.ticketId}'),
            Text('Issue: ${widget.issue}'),
            Text('State: ${widget.state}'),
            Text('Date: ${widget.date}'),
            SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: fetchLabs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No labs available.'));
                } else {
                  return DropdownButtonFormField<String>(
                    value: selectedLab,
                    items: snapshot.data!.map<DropdownMenuItem<String>>((lab) {
                      return DropdownMenuItem<String>(
                        value: lab['id'].toString(),
                        child: Text(lab['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLab = value;
                        selectedDevice = null; // Reset selected device when lab changes
                      });
                    },
                    decoration: InputDecoration(labelText: 'Select Lab'),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            if (selectedLab != null)
              FutureBuilder<List<dynamic>>(
                future: fetchDevices(int.parse(selectedLab!)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No devices available.'));
                  } else {
                    return DropdownButtonFormField<String>(
                      value: selectedDevice,
                      items: snapshot.data!.map<DropdownMenuItem<String>>((device) {
                        return DropdownMenuItem<String>(
                          value: device['device_id'].toString(),
                          child: Text(device['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDevice = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Select Device'),
                    );
                  }
                },
              ),
            SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: fetchTechnicians(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No technicians available.'));
                } else {
                  return DropdownButtonFormField<String>(
                    value: selectedTechnician,
                    items: snapshot.data!.map<DropdownMenuItem<String>>((technician) {
                      return DropdownMenuItem<String>(
                        value: technician['id'].toString(),
                        child: Text(technician['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTechnician = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Select Technician'),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Assign'),
                  onPressed: () {
                    if (selectedTechnician != null && selectedDevice != null && selectedLab != null) {
                      assignTechnicianToTicket(context, widget.ticketId, int.parse(selectedTechnician!), int.parse(selectedDevice!), int.parse(selectedLab!));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> assignTechnicianToTicket(BuildContext context, int ticketId, int technicianId, int deviceId, int labId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/myprojectt/assign_technician.php?action=assignTechnician'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'ticket_id': ticketId,
        'technician_id': technicianId,
        'device_id': deviceId,
        'lab_id': labId,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Technician assigned successfully')));
        Navigator.pop(context, true); // هنا نقوم بإرجاع نتيجة النجاح
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(responseBody['message']),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Server Error"),
            content: Text("Failed to assign technician. Please try again later."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
