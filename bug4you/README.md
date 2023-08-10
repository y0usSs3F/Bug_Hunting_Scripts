# bug4you.sh is a script that do lots of stuff for you using threads as fast as possible, including:

####     1) Subdomain Enumeration with 7 different Tools   (subfinder, assetfinder, subbrute, gobuster, dnsgen, censys, crt.sh)
####     2) Extracting URLs with 5 different Tools         (waybackurls, gospider, gau, katana, linkfinder)
####     3) Extracting JS_Files with 5 different Tools     (waybackurls, gospider, gau, katana, linkfinder)
####     4) Extracting Parameters with 6 different Tools   (paramspider, waybackurls, gospider, gau, katana, linkfinder)



# USAGE:  ./bug4y0u.sh -d [DOMAIN...] [OPTIONS...]
	-h  ,  --help                    Help menu
	-d  ,  --domain                  Target Domain like domain.com
	-se ,  --subdomain-enum          Subdomain Enumeration
	-eu ,  --extracting-urls         Extracting URLs
	-ej ,  --extracting-js           Extracting (URLs & JS_Files)
	-ep ,  --extracting-parameters   Subdomain Enumeration & Extracting (URLs & Parameters)
	-a  ,  --all                     Subdomain Enumeration & Extracting (URLs & JS_Files & Parameters)
