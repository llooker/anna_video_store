view: customer_facts {
  derived_table: {
    sql: SELECT
          payment.customer_id AS CUSTOMER_ID
          , SUM(payment.AMOUNT) AS LIFETIME_REV
          , AVG(payment.AMOUNT) AS AVG_RENTAL_PRICE
          , COUNT(DISTINCT payment.RENTAL_ID) AS LIFETIME_RENTALS
          , MIN(payment.PAYMENT_DATE) AS FIRST_RENTAL
          , MAX(payment.PAYMENT_DATE) AS MOST_RECENT_RENTAL
          , COUNT(DISTINCT WEEK(PAYMENT_DATE)) AS DISTINCT_WEEKS_WITH_RENTALS
          , customer.CREATE_DATE AS SIGN_UP_DATE
          FROM payment
          LEFT JOIN customer ON payment.customer_id = customer.customer_id
          GROUP BY payment.customer_id
       ;;
  }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

  dimension: customer_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.CUSTOMER_ID ;;
  }

  dimension: lifetime_rev {
    type: number
    value_format_name: usd
    sql: ${TABLE}.LIFETIME_REV ;;
  }

  dimension: lifetime_rev_tier {
    type: tier
    tiers: [50, 75, 100, 125, 150]
    value_format_name: usd
    sql: ${lifetime_rev} ;;
    style: integer
  }

  measure: avg_lifetime_rev {
    value_format_name: usd
    type: average
    sql: ${lifetime_rev} ;;
  }

  dimension: avg_rental_price {
    value_format_name: usd
    type: number
    sql: ${TABLE}.AVG_RENTAL_PRICE ;;
  }

  dimension: lifetime_rentals {
    type: number
    sql: ${TABLE}.LIFETIME_RENTALS ;;
  }

  dimension: lifetime_rentals_tier {
    type: tier
    tiers: [0, 1, 2, 3, 5, 10]
    sql: ${lifetime_rentals} ;;
    style: integer
  }

  dimension: distinct_weeks_with_rentals {
    type: number
    sql: ${TABLE}.DISTINCT_WEEKS_WITH_RENTALS ;;
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
    sql: ${TABLE}.FIRST_RENTAL ;;
  }

  dimension_group: most_recent_rental {
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
    sql: ${TABLE}.MOST_RECENT_RENTAL ;;
  }

  dimension_group: sign_up {
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
    sql: ${TABLE}.SIGN_UP_DATE ;;
  }

  dimension: weeks_as_customer {
    description: "Weeks between first and latest order"
    type: number
    value_format_name: decimal_0
    sql: (DATEDIFF(${most_recent_rental_raw},${first_rental_raw})+1) / 7 ;;
  }

  dimension: weeks_as_customer_tiered {
    type: tier
    tiers: [10,30]
    sql: ${weeks_as_customer} ;;
    style: integer
  }

  dimension: days_as_customer {
    description: "Days between first and latest order"
    type: number
    value_format_name: decimal_0
    sql: (DATEDIFF(${most_recent_rental_raw},${first_rental_raw})+1) ;;
  }

  set: detail {
    fields: [
      customer_id,
      lifetime_rev,
      avg_rental_price,
      lifetime_rentals,
      first_rental_time,
      most_recent_rental_time,
      distinct_weeks_with_rentals,
      sign_up_raw
    ]
  }
}
