test_that("infection rate returns sensible values", {
  expect_equal(calc_inf_rate(25,0.2),0.01731575, tolerance = 0.000001)
  expect_equal(calc_inf_rate(30,0.05),0.7244355, tolerance = 0.000001)

  temp <- seq(-5,55, by = 1)
  VPD <- seq(0,3, by = 0.01)
  i_rate <-
    outer(temp,VPD,function(xi,ji){
      calc_inf_rate(Tm = xi, vpd = ji)
      })

  expect_true(all(i_rate < 1 &
                    i_rate >= 0 ))
  #persp(temp,VPD,i_rate, theta = 160)
})
