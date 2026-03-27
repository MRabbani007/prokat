import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prokat/core/api/api_client.dart'; // Adjust path to your ApiClient

class HealthCheckScreen extends StatefulWidget {
  final ApiClient apiClient;
  const HealthCheckScreen({super.key, required this.apiClient});

  @override
  State<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends State<HealthCheckScreen> {
  String _status = "Press button to test";
  bool _isLoading = false;

  Future<void> _checkHealth() async {
    setState(() {
      _isLoading = true;
      _status = "Connecting...";
    });

    try {
      // Testing the GET /health endpoint
      final response = await widget.apiClient.dio.get("/health");

      setState(() {
        _status = "Success (200)\nResponse: ${response.data}";
      });
    } on DioException catch (e) {
      setState(() {
        _status =
            "Error: ${e.type}\nStatus: ${e.response?.statusCode}\nMessage: ${e.message}\nData: ${e.response?.data}";
      });
    } catch (e) {
      setState(() {
        _status = "Unexpected Error: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Health Test")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Base URL: ${widget.apiClient.dio.options.baseUrl}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _status,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkHealth,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("RUN GET /HEALTH"),
            ),
          ],
        ),
      ),
    );
  }
}
