#!/bin/bash
# copyrekt die deutsche Orthopädiespezialist 2018
# a MUCH quicker onedrive downloader than rclone
# usin' oneindex (https://github.com/donwa/oneindex) website's information to get directory structure, download files usin' aria2c (need a thread hacked version), and set modified time right
# here we fockin' go
baseurl="" # your oneindex website's root
absolutepath=`pwd`
mkdir "$absolutepath$1"

function chie() #aug: /
{
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
            chie "$1/$filename" 
            echo -e "\t\e[36mend of $f\e[0m"
            echo
        fi
    done
}

function chie() #aug: /
{
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
            f="$filename"
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
            # echo
        else
            # echo $filename
            # echo `date -d "@$modtime"`
            # echo $size
            # echo
            echo -e "\e[36maria2c -s 128 -x 128 \"$baseurl$1/$filename\"\e[0m"
            if [ -f "$filename" ] && [ ! -f "$filename.aria2" ]
            then
                echo -e "\e[36malready downloaded\e[0m"
            else
                aria2c -s 128 -x 128 "$baseurl$1/$filename"
            fi
            echo -e "\e[36mtouch -d @$modtime \"$filename\"\e[0m"
            touch -d @$modtime "$filename"
        fi
    done
}

chie "$1"
