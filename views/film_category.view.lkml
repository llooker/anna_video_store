view: film_category {
  sql_table_name: sakila.film_category ;;

  dimension: category_id {
    hidden: yes
    type: yesno
    sql: ${TABLE}.category_id ;;
  }

  dimension: film_id {
    hidden: yes
    type: number
    sql: ${TABLE}.film_id ;;
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

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
