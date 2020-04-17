#!/usr/bin/env bash
curl -XPUT "http://localhost:9200/_template/k19_http_default_template" -H 'Content-Type: application/json' -d '
{
  "order": 30,
  "template": "k19_*",
  "settings": {
    "index": {
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
          "default": {
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
            "tokenizer": "standard"
          }
        }
      }
    }
  },
  "mappings": {},
  "aliases": {}
}
'