epidemic_onset_param <-
  read_sb_growth_parameter(system.file("extdata", "uav_img",
                                       package = "cercospoRa"),
                           10)


test_that("SpatData is read as expected", {

  expect_no_condition(read_sb_growth_parameter(system.file("extdata", "uav_img",
                                       package = "cercospoRa"),
                           10))

  # output a named list with expected dates and dimensions
  expect_type(epidemic_onset_param,"list")
  expect_named(epidemic_onset_param,c("tm","imgs"))
  expect_equal(epidemic_onset_param$tm, as.POSIXct(c("2022-06-14", "2022-06-28")))
  expect_s4_class(epidemic_onset_param$imgs,"SpatRaster")
})


param_rxt <- calc_r_x0(epidemic_onset_param,
                       min_r = 0.02,
                       max_r = 0.05,
                       k = 6)

test_that("growth rate is calculated correctly",{

  expect_no_condition(calc_r_x0(epidemic_onset_param,
                                min_r = 0.02,
                                max_r = 0.05,
                                k = 6))

  # output a named list with expected dates and dimensions
  expect_type(param_rxt,"list")
  expect_named(param_rxt,c("r","x0","t0"))

  expect_s4_class(param_rxt$r,"SpatRaster")
  expect_equal(dim(param_rxt$r), c(17,29,1))
  expect_equal(terra::minmax(param_rxt$r),
               matrix(c(0.02, 0.05),dimnames = list(c("min", "max"), "2022_06_14")))

  expect_s4_class(param_rxt$x0,"SpatRaster")
  expect_equal(dim(param_rxt$x0), c(17,29,1))
  expect_equal(terra::minmax(param_rxt$x0),
               matrix(c(0.5216454, 2.9568495),dimnames = list(c("min", "max"), "2022_06_14")))

  expect_equal(param_rxt$t0, as.POSIXct(c("2022-06-14")))

})

test_that("canopy closure is calculated correctly",{

  c_closure <- calc_c_closure(param_rxt,
                              x1 = 1.3,
                              k = 6)

  expect_s4_class(c_closure,"SpatRaster")
  expect_equal(dim(c_closure), c(17,29,1))
  expect_equal(terra::minmax(c_closure),
               matrix(c(19093.5833, 19192.5833),dimnames = list(c("min", "max"), "2022_06_14")))


})
