# RandomShellScripts

## chie.sh

due to onedrive's shitty arse download speed, every time usin' rclone to transfer from onedrive to google drive, google drive will say "i/o timeout", esp. for large files; so i made this shit to download onedrive files manually and upload them later; now not only no more "i/o timeout", but also speed will be more than 10x faster, GREAT GREAT GREAT

由于onedrive捉鸡的下载速度，每次用rclone从onedrive往google drive转东西时，google drive都会报错“i/o timeout”，尤其是大文件；所以我写了这个脚本来先将onedrive的文件下下来再传google drive，现在不仅再也不会报错，速度也快了十倍不止

it's much better to deal with large files (>100MB) than smaller ones, you can leave smaller files to `rclone sync`, since this shitty arse script lacks a lotta things like ignore already uploaded files (it's way more than what bash can do)

最好用这个脚本处理大文件（>100MB），小文件就留给`rclone sync`好了，因为这个破脚本缺很多东西，比如跳过已经处理的文件（这超出了bash可以实现的功能）

Requirements: Oneindex (https://github.com/donwa/oneindex) installed, and set your $baseurl to the home page of your Oneindex site, and set theme to "material"; better clear cache and set cache refresh time shorter than short hair of short haired cutie with glasses

需求：安装Oneindex (https://github.com/donwa/oneindex) ，将$baseurl设成Oneindex站的主页，并将主题设成“material”；最好清一遍缓存，并将缓存失效时间设置得比短发眼镜妹的短发还要短
