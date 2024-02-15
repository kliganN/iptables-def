# Clean ipables
iptables -F
iptables -X
iptables -Z

# Allow DNS connections
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT -m comment --comment dns
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT -m comment --comment dns

# Allow NTP
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT -m comment --comment ntp

# Allow ICMP pings
iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Allow shadowsocks proxy TCP
iptables -A OUTPUT -p tcp --dport 20095 -j ACCEPT
iptables -A INPUT -p tcp --dport 20095 -j ACCEPT

# Allow shadowsocks proxy UDP
iptables -A OUTPUT -p udp --dport 20095 -j ACCEPT
iptables -A INPUT -p udp --dport 20095 -j ACCEPT

# Allow localhost trafic
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# SSH connection
iptables -A INPUT -p tcp --dport 20045 -j ACCEPT -m comment --comment ssh

# HTTPS, HTTP
iptables -A OUTPUT -p tcp -m multiport --dports 443,80 -j ACCEPT

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# DROP all invalid sessions
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A INPUT -m state --state INVALID -j DROP

# DROP ALL POLICY
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP


# Save to
iptables-save > /etc/iptables/rules.v4
