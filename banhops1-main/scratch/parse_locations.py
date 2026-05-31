import re
import os

dart_path = r"c:\xampp\htdocs\Employee_Task_MS\banhops1-main\banhops1-main\lib\core\data\demo_transit_catalog.dart"
sql_path = r"c:\xampp\htdocs\Employee_Task_MS\banhops1-main\banhops1-main\insert_locations.sql"

# Regex to match LocationNode constructor calls
# Example: LocationNode(id: 201, name: 'Ahmed Helmy', latitude: 30.0631, longitude: 31.2467, type: TransitLocationType.hub, alias: 'Ramses Area', governorate: 'Cairo')
pattern = re.compile(
    r"LocationNode\(\s*id:\s*(\d+),\s*name:\s*'([^']*)',\s*latitude:\s*([\d.-]+),\s*longitude:\s*([\d.-]+),\s*type:\s*TransitLocationType\.(\w+)"
)

# Map Dart TransitLocationType to Postgres public.location_type enum
type_map = {
    'hub': 'Hub',
    'station': 'Station',
    'university': 'University',
    'hospital': 'Hospital',
    'restaurant': 'Restaurant',
    'cafe': 'Cafe'
}

with open(dart_path, 'r', encoding='utf-8') as f:
    content = f.read()

matches = pattern.findall(content)

sql_statements = []
sql_statements.append("-- Seeding locations table from demo_transit_catalog.dart")
sql_statements.append("INSERT INTO public.locations (id, name, coordinates, type)")
sql_statements.append("VALUES")

values = []
seen_ids = set()

for match in matches:
    loc_id = int(match[0])
    # Prevent duplicate IDs
    if loc_id in seen_ids:
        continue
    seen_ids.add(loc_id)
    
    name = match[1].replace("'", "''")
    lat = float(match[2])
    lng = float(match[3])
    dart_type = match[4]
    pg_type = type_map.get(dart_type, 'Hub')
    
    # Postgres point is point(longitude, latitude)
    values.append(f"  ({loc_id}, '{name}', point({lng}, {lat}), '{pg_type}')")

sql_statements.append(",\n".join(values))
sql_statements.append("ON CONFLICT (id) DO UPDATE SET")
sql_statements.append("  name = EXCLUDED.name,")
sql_statements.append("  coordinates = EXCLUDED.coordinates,")
sql_statements.append("  type = EXCLUDED.type;")

with open(sql_path, 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_statements))

print(f"Generated insert_locations.sql successfully with {len(values)} locations!")
