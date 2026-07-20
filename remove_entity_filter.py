import json
import glob

def revert_query(query):
    if ", filter:{in(dt.entity.host, classicEntitySelector" in query:
        return query.split(", filter:{in(dt.entity.host")[0]
    if ", filter:{in(dt.entity.disk, classicEntitySelector" in query:
        return query.split(", filter:{in(dt.entity.disk")[0]
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
                tile['query'] = revert_query(tile['query'])
        
        out = json.dumps(j, indent=2)
        out = out.replace('DASHBOARD_NAME_PLACEHOLDER', '${dashboard_name}')
        with open(filepath, 'w') as f:
            f.write(out)
    except Exception as e:
        print(f"Error on {filepath}: {e}")

