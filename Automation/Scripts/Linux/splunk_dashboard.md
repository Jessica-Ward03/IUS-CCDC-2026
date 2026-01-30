# Splunk helpful stuff

## Linux

You will have to adjust to each host name

### Dashboards

#### Traffic by port by host.

Query
```
index=main host="HOSTNAME"
| rex field=_raw ":(?<port_num>\d+)"
| eval port_category=case(
    port_num=="22", "SSH (22)",
    port_num=="80", "http (80)",
    port_num=="25", "smtp (25)",
    port_num=="110", "pop3 (110)",
    port_num=="587", "submission (587)",
    port_num=="8089", "splunk mg (8089)",
    port_num=="9997", "splunk forwarder (9997)",
    port_num=="8000", "http alt (8000)",
    port_num=="80" OR port_num=="443", "Web (80/443)",
    port_num=="53", "DNS (53)",
     isnotnull(port_num), "High Ports (>1024)",
    1==1, "No Port Detected")
| timechart span=1m count by port_category
| eventstats avg(count) as GlobalAverage


```
- [ ] Should see to Area, Stacked, track 30min realtime and 1-2 min updates.
- [ ] Should make a dashboard panel composed of one for each linux machine.

#### ALL Traffic across hosts.

Query
```
index=main (host="HOST1" OR host="HOST2")
| timechart span=2m count by host
| addtotals fieldname=TotalMinuteTraffic
| eventstats avg(TotalMinuteTraffic) as "Global_Avg"
| fields - TotalMinuteTraffic
```
- [ ] Should see to Area, Stacked, track 30min realtime and 1-2 min updates.
- [ ] Should be included on the dashboard panel top.

### Alerts

#### New user account

I think works for both, might trigger multiple times.
```
index=main "new user" OR "Adding user"
| table _time, _raw
```
- [ ] Need to configure


#### Addition to Sudo/wheel group
Should cover Ubuntu and Fedora
```
index=main ("group" AND ("sudo" OR "wheel" OR "adm"))
| table _time, host, _raw
```

## Windows

### Dashboards

#### General Alert Security Dashboard WORKS FOR BOTH

Shows when alerts happen.
```
index=_audit action=alert_fired
| eval alert_time=datetime
| table _time, ss_name, severity, result_count
| timechart span=5m count by ss_name
| rename ss_name as "Alert Name", result_count as "Results Found"
```

