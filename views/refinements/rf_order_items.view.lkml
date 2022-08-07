include: "/views/raw/order_items.view.lkml"

view: +order_items {

  measure: count {
    label: "Total Number of Orders"
  }
  measure: total_revenue_from_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_profit_from_sales {
    type: number
    sql: ${total_revenue_from_sales} - ${products.total_cost_of_products};;
    value_format_name: usd
  }

}
