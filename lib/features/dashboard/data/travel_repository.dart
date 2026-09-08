import 'dart:async';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';

/// Clean repository interface for Travel & Field Mileage.
abstract class ITravelRepository {
  Future<TravelSummary> getTravelSummary({DashboardDateFilter? dateFilter});
  Future<List<TravelRecord>> getTravelHistory();
  Future<TravelRecord> logFieldVisit({
    required String clientName,
    required String projectName,
    required String fromLocation,
    required String toLocation,
    required double distanceKm,
    required String purpose,
    double ratePerKm,
  });
  Future<void> updateMileageRate(double newRate);
}

/// Production-ready mock implementation for TravelRepository.
class TravelRepository implements ITravelRepository {
  static final TravelRepository instance = TravelRepository._internal();
  TravelRepository._internal() {
    _initializeData();
  }
  factory TravelRepository() => instance;

  double _mileageRatePerKm = 12.0;
  final List<TravelRecord> _records = [];

  void _initializeData() {
    _records.addAll([
      TravelRecord(
        id: 'TRV-2026-081',
        date: '08 Sep (Today)',
        fromLocation: 'HQ — DLF Phase 5 Hub',
        toLocation: 'Project #104 (DLF Phase 5)',
        projectName: 'DLF Phase 5 Villa #104',
        clientName: 'Rahul Sharma',
        distanceKm: 18.4,
        ratePerKm: _mileageRatePerKm,
        status: TravelStatus.pending,
        purpose: 'Framing & Laser Level Inspection',
        departureTime: '10:00 AM',
        arrivalTime: '10:35 AM',
      ),
      TravelRecord(
        id: 'TRV-2026-080',
        date: '07 Sep',
        fromLocation: 'Project #104',
        toLocation: 'Sobha City Penthouse #402',
        projectName: 'Sobha City Penthouse',
        clientName: 'Pooja Verma',
        distanceKm: 24.2,
        ratePerKm: _mileageRatePerKm,
        status: TravelStatus.approved,
        purpose: 'Site Measurement & CAD Verification',
        departureTime: '02:15 PM',
        arrivalTime: '03:00 PM',
      ),
      TravelRecord(
        id: 'TRV-2026-079',
        date: '05 Sep',
        fromLocation: 'HQ Hub',
        toLocation: 'Godrej Woods 3BHK',
        projectName: 'Godrej Woods Renovation',
        clientName: 'Ananya Deshmukh',
        distanceKm: 16.5,
        ratePerKm: _mileageRatePerKm,
        status: TravelStatus.approved,
        purpose: 'Marble Slab Sample Match with Architect',
        departureTime: '11:00 AM',
        arrivalTime: '11:45 AM',
      ),
      TravelRecord(
        id: 'TRV-2026-078',
        date: '04 Sep',
        fromLocation: 'HQ Hub',
        toLocation: 'The Camellias Residence',
        projectName: 'The Camellias Ultra Luxury',
        clientName: 'Capt. R. K. Singhal',
        distanceKm: 32.0,
        ratePerKm: _mileageRatePerKm,
        status: TravelStatus.approved,
        purpose: 'Structural Acoustic Panelling Consultation',
        departureTime: '03:30 PM',
        arrivalTime: '04:45 PM',
      ),
      TravelRecord(
        id: 'TRV-2026-077',
        date: '02 Sep',
        fromLocation: 'Sobha City',
        toLocation: 'Kishangarh Stockyard Hub',
        projectName: 'Kishangarh Marble Stockyard',
        clientName: 'Multiple Turnkey Projects',
        distanceKm: 57.1,
        ratePerKm: _mileageRatePerKm,
        status: TravelStatus.approved,
        purpose: 'Material Selection & Lot Lotting',
        departureTime: '08:00 AM',
        arrivalTime: '10:30 AM',
      ),
    ]);
  }

  @override
  Future<TravelSummary> getTravelSummary({DashboardDateFilter? dateFilter}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final totalKm = _records.fold<double>(0.0, (acc, r) => acc + r.distanceKm);
    final approvedReimbursement = _records
        .where((r) => r.status == TravelStatus.approved)
        .fold<double>(0.0, (acc, r) => acc + r.reimbursementAmount);
    final pendingReimbursement = _records
        .where((r) => r.status == TravelStatus.pending)
        .fold<double>(0.0, (acc, r) => acc + r.reimbursementAmount);

    return TravelSummary(
      totalDistanceKm: double.parse(totalKm.toStringAsFixed(1)),
      totalVisits: _records.length,
      approvedReimbursement: approvedReimbursement,
      pendingReimbursement: pendingReimbursement,
      mileageRatePerKm: _mileageRatePerKm,
      thisMonthTotal: approvedReimbursement + pendingReimbursement,
    );
  }

  @override
  Future<List<TravelRecord>> getTravelHistory() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_records);
  }

  @override
  Future<TravelRecord> logFieldVisit({
    required String clientName,
    required String projectName,
    required String fromLocation,
    required String toLocation,
    required double distanceKm,
    required String purpose,
    double? ratePerKm,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final rate = ratePerKm ?? _mileageRatePerKm;
    final newRecord = TravelRecord(
      id: 'TRV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      date: 'Today',
      fromLocation: fromLocation,
      toLocation: toLocation,
      projectName: projectName,
      clientName: clientName,
      distanceKm: distanceKm,
      ratePerKm: rate,
      status: TravelStatus.pending,
      purpose: purpose,
      departureTime: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      arrivalTime: 'In Transit',
    );
    _records.insert(0, newRecord);
    return newRecord;
  }

  @override
  Future<void> updateMileageRate(double newRate) async {
    _mileageRatePerKm = newRate;
  }
}
