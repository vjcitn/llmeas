#' produce a table row from macmon json output
#' @import tibble dplyr purrr
#' @rawNamespace import(jsonlite, except=c(flatten))
#' @param json_str single json doc from macmon
#' @examples
#' mmpath = Sys.getenv("MACMON_PATH")
#' if (file.exists(mmpath)) {
#'   tf = tempfile()
#'   pp = processx::process$new(mmpath, c("pipe"), stdout=tf)
#'   Sys.sleep(5)
#'   pp$kill()
#'   records = readLines(tf)
#'   df <- purrr::map(records, parse_macmon_record) |> purrr::list_rbind()
#'   tibble::glimpse(df)
#' } else message("set MACMON_PATH to demonstrate parse_macmon_records")
#' @export
parse_macmon_record <- function(json_str) {
  r <- fromJSON(json_str)
  
  tibble(
    timestamp        = as.POSIXct(r$timestamp, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC"),
    
    # Power (watts)
    all_power        = r$all_power,
    sys_power        = r$sys_power,
    cpu_power        = r$cpu_power,
    gpu_power        = r$gpu_power,
    gpu_ram_power    = r$gpu_ram_power,
    ram_power        = r$ram_power,
    ane_power        = r$ane_power,
    
    # CPU utilization
    cpu_usage_pct    = r$cpu_usage_pct,
    ecpu_freq_mhz    = r$ecpu_usage[[1]],
    ecpu_usage_ratio = r$ecpu_usage[[2]],
    pcpu_freq_mhz    = r$pcpu_usage[[1]],
    pcpu_usage_ratio = r$pcpu_usage[[2]],
    
    # GPU
    gpu_freq_mhz     = r$gpu_usage[[1]],
    gpu_usage_ratio  = r$gpu_usage[[2]],
    
    # Memory (convert bytes -> GB)
    ram_total_gb     = r$memory$ram_total  / 1e9,
    ram_used_gb      = r$memory$ram_usage  / 1e9,
    swap_total_gb    = r$memory$swap_total / 1e9,
    swap_used_gb     = r$memory$swap_usage / 1e9,
    
    # Temperature
    cpu_temp_c       = r$temp$cpu_temp_avg,
    gpu_temp_c       = r$temp$gpu_temp_avg
  )
}
