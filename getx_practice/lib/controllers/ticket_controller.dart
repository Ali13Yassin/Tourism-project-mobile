import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/ticket.dart';
import '../responses/ticket_response.dart';

class TicketController extends GetxController {
  var tickets = <Ticket>[].obs;
  var isLoading = false.obs;
  var totalAmount = 0.0.obs;
  var categories = <String>[].obs;

  // Single ticket details
  var selectedTicket = Rx<Ticket?>(null);
  var attractionDetails = <String, dynamic>{}.obs;
  var ticketTypeDetails = <String, dynamic>{}.obs;
  var reviewStats = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
      isLoading(true);
      
      final token = await GetStorage().read('login_token');
      
      final response = await Dio().get(
        'http://10.0.2.2:8000/api/tickets',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final ticketResponse = TicketResponse.fromJson(response.data);
      tickets.value = ticketResponse.tickets;
      totalAmount.value = ticketResponse.total;
      
      if (ticketResponse.categories != null) {
        categories.value = ticketResponse.categories!;
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tickets: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTicketDetails(int ticketId) async {
    try {
      isLoading(true);
      
      final token = await GetStorage().read('login_token');
      
      final response = await Dio().get(
        'http://10.0.2.2:8000/api/tickets/$ticketId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final singleTicketResponse = SingleTicketResponse.fromJson(response.data);
      selectedTicket.value = singleTicketResponse.ticket;
      attractionDetails.value = singleTicketResponse.attraction;
      
      if (singleTicketResponse.ticketType != null) {
        ticketTypeDetails.value = singleTicketResponse.ticketType!;
      }
      
      if (singleTicketResponse.reviewStats != null) {
        reviewStats.value = singleTicketResponse.reviewStats!;
      }
      
      if (singleTicketResponse.categories != null) {
        categories.value = singleTicketResponse.categories!;
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch ticket details: $e');
    } finally {
      isLoading(false);
    }
  }

  // Helper methods for filtering tickets
  List<Ticket> get activeTickets => tickets.where((ticket) => ticket.isActive).toList();
  List<Ticket> get pendingTickets => tickets.where((ticket) => ticket.isPending).toList();
  List<Ticket> get cancelledTickets => tickets.where((ticket) => ticket.isCancelled).toList();
  List<Ticket> get expiredTickets => tickets.where((ticket) => ticket.isExpired).toList();

  // Filter tickets by category
  List<Ticket> getTicketsByCategory(String category) {
    return tickets.where((ticket) => ticket.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // Filter tickets by date range
  List<Ticket> getTicketsByDateRange(DateTime startDate, DateTime endDate) {
    return tickets.where((ticket) {
      try {
        final ticketDate = DateTime.parse(ticket.date);
        return ticketDate.isAfter(startDate.subtract(Duration(days: 1))) && 
               ticketDate.isBefore(endDate.add(Duration(days: 1)));
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // Search tickets by title or location
  List<Ticket> searchTickets(String query) {
    if (query.isEmpty) return tickets;
    
    final lowerQuery = query.toLowerCase();
    return tickets.where((ticket) {
      return ticket.title.toLowerCase().contains(lowerQuery) ||
             ticket.location.toLowerCase().contains(lowerQuery) ||
             ticket.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Get total spent amount
  double get totalSpent => tickets.fold(0.0, (sum, ticket) => sum + ticket.subtotal);
  
  // Get total active amount
  double get totalActiveAmount => activeTickets.fold(0.0, (sum, ticket) => sum + ticket.subtotal);

  // Refresh tickets
  Future<void> refreshTickets() async {
    await fetchTickets();
  }

  // Clear selected ticket details
  void clearSelectedTicket() {
    selectedTicket.value = null;
    attractionDetails.clear();
    ticketTypeDetails.clear();
    reviewStats.clear();
  }
}