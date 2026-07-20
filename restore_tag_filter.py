import json
import glob

def restore_query(query):
    if "timeseries" in query and "by:{dt.entity.host}" in query and "filter:" not in query:
        return query + ", filter:{in(dt.entity.host, classicEntitySelector(concat(\"type(HOST),tag(\", $tenant, \")\")))}"
    if "timeseries" in query and "by:{dt.entity.disk}" in query and "filter:" not in query:
        return query + ", filter:{in(dt.entity.disk, classicEntitySelector(concat(\"type(DISK),tag(\", $tenant, \")\")))}"
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

