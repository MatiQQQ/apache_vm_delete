#!/bin/bash

USER_TARGET=$(scutil <<<"show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
HIDDEN_DIR="/Users/${USER_TARGET}/.tmpapachedir"
TARGET_FILE="${HIDDEN_DIR}/tmpapache.txt"

if [[ ! -d $HIDDEN_DIR ]]; then
    mkdir $HIDDEN_DIR
fi

touch $TARGET_FILE

echo "Operation executed on ${USER_TARGET}'s account"

find "/Users/${USER_TARGET}" -type f 2>/dev/null 1>$TARGET_FILE

if [[ -d /opt/homebrew ]]; then
    find "/opt/homebrew" -type f 2>/dev/null 1>>$TARGET_FILE
fi

if [[ -d /usr/local/Homebrew ]]; then
    find "/usr/local" -type f 2>/dev/null 1>>$TARGET_FILE
fi

while IFS= read -r line; do
    if [[ "$line" =~ (.*\/commons-text-1\.([0-9])-sources\.jar$) || "$line" =~ (.*\/commons-text-1\.([0-9])-javadoc\.jar$) || "$line" =~ (.*\/commons-text-1\.([0-9])\.jar$) || "$line" =~ log4j-1\.(0|([1-5]?[0-9]))(\.([0-9]?[0-9]?[0-9]))?\.jar$ || "$line" =~ log4j-2\.(0|1[0-6]|[1-9])(\.([0-9]?[0-9]?[0-9]))?\.jar$ || "$line" =~ log4j-core-1\.(0|([1-5]?[0-9]))(\.([0-9]?[0-9]?[0-9]))?\.jar$ || "$line" =~ log4j-core-2\.(0|1[0-6]|[1-9])(\.([0-9]?[0-9]?[0-9]))?\.jar$ ]]; then
        echo "Found file: $line"
        echo "Removing file: $line"
        rm -rf "$line"
        if [[ $? -eq 0 ]]; then
            echo "File removed: $line"
        else
            echo "Error during file removal"
        fi
    fi
done <"$TARGET_FILE"

rm -f $TARGET_FILE
if [[ $? -eq 0 ]]; then
    echo "Done"
else
    echo "Tmp file not deleted"
fi
