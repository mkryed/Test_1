include: "/views/raw/distribution_centers.view.lkml"

view: +distribution_centers {

  dimension: store_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

}
