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

  dimension_group: created {
    hidden: no
    timeframes: [
      raw,
      time,
      date,
      day_of_year,
      day_of_week,
      day_of_week_index,
      day_of_month,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      quarter,
      quarter_of_year,
      year
    ]
}

  dimension: is_ytd {
    type: yesno
    sql:
          EXTRACT( DAYOFYEAR from ${created_raw} ) < EXTRACT( DAYOFYEAR from current_timestamp() )
        OR
          (
          EXTRACT( DAYOFYEAR from ${created_raw} ) = EXTRACT( DAYOFYEAR from current_timestamp() )
            AND
          EXTRACT( HOUR from ${created_raw} ) < EXTRACT( HOUR from current_timestamp() )
          )
        OR
        (
          EXTRACT( DAYOFYEAR from ${created_raw} ) = EXTRACT( DAYOFYEAR from current_timestamp() )
            AND
          EXTRACT( HOUR from ${created_raw} ) <= EXTRACT( HOUR from current_timestamp() )
            AND
          EXTRACT( MINUTE from ${created_raw} ) < EXTRACT( MINUTE from current_timestamp() )
        )
        ;;
  }

  dimension: is_mtd {
    type: yesno
    sql:
         EXTRACT( DAY from ${created_raw} ) < EXTRACT( DAY from current_timestamp() )
      OR
        (
        EXTRACT( DAY from ${created_raw} ) <= EXTRACT( DAY from current_timestamp() )
            AND
        EXTRACT( HOUR from ${created_raw} ) < EXTRACT( HOUR from current_timestamp() )
        )
      OR
        (
        EXTRACT( DAY from ${created_raw} ) <= EXTRACT( DAY from current_timestamp() )
            AND
        EXTRACT( HOUR from ${created_raw} ) <= EXTRACT( HOUR from current_timestamp() )
            AND
        EXTRACT( MINUTE from ${created_raw} ) < EXTRACT( MINUTE from current_timestamp() )
        )
        ;;
  }

  dimension: is_qtd {
    type: yesno
    sql:
         EXTRACT( QUARTER from ${created_raw} ) < EXTRACT( QUARTER from current_timestamp() )
      OR
        (
        EXTRACT( QUARTER from ${created_raw} ) = EXTRACT( QUARTER from current_timestamp() )
            AND
        EXTRACT( DAY from ${created_raw} ) < EXTRACT( DAY from current_timestamp() )
        )
      OR
        (
        EXTRACT( QUARTER from ${created_raw} ) = EXTRACT( QUARTER from current_timestamp() )
            AND
        EXTRACT( DAY from ${created_raw} ) <= EXTRACT( DAY from current_timestamp() )
            AND
        EXTRACT( HOUR from ${created_raw} ) < EXTRACT( HOUR from current_timestamp() )
        )
      OR
        (
        EXTRACT( QUARTER from ${created_raw} ) = EXTRACT( QUARTER from current_timestamp() )
            AND
        EXTRACT( DAY from ${created_raw} ) = EXTRACT( DAY from current_timestamp() )
            AND
        EXTRACT( HOUR from ${created_raw} ) = EXTRACT( HOUR from current_timestamp() )
            AND
        EXTRACT( MINUTE from ${created_raw} ) < EXTRACT( MINUTE from current_timestamp() )
        )
        ;;
  }


  dimension: is_wtd {
    type: yesno
    sql:
         EXTRACT( WEEK from ${created_raw} ) < EXTRACT( WEEK from current_timestamp() )
      OR
        (
        EXTRACT( WEEK from ${created_raw} ) = EXTRACT( WEEK from current_timestamp() )
            AND
        EXTRACT( DAY from ${created_raw} ) < EXTRACT( DAY from current_timestamp() )
        )
      OR
        (
        EXTRACT( WEEK from ${created_raw} ) = EXTRACT( WEEK from current_timestamp() )
            AND
        EXTRACT( DAY from ${created_raw} ) <= EXTRACT( DAY from current_timestamp() )
            AND
        EXTRACT( HOUR from ${created_raw} ) < EXTRACT( HOUR from current_timestamp() )
        )
      OR
        (
        EXTRACT( WEEK from ${created_raw} ) = EXTRACT( WEEK from current_timestamp() )
            AND
        EXTRACT( DAY from ${created_raw} ) <= EXTRACT( DAY from current_timestamp() )
            AND
        EXTRACT( HOUR from ${created_raw} ) <= EXTRACT( HOUR from current_timestamp() )
            AND
        EXTRACT( MINUTE from ${created_raw} ) < EXTRACT( MINUTE from current_timestamp() )
        )
      ;;
  }

  parameter: choose_breakdown {
    label: "Group (Row) by"
    view_label: "POP"
    type: unquoted
    default_value: "Month"
    allowed_value: {
      label: "Month Name"
      value: "Month"
    }
    allowed_value: {
      label: "Day of Month"
      value: "DOM"
    }
    allowed_value: {
      label: "Day of Year"
      value: "DOY"
    }
    allowed_value: {
      label: "Quarter of Year"
      value: "QOY"
    }
    allowed_value: {
      label: "Day of Week"
      value: "DOW"
    }
    allowed_value: {
      label: "Date"
      value: "Date"
    }
  }

  parameter: choose_comparison {
    label: "Pivot (Column) by"
    view_label: "POP"
    type: unquoted
    default_value: "Year"
    allowed_value: {
      label: "Year"
      value: "Year"
    }
    allowed_value: {
      label: "Month Name"
      value: "Month"
    }
    allowed_value: {
      label: "Week"
      value: "Week"
    }
  }

  dimension: pop_row {
    view_label: "POP"
    label_from_parameter: choose_breakdown
    # order_by_field: sort_by_1
    type: string
    sql:
    {% if choose_breakdown._parameter_value=='Month' %}
    ${created_month_name}
    {% elsif choose_breakdown._parameter_value=='DOY' %}
    ${created_day_of_year}
    {% elsif choose_breakdown._parameter_value=='QOY' %}
    ${created_quarter_of_year}
    {% elsif choose_breakdown._parameter_value=='DOW' %}
    ${created_day_of_week}
    {% elsif choose_breakdown._parameter_value=='Date' %}
    ${created_date}
    {% elsif choose_breakdown._parameter_value=='DOM' %}
    ${created_day_of_month}
    {% else %}
    NULL
    {% endif %}
    ;;
  }

  dimension: pop_pivot {
    # order_by_field: sort_by2
    view_label: "POP"
    label_from_parameter: choose_comparison
    type: string
    sql:
    {% if choose_comparison._parameter_value=='Year' %}
    ${created_year}
    {% elsif choose_comparison._parameter_value=='Month' %}
    ${created_month_name}
    {% elsif choose_comparison._parameter_value=='Year' %}
    ${created_week}
    {% else %}
    NULL
    {% endif %}
    ;;
  }

  dimension: sort_by_1 {
    hidden: yes
    type: number
    sql:
    {% if choose_breakdown._parameter_value == 'Month' %}
    ${created_month_num}
    {% elsif choose_breakdown._parameter_value == 'DOY' %}
    ${created_day_of_year}
    {% elsif choose_breakdown._parameter_value=='QOY' %}
    ${created_quarter_of_year}
    {% elsif choose_breakdown._parameter_value == 'DOM' %}
    ${created_day_of_month}
    {% elsif choose_breakdown._parameter_value == 'DOW' %}
    ${created_day_of_week_index}
    {% elsif choose_breakdown._parameter_value == 'Date' %}
    ${created_date}
    {% else %}
    NULL
    {% endif %} ;;
  }

  dimension: sort_by2 {
    hidden: yes
    type: string
    sql:
    {% if choose_comparison._parameter_value == 'Year' %}
    ${created_year}
    {% elsif choose_comparison._parameter_value == 'Month' %}
    ${created_month_num}
    {% elsif choose_comparison._parameter_value == 'Week' %}
    ${created_week}
    {% else %}
    NULL
    {% endif %} ;;
  }


}
