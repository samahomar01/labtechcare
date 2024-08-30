import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ticket_details_page.dart';
import 'Ticket_Cards.dart';
import 'AssignTechnicianPage.dart'; // Correct import for the Assign Technician page
import 'ReassignTechnicianScreen.dart'; // Import for the Reassign Technician page
import 'notifications_page.dart'; // Import for the Notifications page
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Import for the Login page
import 'AddReviewPage.dart'; // Import for the Add Review page

class Ticket {
  final int ticketId;
  final int userId;
  final String state;
  final String date;
  final String issue;

  Ticket({
    required this.ticketId,
    required this.userId,
    required this.state,
    required this.date,
    required this.issue,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketId: int.parse(json['ticket_id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      state: json['state'],
      date: json['date'],
      issue: json['issue'],
    );
  }
}

class TicketsPage extends StatefulWidget {
  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  late List<Ticket> tickets = [];
  int unreadNotificationsCount = 0;
  int? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
    });
    if (userId != null) {
      _fetchTickets();
      _fetchUnreadNotificationsCount();
    }
  }

  Future<void> _fetchTickets() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/myprojectt/get_ticketsall.php?status_filter=pending_assigned_open'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          setState(() {
            tickets = List<Ticket>.from(jsonData['tickets'].map((item) => Ticket.fromJson(item)));
          });
        } else {
          print('Failed to load tickets: ${jsonData['message']}');
        }
      } else {
        print('Failed to load tickets: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading tickets: $e');
    }
  }

  Future<void> _fetchUnreadNotificationsCount() async {
    if (userId != null) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2/myprojectt/get_unread_notifications_count.php'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, int>{
            'user_id': userId!,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success']) {
            setState(() {
              unreadNotificationsCount = data['count'];
            });
          } else {
            print('Failed to fetch notifications count');
          }
        } else {
          print('Failed to fetch notifications count');
        }
      } catch (e) {
        print('Failed to fetch notifications count: $e');
      }
    }
  }

  Future<void> _updateNotificationsStatus() async {
    if (userId != null) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2/myprojectt/update_notifications_status.php'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, int>{
            'user_id': userId!,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success']) {
            print('Notifications updated successfully');
          } else {
            print('Failed to update notifications status: ${data['message']}');
          }
        } else {
          print('Server error: ${response.statusCode}');
        }
      } catch (e) {
        print('Failed to update notifications status: $e');
      }
    }
  }

  Future<void> _deleteTicket(int ticketId) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/myprojectt/delete_ticket.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'ticket_id': ticketId,
        }),
      );

      final jsonData = json.decode(response.body);

      if (jsonData['success']) {
        setState(() {
          tickets.removeWhere((ticket) => ticket.ticketId == ticketId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket deleted successfully')),
        );
      } else {
        print('Failed to delete ticket: ${jsonData['message']}');
      }
    } catch (e) {
      print('Error deleting ticket: $e');
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ClipOval(
                child: Image.asset(
                  'assets/images/saa.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Tickets List',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFF0288D1), // Light blue color
      ),
      backgroundColor: Color(0xFFE1F5FE), // Light background color
      body: Column(
        children: [
          Container(
            color: Color(0xFF0288D1), // Light blue color
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white), // Home icon
                  onPressed: () {
                    // Add appropriate action here
                  },
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Color(0xFFFFD54F)), // Yellow color
                      onPressed: () async {
                        if (userId != null) {
                          await _updateNotificationsStatus(); // Update notifications status
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificationsPage(userId: userId!)),
                          );
                          if (result == true) {
                            _fetchUnreadNotificationsCount(); // Reload unread notifications count
                            _fetchTickets(); // Reload tickets when returning to main page
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User ID not found')),
                          );
                        }
                      },
                    ),
                    if (unreadNotificationsCount > 0)
                      Positioned(
                        right: 11,
                        top: 11,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '$unreadNotificationsCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.star, color: Colors.white), // Star icon
                  onPressed: () {
                    if (userId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddReviewPage(userId: userId!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User ID not found')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white), // Logout icon
                  onPressed: _logout, // Logout on button press
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Previous Tickets',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF01579B), // Dark blue color
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: tickets.isEmpty
                ? Center(
                    child: Text(
                      'No tickets found',
                      style: TextStyle(
                        color: Color(0xFF01579B), // Dark blue color
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return Card(
                        color: Color(0xFF0288D1), // Light blue color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${ticket.date}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Ticket Number: ${ticket.ticketId}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Status: ${ticket.state}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Issue: ${ticket.issue}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String result) async {
                              if (result == 'details') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TicketDetailsPage(reportId: ticket.ticketId),
                                  ),
                                );
                              } else if (result == 'assign') {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  AssignTechnicianScreen(
                                      ticketId: ticket.ticketId,
                                      issue: ticket.issue,
                                      state: ticket.state,
                                      date: ticket.date,
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  _fetchTickets(); // Reload tickets after successful assignment
                                  _fetchUnreadNotificationsCount(); // Reload unread notifications count
                                }
                              } else if (result == 'reassign') {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReassignTechnicianScreen(
                                      ticketId: ticket.ticketId,
                                      issue: ticket.issue,
                                      state: ticket.state,
                                      date: ticket.date,
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  _fetchTickets(); // Reload tickets after successful reassignment
                                  _fetchUnreadNotificationsCount(); // Reload unread notifications count
                                }
                              } else if (result == 'delete') {
                                _deleteTicket(ticket.ticketId);
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'details',
                                child: Text('View Details'),
                              ),
                              PopupMenuItem<String>(
                                value: tickets[index].state == 'assigned' ? 'reassign' : 'assign',
                                child: Text(tickets[index].state == 'assigned' ? 'Reassign Technician' : 'Assign Technician'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete Ticket'),
                              ),
                            ],
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
