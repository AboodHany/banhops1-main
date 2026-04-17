import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'splash_title': 'BanHops',
      'splash_subtitle': 'Fast routes for smart travel',
      'choose_language': 'Please select a language',
      'arabic': 'العربية',
      'english': 'English',
      'welcome': 'Welcome to',
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',
      'home': 'Home',
      'from': 'From',
      'to': 'To',
      'get_routes': 'Get Routes',
      'popular_zones': 'Popular Zones',
      'train_lines': 'Train Lines',
      'where_are_you_coming_from': 'Where are you coming from?',
      'trip_history': 'Trip History',
      'profile': 'Profile',
      'settings': 'Settings',
      'language': 'Language',
      'apply': 'Apply',
      'current_language': 'Current Language',
      'select_destination': 'Select Destination',
      'route_details': 'Route Details',
      'transportation_options': 'Transportation Options',
      'best_match': 'BEST MATCH',
      'direct_microbus': 'Direct Microbus',
      'train_nearby': 'Train (Nearby Station)',
      'pros': 'Pros',
      'cons': 'Cons',
      'chat_assistant': 'AI Assistant',
      'smart_route': 'Smart Route to Benha',
      'completed_trips': 'Completed Trips',
      'banhops_user': 'BanHops User',
      'banhops_explorer': 'BANHOPS EXPLORER',
      'search_destination': 'Search for a destination in Benha',
      'current_location': 'Your current location',
      'cairo': 'Cairo',
      'tanta': 'Tanta',
      'mansoura': 'Mansoura',
      'minya': 'Minya',
      'new_language_applied':
          'The new language will be applied to all app screens',
    },
    'ar': {
      'splash_title': 'بنهوبس',
      'splash_subtitle': 'طرق سريعة للسفر الذكي',
      'choose_language': 'الرجاء اختيار لغة',
      'arabic': 'العربية',
      'english': 'English',
      'welcome': 'مرحبًا بك في',
      'sign_in': 'تسجيل الدخول',
      'sign_up': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'first_name': 'الاسم الأول',
      'last_name': 'اسم العائلة',
      'confirm_password': 'تأكيد كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'dont_have_account': 'لا تملك حسابًا؟',
      'already_have_account': 'بالفعل لديك حساب؟',
      'home': 'الرئيسية',
      'from': 'من',
      'to': 'إلى',
      'get_routes': 'احصل على الطريق',
      'popular_zones': 'المناطق الشعبية',
      'train_lines': 'خطوط القطارات',
      'where_are_you_coming_from': 'من أين ستبدأ رحلتك؟',
      'trip_history': 'سجل الرحلات',
      'profile': 'الحساب',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'apply': 'تطبيق',
      'current_language': 'اللغة الحالية',
      'select_destination': 'اختر وجهتك',
      'route_details': 'تفاصيل الطريق',
      'transportation_options': 'خيارات التنقل',
      'best_match': 'أفضل اختيار',
      'direct_microbus': 'ميكروباص مباشر',
      'train_nearby': 'قطار (محطة قريبة)',
      'pros': 'الإيجابيات',
      'cons': 'السلبيات',
      'chat_assistant': 'مساعد الذكاء الاصطناعي',
      'smart_route': 'المسار الذكي إلى بنها',
      'completed_trips': 'الرحلات المكتملة',
      'banhops_user': 'مستخدم BanHops',
      'banhops_explorer': 'مستكشف BanHops',
      'search_destination': 'ابحث عن وجهة في بنها',
      'current_location': 'موقعك الحالي',
      'cairo': 'القاهرة',
      'tanta': 'طنطا',
      'mansoura': 'المنصورة',
      'minya': 'المنيا',
      'new_language_applied': 'سيتم تطبيق اللغة الجديدة على جميع الشاشات',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
