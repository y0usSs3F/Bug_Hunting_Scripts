#!/bin/bash



# ANSI color escape codes

RESET="\e[0m"
GRAY="\e[90m"
RED="\e[91m"
GREEN="\e[92m"
YELLOW="\e[93m"
BLUE="\e[94m"
PURPLE="\e[95m"
CYAN="\e[96m"
WHITE="\e[97m"
REDB="\e[44m"

####################################################################################################################




##############################################     Functions     ###################################################




banner() {

echo -e "${RED} _   _ _   _ _   _ _____ _____ ____  ${RESET}"
echo -e "${RED}| | | | | | | \ | |_   _| ____|  _ \ ${RESET}"
echo -e "${RED}| |_| | | | |  \| | | | |  _| | |_) |${RESET}"
echo -e "${RED}|  _  | |_| | |\  | | | | |___|  _ < ${RESET}"
echo -e "${RED}|_| |_|\___/|_| \_| |_| |_____|_| \_\\\\${RESET}"
echo -e "${GREEN}               Created By: bug4you ${RESET}"

}




divider() {

    echo
    echo -e "${PURPLE}====================================================================${RESET}"
    echo
}



help() {

    clear
    banner
    echo
    echo -e "USAGE:$0 [DOMAIN...] [OPTIONS...]"
    echo -e "\t-h ,  --help       Help menu"
    echo -e "\t-hx , --httpx      Get live domains"
    echo -e "\t-u ,  --urls       Get all the urls "
    echo -e "\t-p ,  --parameter  Get parameters"
    echo -e "\t-w ,  --wayback    Get wayback data"
    echo -e "\t      --whois      Get whoisdata"
    echo -e "\t-ps , --portscan  Get the open ports"
    echo

}






##############################################     Variables     ###################################################


DOMAIN=$1


if [ $# -eq 0 ] || [ $# -eq 1 ]
then
    help
    exit 1
fi

if ! [ -d "$DOMAIN" ]
then
    mkdir $DOMAIN
    cd $DOMAIN
else
    echo "Directory Alreay Exists......Esiting...."
    echo -n "[+] Do you want to Delete the directory and continue? [Y/n]"
    read input
    if [[ "$input" == "y" || "$input" == "Y" ]]
    then 
        rm -rf $DOMAIN
        mkdir $DOMAIN
        cd $DOMAIN
    else
        exit 2
    fi
fi




##############################################     Scripting     ###################################################


banner
divider
echo -e "[-]Gathering Sub-domains from internet..."
subfinder -d $DOMAIN -silent -o sub_domains.txt
assetfinder $DOMAIN | tee -a sub_domains.txt

VALID_DOMAINS=`cat sub_domains.txt | sort -u`

echo
echo $VALID_DOMAINS | tee subdomains.txt
echo
echo -e "[+]Subdomains Gathering Completed..."
rm -rf sub_domains.txt


##############################################     Case     ###################################################


while [ $# -gt 0 ]
do
    case "$2" in
        "-h" | "--help" )
            help
            exit 4
            ;;
        "-hx" | "--httpx" )
            echo -e "${BLUE}[-]Running httpx...${RESET}"
            cat subdomains.txt | httpx | tee live-domains.txt
            echo -e "${GREEN}[+]httpx Finished...${RESET}"
            divider
            shift
            shift
            ;;

        "-u" | "--url" )
            echo -e "${BLUE}[-]Running gau...${RESET}"
            gau $DOMAIN | tee urls.txt
            echo -e "${GREEN}[+]gau Finished...${RESET}"
            divider
            shift
            shift
            ;;
        "-p" | "--prameter" )
            echo -e "${BLUE}[-]Running paramspider...${RESET}"
            ~/Desktop/Bug_Hunting/Tools/ParamSpider/paramspider.py -d $DOMAIN | tee parameters.txt
            echo -e "${GREEN}[+]paramspider Finished...${RESET}"
            divider
            shift
            shift
            ;;
        "-w" | "--waybackurls" )
            echo -e "${BLUE}[-]Running waybackurls...${RESET}"
            waybackurls $DOMAIN | tee waybackurls.txt
            echo -e "${GREEN}[+]waybackurls Finished...${RESET}"
            divider
            shift
            shift
            ;;

        "--whois" )
            echo -e "${BLUE}[-]Running whois...${RESET}"
            curl -s https://whois.com/whois/$DOMAIN | grep -A 70 "Registry Domain ID:" | tee whois.txt
            echo -e "${GREEN}[+]whois Finished...${RESET}"
            divider
            shift
            shift
            ;;

        "-ps" | "--portscan" )
            echo -e "${BLUE}[-]Running portscan...${RESET}"
            naabu -silent -host $DOMAIN | tee openport.txt
            echo -e "${GREEN}[+]portscan Finished...${RESET}"
            divider
            shift
            shift
            ;;

    esac
done


divider
echo -e "${GREEN}RECON COMPLETED...${RESET}"
divider






