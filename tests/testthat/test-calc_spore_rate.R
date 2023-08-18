test_that("infection rate returns sensible values", {
  expect_equal(calc_spore_rate(25,98),0.8128693, tolerance = 0.000001)
  expect_equal(calc_spore_rate(30,94),0.01257208, tolerance = 0.000001)

  temp <- seq(-5,55, by = 0.5)
  RH <- seq(0,100, by = 0.5)
  s_rate <-
    outer(temp,RH,function(xi,ji){
      calc_spore_rate(Tm = xi, RH = ji)
    })

  expect_true(all(s_rate < 1 &
                    s_rate >= 0 ))
#  persp(temp,RH,s_rate, theta = 160)
})
