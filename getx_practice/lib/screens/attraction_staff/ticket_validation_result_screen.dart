import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/models/ticket_validation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class TicketValidationResultScreen extends StatefulWidget {
  final TicketValidation validation;
  final String qrCode;

  const TicketValidationResultScreen({
    super.key,
    required this.validation,
    required this.qrCode,
  });

  @override
  State<TicketValidationResultScreen> createState() => _TicketValidationResultScreenState();
}

class _TicketValidationResultScreenState extends State<TicketValidationResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    // Start animations
    _slideController.forward();
    _pulseController.repeat(reverse: true);
    
    // Play sound based on validation result
    _playValidationSound();
    
    // Provide haptic feedback
    _provideHapticFeedback();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
  void _playValidationSound() async {
    try {
      if (widget.validation.valid) {
        // Play success sound based on ticket type
        await _playTicketTypeSound();
      } else {
        // Play error sound - lower pitched beeps
        await _playBeepSequence([400, 300, 200], 400);
      }
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _playTicketTypeSound() async {
    String ticketType = widget.validation.guestType?.toLowerCase() ?? 'standard';
    
    // Different sound patterns based on ticket type
    if (ticketType.contains('vip') || ticketType.contains('premium')) {
      // VIP: High-pitched melodic sequence
      await _playBeepSequence([1000, 1200, 1400, 1600], 150);
    } else if (ticketType.contains('group') || ticketType.contains('family')) {
      // Group: Mid-range harmonic sequence
      await _playBeepSequence([800, 1000, 800, 1000], 200);
    } else if (ticketType.contains('child') || ticketType.contains('kid')) {
      // Child: Playful sequence
      await _playBeepSequence([600, 800, 1000, 800], 180);
    } else if (ticketType.contains('senior') || ticketType.contains('elderly')) {
      // Senior: Gentle sequence
      await _playBeepSequence([700, 900, 700], 250);
    } else {
      // Standard: Simple success beeps
      await _playBeepSequence([800, 1000, 1200], 200);
    }
  }
  Future<void> _playBeepSequence(List<int> frequencies, int duration) async {
    for (int i = 0; i < frequencies.length; i++) {
      await _playSystemBeep();
      await Future.delayed(Duration(milliseconds: duration ~/ 2));
    }
  }Future<void> _playSystemBeep() async {
    try {
      if (widget.validation.valid) {
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      debugPrint('Error playing system sound: $e');
    }
  }
  void _provideHapticFeedback() {
    if (widget.validation.valid) {
      // Success: Light haptic feedback
      HapticFeedback.lightImpact();
      Future.delayed(const Duration(milliseconds: 200), () {
        HapticFeedback.lightImpact();
      });
    } else {
      // Error: Heavy haptic feedback
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 300), () {
        HapticFeedback.heavyImpact();
      });
    }
  }

  Color get _backgroundColor => widget.validation.valid 
    ? Colors.green[50]! 
    : Colors.red[50]!;
    
  Color get _primaryColor => widget.validation.valid 
    ? Colors.green[700]! 
    : Colors.red[700]!;
    
  Color get _accentColor => widget.validation.valid 
    ? Colors.green[100]! 
    : Colors.red[100]!;

  IconData get _statusIcon => widget.validation.valid
    ? Icons.check_circle_rounded
    : Icons.cancel_rounded;

  String get _statusText => widget.validation.valid
    ? 'VALID TICKET'
    : 'INVALID TICKET';

  String get _actionText => widget.validation.valid
    ? 'ALLOW ENTRY'
    : 'DENY ENTRY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        title: Text(
          'Ticket Validation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Animated Status Icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: widget.validation.valid ? 5 : 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        _statusIcon,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 30),
              
              // Status Text
              Text(
                _statusText,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              // Message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryColor.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.validation.message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 24),
                // Ticket Details (only for valid tickets)
              if (widget.validation.valid) ...[
                _buildDetailCard('Number of Guests', 
                  widget.validation.guestsAllowed?.toString() ?? 'N/A',
                  Icons.people_rounded),
                
                const SizedBox(height: 12),
                
                _buildDetailCard('Ticket Type',
                  widget.validation.guestType ?? 'Standard',
                  Icons.local_activity_rounded),
                
                if (widget.validation.visitDate != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailCard('Visit Date',
                    widget.validation.visitDate!,
                    Icons.calendar_today_rounded),
                ],
                
                if (widget.validation.timeSlot != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailCard('Time Slot',
                    widget.validation.timeSlot!,
                    Icons.access_time_rounded),
                ],
                
                if (widget.validation.totalCost != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailCard('Total Cost',
                    '\$${widget.validation.totalCost!.toStringAsFixed(2)}',
                    Icons.attach_money_rounded),
                ],
                
                if (widget.validation.ticketId != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailCard('Ticket ID',
                    widget.validation.ticketId!.toString(),
                    Icons.confirmation_number_rounded),
                ],
                
                const SizedBox(height: 24),
              ],
              
              // Action Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _primaryColor, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(
                      widget.validation.valid ? Icons.thumb_up_rounded : Icons.block_rounded,
                      size: 40,
                      color: _primaryColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _actionText,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate back to QR scanner for next scan
                        Get.back();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Scan Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primaryColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: _primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
