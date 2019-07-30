connection: "bigquery"

include: "*.view.lkml"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard



map_layer: heatmap {
  file: "sensor.topojson"
  property_key: "id"
  ## the id is established using the python script
}

explore: sensor {}
