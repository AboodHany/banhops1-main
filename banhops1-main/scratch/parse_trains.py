import json
from datetime import datetime

json_path = r"c:\xampp\htdocs\Employee_Task_MS\banhops1-main\banhops1-main\benha_trains.json"
sql_path = r"c:\xampp\htdocs\Employee_Task_MS\banhops1-main\banhops1-main\create_trains_table.sql"

with open(json_path, 'r', encoding='utf-8') as f:
    trains = json.load(f)

# Mappings for English values
type_map = {
    'مكيف فرنسي': 'French AC',
    'مكيف إسباني': 'Spanish AC',
    'تالجو فاخر': 'Talgo Luxury',
    'مكيف زراعي': 'Agricultural AC',
    'سريع تحيا مصر': 'Tahya Misr Fast'
}

location_map = {
    'القاهرة': 'Cairo',
    'الإسكندرية': 'Alexandria',
    'بورسعيد': 'Port Said',
    'المنصورة': 'Mansoura',
    'طنطا': 'Tanta',
    'المنيا': 'Minya'
}

def calculate_duration(dep, arr):
    try:
        fmt = "%H:%M"
        t_dep = datetime.strptime(dep, fmt)
        t_arr = datetime.strptime(arr, fmt)
        # Handle overnight trains if any
        if t_arr < t_dep:
            diff = (t_arr - t_dep).seconds
        else:
            diff = (t_arr - t_dep).total_seconds()
        return int(diff / 60)
    except Exception:
        return 35  # default fallback duration

sql_statements = []
sql_statements.append("-- 1. Create the trains table")
sql_statements.append("""CREATE TABLE IF NOT EXISTS public.trains (
    id SERIAL PRIMARY KEY,
    train_no VARCHAR(50) NOT NULL UNIQUE,
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
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);""")
sql_statements.append("")
sql_statements.append("-- 2. Enable Row Level Security (RLS) and allow public read access")
sql_statements.append("ALTER TABLE public.trains ENABLE ROW LEVEL SECURITY;")
sql_statements.append("CREATE POLICY \"Allow public read access to trains\" ON public.trains FOR SELECT USING (true);")
sql_statements.append("")
sql_statements.append("-- 3. Seeding trains table")
sql_statements.append("INSERT INTO public.trains (train_no, type, type_en, origin, origin_en, dest, dest_en, dep_time, arr_benha, price, duration)")
sql_statements.append("VALUES")

values = []
for t in trains:
    train_no = t['train_no']
    tr_type = t['type']
    type_en = type_map.get(tr_type, tr_type)
    origin = t['origin']
    origin_en = location_map.get(origin, origin)
    dest = t['dest']
    dest_en = location_map.get(dest, dest)
    dep_time = t['dep_time']
    arr_benha = t['arr_benha']
    price = float(t['price'])
    duration = calculate_duration(dep_time, arr_benha)
    
    values.append(
        f"  ('{train_no}', '{tr_type}', '{type_en}', '{origin}', '{origin_en}', '{dest}', '{dest_en}', '{dep_time}', '{arr_benha}', {price}, {duration})"
    )

sql_statements.append(",\n".join(values))
sql_statements.append("ON CONFLICT (train_no) DO UPDATE SET")
sql_statements.append("  type = EXCLUDED.type,")
sql_statements.append("  type_en = EXCLUDED.type_en,")
sql_statements.append("  origin = EXCLUDED.origin,")
sql_statements.append("  origin_en = EXCLUDED.origin_en,")
sql_statements.append("  dest = EXCLUDED.dest,")
sql_statements.append("  dest_en = EXCLUDED.dest_en,")
sql_statements.append("  dep_time = EXCLUDED.dep_time,")
sql_statements.append("  arr_benha = EXCLUDED.arr_benha,")
sql_statements.append("  price = EXCLUDED.price,")
sql_statements.append("  duration = EXCLUDED.duration;")

with open(sql_path, 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_statements))

print(f"Generated create_trains_table.sql successfully with {len(values)} trains!")
