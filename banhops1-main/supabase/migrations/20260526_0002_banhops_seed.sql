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
  (301, 'Benha', point(31.1865, 30.4607), 'Station'),
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
  (331, 'Tanta', point(31.0004, 30.7865), 'Station'),
  (332, 'Mahalla', point(31.1654, 30.9689), 'Hub'),
  (333, 'Kafr El-Zayat', point(30.8143, 30.8234), 'Hub'),
  (341, 'Mansoura', point(31.3785, 31.0409), 'Hub'),
  (342, 'Mit Ghamr', point(31.2589, 30.7189), 'Hub'),
  (343, 'Aga', point(31.3145, 30.8876), 'Hub'),
  (344, 'Talkha', point(31.3845, 31.0543), 'Hub'),
  (351, 'Kafr El Sheikh City', point(30.9389, 31.1107), 'Hub'),
  (352, 'Sidi Salem', point(30.8034, 31.2721), 'Hub'),
  (401, 'Alexandria City', point(29.9187, 31.2001), 'Station'),
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
  (102, 'Benha Train Station', point(31.1865, 30.4607), 'Station'),
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
  (311, 'Shiblanga', point(31.2728, 30.4967), 'Station'),
  (327, 'Birket El-Sab', point(31.0824, 30.6291), 'Station'),
  (334, 'Samanoud', point(31.2425, 30.9622), 'Station'),
  (345, 'Sherbin', point(31.5272, 31.1928), 'Station'),
  (361, 'Minya El-Qamh', point(31.3465, 30.5119), 'Station'),
  (362, 'Abu Hammad', point(31.6797, 30.5444), 'Station'),
  (371, 'Itay El-Baroud', point(30.6650, 30.8870), 'Station'),
  (372, 'Kafr El-Dawar', point(30.1294, 31.1342), 'Station'),
  (373, 'Abu Hummus', point(30.3094, 31.0022), 'Station'),
  (381, 'El-Tell El-Kebir', point(31.9161, 30.5606), 'Station'),
  (382, 'El-Kassasin', point(32.0256, 30.5636), 'Station'),
  (383, 'Qantara West', point(32.3061, 30.7761), 'Station')
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
  ('965', 'ثالثة تهوية', '3rd Ventilated', 'القاهرة', 'Cairo', 'Benha', 'Benha', '07:30', '08:15', 20.0, 45),
  ('901', 'ثالثة مكيفة', '3rd AC Russian', 'القاهرة', 'Cairo', 'Benha', 'Benha', '08:15', '08:50', 25.0, 35),
  ('911', 'مكيف درجة ثانية', 'Spanish AC 2nd Class', 'القاهرة', 'Cairo', 'Benha', 'Benha', '10:00', '10:35', 35.0, 35),
  ('2025', 'مكيف درجة أولى', 'Talgo AC 1st Class', 'القاهرة', 'Cairo', 'Benha', 'Benha', '08:00', '08:30', 45.0, 30),
  ('ركاب-قليوب', 'ركاب مطور', 'Improved Passenger', 'قليوب', 'Qalyub', 'Benha', 'Benha', '06:00', '06:40', 8.0, 40),
  ('ركاب-قها', 'ركاب مطور', 'Improved Passenger', 'قها', 'Qaha', 'Benha', 'Benha', '06:15', '06:45', 9.0, 30),
  ('ركاب-طوخ', 'ركاب مطور', 'Improved Passenger', 'طوخ', 'Toukh', 'Benha', 'Benha', '06:30', '06:50', 9.0, 20),
  ('ركاب-شبلنجة', 'ركاب مطور', 'Improved Passenger', 'شبلنجة', 'Shiblanga', 'Benha', 'Benha', '06:45', '07:00', 10.0, 15),
  ('ركاب-شبين', 'ركاب مطور', 'Improved Passenger', 'شبين الكوم', 'Shibin El-Kom', 'Benha', 'Benha', '07:00', '07:50', 5.0, 50),
  ('ركاب-منوف', 'ركاب مطور', 'Improved Passenger', 'منوف', 'Menouf', 'Benha', 'Benha', '06:30', '07:30', 5.0, 60),
  ('ركاب-الباجور', 'ركاب مطور', 'Improved Passenger', 'الباجور', 'El-Bagour', 'Benha', 'Benha', '06:40', '07:30', 5.0, 50),
  ('ركاب-سرس', 'ركاب مطور', 'Improved Passenger', 'سرس الليان', 'Sars El-Lyan', 'Benha', 'Benha', '06:50', '07:45', 5.0, 55),
  ('902-بركة', 'مكيف درجة ثانية', 'Spanish AC 2nd Class', 'بركة السبع', 'Birket El-Sab', 'Benha', 'Benha', '07:20', '07:45', 20.0, 25),
  ('912-بركة', 'مكيف درجة أولى', 'French AC 1st Class', 'بركة السبع', 'Birket El-Sab', 'Benha', 'Benha', '11:50', '12:15', 20.0, 25),
  ('902-قويسنا', 'مكيف درجة ثانية', 'Spanish AC 2nd Class', 'قويسنا', 'Quweisna', 'Benha', 'Benha', '07:30', '07:50', 15.0, 20),
  ('912-قويسنا', 'مكيف درجة أولى', 'French AC 1st Class', 'قويسنا', 'Quweisna', 'Benha', 'Benha', '12:00', '12:20', 15.0, 20),
  ('944-زقازيق', 'تحيا مصر', 'Tahya Misr Fast', 'الزقازيق', 'Zagazig', 'Benha', 'Benha', '05:50', '06:40', 17.0, 50),
  ('946-زقازيق', 'روسي درجة ثانية', 'Russian 2nd Class', 'الزقازيق', 'Zagazig', 'Benha', 'Benha', '16:50', '17:40', 15.0, 50),
  ('948-زقازيق', 'روسي درجة أولى', 'Russian 1st Class', 'الزقازيق', 'Zagazig', 'Benha', 'Benha', '08:00', '08:50', 20.0, 50),
  ('950-زقازيق', 'درجة ثانية مكيفة', 'Spanish AC 2nd Class', 'الزقازيق', 'Zagazig', 'Benha', 'Benha', '10:10', '11:00', 60.0, 50),
  ('944-منية', 'تحيا مصر', 'Tahya Misr Fast', 'منية القمح', 'Minya El-Qamh', 'Benha', 'Benha', '06:30', '07:00', 10.0, 30),
  ('946-منية', 'روسي درجة ثانية', 'Russian 2nd Class', 'منية القمح', 'Minya El-Qamh', 'Benha', 'Benha', '17:30', '18:00', 15.0, 30),
  ('950-منية', 'درجة ثانية مكيفة', 'Spanish AC 2nd Class', 'منية القمح', 'Minya El-Qamh', 'Benha', 'Benha', '10:30', '11:00', 60.0, 30),
  ('944-أبوحماد', 'تحيا مصر', 'Tahya Misr Fast', 'أبو حماد', 'Abu Hammad', 'Benha', 'Benha', '05:30', '06:40', 15.0, 70),
  ('946-أبوحماد', 'روسي درجة ثانية', 'Russian 2nd Class', 'أبو حماد', 'Abu Hammad', 'Benha', 'Benha', '16:30', '17:40', 15.0, 70),
  ('950-أبوحماد', 'درجة ثانية مكيفة', 'Spanish AC 2nd Class', 'أبو حماد', 'Abu Hammad', 'Benha', 'Benha', '09:50', '11:00', 60.0, 70),
  ('966-منصورة', 'تحيا مصر', 'Tahya Misr Fast', 'المنصورة', 'Mansoura', 'Benha', 'Benha', '06:00', '06:45', 18.0, 45),
  ('968-منصورة', 'ثالثة تهوية', '3rd Ventilated', 'المنصورة', 'Mansoura', 'Benha', 'Benha', '07:30', '08:15', 30.0, 45),
  ('970-منصورة', 'درجة ثانية مكيفة', 'Spanish AC 2nd Class', 'المنصورة', 'Mansoura', 'Benha', 'Benha', '09:00', '09:45', 45.0, 45),
  ('972-منصورة', 'درجة أولى مكيفة', 'Spanish AC 1st Class', 'المنصورة', 'Mansoura', 'Benha', 'Benha', '11:00', '11:45', 65.0, 45),
  ('ركاب-ميتغمر', 'ركاب مطور', 'Improved Passenger', 'ميت غمر', 'Mit Ghamr', 'Benha', 'Benha', '06:30', '07:15', 5.0, 45),
  ('966-شربين', 'تحيا مصر', 'Tahya Misr Fast', 'شربين', 'Sherbin', 'Benha', 'Benha', '05:00', '06:45', 18.0, 105),
  ('968-شربين', 'ثالثة تهوية', '3rd Ventilated', 'شربين', 'Sherbin', 'Benha', 'Benha', '06:30', '08:15', 30.0, 105),
  ('970-شربين', 'درجة ثانية مكيفة', 'Spanish AC 2nd Class', 'شربين', 'Sherbin', 'Benha', 'Benha', '08:00', '09:45', 45.0, 105),
  ('972-شربين', 'درجة أولى مكيفة', 'Spanish AC 1st Class', 'شربين', 'Sherbin', 'Benha', 'Benha', '10:00', '11:45', 65.0, 105),
  ('902-طنطا', 'تحيا مصر', 'Tahya Misr Fast', 'طنطا', 'Tanta', 'Benha', 'Benha', '06:00', '06:45', 17.0, 45),
  ('912-طنطا', 'ثالثة تهوية', '3rd Ventilated', 'طنطا', 'Tanta', 'Benha', 'Benha', '07:00', '07:45', 30.0, 45),
  ('914-طنطا', 'ثالثة مكيفة', '3rd AC Russian', 'طنطا', 'Tanta', 'Benha', 'Benha', '08:00', '08:45', 35.0, 45),
  ('916-طنطا', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'طنطا', 'Tanta', 'Benha', 'Benha', '09:00', '09:45', 45.0, 45),
  ('918-طنطا', 'أولى مكيفة', 'Spanish AC 1st Class', 'طنطا', 'Tanta', 'Benha', 'Benha', '10:00', '10:45', 60.0, 45),
  ('920-طنطا', 'ثانية VIP', 'VIP 2nd Class', 'طنطا', 'Tanta', 'Benha', 'Benha', '11:00', '11:45', 80.0, 45),
  ('922-طنطا', 'أولى VIP', 'VIP 1st Class', 'طنطا', 'Tanta', 'Benha', 'Benha', '12:00', '12:45', 90.0, 45),
  ('902-محلة', 'تحيا مصر', 'Tahya Misr Fast', 'Mahalla', 'Mahalla', 'Benha', 'Benha', '05:15', '06:45', 17.0, 90),
  ('912-محلة', 'ثالثة تهوية', '3rd Ventilated', 'Mahalla', 'Mahalla', 'Benha', 'Benha', '06:15', '07:45', 30.0, 90),
  ('916-محلة', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Mahalla', 'Mahalla', 'Benha', 'Benha', '08:15', '09:45', 45.0, 90),
  ('902-سمنود', 'تحيا مصر', 'Tahya Misr Fast', 'سمنود', 'Samanoud', 'Benha', 'Benha', '05:30', '06:45', 17.0, 75),
  ('912-سمنود', 'ثالثة تهوية', '3rd Ventilated', 'سمنود', 'Samanoud', 'Benha', 'Benha', '06:30', '07:45', 30.0, 75),
  ('902-دمنهور', 'تحيا مصر', 'Tahya Misr Fast', 'دمنهور', 'Damanhour', 'Benha', 'Benha', '05:00', '06:30', 30.0, 90),
  ('912-دمنهور', 'ثالثة تهوية', '3rd Ventilated', 'دمنهور', 'Damanhour', 'Benha', 'Benha', '06:00', '07:30', 45.0, 90),
  ('914-دمنهور', 'ثالثة مكيفة', '3rd AC Russian', 'دمنهور', 'Damanhour', 'Benha', 'Benha', '07:00', '08:30', 45.0, 90),
  ('916-دمنهور', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'دمنهور', 'Damanhour', 'Benha', 'Benha', '08:00', '09:30', 55.0, 90),
  ('918-دمنهور', 'أولى مكيفة', 'Spanish AC 1st Class', 'دمنهور', 'Damanhour', 'Benha', 'Benha', '09:00', '10:30', 70.0, 90),
  ('902-إيتاي', 'تحيا مصر', 'Tahya Misr Fast', 'إيتاي البارود', 'Itay El-Baroud', 'Benha', 'Benha', '05:20', '06:30', 30.0, 70),
  ('916-إيتاي', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'إيتاي البارود', 'Itay El-Baroud', 'Benha', 'Benha', '08:20', '09:30', 55.0, 70),
  ('902-أبوحمص', 'تحيا مصر', 'Tahya Misr Fast', 'أبو حمص', 'Abu Hummus', 'Benha', 'Benha', '04:40', '06:30', 30.0, 110),
  ('916-أبوحمص', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'أبو حمص', 'Abu Hummus', 'Benha', 'Benha', '07:40', '09:30', 55.0, 110),
  ('902-كفرالدوار', 'تحيا مصر', 'Tahya Misr Fast', 'كفر الدوار', 'Kafr El-Dawar', 'Benha', 'Benha', '04:20', '06:30', 30.0, 130),
  ('916-كفرالدوار', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'كفر الدوار', 'Kafr El-Dawar', 'Benha', 'Benha', '07:20', '09:30', 55.0, 130),
  ('900', 'تحيا مصر', 'Tahya Misr Fast', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '06:00', '08:10', 35.0, 130),
  ('902', 'ثالثة تهوية', '3rd Ventilated', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '07:00', '09:10', 45.0, 130),
  ('904', 'ثالثة مكيفة', '3rd AC Russian', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '08:00', '10:10', 70.0, 130),
  ('906', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '09:00', '11:10', 75.0, 130),
  ('908', 'أولى مكيفة', 'Spanish AC 1st Class', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '10:00', '12:10', 90.0, 130),
  ('910-Alex', 'تالجو درجة ثانية', 'Talgo AC 2nd Class', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '14:00', '15:50', 150.0, 110),
  ('912-Alex', 'تالجو درجة أولى', 'Talgo AC 1st Class', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '14:00', '15:50', 225.0, 110),
  ('914-Alex', 'ثانية VIP', 'VIP 2nd Class', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '15:00', '17:10', 130.0, 130),
  ('916-Alex', 'أولى VIP', 'VIP 1st Class', 'Alexandria City', 'Alexandria City', 'Benha', 'Benha', '15:00', '17:10', 165.0, 130),
  ('902-دمياط', 'تحيا مصر', 'Tahya Misr Fast', 'Damietta City', 'Damietta City', 'Benha', 'Benha', '06:00', '08:30', 25.0, 150),
  ('912-دمياط', 'ثالثة تهوية', '3rd Ventilated', 'Damietta City', 'Damietta City', 'Benha', 'Benha', '07:00', '09:30', 40.0, 150),
  ('916-دمياط', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Damietta City', 'Damietta City', 'Benha', 'Benha', '08:00', '10:30', 65.0, 150),
  ('945', 'تحيا مصر', 'Tahya Misr Fast', 'Port Said City', 'Port Said City', 'Benha', 'Benha', '06:10', '08:50', 34.0, 160),
  ('947', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Port Said City', 'Port Said City', 'Benha', 'Benha', '08:10', '10:50', 55.0, 160),
  ('949', 'أولى مكيفة', 'Spanish AC 1st Class', 'Port Said City', 'Port Said City', 'Benha', 'Benha', '10:10', '12:50', 85.0, 160),
  ('945-إسماعيلية', 'تحيا مصر', 'Tahya Misr Fast', 'Ismailia City', 'Ismailia City', 'Benha', 'Benha', '06:40', '08:50', 20.0, 130),
  ('947-إسماعيلية', 'ثالثة تهوية', '3rd Ventilated', 'Ismailia City', 'Ismailia City', 'Benha', 'Benha', '07:40', '09:50', 35.0, 130),
  ('945-التل', 'تحيا مصر', 'Tahya Misr Fast', 'El-Tell El-Kebir', 'El-Tell El-Kebir', 'Benha', 'Benha', '07:20', '08:50', 20.0, 90),
  ('945-القصاصين', 'تحيا مصر', 'Tahya Misr Fast', 'El-Kassasin', 'El-Kassasin', 'Benha', 'Benha', '07:05', '08:50', 20.0, 105),
  ('945-القنطرة', 'تحيا مصر', 'Tahya Misr Fast', 'Qantara West', 'Qantara West', 'Benha', 'Benha', '06:15', '08:50', 20.0, 155),
  ('ركاب-سويس', 'تحيا مصر', 'Tahya Misr Fast', 'Suez City', 'Suez City', 'Benha', 'Benha', '06:00', '09:00', 15.0, 180),
  ('روسي-سويس', 'ثالثة تهوية', '3rd Ventilated', 'Suez City', 'Suez City', 'Benha', 'Benha', '07:00', '10:00', 40.0, 180),
  ('88-سويف', 'ثالثة تهوية', '3rd Ventilated', 'Beni Suef City', 'Beni Suef City', 'Benha', 'Benha', '07:00', '09:30', 30.0, 150),
  ('164-سويف', 'ثالثة مكيفة', '3rd AC Russian', 'Beni Suef City', 'Beni Suef City', 'Benha', 'Benha', '08:00', '10:30', 60.0, 150),
  ('1015-سويف', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Beni Suef City', 'Beni Suef City', 'Benha', 'Benha', '09:00', '11:30', 45.0, 150),
  ('88-سويف-أولى', 'أولى مكيفة', 'Spanish AC 1st Class', 'Beni Suef City', 'Beni Suef City', 'Benha', 'Benha', '07:00', '09:30', 60.0, 150),
  ('VIP-سويف-2', 'ثانية VIP', 'VIP 2nd Class', 'Beni Suef City', 'Beni Suef City', 'Benha', 'Benha', '10:00', '12:30', 75.0, 150),
  ('VIP-سويف-1', 'أولى VIP', 'VIP 1st Class', 'Beni Suef City', 'Beni Suef City', 'Benha', 'Benha', '10:00', '12:30', 100.0, 150),
  ('196-فيوم', 'تحيا مصر', 'Tahya Misr Fast', 'Fayoum City', 'Fayoum City', 'Benha', 'Benha', '06:00', '09:00', 15.0, 180),
  ('196-فيوم-مكيف', 'سياحي درجة ثانية', 'Tourist AC 2nd Class', 'Fayoum City', 'Fayoum City', 'Benha', 'Benha', '06:00', '09:00', 35.0, 180),
  ('88-منيا', 'ثالثة تهوية', '3rd Ventilated', 'Minya City', 'Minya City', 'Benha', 'Benha', '05:00', '09:30', 45.0, 270),
  ('164-منيا', 'ثالثة مكيفة', '3rd AC Russian', 'Minya City', 'Minya City', 'Benha', 'Benha', '06:00', '10:30', 70.0, 270),
  ('1015-منيا', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Minya City', 'Minya City', 'Benha', 'Benha', '07:00', '11:30', 70.0, 270),
  ('88-منيا-أولى', 'أولى مكيفة', 'Spanish AC 1st Class', 'Minya City', 'Minya City', 'Benha', 'Benha', '05:00', '09:30', 90.0, 270),
  ('VIP-منيا-2', 'ثانية VIP', 'VIP 2nd Class', 'Minya City', 'Minya City', 'Benha', 'Benha', '08:00', '12:30', 115.0, 270),
  ('VIP-منيا-1', 'أولى VIP', 'VIP 1st Class', 'Minya City', 'Minya City', 'Benha', 'Benha', '08:00', '12:30', 155.0, 270),
  ('تالجو-منيا-2', 'تالجو درجة ثانية', 'Talgo AC 2nd Class', 'Minya City', 'Minya City', 'Benha', 'Benha', '09:00', '13:00', 250.0, 240),
  ('تالجو-منيا-1', 'تالجو درجة أولى', 'Talgo AC 1st Class', 'Minya City', 'Minya City', 'Benha', 'Benha', '09:00', '13:00', 350.0, 240),
  ('88-أسيوط', 'ثالثة تهوية', '3rd Ventilated', 'Asyut City', 'Asyut City', 'Benha', 'Benha', '03:00', '09:30', 60.0, 390),
  ('164-أسيوط', 'ثالثة مكيفة', '3rd AC Russian', 'Asyut City', 'Asyut City', 'Benha', 'Benha', '04:00', '10:30', 95.0, 390),
  ('1015-أسيوط', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Asyut City', 'Asyut City', 'Benha', 'Benha', '05:00', '11:30', 85.0, 390),
  ('88-أسيوط-أولى', 'أولى مكيفة', 'Spanish AC 1st Class', 'Asyut City', 'Asyut City', 'Benha', 'Benha', '03:00', '09:30', 120.0, 390),
  ('VIP-أسيوط-2', 'ثانية VIP', 'VIP 2nd Class', 'Asyut City', 'Asyut City', 'Benha', 'Benha', '06:00', '12:30', 135.0, 390),
  ('VIP-أسيوط-1', 'أولى VIP', 'VIP 1st Class', 'Asyut City', 'Asyut City', 'Benha', 'Benha', '06:00', '12:30', 180.0, 390),
  ('تالجو-أسيوط-2', 'تالجو درجة ثانية', 'Talgo AC 2nd Class', 'Asyut City', 'Asyut City', 'Benha', 'Benha', '07:00', '13:00', 250.0, 360),
  ('تالجو-أسيوط-1', 'تالجو درجة أولى', 'Talgo AC 1st Class', 'Asyut City', 'Asyut City', 'Benha', 'Benha', '07:00', '13:00', 350.0, 360),
  ('88-سوهاج', 'ثالثة تهوية', '3rd Ventilated', 'Sohag City', 'Sohag City', 'Benha', 'Benha', '01:30', '09:30', 65.0, 480),
  ('164-سوهاج', 'ثالثة مكيفة', '3rd AC Russian', 'Sohag City', 'Sohag City', 'Benha', 'Benha', '02:30', '10:30', 120.0, 480),
  ('1015-سوهاج', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Sohag City', 'Sohag City', 'Benha', 'Benha', '03:30', '11:30', 100.0, 480),
  ('88-سوهاج-أولى', 'أولى مكيفة', 'Spanish AC 1st Class', 'Sohag City', 'Sohag City', 'Benha', 'Benha', '01:30', '09:30', 130.0, 480),
  ('VIP-سوهاج-2', 'ثانية VIP', 'VIP 2nd Class', 'Sohag City', 'Sohag City', 'Benha', 'Benha', '04:30', '12:30', 155.0, 480),
  ('VIP-سوهاج-1', 'أولى VIP', 'VIP 1st Class', 'Sohag City', 'Sohag City', 'Benha', 'Benha', '04:30', '12:30', 220.0, 480),
  ('تالجو-سوهاج-2', 'تالجو درجة ثانية', 'Talgo AC 2nd Class', 'Sohag City', 'Sohag City', 'Benha', 'Benha', '05:30', '13:00', 300.0, 450),
  ('تالجو-سوهاج-1', 'تالجو درجة أولى', 'Talgo AC 1st Class', 'Sohag City', 'Sohag City', 'Benha', 'Benha', '05:30', '13:00', 500.0, 450),
  ('88-قنا', 'ثالثة تهوية', '3rd Ventilated', 'Qena City', 'Qena City', 'Benha', 'Benha', '00:00', '09:30', 75.0, 570),
  ('164-قنا', 'ثالثة مكيفة', '3rd AC Russian', 'Qena City', 'Qena City', 'Benha', 'Benha', '01:00', '10:30', 135.0, 570),
  ('1015-قنا', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Qena City', 'Qena City', 'Benha', 'Benha', '02:00', '11:30', 115.0, 570),
  ('88-قنا-أولى', 'أولى مكيفة', 'Spanish AC 1st Class', 'Qena City', 'Qena City', 'Benha', 'Benha', '00:00', '09:30', 155.0, 570),
  ('VIP-قنا-2', 'ثانية VIP', 'VIP 2nd Class', 'Qena City', 'Qena City', 'Benha', 'Benha', '03:00', '12:30', 175.0, 570),
  ('VIP-قنا-1', 'أولى VIP', 'VIP 1st Class', 'Qena City', 'Qena City', 'Benha', 'Benha', '03:00', '12:30', 265.0, 570),
  ('تالجو-قنا-2', 'تالجو درجة ثانية', 'Talgo AC 2nd Class', 'Qena City', 'Qena City', 'Benha', 'Benha', '04:00', '13:00', 350.0, 540),
  ('تالجو-قنا-1', 'تالجو درجة أولى', 'Talgo AC 1st Class', 'Qena City', 'Qena City', 'Benha', 'Benha', '04:00', '13:00', 550.0, 540),
  ('88-الأقصر', 'ثالثة تهوية', '3rd Ventilated', 'Luxor City', 'Luxor City', 'Benha', 'Benha', '23:00', '09:30', 80.0, 630),
  ('164-الأقصر', 'ثالثة مكيفة', '3rd AC Russian', 'Luxor City', 'Luxor City', 'Benha', 'Benha', '00:00', '10:30', 150.0, 630),
  ('1015-الأقصر', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Luxor City', 'Luxor City', 'Benha', 'Benha', '01:00', '11:30', 120.0, 630),
  ('88-الأقصر-أولى', 'أولى مكيفة', 'Spanish AC 1st Class', 'Luxor City', 'Luxor City', 'Benha', 'Benha', '23:00', '09:30', 165.0, 630),
  ('VIP-الأقصر-2', 'ثانية VIP', 'VIP 2nd Class', 'Luxor City', 'Luxor City', 'Benha', 'Benha', '02:00', '12:30', 190.0, 630),
  ('VIP-الأقصر-1', 'أولى VIP', 'VIP 1st Class', 'Luxor City', 'Luxor City', 'Benha', 'Benha', '02:00', '12:30', 280.0, 630),
  ('تالجو-الأقصر-2', 'تالجو درجة ثانية', 'Talgo AC 2nd Class', 'Luxor City', 'Luxor City', 'Benha', 'Benha', '03:00', '13:00', 400.0, 600),
  ('تالجو-الأقصر-1', 'تالجو درجة أولى', 'Talgo AC 1st Class', 'Luxor City', 'Luxor City', 'Benha', 'Benha', '03:00', '13:00', 600.0, 600),
  ('88-أسوان', 'ثالثة تهوية', '3rd Ventilated', 'Aswan City', 'Aswan City', 'Benha', 'Benha', '21:00', '09:30', 100.0, 750),
  ('164-أسوان', 'ثالثة مكيفة', '3rd AC Russian', 'Aswan City', 'Aswan City', 'Benha', 'Benha', '22:00', '10:30', 170.0, 750),
  ('1015-أسوان', 'ثانية مكيفة', 'Spanish AC 2nd Class', 'Aswan City', 'Aswan City', 'Benha', 'Benha', '23:00', '11:30', 145.0, 750),
  ('88-أسوان-أولى', 'أولى مكيفة', 'Spanish AC 1st Class', 'Aswan City', 'Aswan City', 'Benha', 'Benha', '21:00', '09:30', 200.0, 750),
  ('VIP-أسوان-2', 'ثانية VIP', 'VIP 2nd Class', 'Aswan City', 'Aswan City', 'Benha', 'Benha', '00:00', '12:30', 215.0, 750),
  ('VIP-أسوان-1', 'أولى VIP', 'VIP 1st Class', 'Aswan City', 'Aswan City', 'Benha', 'Benha', '00:00', '12:30', 335.0, 750),
  ('تالجو-أسوان-2', 'تالجو درجة ثانية', 'Talgo AC 2nd Class', 'Aswan City', 'Aswan City', 'Benha', 'Benha', '01:00', '13:00', 550.0, 720),
  ('تالجو-أسوان-1', 'تالجو درجة أولى', 'Talgo AC 1st Class', 'Aswan City', 'Aswan City', 'Benha', 'Benha', '01:00', '13:00', 700.0, 720),
  ('902-مطروح', 'ثالثة تهوية', '3rd Ventilated', 'Marsa Matrouh', 'Marsa Matrouh', 'Benha', 'Benha', '06:00', '14:10', 75.0, 490),
  ('916-مطروح', 'درجة ثانية مكيفة', 'Spanish AC 2nd Class', 'Marsa Matrouh', 'Marsa Matrouh', 'Benha', 'Benha', '07:00', '15:10', 210.0, 490),
  ('918-مطروح', 'درجة أولى مكيفة', 'Spanish AC 1st Class', 'Marsa Matrouh', 'Marsa Matrouh', 'Benha', 'Benha', '07:00', '15:10', 295.0, 490)
ON CONFLICT (train_no, origin) DO UPDATE SET
  type = EXCLUDED.type,
  type_en = EXCLUDED.type_en,
  dest = EXCLUDED.dest,
  dest_en = EXCLUDED.dest_en,
  dep_time = EXCLUDED.dep_time,
  arr_benha = EXCLUDED.arr_benha,
  price = EXCLUDED.price,
  duration = EXCLUDED.duration;
