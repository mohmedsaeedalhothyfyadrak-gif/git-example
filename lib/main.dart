import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MobileMoneyApp());
}

class MobileMoneyApp extends StatefulWidget {
  const MobileMoneyApp({super.key});

  @override
  State<MobileMoneyApp> createState() => _MobileMoneyAppState();
}

class _MobileMoneyAppState extends State<MobileMoneyApp> {
  Locale _locale = const Locale('ar');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Money',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', ''), Locale('en', '')],
      home: LoginScreen(onLocaleChange: _changeLanguage),
    );
  }
}

// --- نافذة الحوار العامة ---
void _showUniversalDialog(BuildContext context, String title, String description, IconData icon) {
  bool isAr = Localizations.localeOf(context).languageCode == 'ar';
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: const Color(0xFF003366),
        child: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          Icon(icon, size: 50, color: const Color(0xFF003366)),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(height: 50, color: const Color(0xFF004488), alignment: Alignment.center, child: Text(isAr ? "موافق" : "OK", style: const TextStyle(color: Colors.white))),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(height: 50, color: const Color(0xFFC04000), alignment: Alignment.center, child: Text(isAr ? "إلغاء الأمر" : "Cancel", style: const TextStyle(color: Colors.white))),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

// --- شاشة تسجيل الدخول ---
class LoginScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const LoginScreen({super.key, required this.onLocaleChange});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final String _staticPin = "7717"; // الرمز الثابت المطلوب

  void _handleLogin() {
    if (_passwordController.text == _staticPin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigationHolder()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرمز السري غير صحيح", textAlign: TextAlign.center), backgroundColor: Colors.red),
      );
    }
  }

  void _showResetConfirmation() {
    bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAr ? "إعادة تفعيل" : "Re-activate"),
        content: Text(isAr ? "سيتم حذف البيانات واعادة التفعيل، هل تريد المتابعة ؟" : "Data will be reset. Do you want to continue?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isAr ? "إلغاء" : "Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                _passwordController.clear(); // مسح الرمز السري عند إعادة التفعيل
              });
              Navigator.pop(context);
            },
            child: Text(isAr ? "موافق" : "Confirm", style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        leading: Builder(builder: (context) => IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
        title: Text(isAr ? "مرحباً بك" : "Welcome", style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (val) => widget.onLocaleChange(Locale(val)),
            itemBuilder: (context) => [const PopupMenuItem(value: 'ar', child: Text("العربية")), const PopupMenuItem(value: 'en', child: Text("English"))],
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF003366)),
              accountName: const Text("محمد الحذيفي", style: TextStyle(fontSize: 18)),
              accountEmail: Text(isAr ? "مستخدم موبايل موني" : "User Account"),
              currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: ClipOval(child: Image.asset('assets/mohammed.png', errorBuilder: (c, e, s) => const Icon(Icons.person, size: 50)))),
            ),
            ListTile(leading: const Icon(Icons.home), title: Text(isAr ? "الرئيسية" : "Home")),
            ListTile(leading: const Icon(Icons.info), title: Text(isAr ? "حول التطبيق" : "About")),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF003366))), child: ClipOval(child: Image.asset('assets/mohammed.png', errorBuilder: (c, e, s) => const Icon(Icons.account_circle, size: 100))))),
            const SizedBox(height: 20),
            const Text("Mobile Money", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(controller: _passwordController, obscureText: true, textAlign: TextAlign.center, decoration: InputDecoration(hintText: isAr ? "ادخل الرمز السري" : "Enter Password", prefixIcon: const Icon(Icons.fingerprint), filled: true, fillColor: Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none))),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(onPressed: _handleLogin, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366), minimumSize: const Size(double.infinity, 50)), child: Text(isAr ? "دخول" : "Login", style: const TextStyle(color: Colors.white))),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(onPressed: _showResetConfirmation, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF27059), minimumSize: const Size(double.infinity, 50)), child: Text(isAr ? "إعادة تفعيل" : "Re-activate", style: const TextStyle(color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }
}

// --- الحاوية الرئيسية للتنقل ---
class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({super.key});
  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _selectedIndex = 3;
  final List<Widget> _pages = [const OtherScreen(), const PaymentsScreen(), const TransferScreen(), const AccountsScreen()];

  @override
  Widget build(BuildContext context) {
    bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(icon: const Icon(Icons.power_settings_new, color: Colors.white), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MobileMoneyApp()))),
        title: Text(isAr ? "موبايل موني" : "Mobile Money", style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF003366),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.more_horiz), label: isAr ? "أخرى" : "More"),
          BottomNavigationBarItem(icon: const Icon(Icons.payments), label: isAr ? "مدفوعات" : "Payments"),
          BottomNavigationBarItem(icon: const Icon(Icons.send), label: isAr ? "تحويل" : "Transfer"),
          BottomNavigationBarItem(icon: const Icon(Icons.account_balance_wallet), label: isAr ? "الحسابات" : "Accounts"),
        ],
      ),
    );
  }
}

// --- الشاشات الفرعية وبناء العناصر ---
class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _buildItem(context, "إستعلام عن رصيد", "الإستعلام عن رصيد الحساب", Icons.account_balance),
      _buildItem(context, "اخر العمليات", "استعلام عن اخر العمليات في حسابك", Icons.list_alt),
      _buildItem(context, "خدمة الإيميل", "طلب إرسال كشف الحساب الى إيميل", Icons.email),
      _buildItem(context, "البطائق الإفتراضية", "إصدار بطائق افتراضية قابلة لإعادة الشحن", Icons.credit_card),
      _buildItem(context, "تسجيل رقم الهوية", "تسجيل رقم البطاقة الشخصية", Icons.badge),
    ]);
  }
}

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _buildItem(context, "تحويل الأموال", "خيارات تحويل متعددة", Icons.sync_alt, customOnTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SendMoneyScreen()))),
      _buildItem(context, "إستلام أموال", "إستلام أموال (عبر كود التحويل المرسل إليك)", Icons.download),
      _buildItem(context, "سحب نقدي", "طلب كود للسماح بالسحب النقدي من نقاط الخدمة", Icons.money_off),
      _buildItem(context, "ايداع نقدي", "طلب كود لعملية الايداع النقدي لدى نقاط الخدمة", Icons.add_card),
      _buildItem(context, "سحب نقدي-ATM", "طلب كود للسماح بالسحب النقدي من الصراف الآلي", Icons.atm),
      _buildItem(context, "الحوالات النقدية", "خدمات الحوالات النقدية", Icons.account_tree),
    ]);
  }
}

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _buildItem(context, "سداد الفواتير", "سداد فواتير الهاتف المحمول و الشحن الفوري وفواتير الماء والكهرباء والإنترنت", Icons.receipt_long),
      _buildItem(context, "خدمات الدفع والشراء", "الدفع عبر موبايل موني في المحلات", Icons.shopping_basket),
      _buildItem(context, "التعليم", "تسديد الرسوم الجامعية ودفع رسوم التنسيق", Icons.school),
      _buildItem(context, "المدفوعات الحكومية", "سداد الإلتزامات والمدفوعات الحكومية", Icons.gavel),
      _buildItem(context, "دفع الى تاجر", "دفع وسداد مباشر الى حساب الجهة", Icons.store),
      _buildItem(context, "مدفوعات الزكاة", "سداد واجبات الزكاة", Icons.volunteer_activism),
    ]);
  }
}

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _buildItem(context, "الاعدادات", "إعدادات الامان والخصوصية", Icons.settings),
      _buildItem(context, "التنبيهات", "عرض التنبيهات والرسائل الاعلانية", Icons.notifications),
      _buildItem(context, "المفضلات", "حفظ ارقام حسابات او فواتير للرجوع إليها بسرعة", Icons.star),
      _buildItem(context, "الملف الشخصي", "تغيير البيانات الشخصية الاسم,الصورة الرمزية", Icons.person),
      _buildItem(context, "مواقع الوكلاء والتجار", "ابحث عن اقرب موقع لوكيل او تاجر معتمد", Icons.location_on),
      _buildItem(context, "الاسئلة الشائعة", "هنا تجد جميع الاسئلة الشائعة", Icons.help),
    ]);
  }
}

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});
  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _amount = TextEditingController();
  final _account = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF003366), title: Text(isAr ? "تحويل أموال" : "Send Money")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF003366), borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(isAr ? "رصيدك الحالي" : "Balance", style: const TextStyle(color: Colors.white70)), const Text("575,000.00 YER", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))])),
          const SizedBox(height: 20),
          TextField(controller: _account, decoration: InputDecoration(labelText: isAr ? "رقم الحساب" : "Account Number")),
          TextField(controller: _amount, decoration: InputDecoration(labelText: isAr ? "المبلغ" : "Amount")),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366), minimumSize: const Size(double.infinity, 50)), child: Text(isAr ? "تأكيد" : "Confirm", style: const TextStyle(color: Colors.white)))
        ]),
      ),
    );
  }
}

Widget _buildItem(BuildContext context, String title, String subtitle, IconData icon, {VoidCallback? customOnTap}) {
  return InkWell(
    onTap: customOnTap ?? () => _showUniversalDialog(context, title, subtitle, icon),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
      child: Row(children: [
        Icon(icon, color: Colors.grey[600], size: 30),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey))])),
      ]),
    ),
  );
}