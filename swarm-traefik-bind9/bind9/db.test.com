$ORIGIN .
$TTL 3600	; 1 hour
test.com		IN SOA	ns1.test.com. admin.test.com. (
				10         ; serial
				10800      ; refresh (3 hours)
				3600       ; retry (1 hour)
				604800     ; expire (1 week)
				3600       ; minimum (1 hour)
				)
			NS	ns1.test.com.
$ORIGIN test.com.
hello			A	0.0.0.0
ns1			A	0.0.0.0
