import json
import glob

def restore_query(query):
    # Fix the missing quotes inside entityName()
    # Old: concat("type(HOST),entityName(*", $tenant, "*)")
    # New: concat("type(HOST),entityName(\"*", $tenant, "*\")")
    if "entityName(*" in query:
        query = query.replace("entityName(*\", $tenant, \"*)", "entityName(\\\"*\", $tenant, \"*\\\")")
    return query

for filepath in glob.glob("modules/vault_dashboard/*.tftpl"):
    if "synthetics" in filepath:
        continue
    with open(filepath, 'r') as f:
        data = f.read()
    
    try:
        j = json.loads(data.replace('${dashboard_name}', 'DASHBOARD_NAME_PLACEHOLDER'))
        for tile_id, tile in j.get('tiles', {}).items():
            if 'query' in tile:
                tile['query'] = restore_query(tile['query'])
        
        out = json.dumps(j, indent=2)
        out = out.replace('DASHBOARD_NAME_PLACEHOLDER', '${dashboard_name}')
        with open(filepath, 'w') as f:
            f.write(out)
    except Exception as e:
        print(f"Error on {filepath}: {e}")

