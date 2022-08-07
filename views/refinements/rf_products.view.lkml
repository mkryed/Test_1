include: "/views/raw/products.view.lkml"

view: +products {

  measure: count {
    label: "Total Number of Products"
  }

  measure: total_cost_of_products {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

}
