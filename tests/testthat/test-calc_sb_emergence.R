test_that("sugar beat emergence is accurate", {
  #test vector including outside ranges
  t1 <- 3:50

  t1_out <- calc_sb_emergence(t1)
  expect_equal(t1_out, 183.05)
  expect_length(t1_out,1)
  expect_type(t1_out,"double")

  expect_equal(calc_sb_emergence(23), 5.59)
  expect_equal(calc_sb_emergence(35), 8.91)
  expect_equal(calc_sb_emergence(12), 8.87)
  expect_equal(calc_sb_emergence(6), 27.13)

  t1[6]
})
