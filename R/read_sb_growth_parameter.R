#' Read LAI images at two time points
#'
#' @param im_folder folder containing two georeferenced image of the location of interest collected at two time points.
#' The two images should be named after the date of collection (eg. 2022-05-01.tif)
#' @param resolution desired spatiaal resolution. `resolution` should be equal to or larger than the actual resolution
#' of the images expressed in meters
#'
#' @return `param_list:` list containing parameters that are necessary to calculate `r`, the growth rate
#'
#' @export
#'
#' @import raster
#' @import epiphytoolR
#'
#' @examples
#' epidemic_onset_param <- read_sb_growth_parameter(base_dir, scale)
#' t1 <- epidemic_onset_param$t1; t0 <- epidemic_onset_param$t0


read_sb_growth_parameter <- function(im_folder, resolution){

  Im_list <- list.files(im_folder,
                        recursive = FALSE)

  Im_list <- unlist(strsplit(Im_list, '.tif'))

  t1 <- Im_list[which.max(as.POSIXct(Im_list,
                                     tryFormats = c("%Y-%m-%d",
                                                    "%Y_%m_%d")))]
  t0 <- Im_list[which.min(as.POSIXct(Im_list,
                                     tryFormats = c("%Y-%m-%d",
                                                    "%Y_%m_%d")))]

  mat1 <- raster(file.path(im_folder, paste(t1, '.tif', sep = '')))
  mat0 <- raster(file.path(im_folder, paste(t0, '.tif', sep = '')))

  resolut <- min(mean(res(mat1)), mean(res(mat0)))
  target_res <- resolution

  if(st_is_longlat(mat1) & st_is_longlat(mat0)){
    target_res <- resolution*(360/4e7)
  }

  if(resolut<target_res){
    aggreg_fact <- round(target_res/resolut)
    if(aggreg_fact>=2){
      mat1 <- raster::aggregate(mat1, fact=aggreg_fact, fun='mean')
      mat0 <- raster::aggregate(mat0, fact=aggreg_fact, fun='mean')
    }
  }

  param_list <- list(t1 = t1,
                     t0 = t0,
                     mat1 = mat1,
                     mat0 = mat0)
  return(param_list)
}

