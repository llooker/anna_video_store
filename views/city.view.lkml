view: city {
  sql_table_name: sakila.city ;;
  drill_fields: [city_id]

  dimension: city_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.city_id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_id {
    hidden: yes
    type: number
    sql: ${TABLE}.country_id ;;
  }

#   dimension_group: last_update {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: ${TABLE}.last_update ;;
#   }
#
#   measure: count {
#     type: count
#     drill_fields: [city_id]
#   }
}
