import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ticket_details_page.dart';
import 'Ticket_Cards.dart'; // استبدل بالمسار الصحيح لملف TicketCard.dart

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

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/myproject/get_supervisor_tickets.php'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets List'),
      ),
      body: tickets.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return TicketCard(
                  date: ticket.date,
                  ticketNumber: ticket.ticketId.toString(),
                  status: ticket.state,
                  issue: ticket.issue,
                  ticketId: ticket.ticketId,
                  onDetailsPressed: (value) {
                    if (value == 'details') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailsPage(ticketId: ticket.ticketId),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
