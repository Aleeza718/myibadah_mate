import '../models/zikr_model.dart';

class ZikrService {
  Future<List<ZikrItem>> getMorningAzkar() async {
    return _getHardcodedMorningAzkar();
  }

  Future<List<ZikrItem>> getEveningAzkar() async {
    return _getHardcodedEveningAzkar();
  }

  Future<List<ZikrItem>> getGeneralZikrs() async {
    return _getHardcodedGeneralZikrs();
  }

  Future<List<AsmaUlHusnaItem>> getAsmaUlHusna() async {
    return _getHardcodedAsmaUlHusna();
  }

  // Fallback hardcoded data methods
  List<ZikrItem> _getHardcodedMorningAzkar() {
    return [
      ZikrItem(
        arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ",
        transliteration: "Asbahna wa asbahal mulku lillahi walhamdu lillahi la ilaha illallah wahdahu la sharika lahu",
        translation: "We have reached the morning and at this very time all sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner.",
        purpose: "To affirm Tawhid and thank Allah for the new day",
        count: "1"
      ),
      ZikrItem(
        arabic: "اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ",
        transliteration: "Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilaykan nushur",
        translation: "O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.",
        purpose: "To seek Allah's protection and affirm reliance on Him",
        count: "1"
      ),
      ZikrItem(
        arabic: "اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ",
        transliteration: "Allahumma anta rabbi la ilaha illa anta khalaqtani wa ana abduka wa ana ala ahdika wa wa'dika ma istata'tu a'udhu bika min sharri ma sana'tu abu'u laka bini'matika alayya wa abu'u bidhanbi faghfir li fa innahu la yaghfirudh dhanuba illa anta",
        translation: "O Allah, You are my Lord, there is no god but You. You created me and I am Your servant. I am faithful to my covenant and promise as much as I can. I seek refuge in You from the evil of what I have done. I acknowledge Your favor upon me and I acknowledge my sin, so forgive me, for indeed none forgives sins except You.",
        purpose: "To seek forgiveness and affirm servitude to Allah",
        count: "1"
      ),
      ZikrItem(
        arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ",
        transliteration: "Subhanallah wa bihamdihi adada khalqihi wa rida nafsihi wa zinata arshihi wa midada kalimatihi",
        translation: "Glory be to Allah and praise be to Him, by the number of His creation, by His pleasure, by the weight of His throne, and by the ink of His words.",
        purpose: "To glorify Allah in the morning",
        count: "3"
      ),
      ZikrItem(
        arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُسْلِ وَالْهَرَمِ وَالْمَأْثَمِ وَالْمَغْرَمِ وَمِنْ عَذَابِ الْقَبْرِ وَفِتْنَةِ الْمَحْيَا وَالْمَمَاتِ",
        transliteration: "Allahumma inni a'udhu bika minal kasli wal harami wal ma'thami wal maghrami wa min adhab alqabri wa fitnat almahya wal mamat",
        translation: "O Allah, I seek refuge in You from laziness, old age, sin, debt, and from the punishment of the grave and the trials of life and death.",
        purpose: "To seek protection from various harms",
        count: "1"
      ),
    ];
  }

  List<ZikrItem> _getHardcodedEveningAzkar() {
    return [
      ZikrItem(
        arabic: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ",
        transliteration: "Amsayna wa amsal mulku lillahi walhamdu lillahi la ilaha illallah wahdahu la sharika lahu",
        translation: "We have reached the evening and at this very time all sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner.",
        purpose: "To affirm Tawhid and thank Allah for the day",
        count: "1"
      ),
      ZikrItem(
        arabic: "اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ",
        transliteration: "Allahumma bika amsayna wa bika asbahna wa bika nahya wa bika namutu wa ilaykal masir",
        translation: "O Allah, by You we enter the evening and by You we enter the morning, by You we live and by You we die, and to You is the return.",
        purpose: "To seek Allah's protection and affirm reliance on Him",
        count: "1"
      ),
      ZikrItem(
        arabic: "اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ",
        transliteration: "Allahumma anta rabbi la ilaha illa anta khalaqtani wa ana abduka wa ana ala ahdika wa wa'dika ma istata'tu a'udhu bika min sharri ma sana'tu abu'u laka bini'matika alayya wa abu'u bidhanbi faghfirudh dhanuba illa anta",
        translation: "O Allah, You are my Lord, there is no god but You. You created me and I am Your servant. I am faithful to my covenant and promise as much as I can. I seek refuge in You from the evil of what I have done. I acknowledge Your favor upon me and I acknowledge my sin, so forgive me, for indeed none forgives sins except You.",
        purpose: "To seek forgiveness and affirm servitude to Allah",
        count: "1"
      ),
      ZikrItem(
        arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ",
        transliteration: "Subhanallah wa bihamdihi adada khalqihi wa rida nafsihi wa zinata arshihi wa midada kalimatihi",
        translation: "Glory be to Allah and praise be to Him, by the number of His creation, by His pleasure, by the weight of His throne, and by the ink of His words.",
        purpose: "To glorify Allah in the evening",
        count: "3"
      ),
      ZikrItem(
        arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُسْلِ وَالْهَرَمِ وَالْمَأْثَمِ وَالْمَغْرَمِ وَمِنْ عَذَابِ الْقَبْرِ وَفِتْنَةِ الْمَحْيَا وَالْمَمَاتِ",
        transliteration: "Allahumma inni a'udhu bika minal kasli wal harami wal ma'thami wal maghrami wa min adhab alqabri wa fitnat almahya wal mamat",
        translation: "O Allah, I seek refuge in You from laziness, old age, sin, debt, and from the punishment of the grave and the trials of life and death.",
        purpose: "To seek protection from various harms",
        count: "1"
      ),
    ];
  }

  List<ZikrItem> _getHardcodedGeneralZikrs() {
    return [
      ZikrItem(
        arabic: "سُبْحَانَ اللَّهِ",
        transliteration: "Subhanallah",
        translation: "Glory be to Allah",
        purpose: "To glorify Allah and seek forgiveness",
        count: "33"
      ),
      ZikrItem(
        arabic: "الْحَمْدُ لِلَّهِ",
        transliteration: "Alhamdulillah",
        translation: "All praise is due to Allah",
        purpose: "To express gratitude to Allah",
        count: "33"
      ),
      ZikrItem(
        arabic: "اللَّهُ أَكْبَرُ",
        transliteration: "Allahu Akbar",
        translation: "Allah is the Greatest",
        purpose: "To declare Allah's greatness",
        count: "33"
      ),
      ZikrItem(
        arabic: "لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
        transliteration: "La ilaha illallah wahdahu la sharika lahu lahul mulku wa lahul hamdu wa huwa ala kulli shay'in qadir",
        translation: "There is no god but Allah, alone, without any partner. To Him belongs the sovereignty and to Him belongs all praise, and He is over all things competent.",
        purpose: "To affirm Tawhid and Allah's power",
        count: "1"
      ),
      ZikrItem(
        arabic: "أَسْتَغْفِرُ اللَّهَ",
        transliteration: "Astaghfirullah",
        translation: "I seek forgiveness from Allah",
        purpose: "To seek forgiveness from Allah",
        count: "3"
      ),
    ];
  }

  List<AsmaUlHusnaItem> _getHardcodedAsmaUlHusna() {
    return [
      AsmaUlHusnaItem(arabic: "الله", en: "Allah", ur: "اللہ"),
      AsmaUlHusnaItem(arabic: "الرحمن", en: "The Most Merciful", ur: "نہایت مہربان"),
      AsmaUlHusnaItem(arabic: "الرحيم", en: "The Most Compassionate", ur: "بہت رحم کرنے والا"),
      AsmaUlHusnaItem(arabic: "الملك", en: "The King", ur: "بادشاہ"),
      AsmaUlHusnaItem(arabic: "القدوس", en: "The Most Pure", ur: "نہایت پاک"),
      AsmaUlHusnaItem(arabic: "السلام", en: "The Source of Peace", ur: "سلامتی دینے والا"),
      AsmaUlHusnaItem(arabic: "المؤمن", en: "The Giver of Security", ur: "امن دینے والا"),
      AsmaUlHusnaItem(arabic: "المهيمن", en: "The Protector", ur: "نگہبان"),
      AsmaUlHusnaItem(arabic: "العزيز", en: "The Almighty", ur: "زبردست"),
      AsmaUlHusnaItem(arabic: "الجبار", en: "The Compeller", ur: "زبردست غلبہ والا"),
      AsmaUlHusnaItem(arabic: "المتكبر", en: "The Supremely Great", ur: "بڑائی والا"),
      AsmaUlHusnaItem(arabic: "الخالق", en: "The Creator", ur: "پیدا کرنے والا"),
      AsmaUlHusnaItem(arabic: "البارئ", en: "The Evolver", ur: "بنانے والا"),
      AsmaUlHusnaItem(arabic: "المصور", en: "The Fashioner", ur: "صورت بنانے والا"),
      AsmaUlHusnaItem(arabic: "الغفار", en: "The All-Forgiving", ur: "بہت معاف کرنے والا"),
      AsmaUlHusnaItem(arabic: "القهار", en: "The Subduer", ur: "غالب"),
      AsmaUlHusnaItem(arabic: "الوهاب", en: "The Bestower", ur: "بے لوث عطا کرنے والا"),
      AsmaUlHusnaItem(arabic: "الرزاق", en: "The Provider", ur: "رزق دینے والا"),
      AsmaUlHusnaItem(arabic: "الفتاح", en: "The Opener", ur: "کھولنے والا"),
      AsmaUlHusnaItem(arabic: "العليم", en: "The All-Knowing", ur: "سب کچھ جاننے والا"),
      AsmaUlHusnaItem(arabic: "القابض", en: "The Withholder", ur: "روکنے والا"),
      AsmaUlHusnaItem(arabic: "الباسط", en: "The Expander", ur: "کشادگی دینے والا"),
      AsmaUlHusnaItem(arabic: "الخافض", en: "The Abaser", ur: "پست کرنے والا"),
      AsmaUlHusnaItem(arabic: "الرافع", en: "The Exalter", ur: "بلند کرنے والا"),
      AsmaUlHusnaItem(arabic: "المعز", en: "The Giver of Honor", ur: "عزت دینے والا"),
      AsmaUlHusnaItem(arabic: "المذل", en: "The Giver of Dishonor", ur: "ذلیل کرنے والا"),
      AsmaUlHusnaItem(arabic: "السميع", en: "The All-Hearing", ur: "سب سننے والا"),
      AsmaUlHusnaItem(arabic: "البصير", en: "The All-Seeing", ur: "سب دیکھنے والا"),
      AsmaUlHusnaItem(arabic: "الحكم", en: "The Judge", ur: "فیصلہ کرنے والا"),
      AsmaUlHusnaItem(arabic: "العدل", en: "The Utterly Just", ur: "انصاف کرنے والا"),
      AsmaUlHusnaItem(arabic: "اللطيف", en: "The Most Gentle", ur: "بہت مہربان"),
      AsmaUlHusnaItem(arabic: "الخبير", en: "The All-Aware", ur: "خبر رکھنے والا"),
      AsmaUlHusnaItem(arabic: "الحليم", en: "The Most Forbearing", ur: "بردبار"),
      AsmaUlHusnaItem(arabic: "العظيم", en: "The Most Great", ur: "عظمت والا"),
      AsmaUlHusnaItem(arabic: "الغفور", en: "The Forgiving", ur: "بخشنے والا"),
      AsmaUlHusnaItem(arabic: "الشكور", en: "The Most Appreciative", ur: "قدر دان"),
      AsmaUlHusnaItem(arabic: "العلي", en: "The Most High", ur: "سب سے بلند"),
      AsmaUlHusnaItem(arabic: "الكبير", en: "The Most Great", ur: "سب سے بڑا"),
      AsmaUlHusnaItem(arabic: "الحفيظ", en: "The Preserver", ur: "حفاظت کرنے والا"),
      AsmaUlHusnaItem(arabic: "المقيت", en: "The Sustainer", ur: "خوراک دینے والا"),
      AsmaUlHusnaItem(arabic: "الحسيب", en: "The Reckoner", ur: "حساب لینے والا"),
      AsmaUlHusnaItem(arabic: "الجليل", en: "The Majestic", ur: "بزرگ"),
      AsmaUlHusnaItem(arabic: "الكريم", en: "The Most Generous", ur: "کرم کرنے والا"),
      AsmaUlHusnaItem(arabic: "الرقيب", en: "The Watchful", ur: "نگہبان"),
      AsmaUlHusnaItem(arabic: "المجيب", en: "The Answerer", ur: "قبول کرنے والا"),
      AsmaUlHusnaItem(arabic: "الواسع", en: "The All-Encompassing", ur: "کشادگی والا"),
      AsmaUlHusnaItem(arabic: "الحكيم", en: "The All-Wise", ur: "حکمت والا"),
      AsmaUlHusnaItem(arabic: "الودود", en: "The Most Loving", ur: "محبت کرنے والا"),
      AsmaUlHusnaItem(arabic: "المجيد", en: "The Most Glorious", ur: "بزرگی والا"),
      AsmaUlHusnaItem(arabic: "الباعث", en: "The Resurrector", ur: "اٹھانے والا"),
      AsmaUlHusnaItem(arabic: "الشهيد", en: "The Witness", ur: "گواہ"),
      AsmaUlHusnaItem(arabic: "الحق", en: "The Absolute Truth", ur: "سچا"),
      AsmaUlHusnaItem(arabic: "الوكيل", en: "The Trustee", ur: "کارساز"),
      AsmaUlHusnaItem(arabic: "القوي", en: "The All-Powerful", ur: "طاقتور"),
      AsmaUlHusnaItem(arabic: "المتين", en: "The Firm", ur: "مضبوط"),
      AsmaUlHusnaItem(arabic: "الولي", en: "The Protector", ur: "دوست"),
      AsmaUlHusnaItem(arabic: "الحميد", en: "The Praiseworthy", ur: "قابلِ تعریف"),
      AsmaUlHusnaItem(arabic: "المحصي", en: "The Accounter", ur: "شمار کرنے والا"),
      AsmaUlHusnaItem(arabic: "المبدئ", en: "The Originator", ur: "پہلی بار پیدا کرنے والا"),
      AsmaUlHusnaItem(arabic: "المعيد", en: "The Restorer", ur: "دوبارہ پیدا کرنے والا"),
      AsmaUlHusnaItem(arabic: "المحيي", en: "The Giver of Life", ur: "زندگی دینے والا"),
      AsmaUlHusnaItem(arabic: "المميت", en: "The Taker of Life", ur: "موت دینے والا"),
      AsmaUlHusnaItem(arabic: "الحي", en: "The Ever-Living", ur: "ہمیشہ زندہ"),
      AsmaUlHusnaItem(arabic: "القيوم", en: "The Self-Existing", ur: "قائم رکھنے والا"),
      AsmaUlHusnaItem(arabic: "الواجد", en: "The Perceiver", ur: "پانے والا"),
      AsmaUlHusnaItem(arabic: "الماجد", en: "The Illustrious", ur: "عظمت والا"),
      AsmaUlHusnaItem(arabic: "الواحد", en: "The One", ur: "ایک"),
      AsmaUlHusnaItem(arabic: "الصمد", en: "The Eternal Refuge", ur: "بے نیاز"),
      AsmaUlHusnaItem(arabic: "القادر", en: "The All-Powerful", ur: "قدرت والا"),
      AsmaUlHusnaItem(arabic: "المقتدر", en: "The Determiner", ur: "قدرت رکھنے والا"),
      AsmaUlHusnaItem(arabic: "المقدم", en: "The Promoter", ur: "آگے بڑھانے والا"),
      AsmaUlHusnaItem(arabic: "المؤخر", en: "The Delayer", ur: "پیچھے کرنے والا"),
      AsmaUlHusnaItem(arabic: "الأول", en: "The First", ur: "سب سے پہلا"),
      AsmaUlHusnaItem(arabic: "الآخر", en: "The Last", ur: "سب سے آخر"),
      AsmaUlHusnaItem(arabic: "الظاهر", en: "The Manifest", ur: "ظاہر"),
      AsmaUlHusnaItem(arabic: "الباطن", en: "The Hidden", ur: "پوشیدہ"),
      AsmaUlHusnaItem(arabic: "الوالي", en: "The Governor", ur: "اختیار والا"),
      AsmaUlHusnaItem(arabic: "المتعالي", en: "The Most Exalted", ur: "بہت بلند"),
      AsmaUlHusnaItem(arabic: "البر", en: "The Most Kind", ur: "نیکی کرنے والا"),
      AsmaUlHusnaItem(arabic: "التواب", en: "The Accepter of Repentance", ur: "توبہ قبول کرنے والا"),
      AsmaUlHusnaItem(arabic: "المنتقم", en: "The Avenger", ur: "بدلہ لینے والا"),
      AsmaUlHusnaItem(arabic: "العفو", en: "The Pardoner", ur: "معاف کرنے والا"),
      AsmaUlHusnaItem(arabic: "الرؤوف", en: "The Most Kind", ur: "نہایت مہربان"),
      AsmaUlHusnaItem(arabic: "مالك الملك", en: "Owner of Sovereignty", ur: "بادشاہی کا مالک"),
      AsmaUlHusnaItem(arabic: "ذو الجلال والإكرام", en: "Lord of Majesty and Honor", ur: "جلال و کرم والا"),
      AsmaUlHusnaItem(arabic: "المقسط", en: "The Just One", ur: "انصاف کرنے والا"),
      AsmaUlHusnaItem(arabic: "الجامع", en: "The Gatherer", ur: "جمع کرنے والا"),
      AsmaUlHusnaItem(arabic: "الغني", en: "The Self-Sufficient", ur: "بے نیاز"),
      AsmaUlHusnaItem(arabic: "المغني", en: "The Enricher", ur: "غنی کرنے والا"),
      AsmaUlHusnaItem(arabic: "المانع", en: "The Preventer", ur: "روکنے والا"),
      AsmaUlHusnaItem(arabic: "الضار", en: "The Distresser", ur: "نقصان پہنچانے والا"),
      AsmaUlHusnaItem(arabic: "النافع", en: "The Benefactor", ur: "نفع دینے والا"),
      AsmaUlHusnaItem(arabic: "النور", en: "The Light", ur: "روشنی"),
      AsmaUlHusnaItem(arabic: "الهادي", en: "The Guide", ur: "ہدایت دینے والا"),
      AsmaUlHusnaItem(arabic: "البديع", en: "The Incomparable", ur: "بے مثال"),
      AsmaUlHusnaItem(arabic: "الباقي", en: "The Everlasting", ur: "ہمیشہ رہنے والا"),
      AsmaUlHusnaItem(arabic: "الوارث", en: "The Inheritor", ur: "وارث"),
      AsmaUlHusnaItem(arabic: "الرشيد", en: "The Guide to the Right Path", ur: "راہِ راست دکھانے والا"),
      AsmaUlHusnaItem(arabic: "الصبور", en: "The Most Patient", ur: "بہت صبر والا"),
    ];
  }
}
