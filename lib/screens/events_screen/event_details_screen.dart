import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:flutter/material.dart';
import 'package:polmitra_admin/utils/color_provider.dart';
import 'package:polmitra_admin/utils/text_builder.dart';

import '../../models/event.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({required this.event, super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late final Event _event;
  int? _rating; // Track the rating if needed
  bool _ratingSubmitted = false; // Track if rating is submitted

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _checkIfRatingSubmitted();
  }

  // Convert milliseconds to a readable date and time format with AM/PM
  String formatDateTime(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    final formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')} ${_monthName(dateTime.month)} ${dateTime.year}';
    final formattedTime =
        '${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    return '$formattedDate at $formattedTime';
  }

  // Helper function to get month name from month number
  String _monthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  // Check if the rating has already been submitted
  Future<void> _checkIfRatingSubmitted() async {
    final eventRef =
        FirebaseFirestore.instance.collection('events').doc(_event.id);
    final doc = await eventRef.get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          _rating = data['points']?.toInt();
          _ratingSubmitted = _rating != null;
        });
      }
    }
  }

  // Handle rating selection
  Future<void> _selectRating(int rating) async {
    setState(() {
      _rating = rating;
      _ratingSubmitted = true;
    });

    final eventRef =
        FirebaseFirestore.instance.collection('events').doc(_event.id);
    await eventRef.update({'points': rating});
  }

  @override
  Widget build(BuildContext context) {
    final isEventEnded = _event.endingTime != null &&
        DateTime.fromMillisecondsSinceEpoch(_event.endingTime!)
            .isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Details',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(),
        ),
        backgroundColor: ColorProvider.lemonYellow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: _event.images.isNotEmpty ? _event.images.first : '',
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    );
                  },
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBuilder.getText(
                        text: _event.date,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 8),
                      TextBuilder.getText(
                        text: _event.eventName,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      TextBuilder.getText(
                        text: _event.address,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade700,
                      ),
                      TextBuilder.getText(
                        text: _event.city.cityname,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade700,
                      ),
                      TextBuilder.getText(
                        text: _event.state.statename,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade700,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Starting and Ending Time as ListTiles
            if (_event.createdAt != null && _event.endingTime != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    tileColor: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Icon(
                      Icons.schedule,
                      color: Colors.blue.shade800,
                    ),
                    title: Text(
                      'Start Time',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                    ),
                    subtitle: Text(
                      formatDateTime(
                          _event.createdAt!.toDate().millisecondsSinceEpoch),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.blue.shade800,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    tileColor: Colors.orange.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Icon(
                      Icons.schedule,
                      color: Colors.orange.shade800,
                    ),
                    title: Text(
                      'End Time',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                    ),
                    subtitle: Text(
                      formatDateTime(_event.endingTime!),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.orange.shade800,
                          ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            // Description Box
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextBuilder.getText(
                text: _event.description,
                fontSize: 15,
                overflow: TextOverflow.visible,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            // Carousel Slider
            if (_event.images.isNotEmpty)
              CarouselSlider.builder(
                itemCount: _event.images.length,
                itemBuilder: (context, index, realIndex) {
                  return CachedNetworkImage(
                    imageUrl: _event.images[index],
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      );
                    },
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  );
                },
                options: CarouselOptions(
                  height: 180,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            const SizedBox(height: 20),
            // Event Ending Image with Title
            if (_event.endingImageUrl != null &&
                _event.endingImageUrl!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Ending Image',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          // color: Colors.teal,
                        ),
                  ),
                  const SizedBox(height: 10),
                  CachedNetworkImage(
                    imageUrl: _event.endingImageUrl!,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      );
                    },
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            // Rating Section
            if (isEventEnded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rate the Event',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                  ),
                  const SizedBox(height: 10),
                  _ratingSubmitted
                      ? Row(
                          children: [
                            Text('Rating: $_rating'),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.star,
                              color: Colors.teal,
                            ),
                          ],
                        )
                      : Wrap(
                          spacing: 8,
                          children: List<Widget>.generate(10, (index) {
                            final int rating = index + 1;
                            return ChoiceChip(
                              label: Text('$rating'),
                              selected: _rating == rating,
                              onSelected: (selected) {
                                if (selected) {
                                  _selectRating(rating);
                                }
                              },
                              selectedColor: Colors.teal,
                              backgroundColor: Colors.grey.shade300,
                              labelStyle: TextStyle(
                                color: _rating == rating
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                        ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
