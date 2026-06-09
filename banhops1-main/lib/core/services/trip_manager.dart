import '../models/location_node.dart';
import '../models/transit_route_option.dart';
import '../models/transit_enums.dart';
import '../models/microbus_line.dart';

class TripManager {
  const TripManager();

  static const Map<String, String> _locationTranslations = {
    // Governorates
    'Cairo': 'القاهرة',
    'Giza': 'الجيزة',
    'Qalyubia': 'القليوبية',
    'Alexandria': 'الإسكندرية',
    'Gharbia': 'الغربية',
    'Dakahlia': 'الدقهلية',
    'Menofia': 'المنوفية',
    'Sharqia': 'الشرقية',
    'Beheira': 'البحيرة',
    'Kafr El Sheikh': 'كفر الشيخ',
    'Damietta': 'دمياط',
    'Port Said': 'بورسعيد',
    'Ismailia': 'الإسماعيلية',
    'Suez': 'السويس',
    'North Sinai': 'شمال سيناء',
    'South Sinai': 'جنوب سيناء',
    'Beni Suef': 'بني سويف',
    'Faiyum': 'الفيوم',
    'Minya': 'المنيا',
    'Asyut': 'أسيوط',
    'Sohag': 'سوهاج',
    'Qena': 'قنا',
    'Luxor': 'الأقصر',
    'Aswan': 'أسوان',
    'Red Sea': 'البحر الأحمر',
    'New Valley': 'الوادي الجديد',
    'Matrouh': 'مطروح',

    // Cairo Cities
    'Ahmed Helmy': 'أحمد حلمي',
    'El-Salam': 'السلام',
    'El-Marg': 'المرج',
    'Shubra El-Maza': 'شبرا المظلات / المؤسسة',
    'Helwan': 'حلوان',

    // Giza Cities
    'El-Haram': 'الهرم',
    'Imbaba': 'إمبابة',
    '6th of October': '6 أكتوبر',
    'El-Warraq': 'الوراق',
    'Dokki': 'الدقي',

    // Qalyubia Cities
    'Benha': 'بنها',
    'Qaha': 'قها',
    'Toukh': 'طوخ',
    'Shibin Al Qanater': 'شبين القناطر',
    'Kafr Shukr': 'كفر شكر',
    'Qalyub': 'قليوب',
    'Khanka': 'الخانكة',
    'Al-Obour': 'العبور',
    'Shubra Al-Khaimah': 'شبرا الخيمة',
    'Qanater Al-Khayria': 'القناطر الخيرية',

    // Menofia Cities
    'Shibin El-Kom': 'شبين الكوم',
    'Ashmoun': 'أشمون',
    'Menouf': 'منوف',
    'Sars El-Lyan': 'سرس الليان',
    'Quweisna': 'قويسنا',
    'El-Bagour': 'الباجور',

    // Gharbia Cities
    'Tanta': 'طنطا',
    'Mahalla': 'المحلة الكبرى',
    'Kafr El-Zayat': 'كفر الزيات',

    // Dakahlia Cities
    'Mansoura': 'المنصورة',
    'Mit Ghamr': 'ميت غمر',
    'Aga': 'أجا',
    'Talkha': 'طلخا',

    // Kafr El Sheikh Cities
    'Kafr El Sheikh City': 'كفر الشيخ',
    'Sidi Salem': 'سيدي سالم',

    // Other Cities
    'Alexandria City': 'الإسكندرية',
    'Zagazig': 'الزقازيق',
    'Damanhour': 'دمنهور',
    'Damietta City': 'دمياط',
    'Port Said City': 'بورسعيد',
    'Ismailia City': 'الإسماعيلية',
    'Suez City': 'السويس',
    'Fayoum City': 'الفيوم',
    'Beni Suef City': 'بني سويف',
    'Minya City': 'المنيا',
    'Asyut City': 'أسيوط',
    'Sohag City': 'سوهاج',
    'Qena City': 'قنا',
    'Luxor City': 'الأقصر',
    'Aswan City': 'أسوان',
    'Hurghada': 'الغردقة',
    'Kharga': 'الخارجة',
    'Marsa Matrouh': 'مرسى مطروح',
    'Arish': 'العريش',
    'Tor': 'الطور',

    // New Intermediate Train Stations
    'Minya El-Qamh': 'منية القمح',
    'Abu Hammad': 'أبو حماد',
    'Birket El-Sab': 'بركة السبع',
    'Itay El-Baroud': 'إيتاي البارود',
    'Kafr El-Dawar': 'كفر الدوار',
    'Abu Hummus': 'أبو حمص',
    'Samanoud': 'سمنود',
    'Sherbin': 'شربين',
    'El-Tell El-Kebir': 'التل الكبير',
    'El-Kassasin': 'القصاصين',
    'Qantara West': 'القنطرة غرب',
    'Shiblanga': 'شبلنجة',
    
    'Minya El-Qamh (Train)': 'محطة قطار منية القمح (قطار)',
    'Abu Hammad (Train)': 'محطة قطار أبو حماد (قطار)',
    'Birket El-Sab (Train)': 'محطة قطار بركة السبع (قطار)',
    'Itay El-Baroud (Train)': 'محطة قطار إيتاي البارود (قطار)',
    'Kafr El-Dawar (Train)': 'محطة قطار كفر الدوار (قطار)',
    'Abu Hummus (Train)': 'محطة قطار أبو حمص (قطار)',
    'Samanoud (Train)': 'محطة قطار سمنود (قطار)',
    'Sherbin (Train)': 'محطة قطار شربين (قطار)',
    'El-Tell El-Kebir (Train)': 'محطة قطار التل الكبير (قطار)',
    'El-Kassasin (Train)': 'محطة قطار القصاصين (قطار)',
    'Qantara West (Train)': 'محطة قطار القنطرة غرب (قطار)',
    'Shiblanga (Train)': 'محطة قطار شبلنجة (قطار)',
    'Benha (Train)': 'بنها (قطار)',
    'Tanta (Train)': 'طنطا (قطار)',
    'Alexandria (Train)': 'الإسكندرية (قطار)',
    'Benha Train Station (Train)': 'محطة قطار بنها (قطار)',
    'Bashtiel Train Station (Train)': 'قطار الصعيد بشتيل (قطار)',

    // Benha Destinations
    'Benha Main Bus Terminal': 'موقف بنها',
    'Benha Train Station': 'محطة قطار بنها',
    'Faculty of Engineering': 'كلية الهندسة',
    'Faculty of Medicine': 'كلية الطب',
    'Faculty of Science': 'كلية العلوم',
    'Faculty of Commerce': 'كلية التجارة',
    'Faculty of Arts': 'كلية الآداب',
    'Faculty of Agriculture': 'كلية الزراعة بمشتهر',
    'Faculty of Education': 'كلية التربية',
    'Faculty of Applied Arts': 'كلية الفنون التطبيقية',
    'Faculty of Nursing': 'كلية التمريض',
    'Faculty of Computers and AI': 'كلية الحاسبات والذكاء الاصطناعي',
    'Benha University Hospital': 'مستشفى بنها الجامعي',
    'Al-Ahram Street': 'شارع الأهرام (وسط البلد)',
    'Kafr El-Gazzar': 'كفر الجزار',

    'Colleges Complex (Commerce - Arts)': 'مجمع الكليات (كلية تجارة - كلية اداب)',
    'University Administration': 'إدارة الجامعة',
    'Medicine, Hospital & Corniche (El-Eshara)': 'كلية طب ومستشفى الجامعة وكورنيش النيل (إشارة)',
    'Al-Ahram Area': 'منطقة الأهرام',
    'Old Benha Bridge': 'كوبري (بنها القديمة)',
    'Faculty of Law': 'كلية الحقوق',
    'University Dorms': 'المدينة الجامعية',
    'Al-Villas Area': 'منطقة الفلل',
    'Colleges Complex': 'مجمع الكليات',
    'Administration': 'إدارة الجامعة',
    'Hospital & Corniche': 'المستشفى والكورنيش',
    'Al-Ahram': 'الأهرام',
    'Old Bridge': 'الكوبري القديم',
    'Law': 'كلية الحقوق',
    'Dorms': 'المدينة الجامعية',
    'Villas': 'منطقة الفلل',

    // New Representative Stations
    'Helwan University (Metro)': 'جامعة حلوان (مترو)',
    'Maadi (Metro)': 'المعادي (مترو)',
    'Sayeda Zeinab (Metro)': 'السيدة زينب (مترو)',
    'Hadayek El-Kobba (Metro)': 'حدائق القبة (مترو)',
    'El-Marg El-Jedida (Metro)': 'المرج الجديدة (مترو)',
    'Faculty of Agriculture (Metro)': 'كلية الزراعة (مترو)',
    'Cairo University (Metro)': 'جامعة القاهرة (مترو)',
    'El-Mounib (Metro)': 'المنيب (مترو)',
    'Nadi El-Shams (Metro)': 'نادي الشمس (مترو)',
    'Abassia (Metro)': 'العباسية (مترو)',
    'Kit Kat (Metro)': 'الكيت كات (مترو)',
    'Rod El-Farag Axis (Metro)': 'محور روض الفرج (مترو)',
    'El-Shorouk (LRT)': 'الشروق (LRT)',
    'Badr City (LRT)': 'بدر (LRT)',
    '10th of October (LRT)': 'العاشر من رمضان (LRT)',
    'Arts & Culture City (LRT)': 'مدينة الفنون والثقافة (LRT)',
    'El-Estad (Monorail)': 'الإستاد (المونوريل)',
    'Fifth Settlement (Monorail)': 'التجمع الخامس (المونوريل)',
    'AUC (Monorail)': 'الجامعة الأمريكية (المونوريل)',
    'Governmental District (Monorail)': 'الحي الحكومي (المونوريل)',
    'Wadi El-Nile (Monorail)': 'وادي النيل (المونوريل)',
    'Hyper One (Monorail)': 'هايبر ون (المونوريل)',
    'El-Hosary (Monorail)': 'الحصري (المونوريل)',
    
    'Sadat (Metro)': 'السادات (مترو)',
    'Nasser (Metro)': 'ناصر (مترو)',
    'Attaba (Metro)': 'العتبة (مترو)',
    'Al-Shohadaa (Metro)': 'الشهداء (مترو)',
    'El-Mazallat (Metro)': 'المظلات (مترو)',
    'Rod El-Farag (Metro)': 'روض الفرج (مترو)',
    'Massarra (Metro)': 'مسرة (مترو)',
    'Mohamed Naguib (Metro)': 'محمد نجيب (مترو)',
    'Opera (Metro)': 'الأوبرا (مترو)',
    'El-Bohouth (Metro)': 'البحوث (مترو)',
    'League of Arab States (Metro)': 'جامعة الدول (مترو)',
    'Boulaq El-Dakrour (Metro)': 'بولاق الدكرور (مترو)',
  };

  String _translate(String name, String localeCode) {
    if (localeCode == 'ar') {
      return _locationTranslations[name] ?? name;
    }
    return name;
  }

  static const List<Map<String, dynamic>> _trains = [
    {
      "train_no": "901",
      "type": "مكيف فرنسي",
      "type_en": "French AC",
      "origin": "القاهرة",
      "origin_en": "Cairo",
      "dest": "الإسكندرية",
      "dest_en": "Alexandria",
      "dep_time": "08:15",
      "arr_benha": "08:50",
      "price": 45.0,
      "duration": 35
    }
  ];

  static const List<Map<String, dynamic>> _tantaTrains = [
    {
      "train_no": "902",
      "type": "مكيف إسباني",
      "type_en": "Spanish AC",
      "dep_time": "07:00",
      "arr_benha": "07:45",
      "price": 30.0,
      "duration": 45
    }
  ];

  static const List<Map<String, dynamic>> _mansouraTrains = [
    {
      "train_no": "948",
      "type": "سريع تحيا مصر",
      "type_en": "Tahya Misr Fast",
      "dep_time": "06:00",
      "arr_benha": "07:15",
      "price": 15.0,
      "duration": 75
    }
  ];

  static const List<Map<String, dynamic>> _alexTrains = [
    {
      "train_no": "900",
      "type": "مكيف فرنسي",
      "type_en": "French AC",
      "dep_time": "06:00",
      "arr_benha": "08:10",
      "price": 55.0,
      "duration": 130
    }
  ];

  TripPlanResult evaluate({
    required LocationNode origin,
    required LocationNode destination,
    TripPreferences preferences = const TripPreferences(),
    List<MicrobusLine> microbuses = const [],
    List<Map<String, dynamic>> trains = const [],
    String localeCode = 'en',
  }) {
    final rawAlternatives = _buildAlternatives(origin, destination, microbuses, trains, localeCode);
    final alternatives = rawAlternatives.where((route) => route.transfers <= 2).toList();
    
    // Safety check if alternatives list is empty
    if (alternatives.isEmpty) {
      return TripPlanResult(
        originLabel: _translate(origin.name, localeCode),
        destinationLabel: _translate(destination.name, localeCode),
        routes: const [],
        summary: localeCode == 'ar' ? 'لا توجد مسارات متاحة.' : 'No routes available.',
      );
    }

    final maxTime = alternatives.map((route) => route.durationMinutes).reduce((a, b) => a > b ? a : b).toDouble();
    final maxCost = alternatives.map((route) => route.estimatedCost).reduce((a, b) => a > b ? a : b);
    final maxTransfers = alternatives.map((route) => route.transfers).reduce((a, b) => a > b ? a : b).toDouble();

    final scored = alternatives.map((route) {
      final normalizedTime = maxTime > 0 ? route.durationMinutes / maxTime : 0.0;
      final normalizedCost = maxCost > 0 ? route.estimatedCost / maxCost : 0.0;
      final normalizedTransfers = maxTransfers > 0 ? route.transfers / maxTransfers : 0.0;
      final score = (normalizedTime * preferences.timeWeight) +
          (normalizedCost * preferences.costWeight) +
          (normalizedTransfers * preferences.transferWeight);
      return TransitRouteOption(
        id: route.id,
        title: route.title,
        mode: route.mode,
        durationMinutes: route.durationMinutes,
        estimatedCost: route.estimatedCost,
        transfers: route.transfers,
        rating: route.rating,
        details: route.details,
        gmapsUrl: route.gmapsUrl,
        score: score,
        isRecommended: false,
      );
    }).toList()
      ..sort((a, b) => a.score.compareTo(b.score));

    final best = scored.first;
    final ranked = [
      for (var index = 0; index < scored.length; index++)
        TransitRouteOption(
          id: scored[index].id,
          title: scored[index].title,
          mode: scored[index].mode,
          durationMinutes: scored[index].durationMinutes,
          estimatedCost: scored[index].estimatedCost,
          transfers: scored[index].transfers,
          rating: scored[index].rating,
          details: scored[index].details,
          gmapsUrl: scored[index].gmapsUrl,
          score: scored[index].score,
          isRecommended: index == 0,
        ),
    ];

    final originLabel = _translate(origin.name, localeCode);
    final destinationLabel = _translate(destination.name, localeCode);

    final summary = localeCode == 'ar'
        ? 'الرؤية الذكية تقترح ${best.title} لتحقيق أفضل توازن بين الوقت والتكلفة وراحة السفر.'
        : 'Smart Insight recommends ${best.title} for the best balance of time, cost, and transfer comfort.';

    return TripPlanResult(
      originLabel: originLabel,
      destinationLabel: destinationLabel,
      routes: ranked,
      summary: summary,
    );
  }

  List<TransitRouteOption> _buildAlternatives(
    LocationNode origin,
    LocationNode destination,
    List<MicrobusLine> microbuses,
    List<Map<String, dynamic>> trains,
    String localeCode,
  ) {
    final terminalHub = LocationNode(
      id: 101,
      name: 'Benha Main Bus Terminal',
      latitude: 30.4678,
      longitude: 31.1920,
      type: TransitLocationType.hub,
      alias: 'New Terminal',
      governorate: 'Qalyubia',
    );

    final isDestSubBenha = destination.id >= 103 && destination.id <= 110;
    final isOriginSubBenha = origin.id >= 103 && origin.id <= 110;

    // Case 1: Destination is Colleges Complex, etc. (103 to 110)
    if (isDestSubBenha && origin.id != 101) {
      final baseAlternatives = _buildAlternativesBase(origin, terminalHub, microbuses, trains, localeCode);
      return baseAlternatives.map((baseRoute) {
        final destName = _translate(destination.name, localeCode);
        final newTitle = localeCode == 'ar'
            ? '${baseRoute.title} + سوزوكي داخلي'
            : '${baseRoute.title} + Internal Suzuki';

        final newDetails = localeCode == 'ar'
            ? '${baseRoute.details}\nثم سوزوكي داخلي من موقف بنها إلى $destName (الأجرة الرسمية: 5 جنيه).'
            : '${baseRoute.details}\nThen internal Suzuki from Benha Terminal to $destName (Official Fare: 5 EGP).';

        return TransitRouteOption(
          id: '${baseRoute.id}-suzuki',
          title: newTitle,
          mode: baseRoute.mode,
          durationMinutes: baseRoute.durationMinutes + 15,
          estimatedCost: baseRoute.estimatedCost + 5.0,
          transfers: baseRoute.transfers >= 2 ? 2 : baseRoute.transfers + 1,
          rating: baseRoute.rating,
          details: newDetails,
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: baseRoute.score,
          isRecommended: baseRoute.isRecommended,
        );
      }).toList();
    }

    // Case 2: Origin is Colleges Complex, etc. (103 to 110)
    if (isOriginSubBenha && destination.id != 101) {
      final baseAlternatives = _buildAlternativesBase(terminalHub, destination, microbuses, trains, localeCode);
      return baseAlternatives.map((baseRoute) {
        final originName = _translate(origin.name, localeCode);
        final newTitle = localeCode == 'ar'
            ? 'سوزوكي داخلي + ${baseRoute.title}'
            : 'Internal Suzuki + ${baseRoute.title}';

        final newDetails = localeCode == 'ar'
            ? 'ابدأ بركوب سوزوكي داخلي من $originName إلى موقف بنها (الأجرة الرسمية: 5 جنيه)، ثم ${baseRoute.details}'
            : 'Start by taking internal Suzuki from $originName to Benha Terminal (Official Fare: 5 EGP), then ${baseRoute.details}';

        return TransitRouteOption(
          id: '${baseRoute.id}-suzuki',
          title: newTitle,
          mode: baseRoute.mode,
          durationMinutes: baseRoute.durationMinutes + 15,
          estimatedCost: baseRoute.estimatedCost + 5.0,
          transfers: baseRoute.transfers >= 2 ? 2 : baseRoute.transfers + 1,
          rating: baseRoute.rating,
          details: newDetails,
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: baseRoute.score,
          isRecommended: baseRoute.isRecommended,
        );
      }).toList();
    }

    // Case 3: Destination is Benha Train Station (ID 102)
    if (destination.id == 102 && origin.id != 101 && origin.id != 102) {
      final baseAlternatives = _buildAlternativesBase(origin, destination, microbuses, trains, localeCode);
      return baseAlternatives.map((baseRoute) {
        if (baseRoute.mode == TransitMode.train) {
          return baseRoute;
        }
        final destName = _translate(destination.name, localeCode);
        final newTitle = localeCode == 'ar'
            ? '${baseRoute.title} + سوزوكي داخلي'
            : '${baseRoute.title} + Internal Suzuki';

        final newDetails = localeCode == 'ar'
            ? '${baseRoute.details}\nثم سوزوكي داخلي من موقف بنها إلى $destName (الأجرة الرسمية: 5 جنيه).'
            : '${baseRoute.details}\nThen internal Suzuki from Benha Terminal to $destName (Official Fare: 5 EGP).';

        return TransitRouteOption(
          id: '${baseRoute.id}-suzuki',
          title: newTitle,
          mode: baseRoute.mode,
          durationMinutes: baseRoute.durationMinutes + 15,
          estimatedCost: baseRoute.estimatedCost + 5.0,
          transfers: baseRoute.transfers >= 2 ? 2 : baseRoute.transfers + 1,
          rating: baseRoute.rating,
          details: newDetails,
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: baseRoute.score,
          isRecommended: baseRoute.isRecommended,
        );
      }).toList();
    }

    // Case 4: Origin is Benha Train Station (ID 102)
    if (origin.id == 102 && destination.id != 101 && destination.id != 102) {
      final baseAlternatives = _buildAlternativesBase(origin, destination, microbuses, trains, localeCode);
      return baseAlternatives.map((baseRoute) {
        if (baseRoute.mode == TransitMode.train) {
          return baseRoute;
        }
        final originName = _translate(origin.name, localeCode);
        final newTitle = localeCode == 'ar'
            ? 'سوزوكي داخلي + ${baseRoute.title}'
            : 'Internal Suzuki + ${baseRoute.title}';

        final newDetails = localeCode == 'ar'
            ? 'ابدأ بركوب سوزوكي داخلي من $originName إلى موقف بنها (الأجرة الرسمية: 5 جنيه)، ثم ${baseRoute.details}'
            : 'Start by taking internal Suzuki from $originName to Benha Terminal (Official Fare: 5 EGP), then ${baseRoute.details}';

        return TransitRouteOption(
          id: '${baseRoute.id}-suzuki',
          title: newTitle,
          mode: baseRoute.mode,
          durationMinutes: baseRoute.durationMinutes + 15,
          estimatedCost: baseRoute.estimatedCost + 5.0,
          transfers: baseRoute.transfers >= 2 ? 2 : baseRoute.transfers + 1,
          rating: baseRoute.rating,
          details: newDetails,
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: baseRoute.score,
          isRecommended: baseRoute.isRecommended,
        );
      }).toList();
    }

    return _buildAlternativesBase(origin, destination, microbuses, trains, localeCode);
  }

  bool _isPureStation(LocationNode node) {
    final id = node.id;
    return (id >= 601 && id <= 635) || // Metro 1
           (id >= 701 && id <= 720) || // Metro 2
           (id >= 801 && id <= 834) || // Metro 3
           (id >= 901 && id <= 912) || // LRT
           (id >= 1001 && id <= 1022) || // Monorail East
           (id >= 1101 && id <= 1112);   // Monorail West
  }

  double _getMetroFare(int stations) {
    if (stations <= 0) return 0.0;
    if (stations <= 9) return 10.0;
    if (stations <= 16) return 12.0;
    if (stations <= 23) return 15.0;
    return 20.0;
  }

  double _getLrtFare(int stations) {
    if (stations <= 0) return 0.0;
    if (stations <= 3) return 10.0;
    if (stations <= 7) return 15.0;
    return 20.0;
  }

  double _getMonorailFare(int stations) {
    if (stations <= 0) return 0.0;
    if (stations <= 5) return 20.0;
    if (stations <= 10) return 40.0;
    if (stations <= 15) return 55.0;
    return 80.0;
  }

  List<TransitRouteOption> _getRailAlternatives(
    LocationNode origin,
    LocationNode destination,
    String localeCode, [
    List<Map<String, dynamic>> trains = const [],
  ]) {
    final List<TransitRouteOption> options = [];
    
    // Determine if we are traveling to Benha or from Benha
    final isToBenha = destination.id == 101 || 
                      destination.id == 102 || 
                      destination.id == 301 || 
                      (destination.id >= 103 && destination.id <= 110);
    
    if (!isToBenha) return const []; // One-way constraint: only origin -> Benha is supported

    final id = origin.id;
    final targetName = origin.name;
    
    // Index Maps for station counts
    final line1Indexes = const {
      601: 0,   // Helwan
      602: 1,   // Ain Helwan
      603: 2,   // Helwan University
      604: 3,   // Wadi Hof
      605: 4,   // Hadayek Helwan
      606: 5,   // El-Maasara
      607: 6,   // Tora El-Asmant
      608: 7,   // Kozzika
      609: 8,   // Tora El-Balad
      610: 9,   // Sakanat El-Maadi
      611: 10,  // Maadi
      612: 11,  // Hadayek El-Maadi
      613: 12,  // Dar El-Salam
      614: 13,  // El-Zahraa
      615: 14,  // Mar Girgis
      616: 15,  // El-Malek El-Saleh
      617: 16,  // Sayeda Zeinab
      618: 17,  // Saad Zaghloul
      619: 18,  // Sadat
      620: 19,  // Nasser
      621: 20,  // Orabi
      622: 21,  // Al-Shohadaa
      623: 22,  // Ghamra
      624: 23,  // El-Demerdash
      625: 24,  // Manshiet El-Sadr
      626: 25,  // Kobri El-Qobba
      627: 26,  // Hammamat El-Qobba
      628: 27,  // Saray El-Qobba
      629: 28,  // Hadayek El-Zaitoun
      630: 29,  // Helmiet El-Zaitoun
      631: 30,  // El-Matareya
      632: 31,  // Ain Shams
      633: 32,  // Ezbet El-Nakhl
      634: 33,  // El-Marg
      635: 34,  // El-Marg El-Jedida
    };

    final line2Indexes = const {
      701: 0,   // El-Mounib
      702: 1,   // Sakiat Mekky
      703: 2,   // Omm El-Misryeen
      704: 3,   // Giza
      705: 4,   // Faisal
      706: 5,   // Cairo University
      707: 6,   // El-Bohouth
      708: 7,   // Dokki
      709: 8,   // Opera
      619: 9,   // Sadat
      711: 10,  // Mohamed Naguib
      712: 11,  // Attaba
      622: 12,  // Al-Shohadaa
      714: 13,  // Massarra
      715: 14,  // Rod El-Farag
      716: 15,  // St. Teresa
      717: 16,  // El-Khalafawy
      718: 17,  // El-Mazallat
      719: 18,  // Faculty of Agriculture
      720: 19,  // Shubra El-Kheima
    };

    final line3Indexes = const {
      202: 0,   // Adly Mansour
      801: 6,   // Nadi El-Shams
      1001: 12, // El-Estad Monorail
      802: 14,  // Abassia
      712: 18,  // Attaba
      620: 19,  // Nasser
      803: 22,  // Kit Kat
      212: 24,  // Imbaba
      804: 28,  // Rod El-Farag Axis
      1101: 30, // Wadi El-Nile
      805: 31,  // League of Arab States
      806: 32,  // Boulaq El-Dakrour
      706: 33,  // Cairo University
    };

    final lrtIndexes = const {
      202: 0,   // Adly Mansour
      308: 1,   // Al-Obour
      901: 3,   // El-Shorouk
      902: 5,   // Badr City
      903: 7,   // 10th of October LRT
      904: 9,   // Arts & Culture City
    };

    final monorailEastIndexes = const {
      1001: 0,  // El-Estad
      1002: 10, // Fifth Settlement
      1003: 13, // AUC Station
      1004: 19, // Governmental District
    };

    final monorailWestIndexes = const {
      1101: 0,  // Wadi El-Nile
      1102: 5,  // Hyper One
      1103: 8,  // El-Hosary
      1104: 11, // Bashtiel Station
    };

    final isLine1 = line1Indexes.containsKey(id);
    final isLine2 = line2Indexes.containsKey(id);
    final isLine3 = line3Indexes.containsKey(id);
    final isLRT = lrtIndexes.containsKey(id);
    final isMonorailEast = monorailEastIndexes.containsKey(id);
    final isMonorailWest = monorailWestIndexes.containsKey(id);

    if (id == 622) {
      final activeTrains = trains.isNotEmpty ? trains : _allHardcodedTrains();
      final cairoTrains = activeTrains.where((t) => t['origin'] == 'القاهرة' || t['origin_en'] == 'Cairo').toList();
      if (cairoTrains.isNotEmpty) {
        options.add(TransitRouteOption(
          id: 'train-cairo-shohadaa-representative',
          title: localeCode == 'ar'
              ? 'قطار سكك حديد مصر (من رمسيس)'
              : 'Egypt Railway Train (from Ramses)',
          mode: TransitMode.train,
          durationMinutes: 35,
          estimatedCost: 35.0, // median fare
          transfers: 0,
          rating: 4.7,
          details: localeCode == 'ar'
              ? 'قطار مباشر من محطة رمسيس (بجوار محطة الشهداء) إلى محطة قطار بنها. تتوفر رحلات متعددة يومياً بأسعار تتراوح بين 20 إلى 70 جنيه حسب الدرجة (مثل قطار 901، 911، 2025 تالجو). لمشاهدة جميع القطارات والمواعيد المتاحة والاستعلام المباشر، يرجى الضغط على أزرار الاستعلام بالأسفل.'
              : 'Direct train from Ramses Station (next to Al-Shohadaa) to Benha Train Station. Multiple trips daily with fares between 20 and 70 EGP (e.g. Train #901, #911, #2025 Talgo). Click the schedule inquiry buttons below to see details.',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      }
    }

    if (isLine1) {
      final originIndex = line1Indexes[id]!;

      if (id != 634 && id != 635) {
        // Route B: Metro Line 1 to El-Marg ➔ Microbus to Benha
        final stationsB = (originIndex - 33).abs();
        final metroFareB = _getMetroFare(stationsB);
        options.add(TransitRouteOption(
          id: 'metro-l1-marg-microbus-${id}',
          title: localeCode == 'ar'
              ? 'الخط الأول للمترو + ميكروباص (عبر المرج)'
              : 'Metro Line 1 + Microbus (via El-Marg)',
          mode: TransitMode.microbus,
          durationMinutes: (stationsB * 2) + 10 + 50,
          estimatedCost: metroFareB + 28.0,
          transfers: 1,
          rating: 4.3,
          details: localeCode == 'ar'
              ? 'استقل الخط الأول للمترو من ${_translate(targetName, 'ar')} إلى المرج (عدد المحطات: $stationsB، الأجرة الرسمية: ${metroFareB.toStringAsFixed(0)} جنيه)، ثم استقل ميكروباص إلى موقف بنها (الأجرة الرسمية: 28 جنيه).'
              : 'Take Metro Line 1 from $targetName to El-Marg ($stationsB stations, Official Fare: ${metroFareB.toStringAsFixed(0)} EGP), then take a microbus to Benha Terminal (Official Fare: 28 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      } else {
        // We are already at El-Marg or El-Marg El-Jedida terminal. Take a direct microbus.
        options.add(TransitRouteOption(
          id: 'metro-terminal-direct-microbus-${id}',
          title: localeCode == 'ar'
              ? 'ميكروباص مباشر'
              : 'Direct Microbus',
          mode: TransitMode.microbus,
          durationMinutes: 50,
          estimatedCost: 28.0,
          transfers: 0,
          rating: 4.3,
          details: localeCode == 'ar'
              ? 'استقل ميكروباص مباشر من موقف المرج إلى موقف بنها (الأجرة الرسمية: 28 جنيه).'
              : 'Take a direct microbus from El-Marg terminal to Benha Terminal (Official Fare: 28 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      }
    }

    if (isLine2) {
      final originIndex = line2Indexes[id]!;

      if (id != 720) {
        // Route A: Metro Line 2 to Shubra El-Kheima ➔ Microbus to Benha
        final stationsA = (originIndex - 19).abs();
        final metroFareA = _getMetroFare(stationsA);
        options.add(TransitRouteOption(
          id: 'metro-l2-shubra-microbus-${id}',
          title: localeCode == 'ar'
              ? 'الخط الثاني للمترو + ميكروباص (عبر شبرا)'
              : 'Metro Line 2 + Microbus (via Shubra)',
          mode: TransitMode.microbus,
          durationMinutes: (stationsA * 2) + 10 + 40,
          estimatedCost: metroFareA + 22.0,
          transfers: 1,
          rating: 4.5,
          details: localeCode == 'ar'
              ? 'استقل الخط الثاني للمترو من ${_translate(targetName, 'ar')} إلى محطة مترو مؤسسة (عدد المحطات: $stationsA، الأجرة الرسمية: ${metroFareA.toStringAsFixed(0)} جنيه)، ثم استقل ميكروباص إلى موقف بنها (الأجرة الرسمية: 22 جنيه).'
              : 'Take Metro Line 2 from $targetName to Shubra El-Kheima (Al-Moassasa) ($stationsA stations, Official Fare: ${metroFareA.toStringAsFixed(0)} EGP), then take a microbus to Benha Terminal (Official Fare: 22 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      } else {
        // We are already at Shubra El-Kheima terminal. Take a direct microbus.
        options.add(TransitRouteOption(
          id: 'metro-terminal-direct-microbus-${id}',
          title: localeCode == 'ar'
              ? 'ميكروباص مباشر'
              : 'Direct Microbus',
          mode: TransitMode.microbus,
          durationMinutes: 40,
          estimatedCost: 22.0,
          transfers: 0,
          rating: 4.3,
          details: localeCode == 'ar'
              ? 'استقل ميكروباص مباشر من موقف المؤسسة/شبرا الخيمة إلى موقف بنها (الأجرة الرسمية: 22 جنيه).'
              : 'Take a direct microbus from Shubra El-Kheima (Al-Moassasa) terminal to Benha Terminal (Official Fare: 22 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      }
    }

    if (isLine3) {
      final originIndex = line3Indexes[id]!;

      if (id != 202) {
        // Route A: Metro Line 3 to Adly Mansour ➔ Microbus to Benha
        final stations = (originIndex - 0).abs();
        final metroFare = _getMetroFare(stations);
        options.add(TransitRouteOption(
          id: 'metro-l3-adly-microbus-${id}',
          title: localeCode == 'ar'
              ? 'الخط الثالث للمترو + ميكروباص (عبر عدلي منصور)'
              : 'Metro Line 3 + Microbus (via Adly Mansour)',
          mode: TransitMode.microbus,
          durationMinutes: (stations * 2) + 10 + 50,
          estimatedCost: metroFare + 28.0,
          transfers: 1,
          rating: 4.4,
          details: localeCode == 'ar'
              ? 'استقل الخط الثالث للمترو من ${_translate(targetName, 'ar')} إلى محطة عدلي منصور (عدد المحطات: $stations، الأجرة الرسمية: ${metroFare.toStringAsFixed(0)} جنيه)، ثم التمشية الي موقف السلام خلف محطة المترو واستقلال ميكروباص إلى موقف بنها (الأجرة الرسمية: 28 جنيه).'
              : 'Take Metro Line 3 from $targetName to Adly Mansour Station ($stations stations, Official Fare: ${metroFare.toStringAsFixed(0)} EGP), then walk to El-Salam Bus Station behind the metro station and take a microbus to Benha Terminal (Official Fare: 28 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      }
    }

    if (isLRT) {
      final originIndex = lrtIndexes[id]!;
      if (id != 202) {
        final lrtFare = _getLrtFare(originIndex);
        options.add(TransitRouteOption(
          id: 'lrt-adly-microbus-${id}',
          title: localeCode == 'ar'
              ? 'القطار الكهربائي الخفيف LRT + ميكروباص (عبر عدلي منصور)'
              : 'LRT + Microbus (via Adly Mansour)',
          mode: TransitMode.microbus,
          durationMinutes: (originIndex * 3) + 10 + 50,
          estimatedCost: lrtFare + 28.0,
          transfers: 1,
          rating: 4.5,
          details: localeCode == 'ar'
              ? 'استقل القطار الكهربائي الخفيف (LRT) من ${_translate(targetName, 'ar')} إلى محطة عدلي منصور (عدد المحطات: $originIndex، الأجرة الرسمية: ${lrtFare.toStringAsFixed(0)} جنيه)، ثم التمشية الي موقف السلام خلف محطة المترو واستقلال ميكروباص إلى موقف بنها (الأجرة الرسمية: 28 جنيه).'
              : 'Take the Light Rail Transit (LRT) from $targetName to Adly Mansour Station ($originIndex stations, Official Fare: ${lrtFare.toStringAsFixed(0)} EGP), then walk to El-Salam Bus Station behind the metro station and transfer to a microbus to Benha Terminal (Official Fare: 28 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      }
    }

    if (isMonorailEast) {
      final originIndex = monorailEastIndexes[id]!;
      final monorailFare = _getMonorailFare(originIndex);
      // Metro Line 3 ticket from El-Estad (index 12) to Adly Mansour (index 0): 12 stations -> 12 EGP
      options.add(TransitRouteOption(
        id: 'monorail-east-metro-microbus-${id}',
        title: localeCode == 'ar'
            ? 'مونوريل شرق النيل + المترو + ميكروباص'
            : 'Monorail East + Metro + Microbus',
        mode: TransitMode.microbus,
        durationMinutes: (originIndex * 3) + 10 + 24 + 10 + 50,
        estimatedCost: monorailFare + 12.0 + 28.0,
        transfers: 2,
        rating: 4.4,
        details: localeCode == 'ar'
            ? 'استقل مونوريل شرق النيل من ${_translate(targetName, 'ar')} إلى محطة الإستاد (عدد المحطات: $originIndex، الأجرة الرسمية: ${monorailFare.toStringAsFixed(0)} جنيه)، ثم انتقل إلى الخط الثالث للمترو إلى محطة عدلي منصور (الأجرة الرسمية: 12 جنيه)، ثم التمشية الي موقف السلام خلف محطة المترو واستقلال ميكروباص إلى موقف بنها (الأجرة الرسمية: 28 جنيه).'
            : 'Take Monorail East from $targetName to El-Estad ($originIndex stations, Official Fare: ${monorailFare.toStringAsFixed(0)} EGP), transfer to Metro Line 3 to Adly Mansour Station (Official Fare: 12 EGP), then walk to El-Salam Bus Station behind the metro station and take a microbus to Benha Terminal (Official Fare: 28 EGP).',
        gmapsUrl: _googleMapsUrl(origin, destination),
        score: 0,
        isRecommended: false,
      ));
    }

    if (isMonorailWest) {
      final originIndex = monorailWestIndexes[id]!;
      final monorailFare = _getMonorailFare(originIndex);
      // Metro Line 3 ticket from Wadi El-Nile (index 30) to Adly Mansour (index 0): 30 stations -> 20 EGP
      options.add(TransitRouteOption(
        id: 'monorail-west-metro-microbus-${id}',
        title: localeCode == 'ar'
            ? 'مونوريل غرب النيل + الخط الثالث للمترو + ميكروباص'
            : 'Monorail West + Metro Line 3 + Microbus',
        mode: TransitMode.microbus,
        durationMinutes: (originIndex * 3) + 10 + 60 + 10 + 50,
        estimatedCost: monorailFare + 20.0 + 28.0,
        transfers: 2,
        rating: 4.3,
        details: localeCode == 'ar'
            ? 'استقل مونوريل غرب النيل من ${_translate(targetName, 'ar')} إلى محطة وادي النيل (عدد المحطات: $originIndex، الأجرة الرسمية: ${monorailFare.toStringAsFixed(0)} جنيه)، ثم انتقل إلى الخط الثالث للمترو إلى محطة عدلي منصور (الأجرة الرسمية: 20 جنيه)، ثم التمشية الي موقف السلام خلف محطة المترو واستقلال ميكروباص إلى موقف بنها (الأجرة الرسمية: 28 جنيه).'
            : 'Take Monorail West from $targetName to Wadi El-Nile ($originIndex stations, Official Fare: ${monorailFare.toStringAsFixed(0)} EGP), transfer to Metro Line 3 to Adly Mansour Station (Official Fare: 20 EGP), then walk to El-Salam Bus Station behind the metro station and take a microbus to Benha Terminal (Official Fare: 28 EGP).',
        gmapsUrl: _googleMapsUrl(origin, destination),
        score: 0,
        isRecommended: false,
      ));
    }

    if (isMonorailEast || isMonorailWest) {
      // Add Monorail + Metro + Train option for all destinations going to Benha
      if (isToBenha) {
        final monorailFare = isMonorailEast 
            ? _getMonorailFare(monorailEastIndexes[id]!) 
            : _getMonorailFare(monorailWestIndexes[id]!);
        final originIndex = isMonorailEast 
            ? monorailEastIndexes[id]! 
            : monorailWestIndexes[id]!;
        
        final duration = (originIndex * 3) + 15 + 20 + 15 + 35; // Monorail + Metro + Wait + Train
        final cost = monorailFare + 10.0 + 35.0; // Monorail + Metro + Train (Agricultural AC)
        
        options.add(TransitRouteOption(
          id: 'monorail-metro-train-${id}',
          title: localeCode == 'ar'
              ? 'مونوريل + مترو + قطار رمسيس'
              : 'Monorail + Metro + Ramses Train',
          mode: TransitMode.train,
          durationMinutes: duration,
          estimatedCost: cost,
          transfers: 2, // 2 transfers (Monorail -> Metro, Metro -> Train)
          rating: 4.6,
          details: localeCode == 'ar'
              ? 'استقل المونوريل إلى محطة الربط مع المترو، ثم المترو إلى محطة رمسيس (الشهداء)، ثم قطار مباشر إلى محطة قطار بنها.'
              : 'Take the Monorail to the Metro interchange, then Metro to Ramses (Al-Shohadaa), and finally a train directly to Benha.',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      }
    }

    return options;
  }

  List<TransitRouteOption> _buildAlternativesBase(
    LocationNode origin,
    LocationNode destination,
    List<MicrobusLine> microbuses,
    List<Map<String, dynamic>> trains,
    String localeCode,
  ) {
    if (_isPureStation(origin) || _isPureStation(destination)) {
      return _getRailAlternatives(origin, destination, localeCode, trains);
    }

    final baseDistance = _distanceScore(origin, destination);
    final busDuration = (baseDistance * 54).round().clamp(45, 220);
    final microbusDuration = (baseDistance * 48).round().clamp(30, 190);

    final matched = _findMatchingMicrobuses(origin, destination, microbuses);
    final List<TransitRouteOption> routes = [];

    final originKeyword = _getArabicKeyword(origin.name);

    // Filter dynamic train list
    final activeTrains = trains.isNotEmpty ? trains : _allHardcodedTrains();
    final matchedTrains = activeTrains.where((t) {
      final tOrigin = t['origin'] as String? ?? '';
      final tOriginEn = t['origin_en'] as String? ?? '';
      
      final isCairoTrain = tOrigin == 'القاهرة' || tOriginEn == 'Cairo';
      final isOriginCairoRamses = origin.name == 'Cairo' || 
                                  origin.name == 'Ahmed Helmy' || 
                                  originKeyword == 'القاهرة' || 
                                  originKeyword == 'أحمد حلمي';
      if (isCairoTrain && isOriginCairoRamses) {
        return true;
      }
      
      final cleanTOrigin = _cleanStationName(tOrigin).toLowerCase();
      final cleanTOriginEn = _cleanStationName(tOriginEn).toLowerCase();
      final cleanOriginName = _cleanStationName(origin.name).toLowerCase();
      final cleanOriginKeyword = _cleanStationName(originKeyword).toLowerCase();
      
      return cleanTOrigin == cleanOriginKeyword || 
             cleanTOriginEn == cleanOriginKeyword || 
             cleanTOrigin == cleanOriginName || 
             cleanTOriginEn == cleanOriginName ||
             cleanOriginName.contains(cleanTOrigin) ||
             cleanTOrigin.contains(cleanOriginName) ||
             cleanOriginName.contains(cleanTOriginEn) ||
             cleanTOriginEn.contains(cleanOriginName);
    }).toList();

    // 1. Add specific trains if origin supports direct rail
    if (matchedTrains.isNotEmpty) {
      final representative = matchedTrains.first;
      final tOrigin = representative['origin_en'] ?? representative['origin'];
      final tOriginAr = representative['origin'] ?? representative['origin_en'];
      
      final prices = matchedTrains.map((t) => (t['price'] as num?)?.toDouble() ?? 0.0).toList();
      final durations = matchedTrains.map((t) => t['duration'] as int? ?? 35).toList();
      final minPrice = prices.reduce((a, b) => a < b ? a : b);
      final maxPrice = prices.reduce((a, b) => a > b ? a : b);
      final avgDuration = (durations.reduce((a, b) => a + b) / durations.length).round();

      final trainListString = matchedTrains.map((t) => '#${t['train_no']}').join(', ');
      
      final title = localeCode == 'ar'
          ? 'قطار سكك حديد مصر (من $tOriginAr)'
          : 'Egypt Railway Train (from $tOrigin)';
          
      final details = localeCode == 'ar'
          ? 'قطار مباشر من $tOriginAr إلى محطة قطار بنها. تتوفر رحلات متعددة يومياً (مثل قطار $trainListString). الأجرة تتراوح بين ${minPrice.toStringAsFixed(0)} إلى ${maxPrice.toStringAsFixed(0)} جنيه حسب درجة القطار. لمشاهدة جميع القطارات والمواعيد المتاحة والاستعلام المباشر، يرجى الضغط على أزرار الاستعلام بالأسفل.'
          : 'Direct train from $tOrigin to Benha Train Station. Multiple trips are available daily (e.g. Train $trainListString). Fare ranges from ${minPrice.toStringAsFixed(0)} to ${maxPrice.toStringAsFixed(0)} EGP depending on class. Click the schedule inquiry buttons below to see details.';

      routes.add(TransitRouteOption(
        id: 'train-${tOrigin.toString().replaceAll(' ', '-')}-representative',
        title: title,
        mode: TransitMode.train,
        durationMinutes: avgDuration,
        estimatedCost: minPrice,
        transfers: 0,
        rating: 4.7,
        details: details,
        gmapsUrl: _googleMapsUrl(origin, destination),
        score: 0,
        isRecommended: false,
      ));
    } else {
      // Check if it's a far governorate to suggest combined train route via Ramses Cairo
      final isFar = [
        'Beni Suef', 'Faiyum', 'Minya', 'Asyut', 'Sohag', 'Qena', 'Luxor', 'Aswan',
        'Red Sea', 'New Valley', 'Matrouh', 'North Sinai', 'South Sinai', 'Suez',
        'Ismailia', 'Port Said', 'Damietta', 'Beheira'
      ].contains(origin.governorate);

      if (isFar) {
        final title = localeCode == 'ar' ? 'مسار قطار مشترك عبر رمسيس' : 'Combined Rail Route via Ramses';
        final orgTranslated = _translate(origin.name, localeCode);
        final details = localeCode == 'ar'
            ? 'استقل قطاراً من $orgTranslated إلى محطة رمسيس بالقاهرة، ثم انتقل إلى قطار متجه إلى بنها. تحويلة واحدة.'
            : 'Take a train from $orgTranslated to Ramses Cairo, then transfer to a train heading to Benha. 1 transfer.';

        routes.add(TransitRouteOption(
          id: 'train-combined-${origin.id}',
          title: title,
          mode: TransitMode.train,
          durationMinutes: (baseDistance * 55).round().clamp(150, 360),
          estimatedCost: _roundMoney(60 + baseDistance * 5.0),
          transfers: 1,
          rating: 4.4,
          details: details,
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      }
    }

    final isBorder = ['North Sinai', 'South Sinai', 'Red Sea', 'New Valley'].contains(origin.governorate);

    if (isBorder) {
      if (origin.governorate == 'North Sinai') {
        routes.add(TransitRouteOption(
          id: 'border-mcv-direct-${origin.id}',
          title: localeCode == 'ar' ? 'أتوبيس MCV مباشر' : 'MCV Direct Bus',
          mode: TransitMode.borderBus,
          durationMinutes: 270,
          estimatedCost: 165.0,
          transfers: 0,
          rating: 4.8,
          details: localeCode == 'ar'
              ? 'أتوبيس MCV مكيف مباشر من موقف العريش إلى موقف بنها. شاشات عرض، رحلة مريحة.'
              : 'Direct modern AC MCV coach from Arish terminal to Benha Terminal. Media screens, comfortable journey.',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
        routes.add(TransitRouteOption(
          id: 'border-eastdelta-combined-${origin.id}',
          title: localeCode == 'ar' ? 'أتوبيس شرق الدلتا + ميكروباص' : 'East Delta Bus + Microbus',
          mode: TransitMode.borderBus,
          durationMinutes: 300,
          estimatedCost: 50.0,
          transfers: 1,
          rating: 4.2,
          details: localeCode == 'ar'
              ? 'أتوبيس شرق الدلتا من العريش إلى موقف المرج/الترجمان بالقاهرة (22 ج)، ثم ميكروباص من المرج إلى بنها (28 ج).'
              : 'East Delta Bus from Arish to Cairo El-Marg/Turgoman (22 EGP), then transfer to El-Marg-Benha microbus (28 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      } else if (origin.governorate == 'South Sinai') {
        routes.add(TransitRouteOption(
          id: 'border-gobus-classic-${origin.id}',
          title: localeCode == 'ar' ? 'أتوبيس جو باص + ميكروباص' : 'Go Bus Coach + Microbus',
          mode: TransitMode.borderBus,
          durationMinutes: 360,
          estimatedCost: 206.50,
          transfers: 1,
          rating: 4.5,
          details: localeCode == 'ar'
              ? 'جو باص (درجة كلاسيك) من شرم/الطور إلى القاهرة (180 ج)، ثم ميكروباص أحمد حلمي إلى بنها (26.5 ج).'
              : 'Go Bus (Classic) from Sharm/Tor to Cairo (180 EGP), then local microbus from Ahmed Helmy to Benha (26.5 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
        routes.add(TransitRouteOption(
          id: 'border-superjet-sharm-${origin.id}',
          title: localeCode == 'ar' ? 'أتوبيس سوبر جيت + ميكروباص' : 'Super Jet Bus + Microbus',
          mode: TransitMode.borderBus,
          durationMinutes: 380,
          estimatedCost: 266.50,
          transfers: 1,
          rating: 4.4,
          details: localeCode == 'ar'
              ? 'أتوبيس سوبر جيت مكيف إلى القاهرة (240 ج)، ثم ميكروباص من رمسيس/أحمد حلمي إلى بنها (26.5 ج).'
              : 'Super Jet AC Coach to Cairo (240 EGP), then transfer to Ahmed Helmy-Benha microbus (26.5 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
        routes.add(TransitRouteOption(
          id: 'border-ostaz-shubra-${origin.id}',
          title: localeCode == 'ar' ? 'شركة الأستاذ + ميكروباص شبرا' : 'El-Ostaz Bus + Shubra Microbus',
          mode: TransitMode.borderBus,
          durationMinutes: 350,
          estimatedCost: 51.50,
          transfers: 1,
          rating: 4.1,
          details: localeCode == 'ar'
              ? 'أتوبيس شركة الأستاذ إلى شبرا الخيمة بالقاهرة (30 ج)، ثم ميكروباص من موقف المؤسسة إلى بنها (21.5 ج).'
              : 'El-Ostaz Bus directly to Shubra El-Kheima Cairo (30 EGP), then local microbus from El-Maza/Moustasalam to Benha (21.5 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      } else if (origin.governorate == 'Red Sea') {
        routes.add(TransitRouteOption(
          id: 'border-highjet-hurghada-${origin.id}',
          title: localeCode == 'ar' ? 'أتوبيس هاي جيت / جو باص' : 'High Jet / Go Bus Economy',
          mode: TransitMode.borderBus,
          durationMinutes: 330,
          estimatedCost: 206.50,
          transfers: 1,
          rating: 4.5,
          details: localeCode == 'ar'
              ? 'أتوبيس هاي جيت أو جو باص كلاسيك إلى رمسيس بالقاهرة (180 ج)، ثم ميكروباص أحمد حلمي إلى بنها (26.5 ج).'
              : 'High Jet or Go Bus Classic from Hurghada to Ramses Cairo (180 EGP), then local microbus to Benha (26.5 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
        routes.add(TransitRouteOption(
          id: 'border-superjet-hurghada-${origin.id}',
          title: localeCode == 'ar' ? 'سوبر جيت / جو باص ديلوكس' : 'Super Jet / Go Bus Deluxe',
          mode: TransitMode.borderBus,
          durationMinutes: 330,
          estimatedCost: 251.50,
          transfers: 1,
          rating: 4.6,
          details: localeCode == 'ar'
              ? 'أتوبيس سوبر جيت أو جو باص ديلوكس بلس إلى القاهرة، ثم ميكروباص رمسيس إلى بنها.'
              : 'Super Jet or Go Bus Deluxe Plus to Cairo, then Cairo-Benha microbus.',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      } else if (origin.governorate == 'New Valley') {
        routes.add(TransitRouteOption(
          id: 'border-upperegypt-kharga-${origin.id}',
          title: localeCode == 'ar' ? 'أتوبيس الوجه القبلي + ميكروباص/قطار' : 'Upper Egypt Bus + Train/Microbus',
          mode: TransitMode.borderBus,
          durationMinutes: 420,
          estimatedCost: 246.50,
          transfers: 1,
          rating: 4.3,
          details: localeCode == 'ar'
              ? 'أتوبيس شركة الوجه القبلي/الخارجة إلى موقف الترجمان (220 ج)، ثم ميكروباص/قطار من رمسيس إلى بنها (26.5 ج).'
              : 'Upper Egypt/Express Valley Bus from Kharga to Turgoman Terminal Cairo (220 EGP), then local train/microbus to Benha (26.5 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
        routes.add(TransitRouteOption(
          id: 'border-october-kharga-${origin.id}',
          title: localeCode == 'ar' ? 'أتوبيس أكتوبر + ميكروباص أكتوبر-بنها' : 'October Bus + October-Benha Microbus',
          mode: TransitMode.borderBus,
          durationMinutes: 440,
          estimatedCost: 280.0,
          transfers: 1,
          rating: 4.2,
          details: localeCode == 'ar'
              ? 'حافلة الخارجة إلى موقف الحصري بـ 6 أكتوبر (220 ج)، ثم ميكروباص مباشر من أكتوبر إلى بنها (60 ج).'
              : 'Bus from Kharga to El-Hosary 6th of October (220 EGP), then direct microbus to Benha (60 EGP).',
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      }
    } else {
      // 2. Add matched microbuses
      if (matched.isNotEmpty) {
        for (final line in matched) {
          final originName = _translate(origin.name, localeCode);
          final destName = _translate(destination.name, localeCode);
          final title = localeCode == 'ar'
              ? 'ميكروباص: $originName - $destName'
              : 'Microbus: $originName - $destName';
          final details = localeCode == 'ar'
              ? 'خط رسمي مرخص (${line.category} - خط رقم ${line.lineNo}). خط مباشر وأجرة معتمدة بقيمة ${line.fare} جنيه.'
              : 'Official licensed line (${line.category} - Line #${line.lineNo}). Direct line with authorized fare of ${line.fare} EGP.';

          routes.add(TransitRouteOption(
            id: 'microbus-db-${line.id}',
            title: title,
            mode: TransitMode.microbus,
            durationMinutes: microbusDuration,
            estimatedCost: line.fare,
            transfers: 0,
            rating: 4.3,
            details: details,
            gmapsUrl: _googleMapsUrl(origin, destination),
            score: 0,
            isRecommended: false,
          ));
        }
      } else {
        // Fallback to generic microbus if no db match
        final title = localeCode == 'ar' ? 'ميكروباص مباشر' : 'Direct Microbus';
        final fallbackFare = _getFallbackMicrobusFare(origin);
        final details = localeCode == 'ar'
            ? 'ميكروباص مباشر من مواقف السيارات المحلية. الأجرة الرسمية: ${fallbackFare.toStringAsFixed(1)} جنيه.'
            : 'Direct microbus from local terminal hubs. Official Fare: ${fallbackFare.toStringAsFixed(1)} EGP.';

        routes.add(TransitRouteOption(
          id: 'microbus-${origin.id}-${destination.id}',
          title: title,
          mode: TransitMode.microbus,
          durationMinutes: microbusDuration,
          estimatedCost: fallbackFare,
          transfers: 0,
          rating: 4.1,
          details: details,
          gmapsUrl: _googleMapsUrl(origin, destination),
          score: 0,
          isRecommended: false,
        ));
      }

      // 3. Unconditional Public Bus fallback disabled to avoid showing generic demo-like options
    }

    final railAlts = _getRailAlternatives(origin, destination, localeCode, trains);
    routes.addAll(railAlts);

    final Set<String> seen = {};
    final List<TransitRouteOption> uniqueRoutes = [];
    for (final route in routes) {
      final key = '${route.mode.toString()}-${route.title}-${route.estimatedCost.toStringAsFixed(2)}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueRoutes.add(route);
      }
    }
    return uniqueRoutes;
  }

  String _getArabicKeyword(String name) {
    final translated = _locationTranslations[name] ?? name;
    final clean = translated.toLowerCase();
    if (clean.contains('القاهرة')) return 'القاهرة';
    if (clean.contains('طنطا')) return 'طنطا';
    if (clean.contains('المنصورة')) return 'المنصورة';
    if (clean.contains('المنيا')) return 'المنيا';
    if (clean.contains('بنها')) return 'بنها';
    if (clean.contains('شبرا')) return 'شبرا';
    if (clean.contains('كفر شكر')) return 'كفر شكر';
    if (clean.contains('العبور')) return 'العبور';
    return translated;
  }

  List<MicrobusLine> _findMatchingMicrobuses(
    LocationNode origin,
    LocationNode destination,
    List<MicrobusLine> microbuses,
  ) {
    final originKeyword = _getArabicKeyword(origin.name);
    final destKeyword = _getArabicKeyword(destination.name);

    final isCairoAndBenha =
        (originKeyword == 'القاهرة' && destKeyword == 'بنها') ||
        (originKeyword == 'بنها' && destKeyword == 'القاهرة');

    return microbuses.where((line) {
      final route = line.route;
      final category = line.category;

      if (isCairoAndBenha) {
        final isCairoCategory = category.contains('القاهرة') ||
            category.contains('شبرا الخيمة') ||
            category.contains('الجيزة');
        final hasCairoStation = route.contains('أحمد حلمي') ||
            route.contains('السلام') ||
            route.contains('المؤسسة') ||
            route.contains('المرج') ||
            route.contains('عتبة') ||
            route.contains('تحرير') ||
            route.contains('الهرم') ||
            route.contains('إمبابة') ||
            route.contains('أكتوبر') ||
            route.contains('العبور') ||
            route.contains('القاهرة');
        final hasBenha = route.contains('بنها');
        return isCairoCategory && (hasCairoStation || hasBenha);
      }

      final hasOrigin = route.contains(originKeyword) || category.contains(originKeyword);
      final hasDest = route.contains(destKeyword) || category.contains(destKeyword);
      return hasOrigin && hasDest;
    }).toList();
  }

  double _getFallbackMicrobusFare(LocationNode origin) {
    final id = origin.id;
    final knownFares = const {
      201: 26.5,  // Ahmed Helmy
      202: 30.0,  // El-Salam (Adly Mansour)
      634: 28.0,  // El-Marg
      635: 28.0,  // El-Marg El-Jedida
      204: 21.5,  // Shubra El-Maza (Ahmad Orabi / Institution)
      211: 58.0,  // El-Haram
      213: 60.0,  // 6th of October
      308: 41.0,  // Al-Obour
      720: 21.5,  // Shubra Al-Khaimah (Institution)
      321: 19.0,  // Shibin El-Kom
      325: 16.0,  // Quweisna
      331: 30.0,  // Tanta
      341: 48.0,  // Mansoura
      401: 126.5, // Alexandria
    };
    if (knownFares.containsKey(id)) {
      return knownFares[id]!;
    }
    final baseDistance = _distanceScore(origin, const LocationNode(id: 101, name: 'Benha', latitude: 30.4678, longitude: 31.1920, type: TransitLocationType.hub));
    return _roundMoney(15.0 + baseDistance * 18.0);
  }

  double _distanceScore(LocationNode origin, LocationNode destination) {
    final latDelta = (origin.latitude - destination.latitude).abs();
    final lngDelta = (origin.longitude - destination.longitude).abs();
    return (latDelta + lngDelta).clamp(0.5, 4.0);
  }

  double _roundMoney(double value) => double.parse(value.toStringAsFixed(2));

  String _googleMapsUrl(LocationNode origin, LocationNode destination) {
    return 'https://www.google.com/maps/dir/${origin.latitude},${origin.longitude}/${destination.latitude},${destination.longitude}/';
  }

  List<Map<String, dynamic>> _allHardcodedTrains() {
    return [
      ..._trains,
      ..._tantaTrains.map((t) => {...t, 'origin': 'Tanta', 'origin_en': 'Tanta', 'dest': 'Benha', 'dest_en': 'Benha'}),
      ..._mansouraTrains.map((t) => {...t, 'origin': 'Mansoura', 'origin_en': 'Mansoura', 'dest': 'Benha', 'dest_en': 'Benha'}),
      ..._alexTrains.map((t) => {...t, 'origin': 'Alexandria City', 'origin_en': 'Alexandria City', 'dest': 'Benha', 'dest_en': 'Benha'}),
    ];
  }

  String _cleanStationName(String name) {
    String clean = name;
    clean = clean.replaceAll(RegExp(r'\s*\((Train|Metro|LRT|Monorail|قطار|مترو|المونوريل)\)'), '');
    clean = clean.replaceAll('محطة قطار ', '');
    clean = clean.replaceAll('قطار الصعيد ', '');
    clean = clean.replaceAll('محطة ', '');
    return clean.trim();
  }
}