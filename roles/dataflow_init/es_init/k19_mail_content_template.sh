#!/usr/bin/env bash
curl -XPUT "http://localhost:9200/_template/k19_mail_content_template" -H 'Content-Type: application/json' -d '

{
  "order": 0,
  "template": "k19_mail_content_*",
  "settings": {
    "index": {
      "search": {
        "slowlog": {
          "threshold": {
            "fetch": {
              "debug": "100ms"
            },
            "query": {
              "debug": "5s"
            }
          }
        }
      },
      "refresh_interval": "5s",
      "indexing": {
        "slowlog": {
          "threshold": {
            "index": {
              "info": "50ms"
            }
          }
        }
      },
      "number_of_shards": "5",
      "translog": {
        "flush_threshold_size": "2g"
      },
      "merge": {
        "scheduler": {
          "max_thread_count": "1"
        }
      },
      "analysis": {
        "analyzer": {
          "sign_analyzer": {
            "char_filter": [
              "dot_pattern_filter",
              "underline_pattern_filter"
            ],
            "tokenizer": "standard"
          }
        },
        "char_filter": {
          "dot_pattern_filter": {
            "pattern": "\\.",
            "type": "pattern_replace",
            "replacement": " "
          },
          "underline_pattern_filter": {
            "pattern": "_",
            "type": "pattern_replace",
            "replacement": " "
          }
        }
      },
      "number_of_replicas": "1"
    }
  },
  "mappings": {
    "eml": {
      "properties": {
        "file_key": {
          "type": "keyword",
          "doc_values": false
        },
        "eml_download_path": {
          "type": "keyword",
          "doc_values": false
        },
        "send_time": {
          "type": "long"
        },
        "subject": {
          "type": "text"
        },
        "insert_time": {
          "type": "long"
        },
        "message_id": {
          "type": "keyword",
          "doc_values": false
        },
        "from": {
          "analyzer": "sign_analyzer",
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        },
        "to": {
          "analyzer": "sign_analyzer",
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        },
        "cc": {
          "analyzer": "sign_analyzer",
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        },
        "bcc": {
          "analyzer": "sign_analyzer",
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        },
        "region": {
          "type": "keyword"
        },
        "attachFlag": {
          "type": "long"
        },
        "attachmentStr": {
          "analyzer": "sign_analyzer",
          "type": "text"
        },
        "attachmentList": {
          "type": "nested",
          "include_in_parent": true,
          "properties": {
            "attachmentName": {
              "analyzer": "sign_analyzer",
              "type": "text"
            },
            "contentType": {
              "type": "keyword"
            }
          }
        },
        "content": {
          "type": "text"
        },
        "s_ip": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
        },
        "d_ip": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
        },
        "s_port": {
          "type": "keyword"
        },
        "d_port": {
          "type": "keyword"
        },
        "found_time": {
          "type": "long"
        },
        "account": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
        }
      }
    }
  },
  "aliases": {}
}
'