CREATE DATABASE IF NOT EXISTS zt;

 //-----------------------------------------------------------------------------------------------------
 
 DROP TABLE IF EXISTS zt.cdr_local;

  CREATE TABLE zt.cdr_local (
  record_type String,
  record_id String,
  found_time Int64,
  calling_party_number String,
  called_party_number String,
  redirecting_number String,
  call_id_number String,
  supplementary_services String,
  cause String,
  calling_party_category String,
  call_duration String,
  call_status String,
  connected_number String,
  imsi_calling String,
  imei_calling String,
  imsi_called String,
  imei_called String,
  msisdn_calling String,
  msisdn_called String,
  msc_number String,
  vlr_number String,
  location_lac String,
  location_cell String,
  forwarding_reason String,
  roaming_number String,
  ss_code String,
  ussd String,
  operator_id String,
  date_and_time Int64,
  call_direction String,
  ll String
) ENGINE = MergeTree PARTITION BY toRelativeHourNum(toDateTime(found_time))
ORDER BY
  found_time SETTINGS index_granularity = 8192;
  
  //-----------------------------------------------------------------------------------------------------------------
  
   DROP TABLE IF EXISTS zt.email ;
   
  CREATE TABLE zt.email (
  found_time Int64,
  msisdn_calling String,
  protocol String,
  source_ip String,
  source_port Int64,
  dst_ip String,
  dst_port Int64,
  msg_id Int64,
  subject String,
  from
    String,
    to String,
    reply_to String,
    cc String,
    bcc String,
    received String,
    return_path String,
    comments String,
    in_reply_to String,
    content_type String,
    filenames String
) ENGINE = MergeTree PARTITION BY toRelativeHourNum(toDateTime(found_time))
ORDER BY
  found_time SETTINGS index_granularity = 8192;
  
  //-----------------------------------------------------------------------------------------------------------------
  
   DROP TABLE IF EXISTS zt.http_local ;
   
  CREATE TABLE zt.http_local (
  action Int64,
  version Int64,
  uri String,
  domain String,
  found_time Int64,
  msisdn String,
  source_ip String
) ENGINE = MergeTree PARTITION BY toRelativeHourNum(toDateTime(found_time))
ORDER BY
  found_time SETTINGS index_granularity = 8192;
  
  
  //-----------------------------------------------------------------------------------------------------------------
  
   DROP TABLE IF EXISTS zt.loc_local;
   
  CREATE TABLE zt.loc_local (
  msisdn String,
  lac Int64,
  cell Int64,
  found_time Int64,
  loc_type Int64,
  imsi String,
  imei String,
  ll String,
  switchgear_type String
) ENGINE = MergeTree PARTITION BY toRelativeHourNum(toDateTime(found_time))
ORDER BY
  found_time SETTINGS index_granularity = 8192;
 
 