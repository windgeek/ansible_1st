#!/usr/bin/env bash
curl -XPUT "http://localhost:9200/_template/k19_social_profile_template" -H 'Content-Type: application/json' -d '
{
	"order": 0,
	"template": "k19_social_profile_*",
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
						"pattern": ".",
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
				"name": {
					"type": "text"
				},
				"sn": {
					"type": "keyword",
					"doc_values": false
				},
				"uid": {
					"type": "keyword",
					"doc_values": false
				},
				"user_type": {
					"type": "keyword"
				},
				"phone_number": {
					"type": "keyword",
					"doc_values": false
				},
				"mail": {
					"analyzer": "sign_analyzer",
					"type": "text",
					"fields": {
						"keyword": {
							"type": "keyword"
						}
					}
				},
				"birthday": {
					"type": "keyword",
					"doc_values": false
				},
				"gender": {
					"type": "keyword",
					"doc_values": false
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