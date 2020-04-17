#!/usr/bin/env bash
curl -XPUT "http://localhost:9200/_template/k19_http_content_template" -H 'Content-Type: application/json' -d '
{
  "order": 0,
  "template": "k19_http_content_*",
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
      "number_of_shards": "48",
      "translog": {
        "flush_threshold_size": "2g"
      },
      "merge": {
        "scheduler": {
          "max_thread_count": "1"
        }
      },
      "analysis": {
        "filter": {
          "english_keywords": {
            "keywords": [
              ""
            ],
            "type": "keyword_marker"
          },
          "russian_stemmer": {
            "type": "stemmer",
            "language": "russian"
          },
          "english_stemmer": {
            "type": "stemmer",
            "language": "english"
          },
          "russian_stop": {
            "type": "stop",
            "stopwords": "_russian_"
          },
          "english_stop": {
            "type": "stop",
            "stopwords": "_english_"
          },
          "russian_keywords": {
            "keywords": [
              ""
            ],
            "type": "keyword_marker"
          },
          "english_possessive_stemmer": {
            "type": "stemmer",
            "language": "possessive_english"
          }
        },
        "analyzer": {
          "html_analyzer": {
            "filter": [
              "lowercase",
              "russian_stop",
              "russian_keywords",
              "russian_stemmer",
              "english_possessive_stemmer",
              "lowercase",
              "english_stop",
              "english_keywords",
              "english_stemmer"
            ],
            "char_filter": [
              "html_char_filter"
            ],
            "tokenizer": "standard"
          }
        },
        "char_filter": {
          "html_char_filter": {
            "type": "html_strip"
          }
        }
      },
      "number_of_replicas": "1"
    }
  },
  "mappings": {
    "html": {
      "properties": {
        "file_key": {
          "type": "keyword",
          "doc_values": false
        },
        "file_type": {
          "type": "keyword"
        },
        "cfg_id": {
          "type": "keyword"
        },
        "insert_time": {
          "type": "long"
        },
        "content_type": {
          "type": "keyword"
        },
        "region": {
          "type": "keyword"
        },
        "content": {
          "type": "text",
          "analyzer": "html_analyzer"
        },
        "website": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
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