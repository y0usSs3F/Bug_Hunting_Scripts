#!/bin/bash


# The Script is doing lots of stuff for you using threads as fast as possible, including:

#     1) Subdomain Enumeration with 7 different Tools   (subfinder, assetfinder, subbrute, gobuster, dnsgen, censys, crt.sh)
#     2) Extracting URLs with 5 different Tools         (waybackurls, gospider, gau, katana, linkfinder)
#     3) Extracting JS_Files with 5 different Tools     (waybackurls, gospider, gau, katana, linkfinder)
#     4) Extracting Parameters with 6 different Tools   (paramspider, waybackurls, gospider, gau, katana, linkfinder)




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
    echo -e "${PURPLE}================================================================================================${RESET}"
    echo

}




help() {

    # clear
    banner
    echo
    echo -e "USAGE:$0 [DOMAIN...] [OPTIONS...]"
    echo -e "\t-h  ,  --help                    Help menu"
    echo -e "\t-d  ,  --domain                  Target Domain like domain.com"
    echo -e "\t-se ,  --subdomain-enum          Subdomain Enumeration"
    echo -e "\t-eu ,  --extracting-urls         Extracting URLs"
    echo -e "\t-ej ,  --extracting-js           Extracting (URLs & JS_Files)"
    echo -e "\t-ep ,  --extracting-parameters   Subdomain Enumeration & Extracting (URLs & Parameters)"
    echo -e "\t-a  ,  --all                     Subdomain Enumeration & Extracting (URLs & JS_Files & Parameters)"
    echo

}



Subdomain_Enumeration() {

    banner
    divider

    (
        # Command 1
        echo -e "${RED}[-]Gathering Sub-domains from subfinder...${RESET}"
        subfinder -d $DOMAIN -silent -o subfinder_subdomains.txt
        echo -e "${GREEN}[+]subfinder Done!${RESET}"
    ) &


    (
        # Command 2
        echo -e "${RED}[-]Gathering Sub-domains from assetfinder...${RESET}"
        assetfinder -subs-only $DOMAIN | tee assetfinder_subdomains.txt
        echo -e "${GREEN}[+]assetfinder Done!${RESET}"
    ) &


    # (
    #     # Command 3
    #     echo -e "${RED}[-]Gathering Sub-domains from subbrute...${RESET}"
    #     ~/Desktop/Bug_Hunting/Tools/subbrute/subbrute.py $DOMAIN -r ~/Desktop/Bug_Hunting/Tools/subbrute/resolvers.txt -o subbrute_subdomains.txt
    #     mv ~/Desktop/Bug_Hunting/Tools/subbrute/subbrute_subdomains.txt $TARGET_PATH
    #     echo -e "${GREEN}[+]subbrute Done!${RESET}"
    # ) &


    (
        # Command 4
        echo -e "${RED}[-]Gathering Sub-domains from gobuster...${RESET}"
        gobuster dns -d $DOMAIN -q --no-color -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -o gobuster_subdomains_output.txt
        cat gobuster_subdomains_output.txt | cut -d " " -f 2 | tee gobuster_subdomains.txt
        rm -rf gobuster_subdomains_output.txt
        echo -e "${GREEN}[+]gobuster Done!${RESET}"
    ) &


    (
        # Command 5
        echo -e "${RED}[-]Gathering Sub-domains from dnsgen...${RESET}"
        echo $DOMAIN | dnsgen - | tee dnsgen_subdomains.txt
        echo -e "${GREEN}[+]dnsgen Done!${RESET}"
    ) &


    (
        # Command 6
        echo -e "${RED}[-]Gathering Sub-domains from censys...${RESET}"
        ~/Desktop/Bug_Hunting/Tools/censys-subdomain-finder/censys-subdomain-finder.py wholeip.com --censys-api-id=286f53a4-d73f-4084-a29b-eefcb7035969 --censys-api-secret=dlEnGAG107kvHbY2R5qYHKmTjOQX9UHJ -o censys_subdomains.txt
        echo -e "${GREEN}[+]censys Done!${RESET}"
    ) &


    (
        # Command 7
        echo -e "${RED}[-]Gathering Sub-domains from crt.sh...${RESET}"
        curl "https://crt.sh/?q=$DOMAIN&output=json" -o crt_subdomains.json
        jq -r ".[] | .name_value" crt_subdomains.json > crt_subdomains.txt
        rm -rf crt_subdomains.json
        echo -e "${GREEN}[+]crt.sh Done!${RESET}"
    ) &


    wait


    # Command 8
    echo -e "${RED}\n\n\n[+]Collecting all subdomains in one file xD\n${RESET}"
    cat subfinder_subdomains.txt gobuster_subdomains.txt assetfinder_subdomains.txt dnsgen_subdomains.txt censys_subdomains.txt crt_subdomains.txt | sort -u | tee all_subdomains.txt
    echo -e  "${GREEN}[+]Subdomains Collected Successfully${RESET}"


    # Command 9
    echo -e "${RED}Finding Live Subdomains with httpx...${RESET}"
    cat all_subdomains.txt | httpx -silent -mc 200 | tee all_200_live_Subdomains.txt
    echo -e "${GREEN}httpx on Subdomains Finished!${RESET}"


    echo -e "${GREEN}\n\n\n[+]Subdomain_Enumeration Function Done!\n\n\n${RESET}"


}




Extracting_URLs() {

    banner
    divider
    URL_Domain="http://$DOMAIN"

    (
        # Command 1
        echo -e "${RED}[-]Gathering URLs from waybackurls...${RESET}"
        echo $DOMAIN | waybackurls | tee waybackurls.txt
        echo -e "${GREEN}[+]waybackurls Done!${RESET}"
    ) &


    (
        # Command 2
        echo -e "${RED}[-]Gathering URLs from gospider...${RESET}"
        gospider -s $URL_Domain --js --sitemap --robots -o ${DOMAIN}_url_gospider
        DOMAIN_UNDERSCORED="${DOMAIN//./_}"
        gospider_file="$TARGET_PATH/${DOMAIN}_url_gospider/$DOMAIN_UNDERSCORED"
        grep -oE '(http|https)://[^[:space:]]*' $gospider_file | sed 's/]$//' | tee gospider.txt
        rm -rf ${DOMAIN}_url_gospider
        echo -e "${GREEN}[+]gospider Done!${RESET}"
    ) &


    (
        # Command 3
        echo -e "${RED}[-]Gathering URLs from gau...${RESET}"
        echo $DOMAIN | gau | tee gau.txt
        echo -e "${GREEN}[+]gau Done!${RESET}"
    ) &


    (
        # Command 4
        echo -e "${RED}[-]Gathering URLs from katana...${RESET}"
        katana -u $URL_Domain -jc -silent | tee katana.txt
        echo -e "${GREEN}[+]katana Done!${RESET}"
    ) &


    (
        # Command 5
        echo -e "${RED}[-]Gathering URLs from linkfinder...${RESET}"
        ~/Desktop/Bug_Hunting/Tools/LinkFinder/linkfinder.py -i $URL_Domain -o cli | tee linkfinder.txt
        echo -e "${GREEN}[+]linkfinder Done!${RESET}"
    ) &


    wait


    # Command 6
    echo -e "${RED}\n\n\n[+]Collecting all URLs in one file xD\n${RESET}"
    cat waybackurls.txt gospider.txt gau.txt katana.txt linkfinder.txt | sort -u | tee all_${DOMAIN}_URLs.txt
    cat all_${DOMAIN}_URLs.txt | grep -oE '(http|https)://[^[:space:]]+' | tee all_fetched_URLs.txt
    rm -rf all_${DOMAIN}_URLs.txt
    echo -e "${GREEN}Finished Collecting all URLs!${RESET}"
   


    # Command 7
    echo -e "${RED}Finding Live URLs with httpx...${RESET}"
    cat all_fetched_URLs.txt | httpx -silent -mc 200 | tee all_200_live_URLs.txt
    echo -e "${GREEN}httpx on URLs Finished!${RESET}"


    echo -e "${GREEN}\n\n\n[+]Extracting_URLs Function Done!\n\n\n${RESET}"


}




Extracting_JS_Files() {

    # This Function Depends on the Extracting_URLs Function!

    banner
    divider

    (
        # Command 1
        echo -e "${RED}[-]Gathering JS Files from waybackurls...${RESET}"
        grep '\.js' waybackurls.txt | sort -u | tee waybackurls_js_files.txt
        echo -e "${GREEN}[+]Finished Gathering JS Files from waybackurls${RESET}"
    ) &


    (
        # Command 2
        echo -e "${RED}[-]Gathering JS Files from gospider...${RESET}"
        grep '\.js' gospider.txt | sort -u | tee gospider_js_files.txt
        echo -e "${GREEN}[+]Finished Gathering JS Files from gospider${RESET}"
    ) &


    (
        # Command 3
        echo -e "${RED}[-]Gathering JS Files from gau...${RESET}"
        grep '\.js' gau.txt | sort -u | tee gau_js_files.txt
        echo -e "${GREEN}[+]Finished Gathering JS Files from gau${RESET}"
    ) &


    (
        # Command 4
        echo -e "${RED}[-]Gathering JS Files from katana...${RESET}"
        grep '\.js' katana.txt | sort -u | tee katana_js_files.txt
        echo -e "${GREEN}[+]Finished Gathering JS Files from katana${RESET}"
    ) &


    (
        # Command 5
        # DOMAIN_WITHOUT_DOT_COM="${DOMAIN%%.*}"
        echo -e "${RED}[-]Gathering JS Files from linkfinder...${RESET}"
        grep '\.js' linkfinder.txt | sort -u | tee linkfinder_js_files.txt
        echo -e "${GREEN}[+]Finished Gathering JS Files from linkfinder${RESET}"
    ) &


    wait


    # Command 6
    echo -e "${RED}\n\n\n[+]Collecting all JS Files in one file xD\n${RESET}"
    cat waybackurls_js_files.txt gospider_js_files.txt gau_js_files.txt katana_js_files.txt linkfinder_js_files.txt | sort -u | tee all_JS_Files.txt
    echo -e "${GREEN}Finished Collecting all JS Files!${RESET}"
   


    # Command 7
    echo -e "${RED}Finding Live JS Files with httpx...${RESET}"
    cat all_JS_Files.txt | httpx -silent -mc 200 | tee all_200_live_JS_Files.txt
    echo -e "${GREEN}httpx on JS Files Finished!${RESET}"


    echo -e "${GREEN}\n\n\n[+]Extracting_JS_Files Function Done!\n\n\n${RESET}"


}





Extracting_Parameters() {


    # This Function Depends on the Subdomain_Enumeration and Extracting_URLs Functions!

    banner
    divider
    
    (
        echo -e "${RED}Using ParamSpider on live Domains...${RESET}"
        for URL in $(< all_200_live_Subdomains.txt )
        do
            python3 ~/Desktop/Bug_Hunting/Tools/ParamSpider/paramspider.py -d "${URL}" --level high
        done
        echo -e "${GREEN}ParamSpider on live Domains Finished!${RESET}"


        echo -e "${RED}Adding All ParamSpider outputs to all_parameters_from_paramspider.txt file...${RESET}"
        find $TARGET_PATH/output -type f -exec cat {} + | tee all_parameters_from_paramspider.txt
        rm -rf $TARGET_PATH/output
        echo -e "${GREEN}Done Adding All ParamSpider outputs to all_parameters_from_paramspider.txt file...${RESET}"
    ) &


    (
        echo -e "${RED}grep All the URLs that were grabbed from Extracting_URLs function to get parameters...${RESET}"
        cat all_fetched_URLs.txt | grep ? | sort -u | tee all_parameters_from_Extracting_URLs_Function.txt
        echo -e "${GREEN}Done greping All the URLs that were grabbed from Extracting_URLs function to get parameters...${RESET}"
    ) &


    wait



    cat all_parameters_from_paramspider.txt all_parameters_from_Extracting_URLs_Function.txt > all_parameters.txt

    echo -e "${GREEN}\n\n\n[+]Extracting_Parameters Function Done!\n\n\n${RESET}"


}



check_existing_target_file() {

    if ! [ -d "$DOMAIN" ]
    then
        mkdir $DOMAIN
        cd $DOMAIN
        TARGET_PATH="$(pwd)"
    else
        echo "Directory Alreay Exists......Exiting...."
        echo -n "[+] Do you want to Delete the directory and continue? [Y/n]"
        read input
        if [[ "$input" == "y" || "$input" == "Y" ]]
        then 
            rm -rf $DOMAIN
            mkdir $DOMAIN
            cd $DOMAIN
            TARGET_PATH="$(pwd)"
        else
            exit 2
        fi
    fi

}


main() {
    

    if [ $# -eq 0 ] || [ $# -eq 1 ]
    then
        help
        exit 1
    fi


    while [ $# -gt 0 ]
    do
        case "$1" in
            "-h" | "--help" )
                help
                exit 4
                ;;
            "-d" | "--domain" )
                shift
                DOMAIN=$1
                check_existing_target_file
                divider
                ;;
            "-se" | "--subdomain-enum" )
                Subdomain_Enumeration
                divider
                ;;
            "-eu" | "--extracting-urls" )
                Extracting_URLs
                divider
                ;;
            "-ej" | "--extracting-js" )
                Extracting_URLs
                divider
                Extracting_JS_Files
                divider
                ;;
            "-ep" | "--extracting-parameters" )

                (
                    Subdomain_Enumeration
                    divider
                ) &


                (
                    Extracting_URLs
                    divider
                ) &


                wait

                (
                    Extracting_Parameters
                    divider
                ) &

                wait

                echo""
                

                ;;
            "-a" | "--all" )

                (
                    Subdomain_Enumeration
                    divider
                ) &

                (
                    Extracting_URLs
                    divider
                ) &

                wait

                (
                    Extracting_JS_Files
                    divider
                ) &

                (
                    Extracting_Parameters
                    divider
                ) &

                wait

                echo ""

                ;;
            * )
                help
                exit 4

        esac
        shift
    done


    divider
    divider
    echo -e "${GREEN}================================ RECON COMPLETED <3 ================================${RESET}"
    divider
    divider


}


main "$@"

