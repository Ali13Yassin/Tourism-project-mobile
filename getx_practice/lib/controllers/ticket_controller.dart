import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/base_controller.dart';
import '../models/ticket.dart';
import '../responses/ticket_response.dart';
import '../services/api.dart';

class TicketController extends GetxController with BaseController {
  var tickets = <Ticket>[].obs;
  var isLoading = false.obs;
  var selectedTicket = Rxn<Ticket>();

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
      isLoading(true);
      final response = await Api.getTickets();
      final ticketResponse = TicketResponse.fromJson(response.data);
      tickets.value = ticketResponse.tickets;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load tickets: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Tickets fetch error: $e');
    } finally {
      isLoading(false);
    }
  }  Future<void> fetchTicketDetails(String ticketId) async {
    try {
      isLoading(true);
      print('Fetching ticket details for ID: $ticketId');
      print('Expected UUID format - received: ${ticketId.runtimeType} with value: $ticketId');
      
      // Validate that we received a UUID and not an integer ID
      if (ticketId.isEmpty) {
        throw Exception('Ticket ID is empty');
      }
      
      // Check if the received ID looks like an integer (attraction ID) instead of UUID
      final isInteger = int.tryParse(ticketId) != null;
      if (isInteger) {
        print('WARNING: Received integer ID ($ticketId) instead of UUID. This might be an attraction ID.');
      }
      
      final response = await Api.getTicket(ticketId);
      
      // The API returns a different structure for individual ticket
      final data = response.data['data'] ?? {};
      final ticketData = data['ticket'] ?? {};
      final attractionData = data['attraction'] ?? {};
      final ticketTypeData = data['ticket_type'] ?? {};
      
      // Combine the data for the UI
      final combinedData = {
        ...ticketData,
        'title': attractionData['title'],
        'slug': attractionData['slug'],
        'price': attractionData['price'],
        'rating': attractionData['rating'],
        'reviewCount': attractionData['reviewCount'],
        'description': attractionData['description'],
        'image': attractionData['image'],
        'ticket_type': ticketTypeData['title'] ?? ticketTypeData['Title'],
        // Map additional fields properly
        'visit_date': ticketData['VisitDate'] ?? ticketData['visit_date'],
        'time_slot': ticketData['TimeSlot'] ?? ticketData['time_slot'],
        'phone_number': ticketData['PhoneNumber'] ?? ticketData['phone_number'],
        'total_cost': ticketData['TotalCost'] ?? ticketData['total_cost'],
        'booking_time': ticketData['BookingTime'] ?? ticketData['booking_time'],
      };
      
      selectedTicket.value = Ticket.fromJson(Map<String, dynamic>.from(combinedData));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load ticket details: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Ticket details fetch error: $e');
    } finally {
      isLoading(false);
    }
  }

  // Get tickets by state
  List<Ticket> getTicketsByState(String state) {
    return tickets.where((ticket) => ticket.state.toLowerCase() == state.toLowerCase()).toList();
  }

  // Get confirmed tickets
  List<Ticket> get confirmedTickets => getTicketsByState('confirmed');

  // Get pending tickets
  List<Ticket> get pendingTickets => getTicketsByState('pending');

  // Get cancelled tickets
  List<Ticket> get cancelledTickets => getTicketsByState('cancelled');
}
