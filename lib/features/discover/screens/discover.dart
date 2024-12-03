import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lottie/lottie.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  _Discover createState() => _Discover();
}

class _Discover extends State<Discover> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> courses = [];
  bool isLoading = false;

  void fetchCourses() async {
    final Uri url = Uri.https(
      'udemy-paid-courses-for-free-api.p.rapidapi.com',
      '/rapidapi/courses/search',
      {
        'page': '1',
        'page_size': '10',
        'query': searchController.text,
      },
    );

    final headers = {
      'x-rapidapi-host': 'udemy-paid-courses-for-free-api.p.rapidapi.com',
      'x-rapidapi-key': 'f74865e63emsh6abbd81bdfb272bp13b26djsna0317b2312fb',
    };

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          courses = List<Map<String, dynamic>>.from(data['courses']);
          isLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    final cardColor = theme.cardColor;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16.0),
            Text(
              'Discover useful courses',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8.0),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for courses',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: fetchCourses,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(82, 170, 94, 1.0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text(
                    "Search",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80.0),
            if (isLoading) // Loading Indicator
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (courses.isEmpty)
              Expanded(
                child: Column(
                  children: [
                    Lottie.network(
                      'https://lottie.host/d35fa59c-0c3b-4c27-919c-f7c4ae91025d/4msmVALOBP.json',
                      height: 200,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Start your journey today!',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Find courses to upgrade your skills and achieve your goals.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              )
            else // Course List
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      color: cardColor,
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(course['image'] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['name'] ?? 'No Title',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    course['category'] ?? 'No Category',
                                    style: TextStyle(
                                      color: theme.textTheme.bodyMedium?.color,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Text(
                                        course['actual_price_usd'] != null
                                            ? 'Price: \$${course['actual_price_usd']}'
                                            : 'Free',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      if (course['sale_price_usd'] != null)
                                        Text(
                                          '\$${course['sale_price_usd']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            color: Colors.red,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
