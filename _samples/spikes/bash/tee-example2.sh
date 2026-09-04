#!/bin/bash

# issue _sample_repos/dataverse/scripts/issues/6510/check_datafiles_6522_6510.sh

if [ $NUM_CONFIRMED == 0 ]
then
    echo 
else
    cat /tmp/storageidentifiers.tmp | while read si
    do
        :
    done | tee PROBLEM.IS.HERE
    echo "We apologize for any inconvenience."   
fi

${PSQL_EXEC} -h ${pg_host} -U ${pg_user} -d ${pg_db} -tA -F ' ' -c "${PG_QUERY_4}" |
uniq -c -f 1 | 
awk '{if ($1 > 1) print $NF}' > /tmp/datafileids.tmp

if [ $NUM_CONFIRMED == 0 ]
then
    :
fi



