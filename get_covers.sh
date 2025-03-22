#!/bin/bash
# Script to download Linux Format magazine covers
# Downloads covers from issue 92 through 327

# Create covers directory if it doesn't exist
COVERS_DIR="./covers"
if [ ! -d "$COVERS_DIR" ]; then
    echo "Creating covers directory..."
    mkdir -p "$COVERS_DIR"
fi

# Base URL for the covers
BASE_URL="https://www.linuxformat.com/files/lxf_covers"

# Total number of covers to download
START_ISSUE=92
END_ISSUE=327
TOTAL_COVERS=$((END_ISSUE - START_ISSUE + 1))
DOWNLOADED_COUNT=0
FAILED_COUNT=0
SKIPPED_COUNT=0

echo -e "\e[36mStarting download of $TOTAL_COVERS Linux Format covers...\e[0m"

# Loop through all issue numbers
for ISSUE in $(seq $START_ISSUE $END_ISSUE); do
    COVER_URL="$BASE_URL/$ISSUE-big.jpg"
    OUTPUT_FILE="$COVERS_DIR/lxf$ISSUE.jpg"
    
    # Check if file already exists
    if [ -f "$OUTPUT_FILE" ]; then
        echo -e "\e[90mIssue $ISSUE already downloaded, skipping...\e[0m"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi
    
    # Calculate and show progress percentage
    PROGRESS=$((100 * (ISSUE - START_ISSUE) / TOTAL_COVERS))
    echo -ne "\e[1A\e[K" # Clear previous progress line
    echo -ne "\e[36mProgress: [$PROGRESS%] Issue $ISSUE of $END_ISSUE\e[0m\n"
    
    # Download the cover image
    echo -n "Downloading issue $ISSUE... "
    HTTP_CODE=$(curl -s -w "%{http_code}" -o "$OUTPUT_FILE" "$COVER_URL")
    
    if [ "$HTTP_CODE" -eq 200 ]; then
        echo -e "\e[32mDone!\e[0m"
        DOWNLOADED_COUNT=$((DOWNLOADED_COUNT + 1))
    else
        echo -e "\e[31mFailed! HTTP Code: $HTTP_CODE\e[0m"
        rm -f "$OUTPUT_FILE" # Remove failed download
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
    
    # Optional: Add a small delay to avoid overwhelming the server
    sleep 0.1
done

# Display summary
echo -e "\n\e[36mDownload Summary:\e[0m"
echo -e "\e[36m----------------\e[0m"
echo -e "Total covers processed: $TOTAL_COVERS"
echo -e "\e[32mSuccessfully downloaded: $DOWNLOADED_COUNT\e[0m"
echo -e "\e[31mFailed downloads: $FAILED_COUNT\e[0m"
echo -e "\e[90mSkipped (already exist): $SKIPPED_COUNT\e[0m"
echo -e "\n\e[36mDownloaded covers saved to: $COVERS_DIR\e[0m"

