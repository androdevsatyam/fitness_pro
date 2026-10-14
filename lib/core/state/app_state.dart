import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/trainer_model.dart';
import '../models/booking_model.dart';
import '../models/review_model.dart';
import '../models/message_model.dart';
import '../models/support_model.dart';
import '../models/platform_settings_model.dart';

class AppState extends ChangeNotifier {
  // Current active view role
  UserRole _currentRole = UserRole.customer;
  UserRole get currentRole => _currentRole;

  // Active simulated user
  UserModel _currentUser = const UserModel(
    id: 'user_cust_01',
    name: 'Aarav Sharma',
    email: 'aarav.sharma@example.com',
    phone: '9845012345',
    role: UserRole.customer,
    city: 'Bengaluru',
    area: 'Indiranagar',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
    preferences: CustomerPreferences(
      primaryGoal: 'Fat Loss & Core Strength',
      trainingStyle: 'Functional & HIIT',
      experienceLevel: 'Intermediate',
      preferredDurationMinutes: 60,
      budgetPerSession: 1500,
      preferredLanguage: 'English / Hindi',
      sessionFormat: 'In-Person (Home)',
      exerciseLimitations: ['Mild lower back tightness'],
    ),
  );
  UserModel get currentUser => _currentUser;

  // Platform settings
  PlatformSettingsModel _platformSettings = const PlatformSettingsModel();
  PlatformSettingsModel get platformSettings => _platformSettings;

  // Trainers Database
  List<TrainerModel> _trainers = [];
  List<TrainerModel> get trainers => _trainers;

  // Bookings Database
  List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  // Reviews Database
  List<ReviewModel> _reviews = [];
  List<ReviewModel> get reviews => _reviews;

  // Support & Dispute Tickets
  List<SupportTicketModel> _supportTickets = [];
  List<SupportTicketModel> get supportTickets => _supportTickets;

  // Messages by Booking or Trainer Id
  final Map<String, List<MessageModel>> _messages = {};
  Map<String, List<MessageModel>> get messages => _messages;

  // Active Trainer Application in Progress (for Onboarding flow)
  TrainerModel? _draftTrainerApplication;
  TrainerModel? get draftTrainerApplication => _draftTrainerApplication;

  // Search and Filter State for discovery
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCity = 'Bengaluru';
  String get selectedCity => _selectedCity;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  double _maxBudget = 3000.0;
  double get maxBudget => _maxBudget;

  String _selectedGender = 'All';
  String get selectedGender => _selectedGender;

  // Authentication & Role-based Access Control
  bool _isCustomerRegistered = false; // Guest exploration enabled; booking requires registration
  bool get isCustomerRegistered => _isCustomerRegistered;

  bool _isTrainerRegistered = false; // Trainer portal requires registration/verification
  bool get isTrainerRegistered => _isTrainerRegistered;

  bool _isAdminRegistered = false; // Admin dashboard requires admin authentication
  bool get isAdminRegistered => _isAdminRegistered;

  bool _isSupportRegistered = false; // Support console requires agent authentication
  bool get isSupportRegistered => _isSupportRegistered;

  AppState() {
    _seedData();
  }

  void registerCustomer({
    required String name,
    required String phone,
    String email = '',
    String city = 'Bengaluru',
    CustomerPreferences? preferences,
  }) {
    _currentUser = _currentUser.copyWith(
      id: 'user_cust_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      email: email.isNotEmpty ? email : '$phone@fitpro.in',
      role: UserRole.customer,
      city: city,
      preferences: preferences ?? _currentUser.preferences,
    );
    _isCustomerRegistered = true;
    notifyListeners();
  }

  void logoutCustomer() {
    _isCustomerRegistered = false;
    notifyListeners();
  }

  void loginTrainer({String emailOrPhone = 'priya.fitness@example.com'}) {
    _isTrainerRegistered = true;
    _currentUser = _currentUser.copyWith(
      id: 'trainer_01',
      name: 'Priya Nair',
      role: UserRole.trainer,
      phone: '9880198801',
      email: emailOrPhone,
      city: 'Bengaluru',
    );
    notifyListeners();
  }

  void logoutTrainer() {
    _isTrainerRegistered = false;
    notifyListeners();
  }

  void loginAdmin({String email = 'admin.ops@fitpro.in'}) {
    _isAdminRegistered = true;
    _currentUser = _currentUser.copyWith(
      id: 'admin_01',
      name: 'Vikram Malhotra',
      role: UserRole.admin,
      phone: '9811223344',
      email: email,
      city: 'Bengaluru',
    );
    notifyListeners();
  }

  void logoutAdmin() {
    _isAdminRegistered = false;
    notifyListeners();
  }

  void loginSupport({String email = 'neha.support@fitpro.in'}) {
    _isSupportRegistered = true;
    _currentUser = _currentUser.copyWith(
      id: 'supp_01',
      name: 'Neha Patel',
      role: UserRole.support,
      phone: '9922334455',
      email: email,
      city: 'Bengaluru',
    );
    notifyListeners();
  }

  void logoutSupport() {
    _isSupportRegistered = false;
    notifyListeners();
  }

  void setRole(UserRole role) {
    _currentRole = role;
    switch (role) {
      case UserRole.customer:
        _currentUser = _currentUser.copyWith(
          id: 'user_cust_01',
          name: 'Aarav Sharma',
          role: UserRole.customer,
          phone: '9845012345',
          email: 'aarav.sharma@example.com',
          city: 'Bengaluru',
        );
        break;
      case UserRole.trainer:
        _currentUser = _currentUser.copyWith(
          id: 'trainer_01',
          name: 'Priya Nair',
          role: UserRole.trainer,
          phone: '9880198801',
          email: 'priya.fitness@example.com',
          city: 'Bengaluru',
        );
        break;
      case UserRole.admin:
        _currentUser = _currentUser.copyWith(
          id: 'admin_01',
          name: 'Vikram Malhotra',
          role: UserRole.admin,
          phone: '9811223344',
          email: 'admin.ops@fitpro.in',
          city: 'Bengaluru',
        );
        break;
      case UserRole.support:
        _currentUser = _currentUser.copyWith(
          id: 'supp_01',
          name: 'Neha Patel',
          role: UserRole.support,
          phone: '9922334455',
          email: 'neha.support@fitpro.in',
          city: 'Bengaluru',
        );
        break;
    }
    notifyListeners();
  }

  void updateSearchFilters({
    String? query,
    String? city,
    String? category,
    double? maxBudget,
    String? gender,
  }) {
    if (query != null) _searchQuery = query;
    if (city != null) _selectedCity = city;
    if (category != null) _selectedCategory = category;
    if (maxBudget != null) _maxBudget = maxBudget;
    if (gender != null) _selectedGender = gender;
    notifyListeners();
  }

  List<TrainerModel> get filteredTrainers {
    return _trainers.where((t) {
      if (t.verificationStatus != VerificationStatus.approved) return false;
      if (t.isProfilePaused) return false;

      // City filter
      if (_selectedCity != 'All' && t.city != _selectedCity) {
        return false;
      }

      // Query filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = t.name.toLowerCase().contains(q) ||
            t.headline.toLowerCase().contains(q) ||
            t.serviceAreas.any((a) => a.toLowerCase().contains(q)) ||
            t.services.any((s) => s.category.toLowerCase().contains(q));
        if (!match) return false;
      }

      // Category filter
      if (_selectedCategory != 'All') {
        final matchesCat = t.services.any((s) =>
            s.category.toLowerCase() == _selectedCategory.toLowerCase());
        if (!matchesCat) return false;
      }

      // Budget filter (minimum starting service price <= maxBudget)
      final minPrice = t.services.isEmpty
          ? 0.0
          : t.services.map((s) => s.priceInr).reduce((a, b) => a < b ? a : b);
      if (minPrice > _maxBudget) return false;

      // Gender filter
      if (_selectedGender != 'All' &&
          t.gender != 'Any' &&
          t.gender != _selectedGender) {
        return false;
      }

      return true;
    }).toList();
  }

  // --- Booking Operations ---
  void createBooking(BookingModel booking) {
    _bookings.insert(0, booking);
    // Initialize empty message thread
    _messages[booking.id] = [
      MessageModel(
        id: 'msg_welcome_${booking.id}',
        senderId: booking.trainerId,
        senderName: booking.trainerName,
        text:
            'Hello ${booking.customerName}! Looking forward to our session at ${booking.locationType}. Please let me know if you have specific fitness equipment available.',
        timestamp: DateTime.now(),
        isFromCustomer: false,
        bookingId: booking.id,
      )
    ];
    notifyListeners();
  }

  void updateBookingStatus(String bookingId, BookingStatus newStatus, {String? reason}) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final current = _bookings[index];
      _bookings[index] = current.copyWith(
        status: newStatus,
        cancellationReason: reason ?? current.cancellationReason,
        checkInTime: newStatus == BookingStatus.inProgress ? DateTime.now() : current.checkInTime,
        completedTime: newStatus == BookingStatus.completed ? DateTime.now() : current.completedTime,
      );
      notifyListeners();
    }
  }

  // --- Review Operations ---
  void addReview(ReviewModel review) {
    _reviews.insert(0, review);
    // Update trainer rating and review count
    final trainerIndex = _trainers.indexWhere((t) => t.id == review.trainerId);
    if (trainerIndex != -1) {
      final trainer = _trainers[trainerIndex];
      final newCount = trainer.reviewCount + 1;
      final newRating = ((trainer.rating * trainer.reviewCount) + review.rating) / newCount;
      _trainers[trainerIndex] = trainer.copyWith(
        rating: double.parse(newRating.toStringAsFixed(1)),
        reviewCount: newCount,
      );
    }
    // Mark booking as reviewed
    final bookingIndex = _bookings.indexWhere((b) => b.id == review.bookingId);
    if (bookingIndex != -1) {
      _bookings[bookingIndex] = _bookings[bookingIndex].copyWith(isReviewed: true);
    }
    notifyListeners();
  }

  // --- Chat Operations ---
  void sendMessage(String bookingId, String text, bool isFromCustomer) {
    final msg = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _currentUser.id,
      senderName: _currentUser.name,
      text: text,
      timestamp: DateTime.now(),
      isFromCustomer: isFromCustomer,
      bookingId: bookingId,
    );
    if (!_messages.containsKey(bookingId)) {
      _messages[bookingId] = [];
    }
    _messages[bookingId]!.add(msg);
    notifyListeners();
  }

  // --- Admin Verification Operations ---
  void updateTrainerVerification(String trainerId, VerificationStatus newStatus) {
    final index = _trainers.indexWhere((t) => t.id == trainerId);
    if (index != -1) {
      _trainers[index] = _trainers[index].copyWith(verificationStatus: newStatus);
      notifyListeners();
    }
  }

  void updatePlatformCommission(double newPercent) {
    _platformSettings = _platformSettings.copyWith(platformCommissionPercent: newPercent);
    notifyListeners();
  }

  void updateBaseTravelFee(double newFee) {
    _platformSettings = _platformSettings.copyWith(baseTravelFeeInr: newFee);
    notifyListeners();
  }

  void resolveDispute(String ticketId, String resolutionNotes, {bool issueRefund = false}) {
    final index = _supportTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final ticket = _supportTickets[index];
      _supportTickets[index] = ticket.copyWith(
        status: TicketStatus.resolved,
        resolutionNotes: resolutionNotes,
      );
      if (issueRefund) {
        updateBookingStatus(ticket.bookingId, BookingStatus.refunded);
      }
      notifyListeners();
    }
  }

  void createSupportTicket(SupportTicketModel ticket) {
    _supportTickets.insert(0, ticket);
    updateBookingStatus(ticket.bookingId, BookingStatus.disputed);
    notifyListeners();
  }

  void updateCustomerPreferences(CustomerPreferences newPrefs) {
    _currentUser = _currentUser.copyWith(preferences: newPrefs);
    notifyListeners();
  }

  void toggleTrainerPauseStatus(String trainerId) {
    final index = _trainers.indexWhere((t) => t.id == trainerId);
    if (index != -1) {
      final current = _trainers[index];
      _trainers[index] = current.copyWith(isProfilePaused: !current.isProfilePaused);
      notifyListeners();
    }
  }

  void submitTrainerApplication(TrainerModel newApp) {
    _trainers.insert(0, newApp);
    _draftTrainerApplication = null;
    notifyListeners();
  }

  // --- Seed Demo Data (India Market Centric) ---
  void _seedData() {
    _trainers = [
      TrainerModel(
        id: 'trainer_01',
        name: 'Priya Nair',
        headline: 'ACE & K11 Certified Functional & Strength Coach',
        bio:
            'Former athlete with 6+ years of personal coaching experience in Bengaluru. Specializing in sustainable fat loss, kettlebell conditioning, and posture correction for desk professionals. Provides all portable workout equipment at your doorstep.',
        photoUrl: 'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=400&q=80',
        rating: 4.9,
        reviewCount: 42,
        experienceYears: 6,
        languages: ['English', 'Hindi', 'Kannada'],
        city: 'Bengaluru',
        serviceAreas: ['Indiranagar', 'Koramangala', 'HSR Layout', 'Domlur'],
        maxTravelRadiusKm: 8.0,
        preferredTrainingLocations: ['Customer Home', 'Apartment Society Gym', 'Cubbon Park'],
        verificationStatus: VerificationStatus.approved,
        idVerified: true,
        gender: 'Female',
        nextAvailableSlot: 'Tomorrow, 7:00 AM',
        totalEarningsInr: 58400,
        completedSessionsCount: 46,
        qualifications: const [
          Qualification(
            id: 'q1',
            certName: 'Certified Personal Trainer (CPT)',
            issuingOrg: 'American Council on Exercise (ACE)',
            certNumber: 'ACE-IN-889124',
            issueDate: '2020-03-15',
            expiryDate: '2026-03-15',
            isVerified: true,
          ),
          Qualification(
            id: 'q2',
            certName: 'Advanced Kettlebell & Mobility Specialist',
            issuingOrg: 'K11 School of Fitness Sciences',
            certNumber: 'K11-BLR-4019',
            issueDate: '2021-08-10',
            expiryDate: '2027-08-10',
            isVerified: true,
          ),
        ],
        services: const [
          ServiceOffering(
            id: 'srv_1',
            title: '1-on-1 Functional & HIIT Training',
            description: 'Customized bodyweight, resistance bands and kettlebell training targeted for fat loss and cardio endurance.',
            category: 'Functional Training',
            durationMinutes: 60,
            priceInr: 1200,
            sessionType: '1-on-1 Personal',
            equipmentProvided: 'Kettlebells (8/12kg), Resistance loop bands, Agility ladder',
            travelSurchargeInr: 100,
          ),
          ServiceOffering(
            id: 'srv_2',
            title: 'Core Strength & Posture Alignment',
            description: 'Focus on thoracic mobility, glute activation and lower back relief for sedentary workers.',
            category: 'Mobility & Rehab',
            durationMinutes: 45,
            priceInr: 1000,
            sessionType: '1-on-1 Personal',
            equipmentProvided: 'Foam roller, therapy bands, yoga blocks',
            travelSurchargeInr: 80,
          ),
          ServiceOffering(
            id: 'srv_3',
            title: 'Partner / Small Group Conditioning (2-3 Pax)',
            description: 'High energy partner workout for couples or apartment buddies looking to train together.',
            category: 'Functional Training',
            durationMinutes: 60,
            priceInr: 1800,
            sessionType: 'Small Group',
            equipmentProvided: 'Full portable circuit set',
            travelSurchargeInr: 150,
          ),
        ],
      ),
      TrainerModel(
        id: 'trainer_02',
        name: 'Rohan Deshmukh',
        headline: 'Yoga Alliance 500-HR Registered & Ashtanga Master',
        bio:
            'Dedicated classical Hatha and Vinyasa instructor with 8 years of teaching across Mumbai and Pune. Works with beginners up to advanced practitioners with mindful breathwork (Pranayama) and restorative flexibility.',
        photoUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&q=80',
        rating: 4.95,
        reviewCount: 68,
        experienceYears: 8,
        languages: ['English', 'Marathi', 'Hindi'],
        city: 'Mumbai',
        serviceAreas: ['Bandra West', 'Khar', 'Juhu', 'Santacruz'],
        maxTravelRadiusKm: 6.0,
        preferredTrainingLocations: ['Customer Home', 'Carter Road Promenade', 'Society Clubhouse'],
        verificationStatus: VerificationStatus.approved,
        idVerified: true,
        gender: 'Male',
        nextAvailableSlot: 'Today, 6:00 PM',
        totalEarningsInr: 92000,
        completedSessionsCount: 74,
        qualifications: const [
          Qualification(
            id: 'q3',
            certName: '500-Hour RYT Advanced Yoga Master',
            issuingOrg: 'Yoga Alliance International',
            certNumber: 'YA-500-4821',
            issueDate: '2019-01-20',
            expiryDate: '2029-01-20',
            isVerified: true,
          ),
        ],
        services: const [
          ServiceOffering(
            id: 'srv_4',
            title: 'Authentic Vinyasa Flow & Breathwork',
            description: 'Dynamic sequencing designed to build lean core strength, improve flexibility, and release mental stress.',
            category: 'Yoga & Mindfulness',
            durationMinutes: 60,
            priceInr: 1400,
            sessionType: '1-on-1 Personal',
            equipmentProvided: 'Organic cork blocks, yoga straps',
            travelSurchargeInr: 100,
          ),
          ServiceOffering(
            id: 'srv_5',
            title: 'Restorative Yoga for Senior Adults & Joint Care',
            description: 'Gentle, therapeutic movements with chair modifications to protect knees, hips, and lower spine.',
            category: 'Senior Fitness',
            durationMinutes: 45,
            priceInr: 1100,
            sessionType: '1-on-1 Personal',
            equipmentProvided: 'Bolster, stretch straps, knee pads',
            travelSurchargeInr: 100,
          ),
        ],
      ),
      TrainerModel(
        id: 'trainer_03',
        name: 'Ananya Sengupta',
        headline: 'Women\'s Pre/Postnatal & Strength Conditioning Specialist',
        bio:
            'Passionate advocate for women\'s health and safe weight lifting. Specially certified in diastasis recti recovery, pelvic floor strengthening, and progressive home calisthenics.',
        photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&q=80',
        rating: 4.88,
        reviewCount: 35,
        experienceYears: 5,
        languages: ['English', 'Hindi', 'Bengali'],
        city: 'Bengaluru',
        serviceAreas: ['Whitefield', 'Bellandur', 'Sarjapur Road', 'Marathahalli'],
        maxTravelRadiusKm: 10.0,
        preferredTrainingLocations: ['Customer Home', 'Society Gym'],
        verificationStatus: VerificationStatus.approved,
        idVerified: true,
        gender: 'Female',
        nextAvailableSlot: 'Tomorrow, 10:00 AM',
        totalEarningsInr: 44000,
        completedSessionsCount: 36,
        qualifications: const [
          Qualification(
            id: 'q4',
            certName: 'Certified Pre/Postnatal Fitness Coach',
            issuingOrg: 'Girls Gone Strong (GGS)',
            certNumber: 'GGS-CPPC-391',
            issueDate: '2021-04-12',
            expiryDate: '2027-04-12',
            isVerified: true,
          ),
        ],
        services: const [
          ServiceOffering(
            id: 'srv_6',
            title: 'Women\'s Strength & Postnatal Rehabilitation',
            description: 'Safe, empowering functional strength designed for postpartum recovery and long-term joint health.',
            category: 'Women\'s Fitness',
            durationMinutes: 60,
            priceInr: 1500,
            sessionType: '1-on-1 Personal',
            equipmentProvided: 'Adjustable dumbbells, hip bands, mini pilates ball',
            travelSurchargeInr: 120,
          ),
        ],
      ),
      TrainerModel(
        id: 'trainer_04',
        name: 'Kabir Verma',
        headline: 'ACSM Certified Bodyweight & Calisthenics Specialist',
        bio:
            'Calisthenics practitioner with 7 years of teaching experience. Master handstands, pull-up progressions, muscle-ups, and explosive body control without any gym machines.',
        photoUrl: 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?w=400&q=80',
        rating: 4.85,
        reviewCount: 29,
        experienceYears: 7,
        languages: ['English', 'Hindi', 'Punjabi'],
        city: 'Delhi NCR',
        serviceAreas: ['Gurugram Cyber City', 'Golf Course Road', 'South Delhi', 'Saket'],
        maxTravelRadiusKm: 12.0,
        preferredTrainingLocations: ['Public Park', 'Society Clubhouse', 'Customer Home'],
        verificationStatus: VerificationStatus.approved,
        idVerified: true,
        gender: 'Male',
        nextAvailableSlot: 'Tomorrow, 4:00 PM',
        totalEarningsInr: 39000,
        completedSessionsCount: 30,
        qualifications: const [
          Qualification(
            id: 'q5',
            certName: 'Certified Exercise Physiologist',
            issuingOrg: 'American College of Sports Medicine (ACSM)',
            certNumber: 'ACSM-EP-1094',
            issueDate: '2019-11-05',
            expiryDate: '2025-11-05',
            isVerified: true,
          ),
        ],
        services: const [
          ServiceOffering(
            id: 'srv_7',
            title: 'Pure Calisthenics & Bodyweight Mastery',
            description: 'Learn gymnastics body control, strict push/pull strength, and core compression right in your local park or living room.',
            category: 'Calisthenics & Bodyweight',
            durationMinutes: 60,
            priceInr: 1300,
            sessionType: '1-on-1 Personal',
            equipmentProvided: 'Parallettes, gymnastic rings, door pull-up bar',
            travelSurchargeInr: 100,
          ),
        ],
      ),
      // Under Review Trainer for Admin Queue Demonstration
      TrainerModel(
        id: 'trainer_pending_01',
        name: 'Devraj Chauhan',
        headline: 'ISSA Certified Strength & Conditioning Coach',
        bio:
            'Strength coach specializing in athletic performance, speed, and agility for runners and corporate badminton players.',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80',
        rating: 0.0,
        reviewCount: 0,
        experienceYears: 4,
        languages: ['English', 'Hindi'],
        city: 'Hyderabad',
        serviceAreas: ['Gachibowli', 'Hitec City', 'Jubilee Hills'],
        maxTravelRadiusKm: 8.0,
        preferredTrainingLocations: ['Customer Home', 'Society Gym'],
        verificationStatus: VerificationStatus.underReview,
        idVerified: true,
        gender: 'Male',
        nextAvailableSlot: 'Pending Verification',
        totalEarningsInr: 0,
        completedSessionsCount: 0,
        qualifications: const [
          Qualification(
            id: 'q6',
            certName: 'Certified Fitness Trainer',
            issuingOrg: 'International Sports Sciences Association (ISSA)',
            certNumber: 'ISSA-HYD-9982',
            issueDate: '2023-05-15',
            expiryDate: '2027-05-15',
            documentUrl: 'https://fitpro-assets.s3.ap-south-1.amazonaws.com/certs/issa_devraj.pdf',
            isVerified: false,
          ),
        ],
        services: const [
          ServiceOffering(
            id: 'srv_8',
            title: 'Athletic Conditioning & Agility',
            description: 'Footwork, explosive jumping and core stability for weekend sports enthusiasts.',
            category: 'Functional Training',
            durationMinutes: 60,
            priceInr: 1100,
            sessionType: '1-on-1 Personal',
          ),
        ],
      ),
    ];

    _bookings = [
      BookingModel(
        id: 'BK_IND_8901',
        trainerId: 'trainer_01',
        trainerName: 'Priya Nair',
        trainerPhoto: 'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=400&q=80',
        customerId: 'user_cust_01',
        customerName: 'Aarav Sharma',
        customerPhone: '+91 9845012345',
        serviceTitle: '1-on-1 Functional & HIIT Training',
        serviceCategory: 'Functional Training',
        durationMinutes: 60,
        scheduledDate: DateTime.now().add(const Duration(days: 1)),
        timeSlot: '07:00 AM - 08:00 AM',
        locationAddress: 'Flat 402, Prestige Palms, 12th Main Road, Indiranagar, Bengaluru',
        locationType: 'Customer Home',
        price: const PriceBreakdown(
          basePrice: 1200,
          platformFee: 144, // 12%
          travelFee: 100,
          discountAmount: 240, // FITFIRST promo applied
          gstAmount: 216.7, // 18% GST
          totalAmount: 1420.7,
        ),
        status: BookingStatus.confirmed,
        paymentMethod: 'UPI (GPay)',
        paymentTransactionId: 'UPI_HDFC_9921448',
        promoCodeApplied: 'FITFIRST',
      ),
      BookingModel(
        id: 'BK_IND_8902',
        trainerId: 'trainer_01',
        trainerName: 'Priya Nair',
        trainerPhoto: 'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=400&q=80',
        customerId: 'user_cust_02',
        customerName: 'Kavita Sundaram',
        customerPhone: '+91 9811224466',
        serviceTitle: 'Core Strength & Posture Alignment',
        serviceCategory: 'Mobility & Rehab',
        durationMinutes: 45,
        scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
        timeSlot: '06:30 PM - 07:15 PM',
        locationAddress: 'Villa 18, Palm Meadows, Whitefield, Bengaluru',
        locationType: 'Society Clubhouse',
        price: const PriceBreakdown(
          basePrice: 1000,
          platformFee: 120,
          travelFee: 80,
          discountAmount: 0,
          gstAmount: 216,
          totalAmount: 1416,
        ),
        status: BookingStatus.completed,
        paymentMethod: 'Credit Card (Visa)',
        paymentTransactionId: 'CC_RAZORPAY_88194',
        completedTime: DateTime.now().subtract(const Duration(days: 2)),
        isReviewed: true,
      ),
      // Booking under dispute demo for Admin & Support resolution
      BookingModel(
        id: 'BK_IND_8903',
        trainerId: 'trainer_04',
        trainerName: 'Kabir Verma',
        trainerPhoto: 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?w=400&q=80',
        customerId: 'user_cust_03',
        customerName: 'Sameer Sen',
        customerPhone: '+91 9922114433',
        serviceTitle: 'Pure Calisthenics & Bodyweight Mastery',
        serviceCategory: 'Calisthenics & Bodyweight',
        durationMinutes: 60,
        scheduledDate: DateTime.now().subtract(const Duration(days: 1)),
        timeSlot: '05:00 PM - 06:00 PM',
        locationAddress: 'Siri Fort Sports Complex, New Delhi',
        locationType: 'Public Park',
        price: const PriceBreakdown(
          basePrice: 1300,
          platformFee: 156,
          travelFee: 100,
          discountAmount: 0,
          gstAmount: 280,
          totalAmount: 1836,
        ),
        status: BookingStatus.disputed,
        paymentMethod: 'UPI (Paytm)',
        paymentTransactionId: 'UPI_PAYTM_339182',
        cancellationReason: 'Trainer arrived 45 minutes late due to traffic; session could not finish.',
      ),
    ];

    _reviews = [
      ReviewModel(
        id: 'rev_01',
        bookingId: 'BK_IND_8902',
        customerName: 'Kavita Sundaram',
        customerPhoto: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80',
        trainerId: 'trainer_01',
        rating: 5.0,
        comment:
            'Priya is phenomenal! She came right to my apartment gym with resistance bands and kettlebells. Her cues for posture and pelvic tilt completely relieved my lower back ache. Highly recommended!',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isVerifiedBooking: true,
      ),
      ReviewModel(
        id: 'rev_02',
        bookingId: 'BK_IND_7890',
        customerName: 'Aditya Rao',
        customerPhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
        trainerId: 'trainer_01',
        rating: 4.8,
        comment:
            'Extremely punctual and professional. The 60-minute HIIT workout was tough but scaled perfectly for my fitness level. Great to have quality personal training without paying for expensive annual gym memberships.',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        isVerifiedBooking: true,
      ),
      ReviewModel(
        id: 'rev_03',
        bookingId: 'BK_IND_7761',
        customerName: 'Sunita Mehra',
        customerPhoto: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=100&q=80',
        trainerId: 'trainer_02',
        rating: 5.0,
        comment:
            'Rohan is a master of breath and alignment. Training along Carter Road promenade early in the morning brought a rare calm to my busy week.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isVerifiedBooking: true,
      ),
    ];

    _supportTickets = [
      SupportTicketModel(
        id: 'TCK_991',
        bookingId: 'BK_IND_8903',
        customerName: 'Sameer Sen',
        trainerName: 'Kabir Verma',
        category: 'Trainer Late / Incomplete Session',
        description:
            'Customer reported that trainer Kabir arrived 45 minutes late for the Siri Fort appointment due to ring-road traffic. Customer had a flight and could not complete the session. Requesting 100% refund.',
        priority: TicketPriority.high,
        status: TicketStatus.open,
        createdAt: DateTime.now().subtract(const Duration(hours: 14)),
        requestedRefundInr: 1836,
      ),
      SupportTicketModel(
        id: 'TCK_992',
        bookingId: 'BK_IND_8102',
        customerName: 'Meera Chawla',
        trainerName: 'Priya Nair',
        category: 'Reschedule Request Under 4h Notice',
        description:
            'Customer had an urgent medical emergency and wishes to waive the standard ₹300 late rescheduling penalty.',
        priority: TicketPriority.medium,
        status: TicketStatus.underReview,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        requestedRefundInr: 300,
      ),
    ];

    _messages['BK_IND_8901'] = [
      MessageModel(
        id: 'm1',
        senderId: 'trainer_01',
        senderName: 'Priya Nair',
        text: 'Hi Aarav! Looking forward to our Functional HIIT session tomorrow at 7:00 AM at your flat in Indiranagar.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isFromCustomer: false,
        bookingId: 'BK_IND_8901',
      ),
      MessageModel(
        id: 'm2',
        senderId: 'user_cust_01',
        senderName: 'Aarav Sharma',
        text: 'Hi Priya! Yes, looking forward. Please bring the 12kg kettlebells if possible. The security guard will buzz you up to flat 402.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isFromCustomer: true,
        bookingId: 'BK_IND_8901',
      ),
      MessageModel(
        id: 'm3',
        senderId: 'trainer_01',
        senderName: 'Priya Nair',
        text: 'Noted! I have the 12kg kettlebells, agility cones, and sanitised resistance bands packed. See you tomorrow at 7:00 AM sharp!',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isFromCustomer: false,
        bookingId: 'BK_IND_8901',
      ),
    ];
  }
}

