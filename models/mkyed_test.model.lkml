connection: "looker_partner_demo"

include: "/views/*/*"
include: "/explore/*"


datagroup: mkyed_test_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mkyed_test_default_datagroup
