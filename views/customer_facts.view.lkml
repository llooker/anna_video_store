view: customer_facts {
  derived_table: {
    sql: SELECT
          payment.customer_id AS CUSTOMER_ID
          , SUM(payment.AMOUNT) AS LIFETIME_REV
          , AVG(payment.AMOUNT) AS AVG_RENTAL_PRICE
          , COUNT(DISTINCT payment.RENTAL_ID) AS LIFETIME_ORDERS
          , MIN(payment.PAYMENT_DATE) AS FIRST_RENTAL
          , MAX(payment.PAYMENT_DATE) AS MOST_RECENT_RENTAL
          , COUNT(DISTINCT WEEK(PAYMENT_DATE)) AS DISTINCT_WEEKS_WITH_RENTALS
          , WEEK(customer.CREATE_DATE) AS SIGN_UP_WEEK
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
    type: number
    sql: ${TABLE}.CUSTOMER_ID ;;
  }

  dimension: lifetime_rev {
    type: number
    sql: ${TABLE}.LIFETIME_REV ;;
  }

  dimension: avg_rental_price {
    type: number
    sql: ${TABLE}.AVG_RENTAL_PRICE ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.LIFETIME_ORDERS ;;
  }

  dimension_group: first_rental {
    type: time
    sql: ${TABLE}.FIRST_RENTAL ;;
  }

  dimension_group: most_recent_rental {
    type: time
    sql: ${TABLE}.MOST_RECENT_RENTAL ;;
  }

  dimension: distinct_weeks_with_rentals {
    type: number
    sql: ${TABLE}.DISTINCT_WEEKS_WITH_RENTALS ;;
  }

  dimension: sign_up_week {
    type: number
    sql: ${TABLE}.SIGN_UP_WEEK ;;
  }

  set: detail {
    fields: [
      customer_id,
      lifetime_rev,
      avg_rental_price,
      lifetime_orders,
      first_rental_time,
      most_recent_rental_time,
      distinct_weeks_with_rentals,
      sign_up_week
    ]
  }
}
