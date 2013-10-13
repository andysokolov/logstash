#curl -XPUT 'http://libraryweb.kumc.edu:9200/_river/logstash/_meta' -d '{
#    "type" : "rabbitmq",
#    "rabbitmq" : {
#        "host" : "libraryweb",
#        "port" : 5672,
#        "user" : "guest",
#        "pass" : "guest",
#        "vhost" : "/",
#        "queue" : "elasticsearch",
#        "exchange" : "elasticsearch",
#        "routing_key" : "logstash.#",
#        "exchange_declare" : true,
#        "exchange_type" : "direct",
#        "exchange_durable" : true,
#        "queue_declare" : true,
#        "queue_bind" : true,
#        "queue_durable" : true,
#        "queue_auto_delete" : false,
#        "heartbeat" : "30m"
#    },
#    "index" : {
#        "bulk_size" : 100,
#        "bulk_timeout" : "10ms",
#        "ordered" : false
#    }
#}'

curl -XPUT http://libraryweb.kumc.edu:9200/_template/logstash_per_index -d '
{
    "template" : "logstash*",
    "settings" : {
        "number_of_shards" : 4,
        "index.cache.field.type" : "soft",
        "index.refresh_interval" : "5s",
        "index.store.compress.stored" : true,
        "index.query.default_field" : "@message",
        "index.routing.allocation.total_shards_per_node" : 4
    },
    "mappings" : {
        "_default_" : {
            "_all" : {"enabled" : false},
            "properties" : {
               "@fields" : {
                    "type" : "object",
                    "dynamic": true,
                    "path": "full",
                    "properties" : {
                        "clientip" : { "type": "ip" },
                        "geoip" : {
                            "type" : "object",
                            "dynamic": true,
                            "path": "full",
                            "properties" : {
                                    "area_code" : { "type": "string", "index": "not_analyzed" },
                                    "city_name" : { "type": "string", "index": "not_analyzed" },
                                    "continent_code" : { "type": "string", "index": "not_analyzed" },
                                    "country_code2" : { "type": "string", "index": "not_analyzed" },
                                    "country_code3" : { "type": "string", "index": "not_analyzed" },
                                    "country_name" : { "type": "string", "index": "not_analyzed" },
                                    "dma_code" : { "type": "string", "index": "not_analyzed" },
                                    "ip" : { "type": "string", "index": "not_analyzed" },
                                    "latitude" : { "type": "float", "index": "not_analyzed" },
                                    "longitude" : { "type": "float", "index": "not_analyzed" },
                                    "metro_code" : { "type": "float", "index": "not_analyzed" },
                                    "postal_code" : { "type": "string", "index": "not_analyzed" },
                                    "region" : { "type": "string", "index": "not_analyzed" },
                                    "region_name" : { "type": "string", "index": "not_analyzed" },
                                    "timezone" : { "type": "string", "index": "not_analyzed" }
                            }
                        },
                        "target_host" : {
                          "type" : "multi_field",
                          "fields" : {
                             "target_host" : {"type" : "string", "index" : "analyzed"},
                             "target_host_untouched" : {"type" : "string", "index" : "not_analyzed"}
                          }
                        }
                    }
               },
               "@message": { "type": "string", "index": "analyzed" },
               "@source": { "type": "string", "index": "not_analyzed" },
               "@source_host": { "type": "string", "index": "not_analyzed" },
               "@source_path": { "type": "string", "index": "not_analyzed" },
               "@tags": { "type": "string", "index": "not_analyzed" },
               "@timestamp": { "type": "date", "index": "not_analyzed" },
               "@type": { "type": "string", "index": "not_analyzed" }
            }
        }
    }

}
'
