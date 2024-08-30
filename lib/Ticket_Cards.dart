import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  final String date;
  final String ticketNumber;
  final String status;
  final String issue;
  final int ticketId;
  final Function(String)? onDetailsPressed;
  final Function(String)? onReplyPressed;

  const TicketCard({
    Key? key,
    required this.date,
    required this.ticketNumber,
    required this.status,
    required this.issue,
    required this.ticketId,
    this.onDetailsPressed,
    this.onReplyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: ${date.isNotEmpty ? date : 'N/A'}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Ticket Number: ${ticketNumber.isNotEmpty ? ticketNumber : 'N/A'}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Status: ${status.isNotEmpty ? status : 'N/A'}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Issue: ${issue.isNotEmpty ? issue : 'N/A'}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'details' && onDetailsPressed != null) {
                onDetailsPressed!('details');
              } else if (value == 'reply' && onReplyPressed != null) {
                onReplyPressed!('reply');
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Details', 'Reply'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase(),
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}
