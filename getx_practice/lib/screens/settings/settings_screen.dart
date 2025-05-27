import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/config_service.dart';
import 'server_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configService = ConfigService.instance;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Application Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Server Configuration Section
          Card(
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dns, color: Colors.blue),
                  title: const Text('Server Configuration'),
                  subtitle: Obx(() => Text(
                    configService.currentServerUrl,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  )),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Get.to(() => const ServerSettingsScreen());
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Additional Settings Section (placeholder for future features)
          Card(
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.grey),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                  enabled: false,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help, color: Colors.orange),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Implement help & support
                    Get.snackbar(
                      'Coming Soon',
                      'Help & Support feature will be available soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
