import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine.dart';
import '../models/stock_movement.dart';

class MedicineService {
  static const _medicinesName = 'medicines';
  static const _movementsName = 'movements';
  static const _metaName = 'meta';

  static Box get _medicines => Hive.box(_medicinesName);
  static Box get _movements => Hive.box(_movementsName);
  static Box get _meta => Hive.box(_metaName);

  /// Call once in main() before runApp().
  static Future<void> init() async {
    await Hive.openBox(_medicinesName);
    await Hive.openBox(_movementsName);
    await Hive.openBox(_metaName);

    // Add sample medicines only the very first time the app runs.
    if (_meta.get('seeded') != true) {
      for (final medicine in _sampleMedicines()) {
        await _medicines.put(medicine.id, medicine.toMap());
      }
      await _meta.put('seeded', true);
    }
  }

  // --------------------------------------------------------------- medicines secktion

  static List<Medicine> getMedicines() {
    final list = _medicines.values
        .map((e) => Medicine.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  /// Adds a new medicina
  static Future<void> addMedicine(Medicine medicine) async {
    await _medicines.put(medicine.id, medicine.toMap());
    if (medicine.quantity > 0) {
      await _logMovement(
        medicine: medicine,
        isIn: true,
        quantity: medicine.quantity,
        note: 'Initial stock',
      );
    }
  }

  /// Saves edited details
  static Future<void> updateMedicine(Medicine medicine) =>
      _medicines.put(medicine.id, medicine.toMap());

  /// Deletes the medicine. Its stock history is kept.
  static Future<void> deleteMedicine(String id) => _medicines.delete(id);

  // ------------------------------------------------------------------- stock sektor


  static Future<bool> applyStockChange({
    required Medicine medicine,
    required bool isIn,
    required int quantity,
    String note = '',
  }) async {
    if (quantity <= 0) return false;
    if (!isIn && quantity > medicine.quantity) return false; // can't go below 0

    medicine.quantity += isIn ? quantity : -quantity;
    await _medicines.put(medicine.id, medicine.toMap());
    await _logMovement(
      medicine: medicine,
      isIn: isIn,
      quantity: quantity,
      note: note,
    );
    return true;
  }

  static Future<void> _logMovement({
    required Medicine medicine,
    required bool isIn,
    required int quantity,
    required String note,
  }) {
    final now = DateTime.now();
    final movement = StockMovement(
      id: now.microsecondsSinceEpoch.toString(),
      medicineId: medicine.id,
      medicineName: medicine.displayName,
      isIn: isIn,
      quantity: quantity,
      balanceAfter: medicine.quantity,
      date: now,
      note: note,
    );
    return _movements.put(movement.id, movement.toMap());
  }

  static List<StockMovement> getMovements() {
    final list = _movements.values
        .map((e) => StockMovement.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
    list.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : b.id.compareTo(a.id);
    });
    return list;
  }

  // ------------------------------------------------------------- sample data

  /// Fake demo data. Expiry dates are relative to today so the
  /// "Near expiry" and "Expired" flags always show up in the demo.
  static List<Medicine> _sampleMedicines() {
    final now = DateTime.now();
    DateTime inDays(int days) => DateTime(now.year, now.month, now.day + days);

    return [
      Medicine(id: 'm01', name: 'Paracetamol', strength: '500mg', category: 'Pain Relief', quantity: 120, minStock: 30, expiryDate: inDays(420)),
      Medicine(id: 'm02', name: 'Ibuprofen', strength: '200mg', category: 'Pain Relief', quantity: 18, minStock: 25, expiryDate: inDays(300)),
      Medicine(id: 'm03', name: 'Amoxicillin', strength: '500mg', category: 'Antibiotic', quantity: 60, minStock: 20, expiryDate: inDays(21)),
      Medicine(id: 'm04', name: 'Cetirizine', strength: '10mg', category: 'Allergy', quantity: 45, minStock: 15, expiryDate: inDays(-12)),
      Medicine(id: 'm05', name: 'Vitamin C', strength: '500mg', category: 'Vitamins', quantity: 0, minStock: 20, expiryDate: inDays(200)),
      Medicine(id: 'm06', name: 'Oral Rehydration Salts', strength: '', category: 'First Aid', quantity: 80, minStock: 20, expiryDate: inDays(500)),
      Medicine(id: 'm07', name: 'Cough Syrup', strength: '120ml', category: 'Cough & Cold', quantity: 12, minStock: 10, expiryDate: inDays(14)),
      Medicine(id: 'm08', name: 'Isopropyl Alcohol', strength: '70% 500ml', category: 'First Aid', quantity: 25, minStock: 10, expiryDate: inDays(600)),
    ];
  }
}
