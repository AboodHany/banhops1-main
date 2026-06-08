import '../models/location_node.dart';
import '../models/trip_record.dart';
import '../models/transit_enums.dart';

class DemoTransitCatalog {
  static const governorates = [
    'Cairo', 'Giza', 'Qalyubia', 'Alexandria', 'Gharbia', 'Dakahlia', 'Menofia', 'Sharqia', 
    'Beheira', 'Kafr El Sheikh', 'Damietta', 'Port Said', 'Ismailia', 'Suez', 'North Sinai', 
    'South Sinai', 'Beni Suef', 'Faiyum', 'Minya', 'Asyut', 'Sohag', 'Qena', 'Luxor', 
    'Aswan', 'Red Sea', 'New Valley', 'Matrouh'
  ];

  static const List<LocationNode> cairoCities = [
    LocationNode(id: 201, name: 'Ahmed Helmy', latitude: 30.0631, longitude: 31.2467, type: TransitLocationType.hub, alias: 'Ramses Area', governorate: 'Cairo'),
    LocationNode(id: 202, name: 'El-Salam', latitude: 30.1523, longitude: 31.4234, type: TransitLocationType.hub, alias: 'Adly Mansour Terminal', governorate: 'Cairo'),
    LocationNode(id: 203, name: 'El-Marg', latitude: 30.1518, longitude: 31.3364, type: TransitLocationType.hub, alias: 'Marg Metro', governorate: 'Cairo'),
    LocationNode(id: 204, name: 'Shubra El-Maza', latitude: 30.1189, longitude: 31.2589, type: TransitLocationType.hub, alias: 'El-Moustasalam', governorate: 'Cairo'),
    LocationNode(id: 205, name: 'Helwan', latitude: 29.8402, longitude: 31.2987, type: TransitLocationType.hub, alias: 'South Cairo', governorate: 'Cairo'),
    
    // Metro Line 1
    LocationNode(id: 601, name: 'Helwan (Metro)', latitude: 29.8402, longitude: 31.2987, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 602, name: 'Ain Helwan (Metro)', latitude: 29.8530, longitude: 31.3050, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 603, name: 'Helwan University (Metro)', latitude: 29.8660, longitude: 31.3150, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 604, name: 'Wadi Hof (Metro)', latitude: 29.8780, longitude: 31.3130, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 605, name: 'Hadayek Helwan (Metro)', latitude: 29.8950, longitude: 31.3050, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 606, name: 'El-Maasara (Metro)', latitude: 29.9080, longitude: 31.2980, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 607, name: 'Tora El-Asmant (Metro)', latitude: 29.9230, longitude: 31.2890, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 608, name: 'Kozzika (Metro)', latitude: 29.9340, longitude: 31.2820, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 609, name: 'Tora El-Balad (Metro)', latitude: 29.9460, longitude: 31.2750, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 610, name: 'Sakanat El-Maadi (Metro)', latitude: 29.9540, longitude: 31.2650, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 611, name: 'Maadi (Metro)', latitude: 29.9602, longitude: 31.2598, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 612, name: 'Hadayek El-Maadi (Metro)', latitude: 29.9720, longitude: 31.2500, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 613, name: 'Dar El-Salam (Metro)', latitude: 29.9860, longitude: 31.2420, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 614, name: 'El-Zahraa (Metro)', latitude: 29.9990, longitude: 31.2350, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 615, name: 'Mar Girgis (Metro)', latitude: 30.0060, longitude: 31.2300, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 616, name: 'El-Malek El-Saleh (Metro)', latitude: 30.0180, longitude: 31.2280, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 617, name: 'Sayeda Zeinab (Metro)', latitude: 30.0298, longitude: 31.2330, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 618, name: 'Saad Zaghloul (Metro)', latitude: 30.0360, longitude: 31.2370, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 619, name: 'Sadat (Metro)', latitude: 30.0444, longitude: 31.2357, type: TransitLocationType.station, alias: 'Metro Line 1/2 Hub', governorate: 'Cairo'),
    LocationNode(id: 620, name: 'Nasser (Metro)', latitude: 30.0535, longitude: 31.2403, type: TransitLocationType.station, alias: 'Metro Line 1/3 Hub', governorate: 'Cairo'),
    LocationNode(id: 621, name: 'Orabi (Metro)', latitude: 30.0570, longitude: 31.2430, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 622, name: 'Al-Shohadaa (Metro)', latitude: 30.0617, longitude: 31.2467, type: TransitLocationType.station, alias: 'Metro Line 1/2 Ramses', governorate: 'Cairo'),
    LocationNode(id: 623, name: 'Ghamra (Metro)', latitude: 30.0700, longitude: 31.2680, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 624, name: 'El-Demerdash (Metro)', latitude: 30.0780, longitude: 31.2770, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 625, name: 'Manshiet El-Sadr (Metro)', latitude: 30.0830, longitude: 31.2840, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 626, name: 'Kobri El-Qobba (Metro)', latitude: 30.0870, longitude: 31.2890, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 627, name: 'Hammamat El-Qobba (Metro)', latitude: 30.0910, longitude: 31.2930, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 628, name: 'Saray El-Qobba (Metro)', latitude: 30.0980, longitude: 31.3020, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 629, name: 'Hadayek El-Zaitoun (Metro)', latitude: 30.1060, longitude: 31.3110, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 630, name: 'Helmiet El-Zaitoun (Metro)', latitude: 30.1150, longitude: 31.3200, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 631, name: 'El-Matareya (Metro)', latitude: 30.1250, longitude: 31.3250, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 632, name: 'Ain Shams (Metro)', latitude: 30.1330, longitude: 31.3290, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 633, name: 'Ezbet El-Nakhl (Metro)', latitude: 30.1440, longitude: 31.3320, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 634, name: 'El-Marg (Metro)', latitude: 30.1518, longitude: 31.3364, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),
    LocationNode(id: 635, name: 'El-Marg El-Jedida (Metro)', latitude: 30.1600, longitude: 31.3400, type: TransitLocationType.station, alias: 'Metro Line 1', governorate: 'Cairo'),

    // Metro Line 2 (Cairo side)
    LocationNode(id: 711, name: 'Mohamed Naguib (Metro)', latitude: 30.0441, longitude: 31.2435, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Cairo'),
    LocationNode(id: 712, name: 'Attaba (Metro)', latitude: 30.0526, longitude: 31.2472, type: TransitLocationType.station, alias: 'Metro Line 2/3 Hub', governorate: 'Cairo'),
    LocationNode(id: 714, name: 'Massarra (Metro)', latitude: 30.0769, longitude: 31.2450, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Cairo'),
    LocationNode(id: 715, name: 'Rod El-Farag (Metro)', latitude: 30.0864, longitude: 31.2458, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Cairo'),
    LocationNode(id: 716, name: 'St. Teresa (Metro)', latitude: 30.0930, longitude: 31.2460, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Cairo'),
    LocationNode(id: 717, name: 'El-Khalafawy (Metro)', latitude: 30.0990, longitude: 31.2470, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Cairo'),
    LocationNode(id: 718, name: 'El-Mazallat (Metro)', latitude: 30.1042, longitude: 31.2492, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Cairo'),

    // Metro Line 3
    LocationNode(id: 801, name: 'Nadi El-Shams (Metro)', latitude: 30.1150, longitude: 31.3450, type: TransitLocationType.station, alias: 'Metro Line 3', governorate: 'Cairo'),
    LocationNode(id: 802, name: 'Abassia (Metro)', latitude: 30.0650, longitude: 31.2820, type: TransitLocationType.station, alias: 'Metro Line 3', governorate: 'Cairo'),
    LocationNode(id: 803, name: 'Kit Kat (Metro)', latitude: 30.0720, longitude: 31.2110, type: TransitLocationType.station, alias: 'Metro Line 3', governorate: 'Cairo'),
    
    // LRT
    LocationNode(id: 901, name: 'El-Shorouk (LRT)', latitude: 30.1410, longitude: 31.6320, type: TransitLocationType.station, alias: 'LRT Line', governorate: 'Cairo'),
    LocationNode(id: 902, name: 'Badr City (LRT)', latitude: 30.1380, longitude: 31.7350, type: TransitLocationType.station, alias: 'LRT Line', governorate: 'Cairo'),
    LocationNode(id: 903, name: '10th of October (LRT)', latitude: 30.3010, longitude: 31.7450, type: TransitLocationType.station, alias: 'LRT Line', governorate: 'Cairo'),
    LocationNode(id: 904, name: 'Arts & Culture City (LRT)', latitude: 30.0120, longitude: 31.6980, type: TransitLocationType.station, alias: 'LRT Line', governorate: 'Cairo'),
    
    // Monorail East
    LocationNode(id: 1001, name: 'El-Estad (Monorail)', latitude: 30.0690, longitude: 31.3250, type: TransitLocationType.station, alias: 'East Monorail', governorate: 'Cairo'),
    LocationNode(id: 1002, name: 'Fifth Settlement (Monorail)', latitude: 30.0050, longitude: 31.4210, type: TransitLocationType.station, alias: 'East Monorail', governorate: 'Cairo'),
    LocationNode(id: 1003, name: 'AUC (Monorail)', latitude: 30.0210, longitude: 31.5030, type: TransitLocationType.station, alias: 'East Monorail', governorate: 'Cairo'),
    LocationNode(id: 1004, name: 'Governmental District (Monorail)', latitude: 29.9880, longitude: 31.6850, type: TransitLocationType.station, alias: 'East Monorail', governorate: 'Cairo'),
  ];

  static const List<LocationNode> gizaCities = [
    LocationNode(id: 211, name: 'El-Haram', latitude: 29.9912, longitude: 31.1543, type: TransitLocationType.hub, alias: 'Haram Street', governorate: 'Giza'),
    LocationNode(id: 212, name: 'Imbaba', latitude: 30.0768, longitude: 31.2104, type: TransitLocationType.hub, alias: 'Imbaba Sector', governorate: 'Giza'),
    LocationNode(id: 213, name: '6th of October', latitude: 29.9723, longitude: 30.9421, type: TransitLocationType.hub, alias: 'October Hub', governorate: 'Giza'),
    LocationNode(id: 214, name: 'El-Warraq', latitude: 30.1087, longitude: 31.2065, type: TransitLocationType.hub, alias: 'Warraq Giza', governorate: 'Giza'),
    LocationNode(id: 215, name: 'Dokki', latitude: 30.0384, longitude: 31.2114, type: TransitLocationType.hub, alias: 'Central Giza', governorate: 'Giza'),
    
    // Metro Line 2 (Giza side)
    LocationNode(id: 701, name: 'El-Mounib (Metro)', latitude: 29.9810, longitude: 31.2090, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Giza'),
    LocationNode(id: 702, name: 'Sakiat Mekky (Metro)', latitude: 29.9950, longitude: 31.2080, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Giza'),
    LocationNode(id: 703, name: 'Omm El-Misryeen (Metro)', latitude: 30.0070, longitude: 31.2060, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Giza'),
    LocationNode(id: 704, name: 'Giza (Metro)', latitude: 30.0104, longitude: 31.2002, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Giza'),
    LocationNode(id: 705, name: 'Faisal (Metro)', latitude: 30.0170, longitude: 31.1990, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Giza'),
    LocationNode(id: 706, name: 'Cairo University (Metro)', latitude: 30.0260, longitude: 31.2010, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Giza'),
    LocationNode(id: 707, name: 'El-Bohouth (Metro)', latitude: 30.0358, longitude: 31.2003, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Giza'),
    LocationNode(id: 708, name: 'Dokki (Metro)', latitude: 30.0384, longitude: 31.2114, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Giza'),
    LocationNode(id: 709, name: 'Opera (Metro)', latitude: 30.0425, longitude: 31.2267, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Giza'),
    
    // Metro Line 3 West
    LocationNode(id: 804, name: 'Rod El-Farag Axis (Metro)', latitude: 30.0910, longitude: 31.1850, type: TransitLocationType.station, alias: 'Metro Line 3', governorate: 'Giza'),
    LocationNode(id: 805, name: 'League of Arab States (Metro)', latitude: 30.0435, longitude: 31.2005, type: TransitLocationType.station, alias: 'Metro Line 3', governorate: 'Giza'),
    LocationNode(id: 806, name: 'Boulaq El-Dakrour (Metro)', latitude: 30.0333, longitude: 31.1911, type: TransitLocationType.station, alias: 'Metro Line 3', governorate: 'Giza'),
    
    // Monorail West
    LocationNode(id: 1101, name: 'Wadi El-Nile (Monorail)', latitude: 30.0540, longitude: 31.2000, type: TransitLocationType.station, alias: 'West Monorail', governorate: 'Giza'),
    LocationNode(id: 1102, name: 'Hyper One (Monorail)', latitude: 30.0150, longitude: 30.9850, type: TransitLocationType.station, alias: 'West Monorail', governorate: 'Giza'),
    LocationNode(id: 1103, name: 'El-Hosary (Monorail)', latitude: 29.9720, longitude: 30.9450, type: TransitLocationType.station, alias: 'West Monorail', governorate: 'Giza'),
    LocationNode(id: 1104, name: 'Bashtiel Train Station (Train)', latitude: 30.0820, longitude: 31.1980, type: TransitLocationType.station, alias: 'West Monorail', governorate: 'Giza'),
  ];

  static const List<LocationNode> qalyubiaCities = [
    LocationNode(id: 301, name: 'Benha (Train)', latitude: 30.4607, longitude: 31.1865, type: TransitLocationType.station, alias: 'Capital of Qalyubia', governorate: 'Qalyubia'),
    LocationNode(id: 302, name: 'Qaha', latitude: 30.2831, longitude: 31.2045, type: TransitLocationType.hub, alias: 'Qaha City', governorate: 'Qalyubia'),
    LocationNode(id: 303, name: 'Toukh', latitude: 30.3546, longitude: 31.2005, type: TransitLocationType.hub, alias: 'Toukh Hub', governorate: 'Qalyubia'),
    LocationNode(id: 304, name: 'Shibin Al Qanater', latitude: 30.3134, longitude: 31.3145, type: TransitLocationType.hub, alias: 'Shibin Station', governorate: 'Qalyubia'),
    LocationNode(id: 305, name: 'Kafr Shukr', latitude: 30.5489, longitude: 31.2267, type: TransitLocationType.hub, alias: 'Kafr Shukr City', governorate: 'Qalyubia'),
    LocationNode(id: 306, name: 'Qalyub', latitude: 30.1834, longitude: 31.2056, type: TransitLocationType.hub, alias: 'Qalyub Hub', governorate: 'Qalyubia'),
    LocationNode(id: 307, name: 'Khanka', latitude: 30.2132, longitude: 31.3789, type: TransitLocationType.hub, alias: 'Khanka Area', governorate: 'Qalyubia'),
    LocationNode(id: 308, name: 'Al-Obour', latitude: 30.2089, longitude: 31.4789, type: TransitLocationType.hub, alias: 'Obour City', governorate: 'Qalyubia'),
    LocationNode(id: 309, name: 'Shubra Al-Khaimah', latitude: 30.1256, longitude: 31.2467, type: TransitLocationType.hub, alias: 'Metro Shubra', governorate: 'Qalyubia'),
    LocationNode(id: 310, name: 'Qanater Al-Khayria', latitude: 30.1912, longitude: 31.1367, type: TransitLocationType.hub, alias: 'Barrage Area', governorate: 'Qalyubia'),
    LocationNode(id: 311, name: 'Shiblanga (Train)', latitude: 30.4967, longitude: 31.2728, type: TransitLocationType.station, alias: 'Shiblanga Station', governorate: 'Qalyubia'),
    
    // Metro Line 2 (Shubra branch)
    LocationNode(id: 719, name: 'Faculty of Agriculture (Metro)', latitude: 30.1150, longitude: 31.2520, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Qalyubia'),
    LocationNode(id: 720, name: 'Shubra El-Kheima (Metro)', latitude: 30.1256, longitude: 31.2467, type: TransitLocationType.station, alias: 'Metro Line 2', governorate: 'Qalyubia'),
    
    // Qalyubia Villages & Areas
    LocationNode(id: 501, name: 'دجوى', latitude: 30.4600, longitude: 31.1800, type: TransitLocationType.hub, alias: 'Dajwi', governorate: 'Qalyubia'),
    LocationNode(id: 502, name: 'طحلة', latitude: 30.4500, longitude: 31.1700, type: TransitLocationType.hub, alias: 'Tahla', governorate: 'Qalyubia'),
    LocationNode(id: 503, name: 'بطا', latitude: 30.4700, longitude: 31.1900, type: TransitLocationType.hub, alias: 'Bata', governorate: 'Qalyubia'),
    LocationNode(id: 504, name: 'ميت عاصم', latitude: 30.4650, longitude: 31.2000, type: TransitLocationType.hub, alias: 'Mit Assem', governorate: 'Qalyubia'),
    LocationNode(id: 505, name: 'بتمدّه', latitude: 30.4550, longitude: 31.1600, type: TransitLocationType.hub, alias: 'Betmaddah', governorate: 'Qalyubia'),
    LocationNode(id: 506, name: 'سندنهور', latitude: 30.4450, longitude: 31.2100, type: TransitLocationType.hub, alias: 'Sandanhour', governorate: 'Qalyubia'),
    LocationNode(id: 507, name: 'كفر مويس', latitude: 30.4750, longitude: 31.1500, type: TransitLocationType.hub, alias: 'Kafr Mouis', governorate: 'Qalyubia'),
    LocationNode(id: 508, name: 'العمار', latitude: 30.4300, longitude: 31.2200, type: TransitLocationType.hub, alias: 'El-Ammar', governorate: 'Qalyubia'),
    LocationNode(id: 509, name: 'أمياى', latitude: 30.4250, longitude: 31.2300, type: TransitLocationType.hub, alias: 'Amyai', governorate: 'Qalyubia'),
    LocationNode(id: 510, name: 'بلتان', latitude: 30.4350, longitude: 31.2400, type: TransitLocationType.hub, alias: 'Beltan', governorate: 'Qalyubia'),
    LocationNode(id: 511, name: 'برشوم', latitude: 30.4150, longitude: 31.2500, type: TransitLocationType.hub, alias: 'Barshoum', governorate: 'Qalyubia'),
    LocationNode(id: 512, name: 'العبادلة', latitude: 30.4050, longitude: 31.2600, type: TransitLocationType.hub, alias: 'El-Abadlah', governorate: 'Qalyubia'),
    LocationNode(id: 513, name: 'فرسيس', latitude: 30.4850, longitude: 31.1400, type: TransitLocationType.hub, alias: 'Farsiss', governorate: 'Qalyubia'),
    LocationNode(id: 514, name: 'ميت الحوفيين', latitude: 30.4900, longitude: 31.1300, type: TransitLocationType.hub, alias: 'Mit El-Hofiyyin', governorate: 'Qalyubia'),
    LocationNode(id: 515, name: 'بقيرة', latitude: 30.4950, longitude: 31.1200, type: TransitLocationType.hub, alias: 'Baqirah', governorate: 'Qalyubia'),
    LocationNode(id: 516, name: 'دملو', latitude: 30.5000, longitude: 31.1100, type: TransitLocationType.hub, alias: 'Damlo', governorate: 'Qalyubia'),
    LocationNode(id: 517, name: 'ورورة', latitude: 30.5050, longitude: 31.1000, type: TransitLocationType.hub, alias: 'Warwarah', governorate: 'Qalyubia'),
    LocationNode(id: 518, name: 'ميت العطار', latitude: 30.4100, longitude: 31.2700, type: TransitLocationType.hub, alias: 'Mit El-Attar', governorate: 'Qalyubia'),
    LocationNode(id: 519, name: 'ميت راضى', latitude: 30.4200, longitude: 31.2800, type: TransitLocationType.hub, alias: 'Mit Rady', governorate: 'Qalyubia'),
    LocationNode(id: 520, name: 'نقباس', latitude: 30.4300, longitude: 31.2900, type: TransitLocationType.hub, alias: 'Neqbas', governorate: 'Qalyubia'),
    LocationNode(id: 521, name: 'الشموت', latitude: 30.4400, longitude: 31.3000, type: TransitLocationType.hub, alias: 'El-Shammout', governorate: 'Qalyubia'),
    LocationNode(id: 522, name: 'ميت كنانة', latitude: 30.4500, longitude: 31.3100, type: TransitLocationType.hub, alias: 'Mit Kenanah', governorate: 'Qalyubia'),
    LocationNode(id: 523, name: 'جزيرة بلى', latitude: 30.4600, longitude: 31.3200, type: TransitLocationType.hub, alias: 'Jazirat Belly', governorate: 'Qalyubia'),
    LocationNode(id: 524, name: 'مرصفا', latitude: 30.4700, longitude: 31.3300, type: TransitLocationType.hub, alias: 'Moursofa', governorate: 'Qalyubia'),
    LocationNode(id: 525, name: 'طنط الجزيرة', latitude: 30.4800, longitude: 31.3400, type: TransitLocationType.hub, alias: 'Tant El-Jazirah', governorate: 'Qalyubia'),
    LocationNode(id: 526, name: 'كفر الحصة', latitude: 30.4900, longitude: 31.3500, type: TransitLocationType.hub, alias: 'Kafr El-Hessah', governorate: 'Qalyubia'),
    LocationNode(id: 527, name: 'السفاينة', latitude: 30.5000, longitude: 31.3600, type: TransitLocationType.hub, alias: 'El-Safaynah', governorate: 'Qalyubia'),
    LocationNode(id: 528, name: 'جمجرة', latitude: 30.5100, longitude: 31.3700, type: TransitLocationType.hub, alias: 'Jamjarah', governorate: 'Qalyubia'),
    LocationNode(id: 529, name: 'الصفا', latitude: 30.5200, longitude: 31.3800, type: TransitLocationType.hub, alias: 'El-Safa', governorate: 'Qalyubia'),
    LocationNode(id: 530, name: 'الرملة', latitude: 30.5300, longitude: 31.3900, type: TransitLocationType.hub, alias: 'El-Ramlah', governorate: 'Qalyubia'),
    LocationNode(id: 531, name: 'الشقير', latitude: 30.5400, longitude: 31.4000, type: TransitLocationType.hub, alias: 'El-Shokayr', governorate: 'Qalyubia'),
    LocationNode(id: 532, name: 'برقطا', latitude: 30.5500, longitude: 31.4100, type: TransitLocationType.hub, alias: 'Borqata', governorate: 'Qalyubia'),
    LocationNode(id: 533, name: 'مجول', latitude: 30.5600, longitude: 31.4200, type: TransitLocationType.hub, alias: 'Majoul', governorate: 'Qalyubia'),
    LocationNode(id: 534, name: 'كفر العرب', latitude: 30.5700, longitude: 31.4300, type: TransitLocationType.hub, alias: 'Kafr El-Arab', governorate: 'Qalyubia'),
    LocationNode(id: 535, name: 'أسنيت', latitude: 30.5800, longitude: 31.4400, type: TransitLocationType.hub, alias: 'Esneet', governorate: 'Qalyubia'),
    LocationNode(id: 536, name: 'الشقر', latitude: 30.5900, longitude: 31.4500, type: TransitLocationType.hub, alias: 'El-Shoqar', governorate: 'Qalyubia'),
  ];

  static const List<LocationNode> menofiaCities = [
    LocationNode(id: 321, name: 'Shibin El-Kom', latitude: 30.5512, longitude: 31.0124, type: TransitLocationType.hub, alias: 'Menofia Capital', governorate: 'Menofia'),
    LocationNode(id: 322, name: 'Ashmoun', latitude: 30.2987, longitude: 30.9845, type: TransitLocationType.hub, alias: 'Ashmoun Hub', governorate: 'Menofia'),
    LocationNode(id: 323, name: 'Menouf', latitude: 30.4654, longitude: 30.9321, type: TransitLocationType.hub, alias: 'Menouf City', governorate: 'Menofia'),
    LocationNode(id: 324, name: 'Sars El-Lyan', latitude: 30.4489, longitude: 30.9654, type: TransitLocationType.hub, alias: 'Sars Hub', governorate: 'Menofia'),
    LocationNode(id: 325, name: 'Quweisna', latitude: 30.5654, longitude: 31.1423, type: TransitLocationType.hub, alias: 'Quweisna Zone', governorate: 'Menofia'),
    LocationNode(id: 326, name: 'El-Bagour', latitude: 30.4354, longitude: 31.0345, type: TransitLocationType.hub, alias: 'Bagour Hub', governorate: 'Menofia'),
    LocationNode(id: 327, name: 'Birket El-Sab (Train)', latitude: 30.6291, longitude: 31.0824, type: TransitLocationType.station, alias: 'Birket El-Sab Station', governorate: 'Menofia'),
    
    // Menofia Villages & Areas
    LocationNode(id: 551, name: 'ميت بره', latitude: 30.5600, longitude: 31.1500, type: TransitLocationType.hub, alias: 'Mit Barra', governorate: 'Menofia'),
    LocationNode(id: 552, name: 'مشيرف', latitude: 30.5700, longitude: 31.1600, type: TransitLocationType.hub, alias: 'Moshyaref', governorate: 'Menofia'),
  ];

  static const List<LocationNode> gharbiaCities = [
    LocationNode(id: 331, name: 'Tanta (Train)', latitude: 30.7865, longitude: 31.0004, type: TransitLocationType.station, alias: 'Delta Capital', governorate: 'Gharbia'),
    LocationNode(id: 332, name: 'Mahalla', latitude: 30.9689, longitude: 31.1654, type: TransitLocationType.hub, alias: 'Industrial Hub', governorate: 'Gharbia'),
    LocationNode(id: 333, name: 'Kafr El-Zayat', latitude: 30.8234, longitude: 30.8143, type: TransitLocationType.hub, alias: 'Zayat Hub', governorate: 'Gharbia'),
    LocationNode(id: 334, name: 'Samanoud (Train)', latitude: 30.9622, longitude: 31.2425, type: TransitLocationType.station, alias: 'Samanoud Station', governorate: 'Gharbia'),
  ];

  static const List<LocationNode> dakahliaCities = [
    LocationNode(id: 341, name: 'Mansoura', latitude: 31.0409, longitude: 31.3785, type: TransitLocationType.hub, alias: 'East Delta Capital', governorate: 'Dakahlia'),
    LocationNode(id: 342, name: 'Mit Ghamr', latitude: 30.7189, longitude: 31.2589, type: TransitLocationType.hub, alias: 'Mit Ghamr City', governorate: 'Dakahlia'),
    LocationNode(id: 343, name: 'Aga', latitude: 30.8876, longitude: 31.3145, type: TransitLocationType.hub, alias: 'Aga Zone', governorate: 'Dakahlia'),
    LocationNode(id: 344, name: 'Talkha', latitude: 31.0543, longitude: 31.3845, type: TransitLocationType.hub, alias: 'Talkha Hub', governorate: 'Dakahlia'),
    LocationNode(id: 345, name: 'Sherbin (Train)', latitude: 31.1928, longitude: 31.5272, type: TransitLocationType.station, alias: 'Sherbin Station', governorate: 'Dakahlia'),
  ];

  static const List<LocationNode> kafrElSheikhCities = [
    LocationNode(id: 351, name: 'Kafr El Sheikh City', latitude: 31.1107, longitude: 30.9389, type: TransitLocationType.hub, alias: 'Kafr Capital', governorate: 'Kafr El Sheikh'),
    LocationNode(id: 352, name: 'Sidi Salem', latitude: 31.2721, longitude: 30.8034, type: TransitLocationType.hub, alias: 'Sidi Salem Hub', governorate: 'Kafr El Sheikh'),
  ];

  static const List<LocationNode> otherGovCities = [
    LocationNode(id: 401, name: 'Alexandria (Train)', latitude: 31.2001, longitude: 29.9187, type: TransitLocationType.station, alias: 'Second Capital', governorate: 'Alexandria'),
    LocationNode(id: 402, name: 'Zagazig', latitude: 30.5876, longitude: 31.5012, type: TransitLocationType.hub, alias: 'Sharqia Capital', governorate: 'Sharqia'),
    LocationNode(id: 403, name: 'Damanhour', latitude: 31.0365, longitude: 30.4689, type: TransitLocationType.hub, alias: 'Beheira Capital', governorate: 'Beheira'),
    LocationNode(id: 404, name: 'Damietta City', latitude: 31.4167, longitude: 31.8167, type: TransitLocationType.hub, alias: 'Damietta Capital', governorate: 'Damietta'),
    LocationNode(id: 405, name: 'Port Said City', latitude: 31.2567, longitude: 32.2922, type: TransitLocationType.hub, alias: 'Port Said Capital', governorate: 'Port Said'),
    LocationNode(id: 406, name: 'Ismailia City', latitude: 30.6044, longitude: 32.2742, type: TransitLocationType.hub, alias: 'Ismailia Capital', governorate: 'Ismailia'),
    LocationNode(id: 407, name: 'Suez City', latitude: 29.9744, longitude: 32.5367, type: TransitLocationType.hub, alias: 'Suez Capital', governorate: 'Suez'),
    LocationNode(id: 408, name: 'Fayoum City', latitude: 29.3078, longitude: 30.8411, type: TransitLocationType.hub, alias: 'Fayoum Capital', governorate: 'Faiyum'),
    LocationNode(id: 409, name: 'Beni Suef City', latitude: 29.0744, longitude: 31.0978, type: TransitLocationType.hub, alias: 'Beni Suef Capital', governorate: 'Beni Suef'),
    LocationNode(id: 410, name: 'Minya City', latitude: 28.0871, longitude: 30.7519, type: TransitLocationType.hub, alias: 'Minya Capital', governorate: 'Minya'),
    LocationNode(id: 411, name: 'Asyut City', latitude: 27.1810, longitude: 31.1837, type: TransitLocationType.hub, alias: 'Asyut Capital', governorate: 'Asyut'),
    LocationNode(id: 412, name: 'Sohag City', latitude: 26.5570, longitude: 31.6948, type: TransitLocationType.hub, alias: 'Sohag Capital', governorate: 'Sohag'),
    LocationNode(id: 413, name: 'Qena City', latitude: 26.1551, longitude: 32.7160, type: TransitLocationType.hub, alias: 'Qena Capital', governorate: 'Qena'),
    LocationNode(id: 414, name: 'Luxor City', latitude: 25.6872, longitude: 32.6396, type: TransitLocationType.hub, alias: 'Luxor Capital', governorate: 'Luxor'),
    LocationNode(id: 415, name: 'Aswan City', latitude: 24.0889, longitude: 32.8998, type: TransitLocationType.hub, alias: 'Aswan Capital', governorate: 'Aswan'),
    LocationNode(id: 416, name: 'Hurghada', latitude: 27.2579, longitude: 33.8116, type: TransitLocationType.hub, alias: 'Red Sea Capital', governorate: 'Red Sea'),
    LocationNode(id: 417, name: 'Kharga', latitude: 25.4514, longitude: 30.5471, type: TransitLocationType.hub, alias: 'New Valley Capital', governorate: 'New Valley'),
    LocationNode(id: 418, name: 'Marsa Matrouh', latitude: 31.3522, longitude: 27.2361, type: TransitLocationType.hub, alias: 'Matrouh Capital', governorate: 'Matrouh'),
    LocationNode(id: 419, name: 'Arish', latitude: 31.1321, longitude: 33.8032, type: TransitLocationType.hub, alias: 'North Sinai Capital', governorate: 'North Sinai'),
    LocationNode(id: 420, name: 'Tor', latitude: 28.2345, longitude: 33.6123, type: TransitLocationType.hub, alias: 'South Sinai Capital', governorate: 'South Sinai'),
    LocationNode(id: 361, name: 'Minya El-Qamh (Train)', latitude: 30.5119, longitude: 31.3465, type: TransitLocationType.station, alias: 'Minya El-Qamh Station', governorate: 'Sharqia'),
    LocationNode(id: 362, name: 'Abu Hammad (Train)', latitude: 30.5444, longitude: 31.6797, type: TransitLocationType.station, alias: 'Abu Hammad Station', governorate: 'Sharqia'),
    LocationNode(id: 371, name: 'Itay El-Baroud (Train)', latitude: 30.8870, longitude: 30.6650, type: TransitLocationType.station, alias: 'Itay El-Baroud Station', governorate: 'Beheira'),
    LocationNode(id: 372, name: 'Kafr El-Dawar (Train)', latitude: 31.1342, longitude: 30.1294, type: TransitLocationType.station, alias: 'Kafr El-Dawar Station', governorate: 'Beheira'),
    LocationNode(id: 373, name: 'Abu Hummus (Train)', latitude: 31.0022, longitude: 30.3094, type: TransitLocationType.station, alias: 'Abu Hummus Station', governorate: 'Beheira'),
    LocationNode(id: 381, name: 'El-Tell El-Kebir (Train)', latitude: 30.5606, longitude: 31.9161, type: TransitLocationType.station, alias: 'El-Tell El-Kebir Station', governorate: 'Ismailia'),
    LocationNode(id: 382, name: 'El-Kassasin (Train)', latitude: 30.5636, longitude: 32.0256, type: TransitLocationType.station, alias: 'El-Kassasin Station', governorate: 'Ismailia'),
    LocationNode(id: 383, name: 'Qantara West (Train)', latitude: 30.7761, longitude: 32.3061, type: TransitLocationType.station, alias: 'Qantara West Station', governorate: 'Ismailia'),
  ];

  static const List<LocationNode> benhaDestinations = [
    LocationNode(id: 101, name: 'Benha Main Bus Terminal', latitude: 30.4678, longitude: 31.1920, type: TransitLocationType.hub, alias: 'New Terminal', governorate: 'Qalyubia'),
    LocationNode(id: 102, name: 'Benha Train Station (Train)', latitude: 30.4607, longitude: 31.1865, type: TransitLocationType.station, alias: 'Rail Hub', governorate: 'Qalyubia'),
    LocationNode(id: 103, name: 'Colleges Complex (Commerce - Arts)', latitude: 30.4613, longitude: 31.1803, type: TransitLocationType.university, alias: 'Colleges Complex', governorate: 'Qalyubia'),
    LocationNode(id: 104, name: 'University Administration', latitude: 30.4618, longitude: 31.1809, type: TransitLocationType.university, alias: 'Administration', governorate: 'Qalyubia'),
    LocationNode(id: 105, name: 'Medicine, Hospital & Corniche (El-Eshara)', latitude: 30.4657, longitude: 31.1853, type: TransitLocationType.hospital, alias: 'Hospital & Corniche', governorate: 'Qalyubia'),
    LocationNode(id: 106, name: 'Al-Ahram Area', latitude: 30.4589, longitude: 31.1824, type: TransitLocationType.hub, alias: 'Al-Ahram', governorate: 'Qalyubia'),
    LocationNode(id: 107, name: 'Old Benha Bridge', latitude: 30.4702, longitude: 31.1812, type: TransitLocationType.hub, alias: 'Old Bridge', governorate: 'Qalyubia'),
    LocationNode(id: 108, name: 'Faculty of Law', latitude: 30.4625, longitude: 31.1810, type: TransitLocationType.university, alias: 'Law', governorate: 'Qalyubia'),
    LocationNode(id: 109, name: 'University Dorms', latitude: 30.4640, longitude: 31.1830, type: TransitLocationType.university, alias: 'Dorms', governorate: 'Qalyubia'),
    LocationNode(id: 110, name: 'Al-Villas Area', latitude: 30.4680, longitude: 31.1780, type: TransitLocationType.hub, alias: 'Villas', governorate: 'Qalyubia'),
  ];

  static List<LocationNode> getLocationsForGovernorate(String gov) {
    switch (gov) {
      case 'Cairo': return cairoCities;
      case 'Giza': return gizaCities;
      case 'Qalyubia': return qalyubiaCities;
      case 'Gharbia': return gharbiaCities;
      case 'Dakahlia': return dakahliaCities;
      case 'Menofia': return menofiaCities;
      case 'Kafr El Sheikh': return kafrElSheikhCities;
      default:
        return otherGovCities.where((element) => element.governorate == gov).toList();
    }
  }

  static List<LocationNode> get locations {
    return [
      ...cairoCities,
      ...gizaCities,
      ...qalyubiaCities,
      ...gharbiaCities,
      ...dakahliaCities,
      ...menofiaCities,
      ...kafrElSheikhCities,
      ...otherGovCities,
      ...benhaDestinations,
    ];
  }

  static List<LocationNode> getCitiesForGovernorate(String gov) {
    return getLocationsForGovernorate(gov);
  }

  static final quickZones = <LocationNode>[
    const LocationNode(id: 309, name: 'Shubra Al-Khaimah', latitude: 30.1256, longitude: 31.2467, type: TransitLocationType.hub, alias: 'Metro Shubra', governorate: 'Qalyubia'),
    const LocationNode(id: 305, name: 'Kafr Shukr', latitude: 30.5489, longitude: 31.2267, type: TransitLocationType.hub, alias: 'Kafr Shukr City', governorate: 'Qalyubia'),
    const LocationNode(id: 308, name: 'Al-Obour', latitude: 30.2089, longitude: 31.4789, type: TransitLocationType.hub, alias: 'Obour City', governorate: 'Qalyubia'),
  ];

  static List<TripRecord> history = <TripRecord>[];

  static LocationNode defaultOrigin = cairoCities[0];
  static LocationNode defaultDestination = benhaDestinations[0];
}