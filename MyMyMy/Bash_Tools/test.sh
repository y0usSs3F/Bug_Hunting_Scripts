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


DOMAIN="wholeip.com"
# URL_Domain="http://$DOMAIN"
# mkdir $DOMAIN
# cd $DOMAIN
# TARGET_PATH="$(pwd)/$DOMAIN"


# # Command 2
# echo -e "${RED}[-]Gathering URLs from gospider...${RESET}"
# gospider -s $URL_Domain --js --sitemap --robots -o ${DOMAIN}_url_gospider
# DOMAIN_UNDERSCORED="${DOMAIN//./_}"
# gospider_file="$TARGET_PATH/${DOMAIN}_url_gospider/$DOMAIN_UNDERSCORED"
# grep -oE '(http|https)://[^[:space:]]*' $gospider_file | sed 's/]$//' | tee gospider_urls.txt
# echo -e "${GREEN}[+]gospider Done!${RESET}"


DOMAIN_UNDERSCORED="${DOMAIN//./_}"

# echo $DOMAIN_UNDERSCORED

DOMAIN_WITHOUT_DOT_COM="${DOMAIN%%.*}"

echo "$DOMAIN_WITHOUT_DOT_COM" 