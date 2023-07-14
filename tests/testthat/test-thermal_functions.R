test_that("temperature_index() examples works", {
  expect_equal(temperature_index(18),0.8477678, tolerance = 0.000001)
  expect_equal(temperature_index(10),0.2204469, tolerance = 0.000001)
  expect_equal(temperature_index(28),1, tolerance = 0.000001)
  expect_equal(temperature_index(-28),0, tolerance = 0.000001)

})

test_that("latent_period() examples work", {
  expect_equal(latent_period(25), 7.136435, tolerance = 0.000001)
  expect_equal(latent_period(0), 868.002, tolerance = 0.000001)
  expect_equal(latent_period(35), 7.00412, tolerance = 0.000001)
  })

test_that("moisture_index() examples work", {
  expect_equal(moisture_index(25), 0)
  expect_equal(moisture_index(90), 0.68879132)
  expect_equal(moisture_index(95), 0.9416218)
  expect_equal(moisture_index(25, rain = 0.1), 0, tolerance = 0.0000000001)
  expect_equal(moisture_index(55,rh_thresh = 50), 0.00540259, tolerance = 0.00001)
})

