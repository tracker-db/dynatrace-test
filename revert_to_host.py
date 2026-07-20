import json
import glob

def revert_query(query):
    if "builtin:containers.cpu.usagePercent" in query:
        return "timeseries avg(dt.host.cpu.usage), by:{dt.entity.host}"
    if "builtin:containers.memory.usageBytes" in query:
        return "timeseries avg(dt.host.memory.used), by:{dt.entity.host}"
    if "builtin:containers.network.bytesRx" in query:
        return "timeseries sum(dt.host.net.nic.bytes_rx), by:{dt.entity.host}"
    if "builtin:containers.network.bytesTx" in query:
        return "timeseries sum(dt.host.net.nic.bytes_tx), by:{dt.entity.host}"
    return query

def revert_title(title):
    if title == "Container CPU Trend": return "Node CPU Trend"
    if title == "Container Memory Trend": return "Node Memory Trend"
    return title

for filepath in glob.glob("/Users/ejbest/Library/Mobile Documents/com~apple~CloudDocs/develop/dynatrace-test/modules/vault_dashboard/*.tftpl"):
    if "synthetics" in filepath:
        continue
    with open(filepath, 'r') as f:
        data = f.read()
    
    try:
        j = json.loads(data.replace('${dashboard_name}', 'DASHBOARD_NAME_PLACEHOLDER'))
        for tile_id, tile in j.get('tiles', {}).items():
            if 'query' in tile:
                tile['query'] = revert_query(tile['query'])
            if 'title' in tile:
                tile['title'] = revert_title(tile['title'])
        
        out = json.dumps(j, indent=2)
        out = out.replace('DASHBOARD_NAME_PLACEHOLDER', '${dashboard_name}')
        with open(filepath, 'w') as f:
            f.write(out)
    except Exception as e:
        print(f"Error on {filepath}: {e}")

