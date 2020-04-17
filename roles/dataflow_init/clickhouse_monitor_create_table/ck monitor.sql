CREATE DATABASE IF NOT EXISTS k19_monitor;


CREATE TABLE k19_monitor.k19_dm_log_monitor_local ( time_string String,  time_second Int64,  ip String,  region String,  action String,  file_name String,  file_size Int64,  uuid String,  data_type String) ENGINE = MergeTree PARTITION BY toRelativeDayNum(toDateTime(time_second)) ORDER BY time_second SETTINGS index_granularity = 8192;



CREATE TABLE k19_monitor.ntc_log_count_monitor_day ( table String,  eventtime DateTime,  datatime DateTime,  count Int64) ENGINE = ReplacingMergeTree(eventtime) PARTITION BY toRelativeDayNum(toDateTime(datatime)) ORDER BY (datatime, table) SETTINGS index_granularity = 8192;



CREATE TABLE k19_monitor.ntc_log_count_monitor_hour ( table String,  eventtime DateTime,  datatime DateTime,  count Int64) ENGINE = ReplacingMergeTree(eventtime) PARTITION BY toRelativeDayNum(toDateTime(datatime)) ORDER BY (datatime, table) SETTINGS index_granularity = 8192;