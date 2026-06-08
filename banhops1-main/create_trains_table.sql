-- 1. Create the trains table
CREATE TABLE IF NOT EXISTS public.trains (
    id SERIAL PRIMARY KEY,
    train_no VARCHAR(50) NOT NULL,
    type VARCHAR(100) NOT NULL,
    type_en VARCHAR(100) NOT NULL,
    origin VARCHAR(100) NOT NULL,
    origin_en VARCHAR(100) NOT NULL,
    dest VARCHAR(100) NOT NULL,
    dest_en VARCHAR(100) NOT NULL,
    dep_time VARCHAR(20) NOT NULL,
    arr_benha VARCHAR(20) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    duration INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT trains_train_no_origin_unique UNIQUE (train_no, origin)
);

-- 2. Enable Row Level Security (RLS) and allow public read access
ALTER TABLE public.trains ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read access to trains" ON public.trains FOR SELECT USING (true);

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
  ('902-مطروح', 'ثالثة تهوية', '3rd Ventilated', 'Marsa Matrouh', 'Marsa Matrouh', 'Benha', 'Benha', '06:00', '14:10', 75.0, 490);
ON CONFLICT (train_no, origin) DO UPDATE SET
  type = EXCLUDED.type,
  type_en = EXCLUDED.type_en,
  dest = EXCLUDED.dest,
  dest_en = EXCLUDED.dest_en,
  dep_time = EXCLUDED.dep_time,
  arr_benha = EXCLUDED.arr_benha,
  price = EXCLUDED.price,
  duration = EXCLUDED.duration;