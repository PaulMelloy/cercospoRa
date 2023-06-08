daily_min <- c(5,7,9,1,-5,-2,0)
daily_max <- c(25,37,29,11,15,12,10)

test_that("Simple tests return", {

  expect_equal(calc_sugarbeet_gdd(daily_min, daily_max), 57.1)
  expect_equal(calc_sugarbeet_gdd(daily_min, daily_max,hourly = TRUE), 83.84771,
               tolerance = 0.00001)
})

test_that("hourly returns a curved beta shape",{
  outT2 <- sapply(seq(0,40,1),function(x){
    calc_sugarbeet_gdd(max_tm = x, min_tm = x, hourly = TRUE, tm_optim = 25)
  })

  expect_equal(outT2,
               c(0,0,1.290527,2.703797,4.094393,5.461257,6.80323,8.119032,9.407249,10.6663,11.89444,13.08967,14.24977,15.37216,16.45393,17.49166,18.48136,19.41832,20.29686,21.11007,21.84936,22.50388,23.05946,23.49713,23.79034,23.9,23.76431,23.2749,22.20758,19.92398,0,0,0,0,0,0,0,0,0,0,0),
               tolerance = 0.00001)
  plot(outT2)

})
