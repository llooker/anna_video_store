view: rental {
  sql_table_name: sakila.rental ;;
  drill_fields: [rental_id]

  dimension: rental_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.rental_id ;;
  }

  dimension: customer_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension: inventory_id {
    type: number
    sql: ${TABLE}.inventory_id ;;
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

  dimension_group: rental {
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
    sql: ${TABLE}.rental_date ;;
  }

  dimension_group: return {
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
    sql: ${TABLE}.return_date ;;
  }

  dimension: rental_out_time {
    type: number
    sql:  CASE
      WHEN ${return_raw} IS NOT NULL THEN DATEDIFF(${return_raw},${rental_raw})
      WHEN ${return_raw} IS NULL THEN DATEDIFF(${rental_raw},CURRENT_DATE())
      ELSE NULL
      END;;
  }

  measure: avg_rental_time {
    type: average
    sql: ${rental_out_time} ;;
  }

  dimension: is_late {
    type: yesno
    sql: ${rental_out_time} > 7;;
  }



  dimension: staff_id {
    type: yesno
    sql: ${TABLE}.staff_id ;;
  }

  measure: count {
    type: count
    drill_fields: [rental_id, customer.first_name, customer.last_name, customer.customer_id, payment.count]
  }
}
