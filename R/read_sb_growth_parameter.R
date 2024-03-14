#' Read LAI images at several time points
#'
#' @param im_folder folder containing two georeferenced image of the location of interest collected at two time points.
#' The two images should be named after the date of collection (eg. 2022-05-01.tif)
#' @param resolution desired spatial resolution. `resolution` should be equal to or larger than the actual resolution
#' of the images expressed in meters
#'
#' @return `param_list:` list containing parameters that are necessary to calculate `r`, the growth rate
#'
#' @export
#'
#' @import raster
#' @import sf
#' @import epiphytoolR
#'
#' @examples
#' epidemic_onset_param <- read_sb_growth_parameter(system.file("extdata", "uav_img", package = "cercospoRa"), 10)
#' t <- epidemic_onset_param$t
#' imgs <- epidemic_onset_param$imgs


read_sb_growth_parameter <- function(im_folder, target_res){

  Im_list <- list.files(file.path(im_folder),
                        recursive = FALSE)

  Im_list <- unlist(strsplit(Im_list, '.tif'))

  t <- Im_list[order(as.POSIXct(Im_list,
                                tryFormats = c("%Y-%m-%d",
                                               "%Y_%m_%d")))]
  t0 <- t[1]
  img0 <- raster(file.path(im_folder, paste(t0, '.tif', sep = '')))
  resolut <- mean(res(img0))

  target_res0 <- target_res
  if(st_is_longlat(img0)){
    target_res0 <- target_res0*(360/4e7)
  }

  if(resolut<target_res){
    aggreg_fact <- round(target_res0/resolut)
    if(aggreg_fact>=2){
      img0 <- raster::aggregate(img0, fact=aggreg_fact, fun='mean')
    }
  }


  imgs <- img0
  for(ti in t[-1]){
    imgi <- raster(file.path(im_folder, paste(ti, '.tif', sep = '')))
    resolut <- mean(res(imgi))

    target_resi <- target_res
    if(st_is_longlat(img0)){
      target_resi <- target_resi*(360/4e7)
    }

    if(resolut<target_resi){
      aggreg_fact <- round(target_resi/resolut)
      if(aggreg_fact>=2){
        imgi <- raster::aggregate(imgi, fact=aggreg_fact, fun='mean')
      }
    }

    if(!compareCRS(crs(imgi),crs(img0))[1] | !identical(res(imgi), res(img0))){
      imgi <- projectRaster(imgi,
                            crs = crs(img0),
                            res = res(img0))
    }


    if(!identical(extent(imgi), extent(img0))) imgi <- resample(imgi, img0, method = "bilinear")
    imgi <- crop(imgi,extent(img0))

    imgs <- stack(imgs, imgi)
  }


  param_list <- list(t = as.POSIXct(t,
                                    tryFormats = c("%Y-%m-%d",
                                                   "%Y_%m_%d")),
                     imgs = imgs)

  return(param_list)
}
