connection: "video_store"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project

explore: rental {
  label: "Anna Video Store"

  join: payment {
    type: left_outer
    relationship: one_to_one
    sql_on: ${rental.rental_id} = ${payment.rental_id} ;;
  }

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${rental.customer_id} = ${customer.customer_id} ;;
  }
}
