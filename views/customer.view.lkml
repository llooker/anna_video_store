view: customer {
  sql_table_name: sakila.customer ;;
  drill_fields: [customer_id]

  dimension: customer_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: active {
    type: yesno
    sql: ${TABLE}.active ;;
  }

  dimension: address_id {
    type: number
    sql: ${TABLE}.address_id ;;
  }

  dimension_group: create {
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
    sql: ${TABLE}.create_date ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    action: {
      label: "Email Promotion to Customer"
      url: "https://desolate-refuge-53336.herokuapp.com/posts"
      icon_url: "https://sendgrid.com/favicon.ico"
      param: {
        name: "some_auth_code"
        value: "abc123456"
      }
      form_param: {
        name: "Subject"
        required: yes
        default: "Thank you {{ customer.full_name._value }}"
      }
      form_param: {
        name: "Body"
        type: textarea
        required: yes
        default:
        "Dear {{ customer.full_name._value }},

        Thanks for your loyalty to the Look.  We'd like to offer you a 10% discount
        on your next rental!  Just use the code LOYAL when checking out!

        Your friends at Video Store"
      }
    }
}

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    type: string
    sql: CONCAT(${first_name},' ',${last_name}) ;;
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

  dimension: store_id {
    type: yesno
    # hidden: yes
    sql: ${TABLE}.store_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      customer_id,
      first_name,
      last_name,
      store.store_id,
      payment.count,
      rental.count
    ]
  }
}
