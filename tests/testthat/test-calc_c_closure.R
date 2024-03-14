test_that("function example works", {
  epidemic_onset_param <-
    read_sb_growth_parameter(system.file("extdata", "uav_img",
                                         package = "cercospoRa"),
                             10)

  param_rxt <- calc_r_x0(epidemic_onset_param,
                         min_r = 0.02,
                         max_r = 0.05,
                         k = 6)
  c_closure <- calc_c_closure(param_rxt,
                              x1 = 1.3,
                              k = 6)

})
