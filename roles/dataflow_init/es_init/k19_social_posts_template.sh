#!/usr/bin/env bash
curl -XPUT "http://localhost:9200/_template/k19_social_posts_template" -H 'Content-Type: application/json' -d '

{
  "order": 0,
  "template": "k19_social_posts_*",
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
        "file_key": {
          "type": "keyword",
          "doc_values": false
        },
        "rulekey": {
          "type": "keyword"
        },
        "user_id": {
          "type": "keyword"
        },
        "user_name": {
          "type": "text"
        },
        "desc": {
          "type": "text"
        },
        "user_portrait": {
          "type": "keyword",
          "doc_values": false
        },
        "comment_id": {
          "type": "keyword",
          "doc_values": false
        },
        "content": {
          "type": "text"
        },
        "event_time": {
          "type": "long",
          "doc_values": false
        },
        "post_id": {
          "type": "keyword",
          "doc_values": false
        },
        "event_type": {
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