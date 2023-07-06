set.seed(69)

# ten minute increments for
date_t <- Sys.time() + seq(0, 179 * 60 * 10, (60 * 10))
Tm <- rnorm(180,20,10)
RH <- rep(rbeta(20,3,1)*100, each = 9)
rain <- rbinom(180,1,0.1) * runif(180,0.1,20)

test_that("calc_DIV works", {
# individual vectors
  DIV1 <- calc_DIV(
    date_time = date_t,
    Tm = Tm,
    RH = RH,
    rain = rain
  )
  expect_equal(DIV1$DIV, c(0.02191393, 0.01649486), tolerance = 0.000001)
  expect_equal(DIV1$DIV_racca, c(0.025793197, 0.001450734 ), tolerance = 0.0000001)
  expect_type(DIV1,"list")
  expect_equal(dim(DIV1), c(2,5))
  expect_equal(colnames(DIV1), c("Year","Month","Day","DIV","DIV_racca"))

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
