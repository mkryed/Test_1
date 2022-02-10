# Define the database connection to be used for this model.
connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: mkyed_test_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mkyed_test_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Mkyed Test"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.
explore: order_items {
  view_label: "(1) Order Items"
    join: users {
      view_label: "(2) Customers"
      sql_on: ${order_items.user_id}=${users.id} ;;
      relationship: many_to_one
    }
    join: inventory_items {
      view_label: "(3) Inventory Items"
      sql_on: ${order_items.inventory_item_id}=${inventory_items.id} ;;
      relationship: many_to_one
    }
    join: products {
      view_label: "(4) Products"
      sql_on: ${inventory_items.product_id}=${products.id} ;;
      relationship: many_to_one
    }
}
