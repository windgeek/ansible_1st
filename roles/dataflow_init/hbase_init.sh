#!/bin/bash
su - hbase <<EOF
hbase shell <<TTTT
create_namespace 'file'
create_namespace  'k18_graph'
grant 'oss', 'RWXCA', '@file'
grant 'analy', 'RWXCA', '@file'
grant 'root', 'RWXCA', '@file'
grant 'k19', 'RWXCA', '@file'
grant 'k18', 'RWXCA', '@file'

grant 'oss', 'RWXCA', '@k18_graph'
grant 'analy', 'RWXCA', '@k18_graph'
grant 'root', 'RWXCA', '@k18_graph'
grant 'k19', 'RWXCA', '@k18_graph'
grant 'k18', 'RWXCA', '@k18_graph'

create 'file:ntc_oss_small_file', {NAME => 'sf', BLOOMFILTER => 'ROWCOL', VERSIONS => '1', IN_MEMORY => 'false', KEEP_DELETED_CELLS => 'FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => '7776000', COMPRESSION => 'NONE', MIN_VERSIONS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '65536', REPLICATION_SCOPE => '0'}，{NUMREGIONS => 6, SPLITALGO => 'HexStringSplit'}
quit
TTTT
EOF




su - hbase <<EOF
hbase shell <<TTTT
create 'file:bda_oss_small_file', {NAME => 'sf', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false', KEEP_DELETED_CELLS => 'FALSE', DATA_BLOCK_ENCODING => 'NONE', COMPRESSION => 'NONE', MIN_VERSIONS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '65536', REPLICATION_SCOPE => '0'}
quit
TTTT
EOF


#表授权
su - hbase <<EOF
hbase shell <<TTTT
grant 'oss', 'RWXCA', 'file:ntc_oss_small_file'
grant 'oss', 'RWXCA', 'file:bda_oss_small_file'
grant 'analy', 'RWXCA', 'file:ntc_oss_small_file'
grant 'analy', 'RWXCA', 'file:bda_oss_small_file'
grant 'root', 'RWXCA', 'file:ntc_oss_small_file'
grant 'root', 'RWXCA', 'file:bda_oss_small_file'
grant 'k19', 'RWXCA', 'file:ntc_oss_small_file'
grant 'k19', 'RWXCA', 'file:bda_oss_small_file'
grant 'k18', 'RWXCA', 'file:ntc_oss_small_file'
grant 'k18', 'RWXCA', 'file:bda_oss_small_file'


quit
TTTT
EOF

#创建https kafka2es数据流依赖表
su - hbase <<EOF
hbase shell << TTTT
create_namespace 'k18_media'
create 'k18_media:http_cache','cache'
quit
TTTT
EOF

#表授权
su - hbase <<EOF
hbase shell <<TTTT
grant 'k18', 'RWXCA', 'k18_media:http_cache'
quit
TTTT
EOF

