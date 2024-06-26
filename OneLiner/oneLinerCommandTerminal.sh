# Convert Domains to IPs:
for domain in $(cat all_subs.txt); do echo "Domain: $domain, IP: $(dig +short $domain | head -n 1)"; done | tee result_IPs.txt

# Convert IPs to Domains:
for ip in $(cut -d ':' -f 1 mongo_ips); do domain=$(dig +short -x $ip); [ -n "$domain" ] && echo "IP: $ip, Domain: $domain"; done | tee result_Domains.txt

