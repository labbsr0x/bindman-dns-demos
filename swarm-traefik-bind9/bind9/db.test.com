$TTL 3600	; 1 hour
test.com. IN SOA ns1.test.com. admin.test.com. (
				9          ; serial
				10800      ; refresh (3 hours)
				3600       ; retry (1 hour)
				604800     ; expire (1 week)
				3600       ; minimum (1 hour)
				)

test.com. IN NS ns1.test.com.

ns1.test.com. IN A 0.0.0.0
