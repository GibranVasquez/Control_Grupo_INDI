enum UserRole { operator, administrative, admin }

class MockUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String phone;
  final String employeeId;
  final String supervisor;
  final String photoUrl;
  final List<String> assignedVehicleIds;

  const MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
    this.employeeId = '',
    this.supervisor = '',
    this.photoUrl = '',
    this.assignedVehicleIds = const [],
  });

  MockVehicle? get assignedVehicle {
    if (assignedVehicleIds.isEmpty) return null;
    for (final v in MockData.vehicles) {
      if (v.id == assignedVehicleIds.first) return v;
    }
    return null;
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts[0][0];
  }

  String get roleLabel {
    switch (role) {
      case UserRole.operator:
        return 'Operador';
      case UserRole.administrative:
        return 'Administrativo';
      case UserRole.admin:
        return 'Administrador';
    }
  }
}

enum FuelType { diesel, magna, premium }

extension FuelTypeX on FuelType {
  String get label {
    switch (this) {
      case FuelType.diesel:
        return 'Diésel';
      case FuelType.magna:
        return 'Gasolina Magna';
      case FuelType.premium:
        return 'Gasolina Premium';
    }
  }
}

enum VehicleCategory { vehicle, machinery }

extension VehicleCategoryX on VehicleCategory {
  String get label {
    switch (this) {
      case VehicleCategory.vehicle:
        return 'Vehículo';
      case VehicleCategory.machinery:
        return 'Maquinaria';
    }
  }
}

class MockProject {
  final String id;
  final String name;
  final String location;
  final String status;
  final String progress;
  final int vehicleCount;
  final double budget;

  const MockProject({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.progress,
    required this.vehicleCount,
    required this.budget,
  });
}

class MockVehicle {
  final String id;
  final String plate;
  final String brand;
  final String model;
  final String color;
  final int year;
  final String type;
  final VehicleCategory category;
  final String status;
  final FuelType fuelType;
  final double lastOdometer;
  final double tankCapacity;
  final double expectedPerformance;
  final String lastMaintenanceDate;
  final String nextMaintenanceDate;
  final String insuranceExpiry;

  const MockVehicle({
    required this.id,
    required this.plate,
    required this.brand,
    required this.model,
    this.color = '',
    required this.year,
    required this.type,
    required this.category,
    required this.status,
    required this.fuelType,
    required this.lastOdometer,
    required this.tankCapacity,
    this.expectedPerformance = 0,
    this.lastMaintenanceDate = '',
    this.nextMaintenanceDate = '',
    this.insuranceExpiry = '',
  });
}

class MockExpense {
  final String id;
  final String date;
  final String week;
  final MockProject project;
  final MockVehicle vehicle;
  final MockUser operator;
  final double odometer;
  final double liters;
  final FuelType fuelType;
  final double costPerLiter;
  final double total;
  final String folio;
  final String? notes;
  String status;
  final bool hasTicket;
  String authorizedBy;

  MockExpense({
    required this.id,
    required this.date,
    required this.week,
    required this.project,
    required this.vehicle,
    required this.operator,
    required this.odometer,
    required this.liters,
    required this.fuelType,
    required this.costPerLiter,
    required this.total,
    required this.folio,
    this.notes,
    required this.status,
    this.hasTicket = false,
    this.authorizedBy = '',
  });

  MockExpense copyWith({String? status, String? authorizedBy}) {
    return MockExpense(
      id: id,
      date: date,
      week: week,
      project: project,
      vehicle: vehicle,
      operator: operator,
      odometer: odometer,
      liters: liters,
      fuelType: fuelType,
      costPerLiter: costPerLiter,
      total: total,
      folio: folio,
      notes: notes,
      status: status ?? this.status,
      hasTicket: hasTicket,
      authorizedBy: authorizedBy ?? this.authorizedBy,
    );
  }
}

class MockBudget {
  final String id;
  final String date;
  final String week;
  final MockProject project;
  final MockVehicle vehicle;
  final MockUser operator;
  final double approvedLiters;
  final FuelType fuelType;
  final double estimatedCost;
  final double spentLiters;
  final double spentAmount;
  final String status;
  final String authorizedBy;

  const MockBudget({
    required this.id,
    required this.date,
    required this.week,
    required this.project,
    required this.vehicle,
    required this.operator,
    required this.approvedLiters,
    required this.fuelType,
    required this.estimatedCost,
    required this.spentLiters,
    required this.spentAmount,
    required this.status,
    required this.authorizedBy,
  });

  double get remainingLiters => approvedLiters - spentLiters;
  double get remainingBudget => estimatedCost - spentAmount;
}

class MockData {
  static final users = [
    const MockUser(
      id: 'U-001',
      name: 'Carlos Mendoza',
      email: 'carlos',
      password: '123',
      role: UserRole.operator,
      phone: '555-1001',
      employeeId: 'INDI-045',
      supervisor: 'Pedro Ramírez',
      assignedVehicleIds: ['V-001'],
    ),
    const MockUser(
      id: 'U-002',
      name: 'Juan Pérez',
      email: 'juan',
      password: '123',
      role: UserRole.operator,
      phone: '555-1002',
      employeeId: 'INDI-046',
      supervisor: 'Pedro Ramírez',
      assignedVehicleIds: ['V-002'],
    ),
    const MockUser(
      id: 'U-003',
      name: 'Roberto García',
      email: 'roberto',
      password: '123',
      role: UserRole.operator,
      phone: '555-1003',
      employeeId: 'INDI-047',
      supervisor: 'Admin INDI',
      assignedVehicleIds: ['V-003'],
    ),
    const MockUser(
      id: 'U-004',
      name: 'Luis Hernández',
      email: 'luis',
      password: '123',
      role: UserRole.operator,
      phone: '555-1004',
      employeeId: 'INDI-048',
      supervisor: 'Admin INDI',
      assignedVehicleIds: ['V-006'],
    ),
    const MockUser(
      id: 'U-005',
      name: 'Pedro Ramírez',
      email: 'pedro',
      password: '123',
      role: UserRole.administrative,
      phone: '555-2001',
      employeeId: 'INDI-100',
    ),
    const MockUser(
      id: 'U-006',
      name: 'Admin INDI',
      email: 'admin',
      password: '123',
      role: UserRole.admin,
      phone: '555-0001',
      employeeId: 'INDI-001',
    ),
  ];

  static const projects = [
    MockProject(
      id: 'P-001',
      name: 'Edificio Corporativo Norte',
      location: 'Av. Insurgentes 1500, CDMX',
      status: 'Activa',
      progress: '65%',
      vehicleCount: 3,
      budget: 450000,
    ),
    MockProject(
      id: 'P-002',
      name: 'Puente Vehicular Sur',
      location: 'Carretera México-Cuernavaca',
      status: 'Activa',
      progress: '40%',
      vehicleCount: 2,
      budget: 280000,
    ),
    MockProject(
      id: 'P-003',
      name: 'Planta de Tratamiento',
      location: 'Edo. de México, Zona Industrial',
      status: 'Activa',
      progress: '80%',
      vehicleCount: 4,
      budget: 620000,
    ),
    MockProject(
      id: 'P-004',
      name: 'Centro Comercial Este',
      location: 'Av. Central 500, Puebla',
      status: 'Pendiente',
      progress: '0%',
      vehicleCount: 0,
      budget: 890000,
    ),
    MockProject(
      id: 'P-005',
      name: 'Conjunto Habitacional Verde',
      location: 'Periférico Sur 2000, CDMX',
      status: 'Activa',
      progress: '25%',
      vehicleCount: 2,
      budget: 340000,
    ),
  ];

  static const vehicles = [
    MockVehicle(
      id: 'V-001',
      plate: 'TS-01',
      brand: 'Nissan',
      model: 'NP300',
      color: 'Blanco',
      year: 2023,
      type: 'Camioneta',
      category: VehicleCategory.vehicle,
      status: 'Activo',
      fuelType: FuelType.magna,
      lastOdometer: 15420,
      tankCapacity: 75,
      expectedPerformance: 10.5,
      lastMaintenanceDate: '15/05/2026',
      nextMaintenanceDate: '15/08/2026',
      insuranceExpiry: '31/12/2026',
    ),
    MockVehicle(
      id: 'V-002',
      plate: 'TS-02',
      brand: 'Toyota',
      model: 'Hilux',
      color: 'Gris',
      year: 2022,
      type: 'Camioneta',
      category: VehicleCategory.vehicle,
      status: 'Activo',
      fuelType: FuelType.diesel,
      lastOdometer: 28300,
      tankCapacity: 80,
      expectedPerformance: 12.0,
      lastMaintenanceDate: '01/05/2026',
      nextMaintenanceDate: '01/08/2026',
      insuranceExpiry: '30/06/2026',
    ),
    MockVehicle(
      id: 'V-003',
      plate: 'TS-03',
      brand: 'Kenworth',
      model: 'T660',
      color: 'Azul',
      year: 2021,
      type: 'Camión',
      category: VehicleCategory.vehicle,
      status: 'Activo',
      fuelType: FuelType.diesel,
      lastOdometer: 89150,
      tankCapacity: 300,
      expectedPerformance: 4.2,
      lastMaintenanceDate: '20/04/2026',
      nextMaintenanceDate: '20/07/2026',
      insuranceExpiry: '15/09/2026',
    ),
    MockVehicle(
      id: 'V-004',
      plate: 'TS-04',
      brand: 'Mercedes Benz',
      model: 'Actros',
      color: 'Blanco',
      year: 2023,
      type: 'Camión',
      category: VehicleCategory.vehicle,
      status: 'Activo',
      fuelType: FuelType.diesel,
      lastOdometer: 12400,
      tankCapacity: 280,
      expectedPerformance: 4.5,
      lastMaintenanceDate: '10/06/2026',
      nextMaintenanceDate: '10/09/2026',
      insuranceExpiry: '31/12/2026',
    ),
    MockVehicle(
      id: 'V-005',
      plate: 'TS-05',
      brand: 'Ford',
      model: 'Transit',
      color: 'Blanco',
      year: 2022,
      type: 'Van',
      category: VehicleCategory.vehicle,
      status: 'Activo',
      fuelType: FuelType.magna,
      lastOdometer: 32100,
      tankCapacity: 60,
      expectedPerformance: 8.0,
      lastMaintenanceDate: '25/03/2026',
      nextMaintenanceDate: '25/06/2026',
      insuranceExpiry: '15/08/2026',
    ),
    MockVehicle(
      id: 'V-006',
      plate: 'TS-06',
      brand: 'Chevrolet',
      model: 'Silverado',
      color: 'Negro',
      year: 2020,
      type: 'Camioneta',
      category: VehicleCategory.vehicle,
      status: 'Mantenimiento',
      fuelType: FuelType.premium,
      lastOdometer: 67200,
      tankCapacity: 70,
      expectedPerformance: 7.5,
      lastMaintenanceDate: '01/06/2026',
      nextMaintenanceDate: '01/09/2026',
      insuranceExpiry: '30/04/2026',
    ),
    // Maquinaria pesada
    MockVehicle(
      id: 'M-001',
      plate: 'EX-01',
      brand: 'Caterpillar',
      model: '320D',
      color: 'Amarillo',
      year: 2022,
      type: 'Excavadora',
      category: VehicleCategory.machinery,
      status: 'Activo',
      fuelType: FuelType.diesel,
      lastOdometer: 4200,
      tankCapacity: 400,
      expectedPerformance: 3.5,
      lastMaintenanceDate: '05/05/2026',
      nextMaintenanceDate: '05/08/2026',
      insuranceExpiry: '31/12/2026',
    ),
    MockVehicle(
      id: 'M-002',
      plate: 'CR-01',
      brand: 'Caterpillar',
      model: 'D6R',
      color: 'Amarillo',
      year: 2021,
      type: 'Compactador',
      category: VehicleCategory.machinery,
      status: 'Activo',
      fuelType: FuelType.diesel,
      lastOdometer: 3800,
      tankCapacity: 350,
      expectedPerformance: 3.0,
      lastMaintenanceDate: '12/04/2026',
      nextMaintenanceDate: '12/07/2026',
      insuranceExpiry: '31/12/2026',
    ),
    MockVehicle(
      id: 'M-003',
      plate: 'RC-01',
      brand: 'John Deere',
      model: '310L',
      color: 'Verde',
      year: 2023,
      type: 'Retroexcavadora',
      category: VehicleCategory.machinery,
      status: 'Activo',
      fuelType: FuelType.diesel,
      lastOdometer: 2100,
      tankCapacity: 250,
      expectedPerformance: 4.0,
      lastMaintenanceDate: '18/06/2026',
      nextMaintenanceDate: '18/09/2026',
      insuranceExpiry: '31/12/2026',
    ),
  ];

  static final List<MockExpense> _allExpenses = [
        MockExpense(
          id: 'G-001',
          date: '06/07/2026',
          week: 'Sem 27',
          project: projects[0],
          vehicle: vehicles[0],
          operator: users[0],
          odometer: 15420,
          liters: 45.5,
          fuelType: FuelType.magna,
          costPerLiter: 24.50,
          total: 1114.75,
          folio: 'T-2024-0001',
          notes: 'Carga completa para ruta diaria',
          status: 'Aprobado',
          hasTicket: true,
          authorizedBy: 'Pedro Ramírez',
        ),
        MockExpense(
          id: 'G-002',
          date: '06/07/2026',
          week: 'Sem 27',
          project: projects[2],
          vehicle: vehicles[2],
          operator: users[2],
          odometer: 89150,
          liters: 200.0,
          fuelType: FuelType.diesel,
          costPerLiter: 22.80,
          total: 4560.00,
          folio: 'T-2024-0002',
          status: 'Pendiente',
          hasTicket: true,
        ),
        MockExpense(
          id: 'G-003',
          date: '06/07/2026',
          week: 'Sem 27',
          project: projects[1],
          vehicle: vehicles[1],
          operator: users[1],
          odometer: 28300,
          liters: 60.0,
          fuelType: FuelType.diesel,
          costPerLiter: 22.80,
          total: 1368.00,
          folio: 'T-2024-0003',
          notes: 'Carga antes de ruta larga',
          status: 'Aprobado',
          hasTicket: false,
          authorizedBy: 'Pedro Ramírez',
        ),
        // Maquinaria hoy
        MockExpense(
          id: 'G-007',
          date: '06/07/2026',
          week: 'Sem 27',
          project: projects[0],
          vehicle: vehicles[6],
          operator: users[3],
          odometer: 4200,
          liters: 150.0,
          fuelType: FuelType.diesel,
          costPerLiter: 22.80,
          total: 3420.00,
          folio: 'T-2024-0007',
          notes: 'Carga excavadora - obra norte',
          status: 'Aprobado',
          hasTicket: true,
          authorizedBy: 'Admin INDI',
        ),
        // Lunes (Sem 27)
        MockExpense(
          id: 'G-010',
          date: '30/06/2026',
          week: 'Sem 27',
          project: projects[0],
          vehicle: vehicles[0],
          operator: users[0],
          odometer: 15000,
          liters: 42.0,
          fuelType: FuelType.magna,
          costPerLiter: 24.20,
          total: 1016.40,
          folio: 'T-2024-010',
          status: 'Aprobado',
          authorizedBy: 'Pedro Ramírez',
        ),
        MockExpense(
          id: 'G-011',
          date: '30/06/2026',
          week: 'Sem 27',
          project: projects[2],
          vehicle: vehicles[6],
          operator: users[3],
          odometer: 4000,
          liters: 180.0,
          fuelType: FuelType.diesel,
          costPerLiter: 22.50,
          total: 4050.00,
          folio: 'T-2024-011',
          status: 'Aprobado',
          authorizedBy: 'Admin INDI',
        ),
        // Martes
        MockExpense(
          id: 'G-012',
          date: '01/07/2026',
          week: 'Sem 27',
          project: projects[1],
          vehicle: vehicles[1],
          operator: users[1],
          odometer: 28000,
          liters: 55.0,
          fuelType: FuelType.diesel,
          costPerLiter: 22.60,
          total: 1243.00,
          folio: 'T-2024-012',
          status: 'Aprobado',
          authorizedBy: 'Pedro Ramírez',
        ),
        MockExpense(
          id: 'G-013',
          date: '01/07/2026',
          week: 'Sem 27',
          project: projects[2],
          vehicle: vehicles[7],
          operator: users[2],
          odometer: 3700,
          liters: 200.0,
          fuelType: FuelType.diesel,
          costPerLiter: 22.60,
          total: 4520.00,
          folio: 'T-2024-013',
          status: 'Aprobado',
          authorizedBy: 'Admin INDI',
        ),
        // Miércoles
        MockExpense(
          id: 'G-014',
          date: '02/07/2026',
          week: 'Sem 27',
          project: projects[4],
          vehicle: vehicles[4],
          operator: users[0],
          odometer: 31800,
          liters: 48.0,
          fuelType: FuelType.magna,
          costPerLiter: 24.10,
          total: 1156.80,
          folio: 'T-2024-014',
          status: 'Aprobado',
          authorizedBy: 'Pedro Ramírez',
        ),
        // Jueves
        MockExpense(
          id: 'G-015',
          date: '03/07/2026',
          week: 'Sem 27',
          project: projects[0],
          vehicle: vehicles[5],
          operator: users[1],
          odometer: 67000,
          liters: 40.0,
          fuelType: FuelType.premium,
          costPerLiter: 26.00,
          total: 1040.00,
          folio: 'T-2024-015',
          status: 'Aprobado',
          authorizedBy: 'Pedro Ramírez',
        ),
        MockExpense(
          id: 'G-016',
          date: '03/07/2026',
          week: 'Sem 27',
          project: projects[2],
          vehicle: vehicles[8],
          operator: users[3],
          odometer: 2000,
          liters: 160.0,
          fuelType: FuelType.diesel,
          costPerLiter: 22.50,
          total: 3600.00,
          folio: 'T-2024-016',
          status: 'Pendiente',
          hasTicket: true,
        ),
        // Viernes
        MockExpense(
          id: 'G-017',
          date: '04/07/2026',
          week: 'Sem 27',
          project: projects[2],
          vehicle: vehicles[3],
          operator: users[0],
          odometer: 12400,
          liters: 180.0,
          fuelType: FuelType.diesel,
          costPerLiter: 22.50,
          total: 4050.00,
          folio: 'T-2024-005',
          notes: 'Carga nocturna',
          status: 'Rechazado',
          hasTicket: true,
        ),
        MockExpense(
          id: 'G-018',
          date: '04/07/2026',
          week: 'Sem 27',
          project: projects[4],
          vehicle: vehicles[4],
          operator: users[1],
          odometer: 31500,
          liters: 50.0,
          fuelType: FuelType.magna,
          costPerLiter: 24.00,
          total: 1200.00,
          folio: 'T-2024-006',
          status: 'Aprobado',
          authorizedBy: 'Pedro Ramírez',
        ),
        // Sábado
        MockExpense(
          id: 'G-019',
          date: '05/07/2026',
          week: 'Sem 27',
          project: projects[0],
          vehicle: vehicles[4],
          operator: users[3],
          odometer: 32100,
          liters: 55.0,
          fuelType: FuelType.magna,
          costPerLiter: 24.30,
          total: 1336.50,
          folio: 'T-2024-004',
          status: 'Aprobado',
          hasTicket: true,
          authorizedBy: 'Admin INDI',
        ),
      ];

  static List<MockExpense> get todayExpenses =>
      _allExpenses.where((e) => e.date == '06/07/2026').toList();

  static List<MockExpense> get allExpenses => _allExpenses;

  static List<MockBudget> get budgets => [
        MockBudget(
          id: 'B-001',
          date: '30/06/2026',
          week: 'Sem 27',
          project: projects[0],
          vehicle: vehicles[0],
          operator: users[0],
          approvedLiters: 300,
          fuelType: FuelType.magna,
          estimatedCost: 7350.00,
          spentLiters: 87.5,
          spentAmount: 2131.15,
          status: 'Activo',
          authorizedBy: 'Pedro Ramírez',
        ),
        MockBudget(
          id: 'B-002',
          date: '30/06/2026',
          week: 'Sem 27',
          project: projects[2],
          vehicle: vehicles[2],
          operator: users[2],
          approvedLiters: 800,
          fuelType: FuelType.diesel,
          estimatedCost: 18240.00,
          spentLiters: 200.0,
          spentAmount: 4560.00,
          status: 'Activo',
          authorizedBy: 'Admin INDI',
        ),
        MockBudget(
          id: 'B-003',
          date: '30/06/2026',
          week: 'Sem 27',
          project: projects[2],
          vehicle: vehicles[6],
          operator: users[3],
          approvedLiters: 1000,
          fuelType: FuelType.diesel,
          estimatedCost: 22800.00,
          spentLiters: 330.0,
          spentAmount: 7470.00,
          status: 'Activo',
          authorizedBy: 'Admin INDI',
        ),
        MockBudget(
          id: 'B-004',
          date: '30/06/2026',
          week: 'Sem 27',
          project: projects[1],
          vehicle: vehicles[1],
          operator: users[1],
          approvedLiters: 400,
          fuelType: FuelType.diesel,
          estimatedCost: 9120.00,
          spentLiters: 115.0,
          spentAmount: 2611.00,
          status: 'Activo',
          authorizedBy: 'Pedro Ramírez',
        ),
        MockBudget(
          id: 'B-005',
          date: '30/06/2026',
          week: 'Sem 27',
          project: projects[0],
          vehicle: vehicles[5],
          operator: users[1],
          approvedLiters: 200,
          fuelType: FuelType.premium,
          estimatedCost: 5200.00,
          spentLiters: 40.0,
          spentAmount: 1040.00,
          status: 'Activo',
          authorizedBy: 'Pedro Ramírez',
        ),
        MockBudget(
          id: 'B-006',
          date: '23/06/2026',
          week: 'Sem 26',
          project: projects[2],
          vehicle: vehicles[7],
          operator: users[2],
          approvedLiters: 600,
          fuelType: FuelType.diesel,
          estimatedCost: 13560.00,
          spentLiters: 600.0,
          spentAmount: 13560.00,
          status: 'Completado',
          authorizedBy: 'Admin INDI',
        ),
      ];

  static const fuelTypes = [
    FuelType.diesel,
    FuelType.magna,
    FuelType.premium,
  ];

  static void updateExpenseStatus(String expenseId, String newStatus, String authorizedBy) {
    for (final expense in allExpenses) {
      if (expense.id == expenseId) {
        expense.status = newStatus;
        expense.authorizedBy = authorizedBy;
        return;
      }
    }
  }

  static void addExpense(MockExpense expense) {
    _allExpenses.insert(0, expense);
  }

  static void deleteExpense(String expenseId) {
    _allExpenses.removeWhere((e) => e.id == expenseId);
  }
}
