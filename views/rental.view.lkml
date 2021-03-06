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
    hidden: yes
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

########### Rental (Late/Outstanding) Logic ##############

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

  dimension: outstanding_rental {
    type: yesno
    sql: ${return_raw} IS NULL ;;
  }

  dimension: is_late {
    description: "Rental was out for over 7 days"
    type: yesno
    sql: ${rental_out_time} > 7;;
  }

  measure: count_of_late_rentals {
    type: count
    filters: {field: is_late
              value: "Yes"}
  }

  measure: percentage_of_late_rentals {
    type: number
    value_format_name: percent_2
    drill_fields: [rental.rental_raw, rental.rental_id, rental.is_late, customer.full_name, customer.email, payment.amount, film_category.name, film.title]
    sql: ${count_of_late_rentals} / NULLIF(${count},0) ;;
  }

############## Rental Sequencing ################

  dimension: user_rental_sequence_number {
    type: number
    sql: (
    SELECT COUNT(*)
    FROM rental r
    WHERE r.rental_id <= ${TABLE}.rental_id
    AND r.customer_id = ${TABLE}.customer_id
    ) ;;
  }

  dimension_group: first_rental {
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
    sql: (CASE
            WHEN ${user_rental_sequence_number} = 1 THEN ${rental_raw}
            ELSE 0
            END);;
  }

  dimension: is_first_rental {
    type: yesno
    sql: ${user_rental_sequence_number} = 1 ;;
  }

  measure: first_rental_count {
    type: count_distinct
    sql: ${rental_id} ;;
    drill_fields: [customer.full_name,customer.email,customer_facts.lifetime_rev,customer_facts.avg_rental_price,customer_facts.lifetime_rentals,customer_facts.first_rental_time,customer_facts.most_recent_rental_time,customer_facts.distinct_weeks_with_rentals,customer_facts.sign_up_raw]
    filters: {
      field: is_first_rental
      value: "Yes"
    }
  }

  measure: avg_rentals_to_100 {
    type: average
    value_format_name: decimal_0
    sql: ${user_rental_sequence_number} ;;
    filters: {field: payment.100_value_tipping_point
              value: "Yes"}
    drill_fields: [rental.rental_raw, rental.rental_id, rental.is_late, customer.full_name, customer.email, payment.amount, film_category.name, film.title]
  }

#   dimension: staff_id {
#     type: yesno
#     sql: ${TABLE}.staff_id ;;
#   }

  measure: count {
    type: count
    drill_fields: [rental_id, customer.first_name, customer.last_name, customer.customer_id, payment.count]
  }
}
