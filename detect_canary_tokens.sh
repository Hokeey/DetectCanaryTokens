#!/bin/bash


log_error() {
    local message="$1"
    echo "$(date) - ERROR: $message" >> script.log
}

if [ $# -ne 2 ]; then
    echo "Usage: $0 FILE_OR_DIRECTORY_PATH OUTPUT_FILE"
    exit 1
fi

FILE_OR_DIRECTORY_PATH="$1"
OUTPUT_FILE="$2"


check_connection() {
    local url="https://canarytokens.com"
    curl -s --head --request GET "$url" --max-time 10 | grep "200 OK" > /dev/null
}

extract_urls_from_stream() {
    local stream="$1"
    
    local urls
    urls=$(echo "$stream" | zlib-flate -uncompress 2>/dev/null | grep -Eo 'https?://[^\s<>"]+')
    echo "$urls"
}

process_pdf_file() {
    local pdf_path="$1"
    
    local pdf_content
    pdf_content=$(pdftotext "$pdf_path" - 2>/dev/null)

  
    local streams
    streams=$(echo "$pdf_content" | grep -oP 'stream[\r\n\s]+(.*?)endstream' | sed -n 's/^stream[\r\n\s]\+\(.*\)[\r\n\s]\+endstream$/\1/p')

    
    for stream in $streams; do
        local urls
        urls=$(extract_urls_from_stream "$stream")
        if [ -n "$urls" ]; then
            echo "URLs found in $pdf_path:" >> "$OUTPUT_FILE"
            echo "$urls" >> "$OUTPUT_FILE"
        fi
    done
}

decompress_and_scan() {
    local file_path="$1"
    local temp_dir
    temp_dir=$(mktemp -d) || { log_error "Could not create temporary directory."; return 1; }

    
    unzip -q "$file_path" -d "$temp_dir" 2>/dev/null || { log_error "Could not extract $file_path."; rm -rf "$temp_dir"; return 1; }

   
    local ignored_domains='schemas\.openxmlformats\.org|schemas\.microsoft\.com|purl\.org|w3\.org|example\.com'

    
    find "$temp_dir" -type f -print0 | while IFS= read -r -d '' extracted_file; do
        if [ ! -r "$extracted_file" ]; then
            echo "Permission denied: $extracted_file"
            continue
        fi

        
        local urls
        urls=$(grep -Eo 'https?://[^\s<>"]+' "$extracted_file")
        if [ -n "$urls" ]; then
            echo "URLs found in $extracted_file:" >> "$OUTPUT_FILE"
            echo "$urls" >> "$OUTPUT_FILE"
        fi
    done

    
    rm -rf "$temp_dir"
}

main() {
    if check_connection; then
        if [ -e "$FILE_OR_DIRECTORY_PATH" ]; then
            if [ -f "$FILE_OR_DIRECTORY_PATH" ]; then
                
                if [[ "$FILE_OR_DIRECTORY_PATH" =~ \.(zip|docx|xlsx|pptx)$ ]]; then
                    decompress_and_scan "$FILE_OR_DIRECTORY_PATH"
                elif [[ "$FILE_OR_DIRECTORY_PATH" =~ \.pdf$ ]]; then
                    process_pdf_file "$FILE_OR_DIRECTORY_PATH"
                fi
            elif [ -d "$FILE_OR_DIRECTORY_PATH" ]; then
                
                find "$FILE_OR_DIRECTORY_PATH" -type f -print0 | while IFS= read -r -d '' current_file_path; do
                    if [[ "$current_file_path" =~ \.(zip|docx|xlsx|pptx)$ ]]; then
                        decompress_and_scan "$current_file_path"
                    elif [[ "$current_file_path" =~ \.pdf$ ]]; then
                        process_pdf_file "$current_file_path"
                    fi
                done
            else
                echo "The path $FILE_OR_DIRECTORY_PATH is not a file or directory."
            fi
        else
            echo "The path $FILE_OR_DIRECTORY_PATH does not exist."
        fi
    else
        echo "Cannot connect to canarytokens.com. Files are not checked for suspicious content."
    fi
}



main
