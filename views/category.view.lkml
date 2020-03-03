view: category {
  sql_table_name: sakila.category ;;
  drill_fields: [category_id]

  dimension: category_id {
    primary_key: yes
    hidden: yes
    type: yesno
    sql: ${TABLE}.category_id ;;
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

  dimension: name {
    label: "Category"
    type: string
    sql: ${TABLE}.name ;;
  }

  measure: count {
    label: "Count of Category"
    type: count
    drill_fields: [category_id, name]
  }
}
