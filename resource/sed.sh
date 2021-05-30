old=\\/ddd\\/docker
new=\\/var\\/lib
sed -i ""  "s/$old/$new/g"  daemon.json
