// Default location: lib/services/network_service.dart
// Network connectivity service for checking internet access

import 'dart:io';
import 'dart:async';
import 'dart:convert';
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
  static void _log(
    String event, {
    String level = 'info',
    Object? error,
    Map<String, dynamic>? details,
  }) {
    debugPrint(jsonEncode({
      'scope': 'NetworkService',
      'level': level,
      'event': event,
      'timestamp': DateTime.now().toIso8601String(),
      if (error != null) 'error': error.toString(),
      if (details != null) 'details': details,
    }));
  }

  static List<ConnectivityResult> _normalizeConnectivityResults(
      Object connectivityResult) {
    if (connectivityResult is List<ConnectivityResult>) {
      return connectivityResult;
    }
    if (connectivityResult is ConnectivityResult) {
      return <ConnectivityResult>[connectivityResult];
    }
    return <ConnectivityResult>[];
  }

  // Check internet connectivity by trying to make a basic connection
  static Future<bool> isConnected() async {
    try {
      // First check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      final connectivityResults =
          _normalizeConnectivityResults(connectivityResult);
      final hasConnectivity =
          connectivityResults.any((result) => result != ConnectivityResult.none);
      if (!hasConnectivity) {
        _log(
          'isConnected.no_connectivity',
          level: 'warning',
          details: {'results': connectivityResults.map((e) => e.name).toList()},
        );
        return false;
      }

      // Try each domain until one succeeds
      for (final domain in _testDomains) {
        try {
          final result = await InternetAddress.lookup(domain)
              .timeout(_dnsLookupTimeout, onTimeout: () {
            _log(
              'isConnected.lookup_timeout',
              level: 'warning',
              details: {'domain': domain},
            );
            throw TimeoutException('DNS lookup timeout');
          });

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            _log('isConnected.lookup_success',
                details: {'domain': domain, 'ip': result[0].address});
            return true;
          }
        } on SocketException catch (e) {
          _log(
            'isConnected.lookup_socket_error',
            level: 'warning',
            error: e,
            details: {'domain': domain},
          );
          continue;
        } on TimeoutException catch (e) {
          _log(
            'isConnected.lookup_timeout_exception',
            level: 'warning',
            error: e,
            details: {'domain': domain},
          );
          continue;
        }
      }

      // If we get here, all domains failed
      _log('isConnected.all_tests_failed', level: 'warning');
      return false;
    } on SocketException catch (e) {
      _log('isConnected.socket_exception', level: 'error', error: e);
      return false;
    } on TimeoutException catch (e) {
      _log('isConnected.timeout_exception', level: 'error', error: e);
      return false;
    } catch (e) {
      _log('isConnected.unexpected_exception', level: 'error', error: e);
      return false;
    }
  }

  // Get more detailed error information
  static Future<Map<String, dynamic>> getDiagnostics() async {
    final Map<String, dynamic> diagnostics = {};

    try {
      // Check connectivity type
      final connectivityResult = await Connectivity().checkConnectivity();
      final connectivityResults =
          _normalizeConnectivityResults(connectivityResult);
      diagnostics['connectivity_type'] = connectivityResults
          .map((result) => result.name)
          .toList(growable: false);

      // Try to lookup each domain
      for (final domain in _testDomains) {
        try {
          final lookupResult =
              await InternetAddress.lookup(domain).timeout(_dnsLookupTimeout);
          diagnostics['${domain}_success'] = lookupResult.isNotEmpty;
          diagnostics['${domain}_ip_addresses'] =
              lookupResult.map((e) => e.address).toList();
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