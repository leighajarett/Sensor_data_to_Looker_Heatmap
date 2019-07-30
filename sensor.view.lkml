view: sensor {
  sql_table_name: exoplanets.rashad_query_results ;;

  dimension: pose_x {
    type: number
    sql: ${TABLE}.pose_x ;;
  }

  dimension: co_min_x {
    type: number
    #when rounding up, the min_x coordinate should be 1 less than rounded value
    sql:  case when (round(${pose_x}) - ${pose_x}) > 0 then round(${pose_x})-1
      else round(${pose_x}) end;;
  }


  dimension: co_max_x {
    type: number
    sql: ${co_min_x}+1 ;;
  }

  dimension: pose_y {
    type: number
    sql: ${TABLE}.pose_y ;;
  }

  dimension: co_min_y {
    type: number
    #when rounding up, the min_y coordinate should be 1 less than rounded value
    sql:  case when (round(${pose_y}) - ${pose_y}) > 0 then round(${pose_y})-1
      else round(${pose_y}) end;;
  }


  dimension: co_max_y {
    type: number
    sql: ${co_min_y}+1 ;;
  }

  dimension: id {
    #id field to join on the map layer, its a string that shows [[x_min, x_max], [y_min, y_max]]
    type: string
    sql: concat('[[',cast(cast(${co_min_x} as int64) as string),', ',
              cast(cast(${co_max_x} as int64) as string),'], [',
              cast(cast(${co_min_y} as int64) as string),', ',
              cast(cast(${co_max_y} as int64) as string),']]') ;;
    map_layer_name: heatmap
  }

  dimension: robot_id {
    type: string
    sql: ${TABLE}.robot_id ;;
  }

  dimension_group: time {
    type: time
    timeframes: [date,hour,week,year,month_name,second, raw]
    sql: TIMESTAMP(${TABLE}.time) ;;
  }

  dimension: velocity {
    type: number
    sql: ${TABLE}.velocity ;;
  }

  dimension: time_since_activity {
    type: duration_second
    sql_start: ${time_raw};;
    sql_end: CURRENT_TIMESTAMP() ;;
  }

  measure: count {
    type: count
  }

  measure: average_velocity {
    type: average
    sql: ${velocity} ;;
  }

  measure: furthest_time {
    type: max
    sql: ${time_since_activity} ;;
  }


}
