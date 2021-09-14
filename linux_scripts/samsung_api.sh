#!/bin/sh

adddate() {
    while IFS= read -r line; do
        echo '%s %s\n' "$(date "+%Y-%m-%d %H:%M:%S")" "$line";
    done
}

ip=ip_address
url="https://$ip/api/serverInfo"

echo "Cluster IP: $ip" >> adddate >> samsung.log
echo "curl -X GET --header 'Accept: application/json' -k $url" >> adddate >> samsung.log
curl -X GET --header 'Accept: application/json' -k $url >> samsung.json

N=0
echo "while [ $N -ne 1 ]" >> adddate >> samsung.log
while [ $N -lt 1 ]
do
   rm samsung.json
   echo "curl -X GET --header 'Accept: application/json' -k $url" >> adddate >> samsung.log
   curl -X GET --header 'Accept: application/json' -k $url
   curl -X GET --header 'Accept: application/json' -k $url >> samsung.json
   grep clusterState samsung.json >> adddate >> samsung.log
   if grep -o ACTIVE samsung.json
   then
   echo "Cluster state is ACTIVE !!" >> adddate >> samsung.log
   N=2
   else
   echo "sleeping for 10 sec" >> adddate >> samsung.log
   sleep 10
   fi
done

rm samsung.json
echo "Done" >> adddate >> samsung.log
