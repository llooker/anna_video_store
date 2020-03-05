view: payment {
  sql_table_name: sakila.payment ;;
  drill_fields: [payment_id]

  dimension: payment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.payment_id ;;
  }

  dimension: amount {
    type: number
    value_format_name: usd
    sql: ${TABLE}.amount ;;
  }

  measure: running_total {
    type: running_total
    value_format_name: usd
    sql: ${amount} ;;
  }

  measure: total_amount {
    type: sum
    value_format_name: usd
    drill_fields: [rental.rental_raw, rental.rental_id, rental.is_late, customer.full_name, customer.email, payment.amount, film_category.name, film.title]
    sql: ${amount} ;;
  }

  dimension: customer_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.customer_id ;;
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

  dimension_group: payment {
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
    sql: ${TABLE}.payment_date ;;
  }

  dimension: rental_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.rental_id ;;
  }

  dimension: staff_id {
    type: yesno
    sql: ${TABLE}.staff_id ;;
  }

############## Rental Sequencing ################

  dimension: user_rental_running_total {
    type: number
    value_format_name: usd
    sql: (
          SELECT SUM(amount)
          FROM payment p
          WHERE p.payment_id <= ${TABLE}.payment_id
          AND p.customer_id = ${TABLE}.customer_id
          ) ;;
  }

  measure: avg_user_rental_running_total {
    type: average
    sql: ${user_rental_running_total} ;;
  }

  dimension: previous_user_rental_running_total {
    type: number
    value_format_name: usd
    sql: (
          SELECT SUM(amount)
          FROM payment p
          WHERE p.payment_id < ${TABLE}.payment_id
          AND p.customer_id = ${TABLE}.customer_id
          ) ;;
  }

  dimension: 100_value_tipping_point {
    type: yesno
    sql: ${user_rental_running_total} >= 100 AND ${previous_user_rental_running_total} < 100;;
  }

  dimension_group: 100_value_tipping_point {
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
    sql: CASE
          WHEN ${100_value_tipping_point} = 'Yes' THEN ${payment_raw}
          ELSE NULL
          END;;
  }

  dimension: days_to_100 {
    type: number
    sql: DATEDIFF(${100_value_tipping_point_raw},${customer_facts.first_rental_raw}) ;;
  }

  measure: avg_days_to_100 {
    type: average
    value_format_name: decimal_2
    sql: ${days_to_100} ;;
  }

  measure: count_100_users {
    type: count
    filters: {field: 100_value_tipping_point
              value: "Yes"}
  }

  measure: percentage_100_users {
    type: number
    value_format_name: percent_2
    sql: ${count_100_users} / NULLIF(${customer.count},0) ;;
  }

  measure: count {
    type: count
    drill_fields: [payment_id, rental.rental_id, customer.first_name, customer.last_name, customer.customer_id]
  }
}
