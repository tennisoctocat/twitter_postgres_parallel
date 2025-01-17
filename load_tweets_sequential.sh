#!/bin/sh

files=$(find data/*)

echo '================================================================================'
echo 'load denormalized'
echo '================================================================================'
time ./load_denormalized_loop.sh "$files"
#for file in $files; do
#    time unzip -p "$file" | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:1277/ -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
#done

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
time python3 -u load_tweets.py --db=postgresql://postgres:pass@localhost:2277/ --inputs $files
#for file in $files; do
#    python3 -u load_tweets.py --db=postgresql://postgres:pass@localhost:2277/ --inputs $file
#done
echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
time python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:3277/ --inputs $files
