#!/bin/bash
# Goal: clear DSSAT FILE


# step 1 - remove 6th line

for file in *.WTH;
    do
    sed '6d' "${file}" > "${file}a"
done	

# step 2 - remove first char from lines it was started with "space"8or9or0or1

for file in *.WTHa;
    do
    sed '/^ [8,9,0,1]/s/ //1'   "${file}" > "${file}b"
done

# step 3 - rename file 

for file in *.WTHab
    do
    mv "${file}" "${file/%.WTHab/.WTH}"
done

# step 4 - remove files *WTHa

find ./  -maxdepth 1  -name '*.WTHa' | xargs rm
