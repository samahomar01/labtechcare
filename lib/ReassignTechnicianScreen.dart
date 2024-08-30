import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReassignTechnicianScreen extends StatefulWidget {
  final int ticketId;
  final String issue;
  final String state;
  final String date;

  ReassignTechnicianScreen({
    required this.ticketId,
    required this.issue,
    required this.state,
    required this.date,
  });

  @override
  _ReassignTechnicianScreenState createState() => _ReassignTechnicianScreenState();
}

class _ReassignTechnicianScreenState extends State<ReassignTechnicianScreen> {
  String? selectedLab;
  String? selectedDevice;
  String? selectedTechnician;

  @override
  void initState() {
    super.initState();
    fetchLabAndDeviceDetails();
  }

  Future<void> fetchLabAndDeviceDetails() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/myprojectt/assign_technician.php?action=getLabAndDeviceDetails&ticket_id=${widget.ticketId}'));

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);
        setState(() {
          selectedLab = data['lab_id'].toString();
          selectedDevice = data['device_id'].toString();
        });
      } catch (e) {
        print('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('Failed to load lab and device details');
    }
  }

  Future<List<dynamic>> fetchTechnicians() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/myprojectt/assign_technician.php?action=getTechnicians'));

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);
        return data;
      } catch (e) {
        print('Failed to parse JSON: $e');
        return [];
      }
    } else {
      throw Exception('Failed to load technicians');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reassign Technician'),
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
            if (selectedLab != null && selectedDevice != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lab ID: $selectedLab'),
                  Text('Device ID: $selectedDevice'),
                ],
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
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  child: Text('Reassign'),
                  onPressed: () async {
                    if (selectedTechnician != null && selectedDevice != null && selectedLab != null) {
                      await reassignTechnicianToTicket(context, widget.ticketId, int.parse(selectedTechnician!), int.parse(selectedDevice!), int.parse(selectedLab!));
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

  Future<void> reassignTechnicianToTicket(BuildContext context, int ticketId, int technicianId, int deviceId, int labId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/myprojectt/assign_technician.php?action=reassignTechnician'),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Technician reassigned successfully')));
        Navigator.pop(context, true); // Pass `true` to indicate success
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
            content: Text("Failed to reassign technician. Please try again later."),
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
