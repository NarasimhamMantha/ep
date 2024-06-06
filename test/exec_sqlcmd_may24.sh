sqlcmd -S $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD -d kafkaeunnprodsqldb0001 -q "delete_daily_trans_topics_data_sent_recv_retained; " < /dev/null


echo "Loading Uniq data into Dev Cluster"
pwd
echo Home $HOME
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_sent_dev   in  $HOME/test/dev_sentbytes_May2024_uniq_final.csv -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_recv_dev  in  $HOME/test/dev_receivedbytes_May2024_uniq_final.csv -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_retained_dev  in  $HOME/test/dev_retainedbytes_May2024_uniq_final.csv -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","

echo "Loading Uniq data into Test Pd Cluster"
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_sent_prod    in $HOME/test/prod_sentbytes_May2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_recv_prod   in $HOME/test/prod_receivedbytes_May2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_retained_prod   in $HOME/test/prod_retainedbytes_May2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","

echo "Loading Uniq data into Test PP  Cluster"
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_sent_prod_public   in $HOME/test/prod-public_sentbytes_May2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_recv_prod_public  in $HOME/test/prod-public_receivedbytes_May2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_retained_prod_public  in $HOME/test/prod-public_retainedbytes_May2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","


echo "==== exec update_daily_trans_topics_data_sent_recv_retained ====="
sqlcmd -S $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD -d kafkaeunnprodsqldb0001 -q "exec update_daily_trans_topics_data_sent_recv_retained; " < /dev/null

echo "deleting Old Daily data"
sqlcmd -S $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD -d kafkaeunnprodsqldb0001 -q "delete from daily_base;select * from daily_base; " < /dev/null

echo "Loading Connector KSQL DB Costs"
bcp kafkaeunnprodsqldb0001.dbo.daily_base in $HOME/test/Daily_May2024.csv -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","

echo "Updating Support and Topic Costs"
sqlcmd -S $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD -d kafkaeunnprodsqldb0001  -q "update daily_base set EnvironmentID='SUPPORT' , ResourceID='SUPPORT' , ResourceDisplayName='SUPPORT' where LineType='SUPPORT';Exec update_price_topic_cku;" < /dev/null 

