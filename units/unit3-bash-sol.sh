# challenge 1

echo "There are $(grep -o "bash" unit3-bash.sh | wc -l) uses of 'bash' in unit2-bash.sh."

# Note that "grep -c" counts the number of lines so if 'bash' occurs multiple times in a line, you'd get the wrong answer

# you can also create a variable and then use that in 'echo'

num=$(grep -o "bash" unit3-bash.sh | wc -l)
echo "There are ${num} uses of 'bash' in unit3-bash.sh."

function count() {
    num=$(grep -o "$1" $2 | wc -l)
    echo "There are ${num} uses of '$1' in $2."
}

# challenge 2, parts 1-2
grep Belgium cpds.csv  | cut -d',' -f 6 | sort -n | head -n 1
echo "Belgium $(grep Belgium cpds.csv  | cut -d',' -f 6 | sort -n | head -n 1)"

# challenge 2, part 3
countries=$(tail -n +2 cpds.csv | cut -d"," -f2 | sort | uniq | sed 's/\"//g' | sed 's/ /_/g')
# use of tail gets rid of 'country'

# challenge 2, part 4
for c in $countries; do
   echo "$c $(grep $c cpds.csv  | cut -d',' -f 6 | sort -n | head -n 1)"
done

# challenge 2, part 5
for c in $countries; do
   echo "$c $(grep $c cpds.csv  | cut -d',' -f 6 | sort -n | head -n 1)" >> mingdp.txt
done

# challenge 3
cut -d"," -f4 RTADataSub.csv | sort | uniq | grep "[^0-9,\.]"

# challenge 3, second part
nfields=$(tail -n 1 RTADataSub.csv | grep -o "," | wc -l)
nfields=$(echo "${nfields}+1" | bc)

for(( i=2; i<=${nfields}; i++ )); do
    echo "non-numeric values found in field number $i:"
    cut -d"," -f${i} RTADataSub.csv | sort | uniq | grep "[^0-9,\.]"
done

# challenge 4
echo '1,"America, United States of",45,96.1,"continental, coastal"' > file.csv
echo '2,"France",33,807.1,"continental, coastal"' >> file.csv

sed 's/, /% /g' file.csv | sed 's/,/|/g' | sed 's/%/,/g' > file2.csv



