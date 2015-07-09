cd ~/.vim/bundle
for i in `ls`; do
    cd "$i"
    git pull
    cd ..
done
