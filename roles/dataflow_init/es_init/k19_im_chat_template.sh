#!/usr/bin/env bash
curl -XPUT "http://localhost:9200/_template/k19_im_chat_template" -H 'Content-Type: application/json' -d '

{
  "order": 0,
  "template": "k19_im_chat_*",
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
            "tokenizer": "standard"
          }
        }
      },
      "number_of_replicas": "1"
    }
  },
  "mappings": {
    "http": {
      "properties": {
        "type": {
          "type": "keyword"
        },
        "category": {
          "type": "keyword",
          "doc_values": false
        },
        "action": {
          "type": "keyword",
          "doc_values": false
        },
        "device_type": {
          "type": "keyword"
        },
        "insert_time": {
          "type": "long"
        },
        "region": {
          "type": "keyword"
        },
        "uuid": {
          "type": "keyword",
          "doc_values": false
        },
        "others": {
          "type": "keyword",
          "doc_values": false
        },
        "from_user_name": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        },
        "from_user_id": {
          "type": "keyword"
        },
        "to_user_name": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        },
        "to_user_id": {
          "type": "keyword"
        },
        "content": {
          "type": "text"
        },
        "message_id": {
          "type": "keyword",
          "doc_values": false
        },
        "event_time": {
          "type": "long",
          "doc_values": false
        },
        "chat_mode": {
          "type": "keyword"
        },
        "locale": {
          "type": "keyword"
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