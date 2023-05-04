#!/bin/zsh

clear
RED='\033[0;31m'
echo "Please enter the file path:"
NOCOLOR='\033[0m'
read file_path
cd $file_path
dir_name=$(echo $file_path | awk -F/ '{print $NF}')

# echo $dir_name
if [ -d "$file_path/Subs" ]; then
   cd "$file_path""/Subs"
   a=$(ls -l | grep -v '^total' | wc -l)
   echo $a
else
    echo "Error: directory /Subs does not exist."
    exit 1
fi

for i in $(seq 1 9); do
    min_prefix=0
    min_file=""
    episode_number=$(printf "%02d" $i)
    new_dir=$(echo "$dir_name" | sed "s/S04/S04E$episode_number/")
    cd $new_dir
    for file in *_English.srt; do
        prefix=${file%%_*}
        if [[ -z $min_file || $prefix -lt $min_prefix ]]; then
            min_prefix=$prefix
            min_file=$file
        fi
    done

    for file in *_English.srt; do
        if [[ $file != $min_file ]]; then
            mv $file $file.bak
            if [[ -n $min_file ]]; then
                # cp $min_file $new_dir.srt
                   mv $min_file $new_dir.srt
                   rm *.bak
                   mv *.srt ../
            fi
        fi
    done
    cd ..
done


for i in $(seq 10 $a); do
    min_prefix=0
    min_file=""
    episode_number=$(printf "%02d" $i)
    new_dir=$(echo "$dir_name" | sed "s/S04/S04E$episode_number/")
    cd $new_dir
    for file in *_English.srt; do
        prefix=${file%%_*}
        if [[ -z $min_file || $prefix -lt $min_prefix ]]; then
            min_prefix=$prefix
            min_file=$file
        fi
    done

    for file in *_English.srt; do
        if [[ $file != $min_file ]]; then
            mv $file $file.bak
            if [[ -n $min_file ]]; then
                # cp $min_file $new_dir.srt
                mv $min_file $new_dir.srt
                rm *.bak
                mv *.srt ../
            fi
        fi
    done
    cd ..
    ls -lrt
    rmdir * 2>/dev/null
    mv *.srt ../
done
cd ..
# rmdir --ignore-fail-on-non-empty Subs
rm -r Subs
rm *.txt

