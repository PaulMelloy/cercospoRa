test_that("example returns expected outputs", {
  f_name <- system.file("extdata", "uav_img",
                        package = "cercospoRa")
  epidemic_onset_param <-
    read_sb_growth_parameter(im_folder = f_name,
                             target_res = 10)
  expect_type(epidemic_onset_param,"list")
  expect_s3_class(epidemic_onset_param[[1]],"POSIXct")
  expect_s4_class(epidemic_onset_param[[2]],"SpatRaster")
  expect_length(epidemic_onset_param,2)
  expect_equal(epidemic_onset_param[[1]],
               as.POSIXct(c("2022-06-14", "2022-06-28")))


  )
})
