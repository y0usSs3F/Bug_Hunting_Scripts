#!/bin/bash


# Usage: ./crtsh.sh -t target.com -d {number_of_deep (ranging from 1 to 5 only)}
# Example:  ./crtsh.sh -t target.com -d 5
# The Script is basically dive deep in the crt.sh domain to find more and more subdomains and fetch all of them for you in different level files like (first_deep.txt, second_deep.txt, third_deep.txt, fourth_deep.txt, fifth_deep.txt) the maximum number of deep level is 5


help() {

    echo
    echo -e "USAGE:$0 -t [TARGET] -d [DEPTH]"
    echo -e "\t-h  ,  --help                    Help menu"
    echo -e "\t-t  ,  --target                  Target Domain like domain.com"
    echo -e "\t-d ,  --depth          			DEPTH to go through subdomains"

}

first_deep() {

	echo  -e "\n\nGetting first deep Subdomains..."
	curl -s "https://crt.sh/?Identity=%.$DOMAIN" | grep ">*.$DOMAIN" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$DOMAIN" | sort -u | awk 'NF' > $TARGET_PATH/subdomains_first_deep_temp.txt
	grep -v '@' $TARGET_PATH/subdomains_first_deep_temp.txt | grep -vE '^[^.]+\.[^.]+$' | rev | cut -d '.' -f1,2,3 | rev | grep -v '*' | sort -u > $TARGET_PATH/first_deep_tmp.txt
	cat $TARGET_PATH/first_deep_tmp.txt | sort -u > $TARGET_PATH/first_deep.txt
	echo -e "$(cat $TARGET_PATH/first_deep.txt | wc -l) Found\n"
	rm -rf $TARGET_PATH/first_deep_tmp.txt $TARGET_PATH/subdomains_first_deep_temp.txt
	echo  -e "\n\n[+] Done first deep Subdomains..."

}


second_deep() {

	echo  -e "\n\nGetting second deep Subdomains..."
	    for subdomain in $(< $TARGET_PATH/first_deep.txt )
	    do
	        echo "Getting Subdomains of ${subdomain}"
			curl -s "https://crt.sh/?Identity=%.$subdomain" | grep ">*.$DOMAIN" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$DOMAIN" | sort -u | awk 'NF' > $TARGET_PATH/subdomains_second_deep_temp.txt
			grep -v '@' $TARGET_PATH/subdomains_second_deep_temp.txt | grep -vE '^[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+$' | rev | cut -d '.' -f1,2,3,4 | rev | grep -v '*' | sort -u > $TARGET_PATH/count_second_deep_for_each_subdomain.txt
			echo -e "$(cat $TARGET_PATH/count_second_deep_for_each_subdomain.txt | wc -l) Found\n"
			cat $TARGET_PATH/count_second_deep_for_each_subdomain.txt >> $TARGET_PATH/second_deep_tmp.txt
	    done
	    cat $TARGET_PATH/second_deep_tmp.txt | sort -u > $TARGET_PATH/second_deep.txt
	    rm -rf $TARGET_PATH/second_deep_tmp.txt $TARGET_PATH/subdomains_second_deep_temp.txt $TARGET_PATH/count_second_deep_for_each_subdomain.txt
	echo  -e "\n\n[+] Done second deep Subdomains..."

}



third_deep() {

	echo  -e "\n\nGetting third deep Subdomains..."
	    for subdomain in $(< $TARGET_PATH/second_deep.txt )
	    do
	        echo "Getting Subdomains of ${subdomain}"
			curl -s "https://crt.sh/?Identity=%.$subdomain" | grep ">*.$DOMAIN" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$DOMAIN" | sort -u | awk 'NF' > $TARGET_PATH/subdomains_third_deep_temp.txt
			grep -v '@' $TARGET_PATH/subdomains_third_deep_temp.txt | grep -vE '^[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+\.[^.]+$' | rev | cut -d '.' -f1,2,3,4,5 | rev | grep -v '*' | sort -u > $TARGET_PATH/count_third_deep_for_each_subdomain.txt
			echo -e "$(cat $TARGET_PATH/count_third_deep_for_each_subdomain.txt | wc -l) Found\n"
			cat $TARGET_PATH/count_third_deep_for_each_subdomain.txt >> $TARGET_PATH/third_deep_tmp.txt
	    done
	    cat $TARGET_PATH/third_deep_tmp.txt | sort -u > $TARGET_PATH/third_deep.txt
	    rm -rf $TARGET_PATH/third_deep_tmp.txt $TARGET_PATH/subdomains_third_deep_temp.txt $TARGET_PATH/count_third_deep_for_each_subdomain.txt
	echo  -e "\n\n[+] Done third deep Subdomains..."

}


fourth_deep() {

	echo -e "\n\nGetting fourth deep Subdomains..."
	    for subdomain in $(< $TARGET_PATH/third_deep.txt )
	    do
	        echo "Getting Subdomains of ${subdomain}"
			curl -s "https://crt.sh/?Identity=%.$subdomain" | grep ">*.$DOMAIN" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$DOMAIN" | sort -u | awk 'NF' > $TARGET_PATH/subdomains_fourth_deep_temp.txt
			grep -v '@' $TARGET_PATH/subdomains_fourth_deep_temp.txt | grep -vE '^[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+\.[^.]+\.[^.]+$' | rev | cut -d '.' -f1,2,3,4,5,6 | rev | grep -v '*' | sort -u > $TARGET_PATH/count_fourth_deep_for_each_subdomain.txt
			echo -e "$(cat $TARGET_PATH/count_fourth_deep_for_each_subdomain.txt | wc -l) Found\n"
			cat $TARGET_PATH/count_fourth_deep_for_each_subdomain.txt >> $TARGET_PATH/fourth_deep_tmp.txt
	    done
	    cat $TARGET_PATH/fourth_deep_tmp.txt | sort -u > $TARGET_PATH/fourth_deep.txt
	    rm -rf $TARGET_PATH/fourth_deep_tmp.txt $TARGET_PATH/subdomains_fourth_deep_temp.txt $TARGET_PATH/count_fourth_deep_for_each_subdomain.txt
	echo  -e "\n\n[+] Done fourth deep Subdomains..."

}



fifth_deep() {

	echo -e "\n\nGetting fifth deep Subdomains..."
	    for subdomain in $(< $TARGET_PATH/fourth_deep.txt )
	    do
	        echo "Getting Subdomains of ${subdomain}"
			curl -s "https://crt.sh/?Identity=%.$subdomain" | grep ">*.$DOMAIN" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$DOMAIN" | sort -u | awk 'NF' > $TARGET_PATH/subdomains_fifth_deep_temp.txt
			grep -v '@' $TARGET_PATH/subdomains_fifth_deep_temp.txt | grep -vE '^[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+\.[^.]+\.[^.]+$' | grep -vE '^[^.]+\.[^.]+\.[^.]+\.[^.]+\.[^.]+\.[^.]+$' | rev | cut -d '.' -f1,2,3,4,5,6,7 | rev | grep -v '*' | sort -u > $TARGET_PATH/count_fifth_deep_for_each_subdomain.txt
			echo -e "$(cat $TARGET_PATH/count_fifth_deep_for_each_subdomain.txt | wc -l) Found\n"
			cat $TARGET_PATH/count_fifth_deep_for_each_subdomain.txt >> $TARGET_PATH/fifth_deep_tmp.txt
	    done
	    cat $TARGET_PATH/fifth_deep_tmp.txt | sort -u > $TARGET_PATH/fifth_deep.txt
	    rm -rf $TARGET_PATH/fifth_deep_tmp.txt $TARGET_PATH/subdomains_fifth_deep_temp.txt $TARGET_PATH/count_fifth_deep_for_each_subdomain.txt
	echo  -e "\n\n[+] Done fifth deep Subdomains..."

}



process_depth_subdomains() {

	if [[ "$DEPTH" == "1" ]]; then
		first_deep
	elif [[ "$DEPTH" == "2" ]]; then
		first_deep
		second_deep
	elif [[ "$DEPTH" == "3" ]]; then
		first_deep
		second_deep
		third_deep
	elif [[ "$DEPTH" == "4" ]]; then
		first_deep
		second_deep
		third_deep
		fourth_deep
	elif [[ "$DEPTH" == "5" ]]; then
		first_deep
		second_deep
		third_deep
		fourth_deep
		fifth_deep
	fi

}



collecting() {

	if [[ "$DEPTH" == "1" ]]; then
		cat $TARGET_PATH/first_deep.txt | sort -u >> $TARGET_PATH/all_subdomains.txt
	elif [[ "$DEPTH" == "2" ]]; then
		cat $TARGET_PATH/first_deep.txt $TARGET_PATH/second_deep.txt | sort -u >> $TARGET_PATH/all_subdomains.txt
	elif [[ "$DEPTH" == "3" ]]; then
		cat $TARGET_PATH/first_deep.txt $TARGET_PATH/second_deep.txt $TARGET_PATH/third_deep.txt | sort -u >> $TARGET_PATH/all_subdomains.txt
	elif [[ "$DEPTH" == "4" ]]; then
		cat $TARGET_PATH/first_deep.txt $TARGET_PATH/second_deep.txt $TARGET_PATH/third_deep.txt $TARGET_PATH/fourth_deep.txt | sort -u >> $TARGET_PATH/all_subdomains.txt
	elif [[ "$DEPTH" == "5" ]]; then
		cat $TARGET_PATH/first_deep.txt $TARGET_PATH/second_deep.txt $TARGET_PATH/third_deep.txt $TARGET_PATH/fourth_deep.txt $TARGET_PATH/fifth_deep.txt | sort -u >> $TARGET_PATH/all_subdomains.txt
	fi

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
            "-t" | "--target" )
                shift
                DOMAIN=$1
                check_existing_target_file
                ;;
            "-d" | "--depth" )
                shift
                DEPTH=$1
                process_depth_subdomains
                collecting
                ;;
            * )
                help
                exit 4

        esac
        shift
    done

}


main "$@"

