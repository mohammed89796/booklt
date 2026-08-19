import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:booklt/models/provider.dart';
import 'package:booklt/models/service.dart';
import 'package:booklt/models/booking.dart';
import 'package:booklt/services/booking_service.dart';

class AppointmentPage extends StatefulWidget {
  final Provider provider;
  final Service service;

  const AppointmentPage({
    super.key,
    required this.provider,
    required this.service,
  });

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  late DateTime selectedDate;
  String? selectedTime;

  bool isBooking = false;

  final BookingService bookingService = BookingService();

  final Map<int, List<String>> availability = {
    0: [
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
      '2:00 PM',
      '2:30 PM',
      '3:00 PM',
      '3:30 PM',
    ],
    1: [
      '9:00 AM',
      '9:30 AM',
      '10:00 AM',
      '11:00 AM',
      '3:00 PM',
      '3:30 PM',
    ],
    2: [
      '10:00 AM',
      '10:30 AM',
      '12:00 PM',
      '1:00 PM',
      '4:00 PM',
    ],
    3: [
      '9:00 AM',
      '10:00 AM',
      '11:30 AM',
      '1:30 PM',
      '2:00 PM',
    ],
    4: [
      '10:00 AM',
      '10:30 AM',
      '12:30 PM',
      '2:00 PM',
      '3:30 PM',
    ],
    5: [
      '11:00 AM',
      '11:30 AM',
      '1:00 PM',
      '2:30 PM',
    ],
    6: [],
  };

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  List<DateTime> get upcomingDays {
    final today = DateTime.now();

    return List.generate(
      7,
      (index) => DateTime(
        today.year,
        today.month,
        today.day + index,
      ),
    );
  }

  List<String> get selectedDaySlots {
    return availability[selectedDate.weekday % 7] ?? [];
  }

  Future<void> bookAppointment() async {
    if (selectedTime == null) return;

    setState(() {
      isBooking = true;
    });

    try {
      final sessionToken =
          await ClerkAuth.of(context).sessionToken();

      final token = sessionToken.jwt;

      final selectedDateTime = _combineDateAndTime(
        selectedDate,
        selectedTime!,
      );

      final Booking booking =
          await bookingService.createBooking(
        providerId: widget.provider.id,
        serviceId: widget.service.id,
        date: selectedDateTime,
        token: token,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Appointment booked successfully!',
          ),
        ),
      );

      print('Booking ID: ${booking.id}');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isBooking = false;
        });
      }
    }
  }

  DateTime _combineDateAndTime(
    DateTime date,
    String time,
  ) {
    final parts = time.split(' ');
    final timePart = parts[0];
    final period = parts[1];

    final timeParts = timePart.split(':');

    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    if (period == 'PM' && hour != 12) {
      hour += 12;
    }

    if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: isBooking
              ? null
              : () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                20,
              ),
              children: [
                _providerCard(),
                const SizedBox(height: 28),
                _sectionTitle('Select Date'),
                const SizedBox(height: 14),
                _dateSelector(),
                const SizedBox(height: 28),
                _sectionTitle('Available Times'),
                const SizedBox(height: 14),
                _timeSlots(),
              ],
            ),
          ),
          _bottomButton(),
        ],
      ),
    );
  }

  Widget _providerCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 85,
              height: 85,
              child: widget.provider.image.startsWith('http')
                  ? Image.network(
                      widget.provider.image,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      widget.provider.image,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  widget.provider.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.service.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.service.price.toStringAsFixed(0)} EGP',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0F172A),
      ),
    );
  }

  Widget _dateSelector() {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: upcomingDays.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = upcomingDays[index];

          final isSelected =
              date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;

          return GestureDetector(
            onTap: isBooking
                ? null
                : () {
                    setState(() {
                      selectedDate = date;
                      selectedTime = null;
                    });
                  },
            child: Container(
              width: 70,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4F46E5)
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4F46E5)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    _dayName(date),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF0F172A),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _timeSlots() {
    if (selectedDaySlots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Center(
          child: Text(
            'No available appointments for this day.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: selectedDaySlots.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (context, index) {
        final time = selectedDaySlots[index];
        final isSelected =
            selectedTime == time;

        return GestureDetector(
          onTap: isBooking
              ? null
              : () {
                  setState(() {
                    selectedTime = time;
                  });
                },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF4F46E5)
                  : Colors.white,
              borderRadius:
                  BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF0F172A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomButton() {
    final enabled =
        selectedTime != null && !isBooking;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed:
              enabled ? bookAppointment : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                const Color(0xFFE2E8F0),
            disabledForegroundColor:
                const Color(0xFF94A3B8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16),
            ),
          ),
          child: isBooking
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Confirm Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  String _dayName(DateTime date) {
    final today = DateTime.now();
    final tomorrow =
        today.add(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    }

    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    }

    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return days[date.weekday - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}