function pixiv {
    f=`curl "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=$1" | sed 's/;/\n;/g' | grep ";pixiv.context.ugokuIllustData"`
    lastframe=`echo $f | sed 's/,{/\n/g' | grep "}]}" | grep -Eo "[0-9]*.jpg" | grep -Eo "[0-9]*"`
    imglink=`echo $f | sed 's/,/\n/g' | sed 's/\\\//g'  | grep "src" | sed  's/"/\n/g' | grep "https" | sed 's/img-zip-ugoira/img-original/g' | sed 's/_ugoira.*.zip/_ugoira/g'`
    fish=0
    if [ `curl -o /dev/null -sL -H "Referer: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=23333333" -w "%{http_code}" "$imglink$fish.jpg"` = "404" ]
    then
        ext=".png"
    else
        ext=".jpg"
    fi
    mkdir $1
    cd $1
    for nein in `seq 0 $lastframe`
    do
        echo -e "downloadin' \e[36m$imglink$nein$ext\e[0m"
        wget --header="Referer: https://www.pixiv.net/member_illust.php?mode=medium&illust_id=23333333" "$imglink$nein$ext";
    done
    # ffmpeg -r 10 -i "$1_ugoira%d$ext" -vcodec libx264 "$1.mp4"
    # ffmpeg -r 10 -i "$1_ugoira%d$ext" -vcodec libx264 -pix_fmt yuv420p "$1.old.mp4" # for outdated media players
    cd ..
    # rar a -df -htb -m0 -ma5 -rr5 -ts -ol "$1.rar" "$1"
}

if [ "$2" = "-f" ]
then
    for neinfish in `cat $1`
    do
        pixiv "$neinfish"
    done
else
    pixiv "$1"
fi
