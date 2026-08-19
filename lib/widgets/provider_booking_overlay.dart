import 'package:booklt/pages/appotiment_page.dart';
import 'package:flutter/material.dart';
import 'package:booklt/models/provider.dart';
import 'package:booklt/models/service.dart';
import 'package:booklt/services/services_service.dart';

class ProviderBookingOverlay extends StatefulWidget {
  final Provider provider;

  const ProviderBookingOverlay({
    super.key,
    required this.provider,
  });

  @override
  State<ProviderBookingOverlay> createState() =>
      _ProviderBookingOverlayState();
}

class _ProviderBookingOverlayState extends State<ProviderBookingOverlay> {
  late Future<List<Service>> servicesFuture;

  Service? selectedService;

  @override
  void initState() {
    super.initState();

    servicesFuture = ServicesService().getServices(
      widget.provider.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  widget.provider.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                widget.provider.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(widget.provider.location),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Availability',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _availabilityItem('Mon'),
                  _availabilityItem('Tue'),
                  _availabilityItem('Wed'),
                  _availabilityItem('Thu'),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              FutureBuilder<List<Service>>(
                future: servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      'Failed to load services: ${snapshot.error}',
                    );
                  }

                  final services = snapshot.data ?? [];

                  if (services.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No services available',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return Column(
                    children: services.map((service) {
                      final isSelected =
                          selectedService?.id == service.id;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedService = service;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      service.description,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                '${service.price.toStringAsFixed(0)} EGP',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),

             SizedBox(
  height: 55,
  child: ElevatedButton(
    onPressed: selectedService == null
        ? null
        : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AppointmentPage(
                    provider: widget.provider,
                    service: selectedService!,
                  );
                },
                ),);},
          child: const Text(
            'Book Appointment',
          ),
        ),
      ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _availabilityItem(String day) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: Text(
          day,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}