import json
import sys

# Configure UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

input_path = 'benha_microbuses.json'
output_path = 'filtered_benha_microbuses.json'

with open(input_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

filtered_data = []

for category_block in data:
    category = category_block['category']
    matching_lines = []
    
    for line in category_block['lines']:
        route = line['route']
        
        # We want routes that connect to Benha or Kafr El-Gazzar,
        # but we ignore Atrib neighborhood lines.
        if ('بنها' in route or 'الجزار' in route) and 'أتريب' not in route:
            matching_lines.append(line)
            
    if matching_lines:
        filtered_data.append({
            'category': category,
            'lines': matching_lines
        })

# Save the filtered dataset
with open(output_path, 'w', encoding='utf-8') as f:
    json.dump(filtered_data, f, indent=2, ensure_ascii=False)

print(f"Filtering complete! Saved to {output_path}")
total_lines = sum(len(c['lines']) for c in filtered_data)
print(f"Total matching lines: {total_lines}")

print("\n--- Filtered Lines ---")
for cat_block in filtered_data:
    print(f"\nCategory: {cat_block['category']}")
    for line in cat_block['lines']:
        print(f"  Line {line['line_no']}: {line['route']} ({line['fare']} EGP)")
