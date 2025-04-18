#!/bin/bash

# === Configuration ===
SETUP_CONFIG() {
	
	#choose between darkweb mode or normal mode by commenting the WGT you dont want
    
    # WGT="torrify wget"  #datkweb mode
    WGT="wget"   #normal mode
    
    
    
    DATE=$(date +"%d/%m/%Y|%H:%M")
    URLS="urls/urls"
    KEYWORDS="search/keywords.txt"
    TEMP="info/temp_links"
    LOG_FILE="crawler_log.txt"
    VISITED_URLS="info/visited_urls.txt"
    MATCHES_FILE="info/matches.txt"
    MATCH_COUNTER_FILE="info/match_counter.txt"
    KEYWORDS_FOUND_FILE="info/keywords_found_counter.txt"
    MATCH_OUTPUT_TMP="info/match_output.tmp"
    DOWNLOAD_DIR="downloaded_pages"

    # Colors
    GREEN='\033[1;32m'
    BLUE='\033[1;34m'
    YELLOW='\033[1;33m'
    CYAN='\033[1;36m'
    NC='\033[0m'
    BOLD='\033[1m'
}

# === Initialize directories and files ===
SETUP_DIRECTORIES() {
    mkdir -p "$DOWNLOAD_DIR" info
    touch "$URLS" "$VISITED_URLS" "$MATCHES_FILE" "$MATCH_COUNTER_FILE" "$KEYWORDS_FOUND_FILE" "$MATCH_OUTPUT_TMP"
}

# === Initialize counters ===
INIT_COUNTERS() {
    TOTAL_CRAWLED=$(wc -l < "$VISITED_URLS")
    MATCH_COUNT=$(cat "$MATCH_COUNTER_FILE" 2>/dev/null || echo "0")
    KEYWORDS_FOUND=$(cat "$KEYWORDS_FOUND_FILE" 2>/dev/null || echo "0")
}

# === User Agents ===
setup_user_agents() {
    USER_AGENTS=(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Safari/537.36"
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_6_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Safari/537.36"
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Safari/537.36"
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0"
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 13.6; rv:124.0) Gecko/20100101 Firefox/124.0"
      "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0"
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_6_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15"
      "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/15E148 Safari/604.1"
      "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/15E148 Safari/604.1"
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Safari/537.36 Edg/123.0.2420.65"
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_6_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Safari/537.36 Edg/123.0.2420.65"
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Safari/537.36 OPR/108.0.0.0"
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_6_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Safari/537.36 OPR/108.0.0.0"
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Safari/537.36 Brave/123.1.64.122"
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_6_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Safari/537.36 Brave/123.1.64.122"
      "Mozilla/5.0 (Linux; Android 14; Pixel 8 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Mobile Safari/537.36"
      "Mozilla/5.0 (Linux; Android 13; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.106 Mobile Safari/537.36"
      "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/123.0.6312.106 Mobile/15E148 Safari/604.1"
      "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/123.0.6312.106 Mobile/15E148 Safari/604.1"
      "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/124.0 Mobile/15E148 Safari/605.1.15"
      "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/124.0 Mobile/15E148 Safari/605.1.15"
      "Mozilla/5.0 (Android 14; Mobile; rv:124.0) Gecko/124.0 Firefox/124.0"
    )
}

# === Get random user agent ===
GET_RANDOM_USER_AGENT() {
    if [ ${#USER_AGENTS[@]} -eq 0 ]; then
        echo "Mozilla/5.0 (compatible)"
    else
        echo "${USER_AGENTS[$RANDOM % ${#USER_AGENTS[@]}]}"
    fi
}

# === Delay Function ===
GET_DELAY() {
    RAND=$((RANDOM % 100))
    if [ $RAND -lt 70 ]; then 
        awk -v min=1 -v max=3 'BEGIN{srand(); print min+rand()*(max-min)}'
    elif [ $RAND -lt 90 ]; then 
        awk -v min=3 -v max=7 'BEGIN{srand(); print min+rand()*(max-min)}'
    else 
        awk -v min=7 -v max=15 'BEGIN{srand(); print min+rand()*(max-min)}'
    fi
}

# === Status Display ===
DISPLAY_STATUS_BOX() {
    local current_url="$1"
    local width=80
    local timestamp=$DATE
    local border_line=$(printf '%*s' "$width" "" | tr ' ' '*')

    clear
    echo -e "\n${BLUE}${BOLD}WEB CRAWLER${NC}${BOLD} - Advanced Web Intelligence System [${timestamp}]${NC}\n"
    echo "$border_line"
    echo -e "*${CYAN}${BOLD}                              CRAWLER STATISTICS                              ${NC}*"
    echo "$border_line"
    printf "* ${BOLD}🕸️ TOTAL CRAWLED:      ${BLUE}%s${NC}${BOLD}%*s*\n" "$TOTAL_CRAWLED" $(( width - 25 - ${#TOTAL_CRAWLED} )) ""
    printf "* ${BOLD}🔍 KEYWORDS MATCHED:   ${YELLOW}%s${NC}${BOLD}%*s*\n" "$KEYWORDS_FOUND" $(( width - 26 - ${#KEYWORDS_FOUND} )) ""
    printf "* ${BOLD}📡 CURRENT OPERATION:  ${CYAN}CRAWLING${NC}${BOLD}%*s*\n" $(( width - 26 - 8 )) ""
    echo "$border_line"
    echo -e "*${CYAN}${BOLD}                                CURRENT TARGET                                ${NC}*"
    local display_url="$current_url"
    local url_visible_length=${#current_url}
    if [[ $url_visible_length -gt $((width - 4)) ]]; then
        display_url="${current_url:0:$((width - 11))}..."
        url_visible_length=$((width - 7 + 3))
    fi
    printf "* ${GREEN}%s${NC}%*s*\n" "$display_url" $(( width - 2 - url_visible_length )) ""
    echo "$border_line"
    echo -e "\n${BOLD}RECENT MATCHES:${NC}"
    echo "$border_line"
    if [ -s "$MATCH_OUTPUT_TMP" ]; then
        tail -n 3 "$MATCH_OUTPUT_TMP" | while IFS= read -r line; do
            local plain_line=$(echo "$line" | sed 's/\x1B\[[0-9;]*[mK]//g')
            printf "* %s%*s*\n" "$line" $(( width - ${#plain_line} - 2 )) ""
        done
    else
        printf "* ${BOLD}No matches found yet${NC}%*s*\n" $(( width - 17 - 2 )) ""
    fi
    echo "$border_line"
    local memory_usage=$(ps -o rss= -p $$ | awk '{print $1/1024 " MB"}')
    echo -e "\n${BOLD}SYSTEM:${NC} ${BOLD}Memory: ${memory_usage} | PID: $$${NC}"
}

# === Format match output ===
FORMAT_MATCH_OUTPUT() {
    local match_num="$1"
    local url="$2"
    local keyword="$3"
    echo -e "${GREEN}${BOLD}🟢 MATCH #${match_num}:${NC} ${url} ${BOLD}[keyword: \"${keyword}\"]${NC}"
}

# === Parse URL ===
PARSE_URL() {
    local link="$1"
    DOMAIN=$(echo "$link" | sed -E 's|^https?://([^/]+).*|\1|')
    LINK_MD5=$(echo "$link" | md5sum | cut -d' ' -f1)
    SAFE_NAME="${LINK_MD5}_$(echo "$link"_${DATE} | sed 's/[^a-zA-Z0-9]/_/g')"
    DOMAIN_DIR="$DOWNLOAD_DIR/$DOMAIN"
    mkdir -p "$DOMAIN_DIR"
    FILENAME="$DOMAIN_DIR/$SAFE_NAME.html"
}

# === Download URL ===
DOWNLOAD_URL() {
    local link="$1"
    local ua="$2"
    $WGT --quiet "$link" --timeout=10 --tries=2 --no-check-certificate \
         --user-agent="$ua" --header="Accept: text/html" -O "$FILENAME"
    return $?
}

# === Extract links ===
EXTRACT_LINKS() {
    grep -oP 'https?://[^\s"'\''<>]+' "$FILENAME" | sort -u > "${TEMP}_raw"
}

# === Check keywords ===
CHECK_KEYWORDS() {
    local link="$1"
    local keywords_found_this_url=0
    while IFS= read -r word; do
        [ -z "$word" ] && continue
        if grep -iq "$word" "$FILENAME"; then
            if ! grep -qF "$link|$word" "$MATCHES_FILE"; then
                MATCH_COUNT=$((MATCH_COUNT + 1))
                echo "$MATCH_COUNT" > "$MATCH_COUNTER_FILE"
                echo -e "${GREEN}${BOLD}🟢 MATCH #$MATCH_COUNT:${NC} $link ${BOLD}[keyword: \"$word\"]${NC}" >> "$MATCH_OUTPUT_TMP"
                echo "$link|$word" >> "$MATCHES_FILE"
                keywords_found_this_url=1
            fi
        fi
        grep -i "$word" "${TEMP}_raw" >> "$TEMP"
    done < "$KEYWORDS"
    if [ $keywords_found_this_url -eq 1 ]; then
        KEYWORDS_FOUND=$((KEYWORDS_FOUND + 1))
        echo "$KEYWORDS_FOUND" > "$KEYWORDS_FOUND_FILE"
        return 0
    else
        rm -f "$FILENAME"
        return 1
    fi
}

# === Update queue ===
UPDATE_URL_QUEUE() {
    if [ -s "$TEMP" ]; then
        grep -vxFf "$URLS" "$TEMP" | grep -vxFf "$VISITED_URLS" >> "$URLS"
    fi
}

# === Process one URL ===
PROCESS_URL() {
    local link="$1"
    grep -qF "$link" "$VISITED_URLS" && return
    echo "$link" >> "$VISITED_URLS"
    TOTAL_CRAWLED=$((TOTAL_CRAWLED + 1))
    DISPLAY_STATUS_BOX "$link"
    PARSE_URL "$link"
    UA=$(GET_RANDOM_USER_AGENT)
    if DOWNLOAD_URL "$link" "$UA"; then
        EXTRACT_LINKS
        [ -s "$KEYWORDS" ] && CHECK_KEYWORDS "$link"
        cat "${TEMP}_raw" >> "$TEMP"
        rm -f "${TEMP}_raw"
    fi
    sleep $(GET_DELAY)
}

# === Main loop ===
MAIN() {
    SETUP_CONFIG
    SETUP_DIRECTORIES
    setup_user_agents
    INIT_COUNTERS
    while true; do
        > "$TEMP"
        touch "$MATCH_OUTPUT_TMP"
        while IFS= read -r link; do
            [ -z "$link" ] && continue
            PROCESS_URL "$link"
        done < "$URLS"
        UPDATE_URL_QUEUE
        sleep $((RANDOM % 15 + 1))
    done
}

# Start
MAIN
