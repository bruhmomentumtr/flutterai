// Default location: lib/services/network_service.dart
// Network connectivity service for checking internet access

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Network test configuration
const Duration _dnsLookupTimeout = Duration(seconds: 3);
const List<String> _testDomains = [
  'google.com',
  'cloudflare.com',
  'openrouter.ai'
];

class NetworkService {
  // Check internet connectivity by trying to make a basic connection
  static Future<bool> isConnected() async {
    try {
      // First check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        debugPrint('No connectivity: $connectivityResult');
        return false;
      }
      
      // Try each domain until one succeeds
      for (final domain in _testDomains) {
        try {
          final result = await InternetAddress.lookup(domain)
              .timeout(_dnsLookupTimeout, onTimeout: () {
            debugPrint('$domain lookup timeout');
            throw TimeoutException('DNS lookup timeout');
          });
          
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            debugPrint('Successfully connected to $domain');
            return true;
          }
        } on SocketException catch (e) {
          debugPrint('Failed to connect to $domain: $e');
          continue;
        } on TimeoutException catch (e) {
          debugPrint('Timeout connecting to $domain: $e');
          continue;
        }
      }
      
      // If we get here, all domains failed
      debugPrint('All connectivity tests failed');
      return false;
    } on SocketException catch (e) {
      debugPrint('Internet connection error: $e');
      return false;
    } on TimeoutException catch (e) {
      debugPrint('Timeout error: $e');
      return false;
    } catch (e) {
      debugPrint('General internet connection error: $e');
      return false;
    }
  }
  
  // Get more detailed error information
  static Future<Map<String, dynamic>> getDiagnostics() async {
    final Map<String, dynamic> diagnostics = {};
    
    try {
      // Check connectivity type
      final connectivityResult = await Connectivity().checkConnectivity();
      diagnostics['connectivity_type'] = connectivityResult.toString();
      
      // Try to lookup each domain
      for (final domain in _testDomains) {
        try {
          final lookupResult = await InternetAddress.lookup(domain)
              .timeout(_dnsLookupTimeout);
          diagnostics['${domain}_success'] = lookupResult.isNotEmpty;
          diagnostics['${domain}_ip_addresses'] = lookupResult.map((e) => e.address).toList();
        } catch (e) {
          diagnostics['${domain}_error'] = e.toString();
        }
      }
      
      return diagnostics;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
} 