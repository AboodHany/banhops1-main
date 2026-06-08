-- Seed Locations, Microbuses, and Trains data
-- 1. Seed Locations
-- Seeding locations table from demo_transit_catalog.dart
TRUNCATE TABLE public.locations CASCADE;
INSERT INTO public.locations (id, name, coordinates, type)
VALUES
  (201, 'Ahmed Helmy', point(31.2467, 30.0631), 'Hub'),
  (202, 'El-Salam', point(31.4234, 30.1523), 'Hub'),
  (203, 'El-Marg', point(31.3364, 30.1518), 'Hub'),
  (204, 'Shubra El-Maza', point(31.2589, 30.1189), 'Hub'),
  (205, 'Helwan', point(31.2987, 29.8402), 'Hub'),
  (211, 'El-Haram', point(31.1543, 29.9912), 'Hub'),
  (212, 'Imbaba', point(31.2104, 30.0768), 'Hub'),
  (213, '6th of October', point(30.9421, 29.9723), 'Hub'),
  (214, 'El-Warraq', point(31.2065, 30.1087), 'Hub'),
  (215, 'Dokki', point(31.2114, 30.0384), 'Hub'),
  (301, 'Benha (Train)', point(31.1865, 30.4607), 'Station'),
  (302, 'Qaha', point(31.2045, 30.2831), 'Hub'),
  (303, 'Toukh', point(31.2005, 30.3546), 'Hub'),
  (304, 'Shibin Al Qanater', point(31.3145, 30.3134), 'Hub'),
  (305, 'Kafr Shukr', point(31.2267, 30.5489), 'Hub'),
  (306, 'Qalyub', point(31.2056, 30.1834), 'Hub'),
  (307, 'Khanka', point(31.3789, 30.2132), 'Hub'),
  (308, 'Al-Obour', point(31.4789, 30.2089), 'Hub'),
  (309, 'Shubra Al-Khaimah', point(31.2467, 30.1256), 'Hub'),
  (310, 'Qanater Al-Khayria', point(31.1367, 30.1912), 'Hub'),
  (321, 'Shibin El-Kom', point(31.0124, 30.5512), 'Hub'),
  (322, 'Ashmoun', point(30.9845, 30.2987), 'Hub'),
  (323, 'Menouf', point(30.9321, 30.4654), 'Hub'),
  (324, 'Sars El-Lyan', point(30.9654, 30.4489), 'Hub'),
  (325, 'Quweisna', point(31.1423, 30.5654), 'Hub'),
  (326, 'El-Bagour', point(31.0345, 30.4354), 'Hub'),
  (331, 'Tanta (Train)', point(31.0004, 30.7865), 'Station'),
  (332, 'Mahalla', point(31.1654, 30.9689), 'Hub'),
  (333, 'Kafr El-Zayat', point(30.8143, 30.8234), 'Hub'),
  (341, 'Mansoura', point(31.3785, 31.0409), 'Hub'),
  (342, 'Mit Ghamr', point(31.2589, 30.7189), 'Hub'),
  (343, 'Aga', point(31.3145, 30.8876), 'Hub'),
  (344, 'Talkha', point(31.3845, 31.0543), 'Hub'),
  (351, 'Kafr El Sheikh City', point(30.9389, 31.1107), 'Hub'),
  (352, 'Sidi Salem', point(30.8034, 31.2721), 'Hub'),
  (401, 'Alexandria (Train)', point(29.9187, 31.2001), 'Station'),
  (402, 'Zagazig', point(31.5012, 30.5876), 'Hub'),
  (403, 'Damanhour', point(30.4689, 31.0365), 'Hub'),
  (404, 'Damietta City', point(31.8167, 31.4167), 'Hub'),
  (405, 'Port Said City', point(32.2922, 31.2567), 'Hub'),
  (406, 'Ismailia City', point(32.2742, 30.6044), 'Hub'),
  (407, 'Suez City', point(32.5367, 29.9744), 'Hub'),
  (408, 'Fayoum City', point(30.8411, 29.3078), 'Hub'),
  (409, 'Beni Suef City', point(31.0978, 29.0744), 'Hub'),
  (410, 'Minya City', point(30.7519, 28.0871), 'Hub'),
  (411, 'Asyut City', point(31.1837, 27.181), 'Hub'),
  (412, 'Sohag City', point(31.6948, 26.557), 'Hub'),
  (413, 'Qena City', point(32.716, 26.1551), 'Hub'),
  (414, 'Luxor City', point(32.6396, 25.6872), 'Hub'),
  (415, 'Aswan City', point(32.8998, 24.0889), 'Hub'),
  (416, 'Hurghada', point(33.8116, 27.2579), 'Hub'),
  (417, 'Kharga', point(30.5471, 25.4514), 'Hub'),
  (418, 'Marsa Matrouh', point(27.2361, 31.3522), 'Hub'),
  (419, 'Arish', point(33.8032, 31.1321), 'Hub'),
  (420, 'Tor', point(33.6123, 28.2345), 'Hub'),
  (101, 'Benha Main Bus Terminal', point(31.192, 30.4678), 'Hub'),
  (102, 'Benha Train Station (Train)', point(31.1865, 30.4607), 'Station'),
  (103, 'Faculty of Engineering', point(31.1812, 30.4623), 'University'),
  (104, 'Faculty of Medicine', point(31.1852, 30.4655), 'University'),
  (105, 'Faculty of Science', point(31.1795, 30.4598), 'University'),
  (106, 'Faculty of Commerce', point(31.1802, 30.4611), 'University'),
  (107, 'Faculty of Arts', point(31.1805, 30.4615), 'University'),
  (108, 'Faculty of Agriculture', point(31.22, 30.42), 'University'),
  (109, 'Faculty of Education', point(31.182, 30.463), 'University'),
  (110, 'Faculty of Applied Arts', point(31.181, 30.458), 'University'),
  (111, 'Faculty of Nursing', point(31.185, 30.4658), 'University'),
  (112, 'Faculty of Computers and AI', point(31.179, 30.459), 'University'),
  (113, 'Benha University Hospital', point(31.1855, 30.466), 'Hospital'),
  (114, 'Al-Ahram Street', point(31.1824, 30.4589), 'Hub'),
  (115, 'Kafr El-Gazzar', point(31.1812, 30.4702), 'Hub'),
  (311, 'Shiblanga (Train)', point(31.2728, 30.4967), 'Station'),
  (327, 'Birket El-Sab (Train)', point(31.0824, 30.6291), 'Station'),
  (334, 'Samanoud (Train)', point(31.2425, 30.9622), 'Station'),
  (345, 'Sherbin (Train)', point(31.5272, 31.1928), 'Station'),
  (361, 'Minya El-Qamh (Train)', point(31.3465, 30.5119), 'Station'),
  (362, 'Abu Hammad (Train)', point(31.6797, 30.5444), 'Station'),
  (371, 'Itay El-Baroud (Train)', point(30.6650, 30.8870), 'Station'),
  (372, 'Kafr El-Dawar (Train)', point(30.1294, 31.1342), 'Station'),
  (373, 'Abu Hummus (Train)', point(30.3094, 31.0022), 'Station'),
  (381, 'El-Tell El-Kebir (Train)', point(31.9161, 30.5606), 'Station'),
  (382, 'El-Kassasin (Train)', point(32.0256, 30.5636), 'Station'),
  (383, 'Qantara West (Train)', point(32.3061, 30.7761), 'Station'),
  
  -- Metro, Monorail and LRT Stations
  -- Metro Line 1 Stations
  (601, 'Helwan (Metro)', point(31.2987, 29.8402), 'Station'),
  (602, 'Ain Helwan (Metro)', point(31.3050, 29.8530), 'Station'),
  (603, 'Helwan University (Metro)', point(31.3150, 29.8660), 'Station'),
  (604, 'Wadi Hof (Metro)', point(31.3130, 29.8780), 'Station'),
  (605, 'Hadayek Helwan (Metro)', point(31.3050, 29.8950), 'Station'),
  (606, 'El-Maasara (Metro)', point(31.2980, 29.9080), 'Station'),
  (607, 'Tora El-Asmant (Metro)', point(31.2890, 29.9230), 'Station'),
  (608, 'Kozzika (Metro)', point(31.2820, 29.9340), 'Station'),
  (609, 'Tora El-Balad (Metro)', point(31.2750, 29.9460), 'Station'),
  (610, 'Sakanat El-Maadi (Metro)', point(31.2650, 29.9540), 'Station'),
  (611, 'Maadi (Metro)', point(31.2598, 29.9602), 'Station'),
  (612, 'Hadayek El-Maadi (Metro)', point(31.2500, 29.9720), 'Station'),
  (613, 'Dar El-Salam (Metro)', point(31.2420, 29.9860), 'Station'),
  (614, 'El-Zahraa (Metro)', point(31.2350, 29.9990), 'Station'),
  (615, 'Mar Girgis (Metro)', point(31.2300, 30.0060), 'Station'),
  (616, 'El-Malek El-Saleh (Metro)', point(31.2280, 30.0180), 'Station'),
  (617, 'Sayeda Zeinab (Metro)', point(31.2330, 30.0298), 'Station'),
  (618, 'Saad Zaghloul (Metro)', point(31.2370, 30.0360), 'Station'),
  (619, 'Sadat (Metro)', point(31.2357, 30.0444), 'Station'),
  (620, 'Nasser (Metro)', point(31.2403, 30.0535), 'Station'),
  (621, 'Orabi (Metro)', point(31.2430, 30.0570), 'Station'),
  (622, 'Al-Shohadaa (Metro)', point(31.2467, 30.0617), 'Station'),
  (623, 'Ghamra (Metro)', point(31.2680, 30.0700), 'Station'),
  (624, 'El-Demerdash (Metro)', point(31.2770, 30.0780), 'Station'),
  (625, 'Manshiet El-Sadr (Metro)', point(31.2840, 30.0830), 'Station'),
  (626, 'Kobri El-Qobba (Metro)', point(31.2890, 30.0870), 'Station'),
  (627, 'Hammamat El-Qobba (Metro)', point(31.2930, 30.0910), 'Station'),
  (628, 'Saray El-Qobba (Metro)', point(31.3020, 30.0980), 'Station'),
  (629, 'Hadayek El-Zaitoun (Metro)', point(31.3110, 30.1060), 'Station'),
  (630, 'Helmiet El-Zaitoun (Metro)', point(31.3200, 30.1150), 'Station'),
  (631, 'El-Matareya (Metro)', point(31.3250, 30.1250), 'Station'),
  (632, 'Ain Shams (Metro)', point(31.3290, 30.1330), 'Station'),
  (633, 'Ezbet El-Nakhl (Metro)', point(31.3320, 30.1440), 'Station'),
  (634, 'El-Marg (Metro)', point(31.3364, 30.1518), 'Station'),
  (635, 'El-Marg El-Jedida (Metro)', point(31.3400, 30.1600), 'Station'),

  -- Metro Line 2 Stations
  (701, 'El-Mounib (Metro)', point(31.2090, 29.9810), 'Station'),
  (702, 'Sakiat Mekky (Metro)', point(31.2080, 29.9950), 'Station'),
  (703, 'Omm El-Misryeen (Metro)', point(31.2060, 30.0070), 'Station'),
  (704, 'Giza (Metro)', point(31.2002, 30.0104), 'Station'),
  (705, 'Faisal (Metro)', point(31.1990, 30.0170), 'Station'),
  (706, 'Cairo University (Metro)', point(31.2010, 30.0260), 'Station'),
  (707, 'El-Bohouth (Metro)', point(31.2003, 30.0358), 'Station'),
  (708, 'Dokki (Metro)', point(31.2114, 30.0384), 'Station'),
  (709, 'Opera (Metro)', point(31.2267, 30.0425), 'Station'),
  (711, 'Mohamed Naguib (Metro)', point(31.2435, 30.0441), 'Station'),
  (712, 'Attaba (Metro)', point(31.2472, 30.0526), 'Station'),
  (714, 'Massarra (Metro)', point(31.2450, 30.0769), 'Station'),
  (715, 'Rod El-Farag (Metro)', point(31.2458, 30.0864), 'Station'),
  (716, 'St. Teresa (Metro)', point(31.2460, 30.0930), 'Station'),
  (717, 'El-Khalafawy (Metro)', point(31.2470, 30.0990), 'Station'),
  (718, 'El-Mazallat (Metro)', point(31.2492, 30.1042), 'Station'),
  (719, 'Faculty of Agriculture (Metro)', point(31.2520, 30.1150), 'Station'),
  (720, 'Shubra El-Kheima (Metro)', point(31.2467, 30.1256), 'Station'),

  -- Metro Line 3 Stations
  (801, 'Nadi El-Shams (Metro)', point(31.3450, 30.1150), 'Station'),
  (802, 'Abassia (Metro)', point(31.2820, 30.0650), 'Station'),
  (803, 'Kit Kat (Metro)', point(31.2110, 30.0720), 'Station'),
  (804, 'Rod El-Farag Axis (Metro)', point(31.1850, 30.0910), 'Station'),
  (805, 'League of Arab States (Metro)', point(31.2005, 30.0435), 'Station'),
  (806, 'Boulaq El-Dakrour (Metro)', point(31.1911, 30.0333), 'Station'),

  -- LRT & Monorail Stations
  (901, 'El-Shorouk (LRT)', point(31.6320, 30.1410), 'Station'),
  (902, 'Badr City (LRT)', point(31.7350, 30.1380), 'Station'),
  (903, '10th of October (LRT)', point(31.7450, 30.3010), 'Station'),
  (904, 'Arts & Culture City (LRT)', point(31.6980, 30.0120), 'Station'),
  (1001, 'El-Estad (Monorail)', point(31.3250, 30.0690), 'Station'),
  (1002, 'Fifth Settlement (Monorail)', point(31.4210, 30.0050), 'Station'),
  (1003, 'AUC (Monorail)', point(31.5030, 30.0210), 'Station'),
  (1004, 'Governmental District (Monorail)', point(31.6850, 29.9880), 'Station'),
  (1101, 'Wadi El-Nile (Monorail)', point(31.2000, 30.0540), 'Station'),
  (1102, 'Hyper One (Monorail)', point(30.9850, 30.0150), 'Station'),
  (1103, 'El-Hosary (Monorail)', point(30.9450, 29.9720), 'Station'),
  (1104, 'Bashtiel Train Station (Train)', point(31.1980, 30.0820), 'Station')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  coordinates = EXCLUDED.coordinates,
  type = EXCLUDED.type;

-- 2. Truncate microbuses to avoid duplicates on re-run, then Seed Microbuses
TRUNCATE TABLE public.microbuses RESTART IDENTITY;

INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والمنوفية', 11, 'قويسنا - بنها', 11.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والمنوفية', 12, 'ميت بره - بنها', 11.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والمنوفية', 13, 'شبين الكوم - بنها', 19.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والمنوفية', 14, 'الالباجور (إقليمي) - بنها', 16.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والمنوفية', 15, 'الباجور (زراعي) - بنها', 14.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والمنوفية', 16, 'مشيرف - بنها', 8.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والمنوفية', 17, 'مدينة السادات - بنها', 65.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والجيزة', 6, 'أكتوبر - بنها', 60.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والجيزة', 8, 'الهرم (المنصورية) - بنها', 58.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والجيزة', 26, 'أحمد عرابي - بنها', 21.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والدقهلية', 1, 'ميت غمر - بنها', 17.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والدقهلية', 6, 'المنصورة - بنها', 48.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والقاهرة', 19, 'السلام - بنها', 30.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والقاهرة', 22, 'مدينة بدر - بنها', 41.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والقاهرة', 23, 'أحمد حلمي - مجمع مواقف بنها', 26.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('شبين القناطر', 1, 'شبين القناطر - بنها', 15.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القليوبية والإسكندرية', 1, 'الإسكندرية - مجمع مواقف بنها', 126.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('طوخ', 2, 'طوخ - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 3, 'دجوى - بنها', 7.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 4, 'طحلة - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 6, 'بطا - بنها', 5.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 8, 'ميت عاصم - بنها', 6.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 9, 'بتمدّه - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 11, 'سندنهور - بنها', 5.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 12, 'شبلنجة - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 14, 'كفر مويس - بنها', 6.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 15, 'العمار - بنها', 9.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 16, 'أمياى - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 17, 'بلتان - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 18, 'برشوم - بنها', 9.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 19, 'العبادلة - بنها', 7.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 20, 'فرسيس - كفر - بنها', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 21, 'كفر الجزار - ميت الحوفيين', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 22, 'كفر الجزار - بقيرة', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 23, 'كفر الجزار - دملو', 6.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 24, 'كفر الجزار - ورورة', 6.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 25, 'ميت العطار - بنها', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 26, 'ميت راضى - بنها', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 27, 'نقباس - بنها', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 28, 'الشموت - بنها', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 29, 'ميت كنانة - بنها', 9.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 30, 'جزيرة بلى - عرابى - بنها', 9.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 31, 'مرصفا - بنها', 7.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 32, 'طنط الجزيرة - بنها', 9.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 33, 'كفر الحصة - بنها', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 34, 'السفاينة - بنها', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 36, 'جمجرة - بنها', 5.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 37, 'الصفا - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 38, 'الرملة - بنها', 5.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 41, 'الشقير - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 42, 'برقطا - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 43, 'مجول - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 49, 'داخلي سوزوكي - بنها', 5.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 50, 'العبور (الشباب) - بنها', 41.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 51, 'العبور (الجامعة) - بنها', 45.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('بنها', 54, 'كفر العرب - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('حي غرب شبرا الخيمة', 1, 'أحمد عرابي مؤسسة - بنها', 21.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('كفر شكر', 1, 'كفر شكر - بنها', 8.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('كفر شكر', 3, 'أسنيت - بنها', 6.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('كفر شكر', 14, 'الشقر - بنها', 7.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('كفر شكر', 15, 'كفر على شرف الدين - بنها', 6.5);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('قها', 2, 'قها - بنها', 9.0);
INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('القناطر الخيرية', 5, 'القناطر - بنها', 12.5);


-- 3. Seed Trains
TRUNCATE TABLE public.trains RESTART IDENTITY;

INSERT INTO public.trains (train_no, type, type_en, origin, origin_en, dest, dest_en, dep_time, arr_benha, price, duration)
VALUES
  ('945', 'تحيا مصر', 'Tahya Misr Fast', 'القاهرة', 'Cairo', 'Benha', 'Benha', '06:10', '06:50', 10.0, 40),
  ('ركاب-قليوب', 'ركاب مطور', 'Improved Passenger', 'قليوب', 'Qalyub', 'Benha', 'Benha', '06:00', '06:40', 8.0, 40),
  ('ركاب-قها', 'ركاب مطور', 'Improved Passenger', 'قها', 'Qaha', 'Benha', 'Benha', '06:15', '06:45', 9.0, 30),
  ('ركاب-طوخ', 'ركاب مطور', 'Improved Passenger', 'طوخ', 'Toukh', 'Benha', 'Benha', '06:30', '06:50', 9.0, 20),
  ('ركاب-شبلنجة', 'ركاب مطور', 'Improved Passenger', 'شبلنجة', 'Shiblanga', 'Benha', 'Benha', '06:45', '07:00', 10.0, 15),
  ('ركاب-شبين', 'ركاب مطور', 'Improved Passenger', 'شبين الكوم', 'Shibin El-Kom', 'Benha', 'Benha', '07:00', '07:50', 5.0, 50),
  ('ركاب-منوف', 'ركاب مطور', 'Improved Passenger', 'منوف', 'Menouf', 'Benha', 'Benha', '06:30', '07:30', 5.0, 60),
  ('ركاب-الباجور', 'ركاب مطور', 'Improved Passenger', 'الباجور', 'El-Bagour', 'Benha', 'Benha', '06:40', '07:30', 5.0, 50),
  ('ركاب-سرس', 'ركاب مطور', 'Improved Passenger', 'سرس الليان', 'Sars El-Lyan', 'Benha', 'Benha', '06:50', '07:45', 5.0, 55),
  ('902-بركة', 'مكيف درجة ثانية', 'Spanish AC 2nd Class', 'بركة السبع', 'Birket El-Sab', 'Benha', 'Benha', '07:20', '07:45', 20.0, 25),
  ('902-قويسنا', 'مكيف درجة ثانية', 'Spanish AC 2nd Class', 'قويسنا', 'Quweisna', 'Benha', 'Benha', '07:30', '07:50', 15.0, 20),
  ('944-زقازيق', 'تحيا مصر', 'Tahya Misr Fast', 'الزقازيق', 'Zagazig', 'Benha', 'Benha', '05:50', '06:40', 17.0, 50),
  ('944-منية', 'تحيا مصر', 'Tahya Misr Fast', 'منية القمح', 'Minya El-Qamh', 'Benha', 'Benha', '06:30', '07:00', 10.0, 30),
  ('944-أبوحماد', 'تحيا مصر', 'Tahya Misr Fast', 'أبو حماد', 'Abu Hammad', 'Benha', 'Benha', '05:30', '06:40', 15.0, 70),
  ('966-منصورة', 'تحيا مصر', 'Tahya Misr Fast', 'المنصورة', 'Mansoura', 'Benha', 'Benha', '06:00', '06:45', 18.0, 45),
  ('ركاب-ميتغمر', 'ركاب مطور', 'Improved Passenger', 'ميت غمر', 'Mit Ghamr', 'Benha', 'Benha', '06:30', '07:15', 5.0, 45),
  ('966-شربين', 'تحيا مصر', 'Tahya Misr Fast', 'شربين', 'Sherbin', 'Benha', 'Benha', '05:00', '06:45', 18.0, 105),
  ('902-طنطا', 'تحيا مصر', 'Tahya Misr Fast', 'طنطا', 'Tanta', 'Benha', 'Benha', '06:00', '06:45', 17.0, 45),
  ('902-محلة', 'تحيا مصر', 'Tahya Misr Fast', 'Mahalla', 'Mahalla', 'Benha', 'Benha', '05:15', '06:45', 17.0, 90),
  ('902-سمنود', 'تحيا مصر', 'Tahya Misr Fast', 'سمنود', 'Samanoud', 'Benha', 'Benha', '05:30', '06:45', 17.0, 75),
  ('902-دمنهور', 'تحيا مصر', 'Tahya Misr Fast', 'دمنهور', 'Damanhour', 'Benha', 'Benha', '05:00', '06:30', 30.0, 90),
  ('902-إيتاي', 'تحيا مصر', 'Tahya Misr Fast', 'إيتاي البارود', 'Itay El-Baroud', 'Benha', 'Benha', '05:20', '06:30', 30.0, 70),
  ('902-أبوحمص', 'تحيا مصر', 'Tahya Misr Fast', 'أبو حمص', 'Abu Hummus', 'Benha', 'Benha', '04:40', '06:30', 30.0, 110),
  ('902-كفرالدوار', 'تحيا مصر', 'Tahya Misr Fast', 'كفر الدوار', 'Kafr El-Dawar', 'Benha', 'Benha', '04:20', '06:30', 30.0, 130),
  ('900', 'تحيا مصر', 'Tahya Misr Fast', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '06:00', '08:10', 35.0, 130),
  ('902-دمياط', 'تحيا مصر', 'Tahya Misr Fast', 'Damietta City', 'Damietta City', 'Benha', 'Benha', '06:00', '08:30', 25.0, 150),
  ('945', 'تحيا مصر', 'Tahya Misr Fast', 'Port Said City', 'Port Said City', 'Benha', 'Benha', '06:10', '08:50', 34.0, 160),
  ('945-إسماعيلية', 'تحيا مصر', 'Tahya Misr Fast', 'Ismailia City', 'Ismailia City', 'Benha', 'Benha', '06:40', '08:50', 20.0, 130),
  ('945-التل', 'تحيا مصر', 'Tahya Misr Fast', 'El-Tell El-Kebir', 'El-Tell El-Kebir', 'Benha', 'Benha', '07:20', '08:50', 20.0, 90),
  ('945-القصاصين', 'تحيا مصر', 'Tahya Misr Fast', 'El-Kassasin', 'El-Kassasin', 'Benha', 'Benha', '07:05', '08:50', 20.0, 105),
  ('945-القنطرة', 'تحيا مصر', 'Tahya Misr Fast', 'Qantara West', 'Qantara West', 'Benha', 'Benha', '06:15', '08:50', 20.0, 155),
  ('ركاب-سويس', 'تحيا مصر', 'Tahya Misr Fast', 'Suez City', 'Suez City', 'Benha', 'Benha', '06:00', '09:00', 15.0, 180),
  ('88-سويف', 'ثالثة تهوية', '3rd Ventilated', 'Beni Suef City', 'Beni Suef City', 'Benha', 'Benha', '07:00', '09:30', 30.0, 150),
  ('196-فيوم', 'تحيا مصر', 'Tahya Misr Fast', 'Fayoum City', 'Fayoum City', 'Benha', 'Benha', '06:00', '09:00', 15.0, 180),
  ('88-منيا', 'ثالثة تهوية', '3rd Ventilated', 'Minya City', 'Minya City', 'Benha', 'Benha', '05:00', '09:30', 45.0, 270),
  ('88-أسيوط', 'ثالثة تهوية', '3rd Ventilated', 'Asyut City', 'Asyut City', 'Benha', 'Benha', '03:00', '09:30', 60.0, 390),
  ('88-سوهاج', 'ثالثة تهوية', '3rd Ventilated', 'Sohag City', 'Sohag City', 'Benha', 'Benha', '01:30', '09:30', 65.0, 480),
  ('88-قنا', 'ثالثة تهوية', '3rd Ventilated', 'Qena City', 'Qena City', 'Benha', 'Benha', '00:00', '09:30', 75.0, 570),
  ('88-الأقصر', 'ثالثة تهوية', '3rd Ventilated', 'Luxor City', 'Luxor City', 'Benha', 'Benha', '23:00', '09:30', 80.0, 630),
  ('88-أسوان', 'ثالثة تهوية', '3rd Ventilated', 'Aswan City', 'Aswan City', 'Benha', 'Benha', '21:00', '09:30', 100.0, 750),
  ('902-مطروح', 'ثالثة تهوية', '3rd Ventilated', 'Marsa Matrouh', 'Marsa Matrouh', 'Benha', 'Benha', '06:00', '14:10', 75.0, 490)
ON CONFLICT (train_no, origin) DO UPDATE SET
  type = EXCLUDED.type,
  type_en = EXCLUDED.type_en,
  dest = EXCLUDED.dest,
  dest_en = EXCLUDED.dest_en,
  dep_time = EXCLUDED.dep_time,
  arr_benha = EXCLUDED.arr_benha,
  price = EXCLUDED.price,
  duration = EXCLUDED.duration;
