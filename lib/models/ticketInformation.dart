import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TicketInformation {

  final String ticketId;
  final String passengerName;
  final String from;
  final String to;
  final String date;
  final String time;
  final String seat;
  final String status;

  TicketInformation({

    required this.ticketId,
    required this.passengerName,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.seat,
    required this.status,
  });



  Map<String, dynamic> toMap() {

    return {

      'ticketId': ticketId,
      'passengerName': passengerName,
      'fromStation': from,
      'toStation': to,
      'date': date,
      'time': time,
      'seat': seat,
      'status': status,
    };
  }



  factory TicketInformation.fromMap(
      Map<String, dynamic> map) {

    return TicketInformation(

      ticketId: map['ticketId'],

      passengerName: map['passengerName'],

      from: map['fromStation'],

      to: map['toStation'],

      date: map['date'],

      time: map['time'],

      seat: map['seat'],

      status: map['status'],
    );
  }
}

