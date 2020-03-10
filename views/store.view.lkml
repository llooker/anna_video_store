view: store {
  sql_table_name: sakila.store ;;
  drill_fields: [store_id]

  dimension: store_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.store_id ;;
  }

  dimension: store_name {
    type: string
    sql: CASE
          WHEN ${store_id} = 1 THEN 'Store A'
          WHEN ${store_id} = 2 THEN 'Store B'
          ELSE NULL
          END;;
  }

  dimension: address_id {
    type: number
    sql: ${TABLE}.address_id ;;
  }

  dimension_group: last_update {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_update ;;
  }

  dimension: manager_staff_id {
    type: yesno
    sql: ${TABLE}.manager_staff_id ;;
  }

  measure: count {
    type: count
    drill_fields: [store_id, customer.count]
  }
}
