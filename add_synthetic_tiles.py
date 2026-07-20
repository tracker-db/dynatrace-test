import json

filepath = "modules/vault_dashboard/dashboard_synthetics.tftpl"
with open(filepath, 'r') as f:
    data = f.read()

j = json.loads(data.replace('${dashboard_name}', 'DASHBOARD_NAME_PLACEHOLDER').replace('${service_name}', 'SERVICE_NAME_PLACEHOLDER'))

# Add Markdown Header for the new section
j['tiles']['101'] = {
  "type": "markdown",
  "title": "",
  "content": "### 🛠️ Synthetic Diagnostics & Troubleshooting"
}
j['layouts']['101'] = { "x": 0, "y": 14, "w": 24, "h": 2 }

# Add Event Log Tile
j['tiles']['5'] = {
  "type": "data",
  "title": "🚨 Recent Synthetic Outages & Errors",
  "query": "fetch events | filter in(dt.entity.http_check, classicEntitySelector(concat(\"type(HTTP_CHECK),tag(\\\"env:\", $tenant, \"\\\")\"))) | fields timestamp, event.name, event.status, event.description | sort timestamp desc | limit 20",
  "visualization": "table",
  "visualizationSettings": {}
}
j['layouts']['5'] = { "x": 0, "y": 16, "w": 12, "h": 8 }

# Add Step-by-Step Latency Tile
j['tiles']['6'] = {
  "type": "data",
  "title": "Authentication vs. Read Latency (Step Breakdown)",
  "query": "timeseries avg(dt.synthetic.http.duration), by:{dt.entity.http_check_step}, filter:{in(dt.entity.http_check, classicEntitySelector(concat(\"type(HTTP_CHECK),tag(\\\"service:SERVICE_NAME_PLACEHOLDER\\\"),tag(\\\"env:\", $tenant, \"\\\"),tag(\\\"check_type:auth_and_read\\\")\")))}",
  "visualization": "lineChart",
  "visualizationSettings": {}
}
j['layouts']['6'] = { "x": 12, "y": 16, "w": 12, "h": 8 }

out = json.dumps(j, indent=2)
out = out.replace('DASHBOARD_NAME_PLACEHOLDER', '${dashboard_name}')
out = out.replace('SERVICE_NAME_PLACEHOLDER', '${service_name}')

with open(filepath, 'w') as f:
    f.write(out)

