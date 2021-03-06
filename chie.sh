#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2018
# a MUCH faster onedrive downloader and reuploader than rclone
# usin' oneindex (https://github.com/donwa/oneindex) website's information to get directory structure, download files usin' aria2 (need a thread hacked version), and set modified time right
# and reupload every folder to google drive and delete it after finish downloadin' them
# here we fockin' go
baseurl="" # your oneindex website's root
absolutepath=`pwd`
gdrive="" # your google drive root in rclone
sizelimit=104857600
# sizelimit=9
filesnum=50

mkdir "$absolutepath$1"
cd "$absolutepath$1"

function chie_display() {
    echo "$baseurl$1/"
    for list in `curl --globoff "$baseurl$1/" | grep "<li class=.* data-sort" | sed 's/li class="//g' | sed 's/" data-sort data-sort-name="/?/g' | sed 's/" data-sort-date="/?/g' | sed 's/" data-sort-size="/?/g' | sed 's/">//g' | sed 's/ /|/g'`; 
    do 
        list=`echo $list | sed 's/|/ /g'`; 
        delta=`echo $list | cut -d'?' -f1`; 
        filename=`echo $list | cut -d'?' -f2`; 
        modtime=`echo $list | cut -d'?' -f3`; 
        size=`echo $list | cut -d'?' -f4`; 
        echo $delta
        if [ "$delta" = "<mdui-list-item file mdui-ripple" ]
        then
            echo $filename
            echo `date -d "@$modtime"`
            echo $size
            echo
        else
            f="$1/$filename"
            echo
            echo -e "\t\e[36mstart of $f\e[0m"
            chie_display "$1/$filename" 
            echo -e "\t\e[36mend of $f\e[0m"
            echo
        fi
    done
}

function chie() {
    total=0
    echo "# current dir: $baseurl$1/"
    for list in `curl --globoff "$baseurl$1/" | grep "<li class=.* data-sort" | sed 's/li class="//g' | sed 's/" data-sort data-sort-name="/?/g' | sed 's/" data-sort-date="/?/g' | sed 's/" data-sort-size="/?/g' | sed 's/">//g' | sed 's/ /|/g'`; 
    do 
        list=`echo $list | sed 's/|/ /g'`; 
        delta=`echo $list | cut -d'?' -f1`; 
        filename=`echo $list | cut -d'?' -f2`; 
        modtime=`echo $list | cut -d'?' -f3`; 
        size=`echo $list | cut -d'?' -f4`; 
        # echo $delta
        if [ "$delta" != "<mdui-list-item file mdui-ripple" ]
        then
            local f="$filename"
            # echo
            # echo -e "\t\e[36mstart of $f\e[0m"
            echo -e "\e[36mmkdir \"$absolutepath$1/$f\"\e[0m"
            mkdir "$absolutepath$1/$f"
            echo -e "\e[36mcd \"$absolutepath$1/$f\"\e[0m"
            cd "$absolutepath$1/$f"
            chie "$1/$f"
            # echo -e "\t\e[36mend of $f\e[0m"
            echo -e "\e[36mcd ..\e[0m"
            cd ..
            echo -e "\e[36mtouch -d @$modtime \"$f\"\e[0m"
            touch -d @$modtime "$f"
            echo -e "\e[36mrclone --low-level-retries=666 -vv --checksum --drive-chunk-size=128M --onedrive-chunk-size=100M move \"$absolutepath$1/$f\" \"$gdrive$1/$f\"\e[0m"
            rclone --low-level-retries=666 -vv --checksum --drive-chunk-size=128M --onedrive-chunk-size=100M move "$absolutepath$1/$f" "$gdrive$1/$f"
            # echo
        elif [ "$delta" = "<mdui-list-item file mdui-ripple" ]
        then
            # echo $filename
            # echo `date -d "@$modtime"`
            # echo $size
            # echo
            if [ -f "$filename" ] && [ ! -f "$filename.aria2" ]
            then
                echo -e "\e[36malready downloaded\e[0m"
            elif [ $size -lt $sizelimit ]
            then
                echo -e "\e[36m< $sizelimit bytes, skipped\e[0m"
            else
                echo -e "\e[36maria2c -s 128 -x 128 \"$baseurl$1/$filename\"\e[0m"
                aria2c -s 128 -x 128 "$baseurl$1/$filename"
                echo -e "\e[36mtouch -d @$modtime \"$filename\"\e[0m"
                touch -d @$modtime "$filename"
                total=$[ $total + 1 ]
                if [ $[ $total % $filesnum ] = 0 ]
                then
                    echo -e "\e[36m rclone --low-level-retries=666 -vv --checksum --drive-chunk-size=128M --onedrive-chunk-size=100M move \"$absolutepath$1\" \"$gdrive$1\" \e[0m"
                    rclone --low-level-retries=666 -vv --checksum --drive-chunk-size=128M --onedrive-chunk-size=100M move "$absolutepath$1" "$gdrive$1"
                fi
            fi
        fi
    done
}

function naoto() {
    total=0
    echo "# current dir: $baseurl$1/"
    for list in `curl --globoff "$baseurl$1/" | grep "<li class=.* data-sort" | sed 's/li class="//g' | sed 's/" data-sort data-sort-name="/?/g' | sed 's/" data-sort-date="/?/g' | sed 's/" data-sort-size="/?/g' | sed 's/">//g' | sed 's/ /|/g'`; 
    do 
        list=`echo $list | sed 's/|/ /g'`; 
        delta=`echo $list | cut -d'?' -f1`; 
        filename=`echo $list | cut -d'?' -f2`; 
        modtime=`echo $list | cut -d'?' -f3`; 
        size=`echo $list | cut -d'?' -f4`; 
        # echo $delta
        if [ "$delta" = "<mdui-list-item file mdui-ripple" ]
        then
            # echo $filename
            # echo `date -d "@$modtime"`
            # echo $size
            # echo
            if [ -f "$filename" ] && [ ! -f "$filename.aria2" ]
            then
                echo -e "\e[36malready downloaded\e[0m"
            elif [ $size -lt $sizelimit ]
            then
                echo -e "\e[36m< $sizelimit bytes, skipped\e[0m"
            else
                echo -e "\e[36maria2c -s 128 -x 128 \"$baseurl$1/$filename\"\e[0m"
                aria2c -s 128 -x 128 "$baseurl$1/$filename"
                echo -e "\e[36mtouch -d @$modtime \"$filename\"\e[0m"
                touch -d @$modtime "$filename"
                total=$[ $total + 1 ]
                if [ $[ $total % $filesnum ] = 0 ]
                then
                    echo -e "\e[36m rclone --low-level-retries=666 -vv --checksum --drive-chunk-size=128M --onedrive-chunk-size=100M move \"$absolutepath$1\" \"$gdrive$1\" \e[0m"
                    rclone --low-level-retries=666 -vv --checksum --drive-chunk-size=128M --onedrive-chunk-size=100M move "$absolutepath$1" "$gdrive$1"
                fi
            fi
        fi
    done
}

if [ "$2" ]
then
    naoto "$1"
else
    chie "$1"
fi

echo -e "\e[36m rclone --low-level-retries=666 -vv --checksum --drive-chunk-size=128M --onedrive-chunk-size=100M move \"$absolutepath$1\" \"$gdrive$1\" \e[0m"
rclone --low-level-retries=666 -vv --checksum --drive-chunk-size=128M --onedrive-chunk-size=100M move "$absolutepath$1" "$gdrive$1"
