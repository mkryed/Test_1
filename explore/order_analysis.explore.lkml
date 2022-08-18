include: "/views/refinements/rf_order_items.view.lkml"
include: "/views/refinements/rf_products.view.lkml"
include: "/views/refinements/rf_users.view.lkml"

explore: order_items {
  label: "Order Analysis"
  fields: [order_items*,products*,users*]

  join: products {
    relationship: many_to_one
    type: inner
    sql_on: ${order_items.product_id}=${products.id} ;;
  }

  join: users {
    relationship: many_to_one
    type: inner
    sql_on: ${order_items.user_id}=${users.id} ;;

  }

}
