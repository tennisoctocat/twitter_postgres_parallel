#!/bin/sh

files=$(find data/*)

echo '================================================================================'
echo 'load pg_denormalized'
echo '================================================================================'
# time for file in $files; do
#     ./load_denormalized.sh "$file"
#    unzip -p "$file" | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:1277/ -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
# done

time echo "$files" | parallel ./load_denormalized.sh

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
time echo "$files" | parallel python3 -u load_tweets.py --db=postgresql://postgres:pass@localhost:2277/ --inputs

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
# echo "$files" | time parallel python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:3277/ --inputs
