set.seed(69)

# ten minute increments for
date_t <- Sys.time() + seq(0, 179 * 60 * 10, (60 * 10))
Tm <- rnorm(180,20,10)
RH <- runif(180,min = 40,90)
rain <- rbinom(180,1,0.1) * runif(180,0.1,20)

test_that("calc_DIV works", {
# individual vectors
  DIV1 <- calc_DIV(
    date_time = date_t,
    Tm = Tm,
    RH = RH,
    rain = rain
  )
  expect_equal(DIV1,c(0.03598820,0.02570586), tolerance = 0.0000001)

  in_dat <- data.frame(
    date_time = date_t,
    temp = Tm,
    RH = RH,
    rain = rain
  )

  expect_error(calc_DIV(dat = in_dat),
               regexp = "'dat' data.frame must have colnames 'times','temp','RH','rain'")

  in_dat <- data.frame(
    times = date_t,
    temp = Tm,
    RH = RH,
    rain = rain
  )
  calc_DIV(dat = in_dat)

})
