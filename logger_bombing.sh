counter=1
stop=true
while $stop;
do
   logger This is number $counter writing to the log
   counter=$((counter+1))
   if [[ $counter -gt 100 ]]; then
       stop=false
   fi
done
