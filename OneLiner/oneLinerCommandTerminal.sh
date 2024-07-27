# Convert Domains to IPs:
└─$ for domain in $(cat all_subs.txt); do echo "Domain: $domain, IP: $(dig +short $domain)"; done | tee result_IPs.txt

# Convert IPs to Domains:
└─$ for ip in $(cut -d ':' -f 1 mongo_ips); do domain=$(dig +short -x $ip); [ -n "$domain" ] && echo "IP: $ip, Domain: $domain"; done | tee result_Domains.txt

# Collect IPs from the result_IPs.txt file:
└─$ grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' result_IPs.tx | sort -u | tee IPs.txt

# Scan the top 1000 ports on all of the IPs:
└─$ sudo naabu -l IPs.txt -o Scan_IPs.txt --top-ports 1000
