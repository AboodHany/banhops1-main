import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/models/transit_route_option.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/localization/app_localizations.dart';

class RouteAiAnalysisScreen extends StatefulWidget {
  const RouteAiAnalysisScreen({
    super.key,
    required this.route,
    required this.origin,
    required this.destination,
  });

  final TransitRouteOption route;
  final String origin;
  final String destination;

  @override
  State<RouteAiAnalysisScreen> createState() => _RouteAiAnalysisScreenState();
}

class _RouteAiAnalysisScreenState extends State<RouteAiAnalysisScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  bool _isRefreshing = false;

  // Mock Analysis State Variables
  late int _trafficIndex; // 1 to 10
  late String _trafficStatusAr;
  late String _trafficStatusEn;
  late String _roadQualityAr;
  late String _roadQualityEn;
  late String _bestTimeAr;
  late String _bestTimeEn;
  late List<String> _alertsAr;
  late List<String> _alertsEn;
  late String _aiTipsAr;
  late String _aiTipsEn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _generateMockData();
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _generateMockData() {
    final random = Random();
    final routeId = widget.route.id.toLowerCase();
    final routeTitle = widget.route.title.toLowerCase();
    
    final isTrain = widget.route.mode == TransitMode.train || routeId.contains('train') || routeTitle.contains('train') || routeTitle.contains('قطار');
    final isMetro = routeId.contains('metro') || routeTitle.contains('metro') || routeTitle.contains('مترو');
    final isMonorailOrLrt = routeId.contains('monorail') || routeId.contains('lrt') || routeTitle.contains('monorail') || routeTitle.contains('lrt') || routeTitle.contains('مونوريل') || routeTitle.contains('القطار الكهربائي');

    if (isTrain) {
      _trafficIndex = random.nextInt(2) + 1; // 1 to 2
      _trafficStatusAr = "القطارات منتظمة المواعيد تماماً ولا تتأثر بالازدحام المروري للطرق";
      _trafficStatusEn = "Trains are perfectly on schedule and unaffected by highway road traffic";

      _roadQualityAr = "سكك حديد مصر بحالة جيدة جداً، مع تشغيل خطوط القطارات المطورة (التالجو والإسباني وتحيا مصر) بكفاءة كاملة.";
      _roadQualityEn = "Egypt Railways infrastructure is in very good condition, with upgraded lines (Talgo, AC Spanish, and Tahya Misr) operating at full capacity.";

      _bestTimeAr = "تجنب فترات ازدحام شبابيك التذاكر في الصباح الباكر (7:00 - 9:00 ص)؛ الحجز المسبق عبر التطبيق أو الفيزا يوفر وقتك.";
      _bestTimeEn = "Avoid early morning ticket window queues (7:00 - 9:00 AM); pre-booking online or via app saves time.";

      _alertsAr = [
        "تنبيه هام: يجب التواجد على الرصيف قبل موعد تحرك القطار بـ 15 دقيقة على الأقل.",
        "تأكد من فئة القطار ورقم الرحلة (مكيف/تحيا مصر/تالجو) لتفادي الغرامات عند فحص التذاكر.",
        "الازدحام يزداد عند بوابات الدخول بمحطة رمسيس ومحطة بنها في عطلات نهاية الأسبوع.",
      ];
      _alertsEn = [
        "Important Alert: You must be on the platform at least 15 minutes before train departure.",
        "Verify the train class (AC/Tahya Misr/Talgo) before boarding to avoid class fare penalty fines.",
        "Congestion increases at Ramses Station and Benha Station entry gates during weekends.",
      ];

      _aiTipsAr = "تحليل الذكاء الاصطناعي: القطار هو وسيلة السفر الأكثر أماناً وراحة وهدوءاً لرحلتك اليوم للربط المباشر بين محطات رمسيس وبنها دون الدخول في زحمة الطرق الزراعية. إذا كانت وجهتك النهائية في بنها غير محطة القطار، فستحتاج تحويلة سوزوكي داخلي بـ 5 جنيه.";
      _aiTipsEn = "AI Analysis: The train is the safest, most comfortable, and peaceful mode of travel today, offering a direct link between Ramses and Benha without agricultural road delays. If your final destination is not the train station, you will need a local Suzuki transfer costing 5 EGP.";

    } else if (isMetro) {
      _trafficIndex = random.nextInt(3) + 7; // 7 to 9 (High Station Traffic)
      _trafficStatusAr = "مزدحم جداً - حركة الركاب كثيفة داخل العربات والمحطات التبادلية خلال أوقات الذروة";
      _trafficStatusEn = "Highly congested - extremely heavy passenger flow in cars and interchange stations during peak hours";

      _roadQualityAr = "خطوط المترو نظيفة، المحطات مكيفة وتعمل بكفاءة ممتازة، وزمن التقاطر لا يتعدى 3 دقائق بين الرحلات.";
      _roadQualityEn = "Metro lines are clean, stations are fully air-conditioned and highly efficient, headway is only 3 mins.";

      _bestTimeAr = "تجنب تماماً فترات ذروة الموظفين والطلاب صباحاً (7:30 - 9:30 ص) ومساءً (2:00 - 4:30 م) لتفادي التكدس الشديد.";
      _bestTimeEn = "Avoid student and employee peak hours: (7:30 - 9:30 AM) and (2:00 - 4:30 PM) to bypass massive crowding.";

      _alertsAr = [
        "تنبيه: احرص على حماية متعلقاتك الشخصية وهاتفك المحمول داخل العربات المزدحمة خلال أوقات الذروة.",
        "تأكد من شراء تذكرة مطابقة لعدد المحطات لتجنب الغرامة الفورية عند ماكينات الخروج.",
        "عربات السيدات المخصصة متوفرة في منتصف كل قطار لضمان خصوصية وراحة أكبر.",
      ];
      _alertsEn = [
        "Alert: Protect your personal belongings and mobile phone inside crowded train cars during peak hours.",
        "Make sure to buy a ticket matching your station count to avoid exit gate fines.",
        "Women-only designated cars are available in the middle of each train all day.",
      ];

      _aiTipsAr = "توصية: المترو هو الخيار الأسرع والأنسب لاختراق زحام القاهرة الكبرى والوصول لمحطات الربط بسرعة فائقة، ولكن تجنب عربات النصف الأول في قطارات أوقات الذروة لتقليل ضغط الزحام.";
      _aiTipsEn = "Recommendation: The metro is the ultimate choice to bypass Greater Cairo traffic and reach interchange stations, but avoid center cars during peak hours to minimize crowding.";

    } else if (isMonorailOrLrt) {
      _trafficIndex = random.nextInt(3) + 2; // 2 to 4
      _trafficStatusAr = "حركة مرورية سريعة ونسب إشغال خفيفة إلى متوسطة";
      _trafficStatusEn = "Fast traffic flow with light to moderate passenger occupancy";

      _roadQualityAr = "بنية تحتية حديثة للغاية، القطارات تسير بدون سائق ومكيفة بالكامل مع شاشات معلومات ذكية وتصميم راقٍ.";
      _roadQualityEn = "Ultra-modern infrastructure, driverless trains fully air-conditioned with smart media screens.";

      _bestTimeAr = "الخدمة مريحة جداً طوال اليوم، ولكن السفر بين 10:00 صباحاً و 1:00 ظهراً هو الأهدأ والأكثر راحة.";
      _bestTimeEn = "The service is comfortable all day, but traveling between 10:00 AM and 1:00 PM is the quietest.";

      _alertsAr = [
        "تنبيه: سعر التذكرة أعلى من المترو العادي ولكنه يضمن راحة وسرعة فائقة وتجربة VIP.",
        "تأكد من شحن كارت المونوريل/LRT الخاص بك مسبقاً لتفادي الانتظار الطويل عند ماكينات التذاكر.",
      ];
      _alertsEn = [
        "Alert: Ticket fare is higher than the standard Metro, but guarantees premium speed and comfort.",
        "Ensure your Monorail/LRT smart card is topped up in advance to avoid ticket queue delays.",
      ];

      _aiTipsAr = "توصية الذكاء الاصطناعي: المونوريل أو القطار الكهربائي يمثل الخيار المستقبلي الفاخر والأسرع لربط المدن الجديدة بمحطة عدلي منصور التبادلية مباشرة.";
      _aiTipsEn = "AI Suggestion: Monorail or LRT represents the luxury future travel option, connecting new cities to Adly Mansour Hub rapidly.";

    } else {
      // Microbus / Road Routes
      _trafficIndex = random.nextInt(5) + 4; // 4 to 8 (Standard road traffic)
      _trafficStatusAr = _trafficIndex < 6 ? "حركة المرور متوسطة وشبه سالكة على الطريق الزراعي" : "مزدحم جزئياً مع وجود تباطؤ في حركة السير عند الكباري";
      _trafficStatusEn = _trafficIndex < 6 ? "Moderate traffic flow on the agricultural road" : "Partially crowded with traffic slowdowns around bridge intersections";

      _roadQualityAr = "طريق مصر الإسكندرية الزراعي يمر ببعض أعمال الصيانة والكباري الجديدة، مما يسبب مطبات وأجزاء متكسرة في بعض النقاط.";
      _roadQualityEn = "The Cairo-Alexandria Agricultural Road undergoes bridge construction and repairs, causing speed bumps and broken paving.";

      _bestTimeAr = "قبل الساعة 1:30 ظهراً، أو بعد الساعة 8:00 مساءً للابتعاد عن تكدس السيارات والميكروباصات.";
      _bestTimeEn = "Before 1:30 PM, or after 8:00 PM to stay clear of microbus and car congestion peaks.";

      _alertsAr = [
        "ساعات بيبقا الطريق زحمة جداً ومتكسر بسبب الإنشاءات الجارية، انتبه للحفر والتحويلات.",
        "تنبيه: احرص على الركوب من الموقف الرسمي لضمان الأجرة المعتمدة وتجنب استغلال السائقين.",
        "الرؤية قد تكون منخفضة في الصباح الباكر خلال فصل الشتاء بسبب الشبورة المائية كثيفة على الطريق الزراعي.",
      ];
      _alertsEn = [
        "Road is sometimes heavily congested and broken due to ongoing bridge construction; watch out for diversions.",
        "Alert: Always board from official terminals to avoid random fare changes by drivers.",
        "Visibility might be low in the early morning due to winter fog on the highway.",
      ];

      _aiTipsAr = "تحليل الذكاء الاصطناعي: الميكروباص المباشر يوفر سرعة ومرونة عالية للتنقل مباشرة إلى موقف بنها، ولكن ننصح بتهدئة السرعة والانتباه للتحويلات على الطريق الزراعي.";
      _aiTipsEn = "AI Analysis: Direct microbus offers high speed and flexibility to reach Benha Terminal, but we advise keeping speed in check and watching out for agricultural road diversions.";
    }
  }

  Future<void> _refreshAnalysis() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1500 ~/ 1000));

    if (mounted) {
      setState(() {
        _generateMockData();
        _isRefreshing = false;
      });
      _animController.reset();
      _animController.forward();
    }
  }

  Color _getTrafficColor() {
    if (_trafficIndex < 5) return const Color(0xFF1B998B); // Greenish
    if (_trafficIndex < 8) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final localeCode = localization.locale.languageCode;
    final isAr = localeCode == 'ar';

    final trafficStatus = isAr ? _trafficStatusAr : _trafficStatusEn;
    final roadQuality = isAr ? _roadQualityAr : _roadQualityEn;
    final bestTime = isAr ? _bestTimeAr : _bestTimeEn;
    final alerts = isAr ? _alertsAr : _alertsEn;
    final aiTips = isAr ? _aiTipsAr : _aiTipsEn;

    final primaryColor = const Color(0xFF0F4C81);
    final accentColor = const Color(0xFF1B998B);
    final aiThemeColor = Colors.deepPurple;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'تحليل الطريق بالذكاء الاصطناعي' : 'AI Route Analysis',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: aiThemeColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshAnalysis,
            tooltip: isAr ? 'تحديث التحليل' : 'Refresh Analysis',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [aiThemeColor, aiThemeColor.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: aiThemeColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.psychology,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAr ? 'التحليل الذكي للمسار' : 'Smart Route Insights',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.origin} ➔ ${widget.destination}',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flash_on, color: Colors.amber, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              isAr
                                  ? 'تحديث مباشر: نشط ومحدث الآن'
                                  : 'Live update: Active and updated now',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Traffic index & status
                Text(
                  isAr ? 'مؤشر الازدحام اليوم' : 'Traffic Index Today',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _getTrafficColor().withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$_trafficIndex/10',
                              style: TextStyle(
                                color: _getTrafficColor(),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? 'حالة الحركة المرورية' : 'Traffic State',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trafficStatus,
                                style: TextStyle(
                                  color: _getTrafficColor(),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Road Quality Card
                _buildAnalysisCard(
                  context,
                  title: isAr ? 'حالة البنية التحتية للطريق' : 'Road Infrastructure',
                  icon: Icons.construction_rounded,
                  iconColor: Colors.orange,
                  content: roadQuality,
                ),
                const SizedBox(height: 12),

                // Best departure time card
                _buildAnalysisCard(
                  context,
                  title: isAr ? 'الوقت الأمثل للتحرك' : 'Best Time to Travel',
                  icon: Icons.alarm_on_rounded,
                  iconColor: accentColor,
                  content: bestTime,
                ),
                const SizedBox(height: 20),

                // Alerts Section
                Text(
                  isAr ? 'تنبيهات الطريق وتفاصيل الصيانة' : 'Road Alerts & Maintenance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: alerts.map((alert) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                alert,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // AI Recommendations
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: aiThemeColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: aiThemeColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.deepPurple, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            isAr ? 'توصيات الذكاء الاصطناعي للمسار' : 'AI Route Recommendation',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        aiTips,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
