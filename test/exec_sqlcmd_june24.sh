echo pwd: `pwd`
sqlcmd -S $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD -d kafkaeunnprodsqldb0001 -q "delete_daily_trans_topics_data_sent_recv_retained; " < /dev/null


echo "Loading Uniq data into Dev Cluster"
pwd
echo Home $HOME
cd /home/runner/work/ep/ep/test
pwd
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_sent_dev      in  dev_sentbytes_June2024_uniq_final.csv -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_recv_dev      in  dev_receivedbytes_June2024_uniq_final.csv -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_retained_dev  in  dev_retainedbytes_June2024_uniq_final.csv -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","

echo "Loading Uniq data into Test Pd Cluster"
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_sent_prod       in prod_sentbytes_June2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_recv_prod       in prod_receivedbytes_June2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_retained_prod   in prod_retainedbytes_June2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","

echo "Loading Uniq data into Test PP  Cluster"
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_sent_prod_public      in prod-public_sentbytes_June2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_recv_prod_public      in prod-public_receivedbytes_June2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
bcp kafkaeunnprodsqldb0001.dbo.daily_trans_topics_data_retained_prod_public  in prod-public_retainedbytes_June2024_uniq_final.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","

bcp kafkaeunnprodsqldb0001.dbo.daily_base  in  Daily_June2024.csv  -S  $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD  -q -c -t ","
echo "==== exec update_daily_trans_topics_data_sent_recv_retained ====="
sqlcmd -S $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD -d kafkaeunnprodsqldb0001 -q "exec update_daily_trans_topics_data_sent_recv_retained; " < /dev/null


echo "Updating Support and Topic Costs"
sqlcmd -S $SQL_SERVER -U $SQL_USER -P $SQL_PASSWORD -d kafkaeunnprodsqldb0001  -q "update daily_base set EnvironmentID='SUPPORT' , ResourceID='SUPPORT' , ResourceDisplayName='SUPPORT' where LineType='SUPPORT';Exec update_price_topic_cku;" < /dev/null 

