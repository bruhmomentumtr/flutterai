// Default location: lib/services/network_service.dart
// Girilen API anahtarı ile tüm endpointleri test eder, başarılı olanı döndürür.
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../languages/languages.dart';
import '../settingsvariables/default_settings_variables.dart';
import 'package:http/http.dart' as http;

/// Girilen apikey ile tüm endpointleri defaultControlModel üzerinden test eder.
/// Başarılı olan ilk endpointi döndürür, hiçbiri başarılı olmazsa null döner.
Future<ApiEndpoint?> testApiKeyOnAllEndpoints(String apiKey) async {
  for (final endpoint in apiEndpoints) {
    try {
      final response = await http.post(
        Uri.parse('${endpoint.baseUrl}/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: '{"model": "${endpoint.defaultControlModel}", "messages": [{"role": "user", "content": "Hello"}]}'
      );
      if (response.statusCode == 200) {
        // Başarılı yanıt alındı
        return endpoint;
      }
    } catch (_) {
      // Hata olursa diğer endpointi dene
      continue;
    }
  }
  // Hiçbiri başarılı olmadı
  return null;
}

// Network connectivity service for checking internet access

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../languages/languages.dart';

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
        debugPrint('$Languages.msgNoConnectivity $connectivityResult');
        return false;
      }
      
      // Try each domain until one succeeds
      for (final domain in _testDomains) {
        try {
          final result = await InternetAddress.lookup(domain)
              .timeout(_dnsLookupTimeout, onTimeout: () {
            debugPrint(' [33m$domain$Languages.msgLookupTimeout [0m');
            throw TimeoutException('DNS lookup timeout');
          });
          
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            debugPrint('$Languages.msgSuccessfullyConnected$domain');
            return true;
          }
        } on SocketException catch (e) {
          debugPrint('$Languages.msgFailedToConnect$domain: $e');
          continue;
        } on TimeoutException catch (e) {
          debugPrint('$Languages.msgTimeoutConnecting$domain: $e');
          continue;
        }
      }
      
      // If we get here, all domains failed
      debugPrint(Languages.msgAllConnectivityTestsFailed);
      return false;
    } on SocketException catch (e) {
      debugPrint('$Languages.msgInternetConnectionError $e');
      return false;
    } on TimeoutException catch (e) {
      debugPrint('$Languages.msgTimeoutError $e');
      return false;
    } catch (e) {
      debugPrint('$Languages.msgGeneralInternetConnectionError $e');
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