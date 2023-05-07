#!/bin/zsh

setopt null_glob

clear
RED='\033[0;31m'
echo "Please enter the absolute file path:"
NOCOLOR='\033[0m'
read file_path
cd "$file_path"
dir_name=$(echo $file_path | awk -F/ '{print $NF}')
a=$(ls -l 2>/dev/null | grep -v '^total' | wc -l)

if [ -d "$file_path/Subs" ]; then
    cd "$file_path/Subs"
    if find . -maxdepth 1 -type d ! -name '.*' | grep -q .; then
        echo "Subdirectories found!"
        original_dir=$(pwd) # Save the original working directory
        for sub_dir in $(find . -maxdepth 1 -type d ! -name '.*'); do
            echo "Current directory: $sub_dir"
            cd "$sub_dir"

            # Find the .srt file with the lowest prefix and rename it
            srt_file=$(ls *_English.srt 2>/dev/null | sort -t _ -k1.1n | head -1)
            if [[ -n $srt_file ]]; then
                new_file="${sub_dir:2}.srt"
                mv "$srt_file" "$new_file"
                echo "File $srt_file renamed to $new_file"

                # Delete the non-renamed .srt files
                for remaining_srt in *_English.srt; do
                    rm "$remaining_srt"
                    echo "Deleted $remaining_srt"
                done

                # Move the processed .srt file one directory up
                mv "$new_file" ..
                echo "Moved $new_file one directory up"
            else
                echo "No .srt files found in $sub_dir"
            fi

            cd "$original_dir" # Change back to the original working directory

            # Erase the empty folder
            rmdir "$sub_dir" 2>/dev/null && echo "Deleted empty folder: $sub_dir"
        done

        # Move all the processed *.srt files to one directory above
        mv *.srt "$file_path"
        echo "Moved all processed *.srt files one directory above"

        # Delete the /Subs folder
        cd ..
        rm -r Subs && echo "Deleted /Subs folder"

    else
        echo "No subdirectories found!"
        srt_file=$(ls *_English.srt 2>/dev/null | sort -t _ -k1.1n | head -1)
        if [[ -n $srt_file ]]; then
            new_file="${dir_name}.srt"
            mv "$srt_file" "$new_file"
            echo "File $srt_file renamed to $new_file"
            mv "$new_file" "$file_path"
            cd ..
            rm -r Subs && echo "Deleted /Subs folder"
        else
            echo "No .srt files found!"
        fi
    fi
else
    echo "Error: directory /Subs does not exist."
    exit 1
fi

echo "Current working directory: $(pwd -P)"
