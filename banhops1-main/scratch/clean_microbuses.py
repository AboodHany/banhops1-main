import json
import sys

# Configure stdout to support UTF-8 characters on Windows console
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

def clean_and_flip():
    with open('benha_microbuses.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    cleaned_categories = []
    seen_routes = set()

    # We will specifically delete these duplicate routes (after flipping) to avoid duplicates
    duplicates_to_delete = {
        ('بنها', 'بنها - شبين القناطر'),
        ('بنها', 'بنها - عرابى'),
        ('بنها', 'بنها - كفر شكر'),
        ('بنها', 'بنها - طوخ'),
        ('بنها', 'بنها - القناطر الخيرية'),
        ('بنها', 'بنها - كفر على شرف الدين'),
        ('بنها', 'بنها - السلام'),
        ('بنها', 'بنها - الباجور'),
        ('بنها', 'بنها - الباجور الإقليمى'),
        ('بنها', 'بنها - طحلة'), # We have line 39 duplicate of line 4
    }

    for cat_idx, category_data in enumerate(data):
        category = category_data['category']
        lines = category_data['lines']
        cleaned_lines = []

        for line in lines:
            line_no = line['line_no']
            route = line['route']
            fare = line['fare']

            # Check if it's a duplicate we want to skip
            if (category, route) in duplicates_to_delete:
                # Special check for duplicate طحلة: keep line 4, delete line 39
                if route == 'بنها - طحلة' and line_no == 4:
                    # Let it pass, but it will be flipped
                    pass
                else:
                    print(f"Skipping duplicate: {category} -> {route} (Line {line_no})")
                    continue

            # Flip if it starts with Benha
            new_route = route
            if route.startswith('بنها - '):
                dest = route[len('بنها - '):]
                new_route = f"{dest} - بنها"
            elif route.startswith('مجمع مواقف بنها - '):
                dest = route[len('مجمع مواقف بنها - '):]
                new_route = f"{dest} - مجمع مواقف بنها"
            
            # Normalize some names for consistency
            if new_route == "عرابى - بنها":
                new_route = "أحمد عرابي - بنها"
            
            # De-duplicate check based on normalized route and category
            route_key = (category, new_route)
            if route_key in seen_routes:
                print(f"Skipping duplicate route key: {route_key}")
                continue
            seen_routes.add(route_key)

            cleaned_lines.append({
                'line_no': line_no,
                'route': new_route,
                'fare': fare
            })

        if cleaned_lines:
            cleaned_categories.append({
                'category': category,
                'lines': cleaned_lines
            })

    # Write cleaned data back to JSON
    with open('benha_microbuses.json', 'w', encoding='utf-8') as f:
        json.dump(cleaned_categories, f, ensure_ascii=False, indent=2)

    # Generate SQL statements
    sql_statements = []
    for cat_data in cleaned_categories:
        cat = cat_data['category']
        for line in cat_data['lines']:
            line_no = line['line_no']
            route = line['route']
            fare = line['fare']
            sql_statements.append(f"INSERT INTO public.microbuses (category, line_no, route, fare) VALUES ('{cat}', {line_no}, '{route}', {fare});")

    with open('scratch/cleaned_microbuses.sql', 'w', encoding='utf-8') as f:
        f.write("\n".join(sql_statements))

    print("Successfully cleaned and flipped all microbuses JSON and generated SQL!")

if __name__ == '__main__':
    clean_and_flip()
