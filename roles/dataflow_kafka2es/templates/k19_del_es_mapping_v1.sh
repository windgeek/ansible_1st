#!/usr/bin/env bash
base_rest_url=${1}
echo 'ip port:'${base_rest_url}
echo '   '
curl -XDELETE ${base_rest_url}/_template/default_template
echo 'default_template del success!!!'
echo '  '
curl -XDELETE ${base_rest_url}/_template/mail_content_template
echo '     '
echo 'mail_content_template del success'
curl -XDELETE ${base_rest_url}/_template/http_content_template
echo '     '
echo 'http_content_template del success'
