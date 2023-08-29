test_that("dispersal kernal example works", {
  # this dispersal kernal needs to be checked against the literature
  # and can only be used for splash dispersal without the influence of wind

  expect_equal(cercospora_dk(0,0, 0.1,3),47.746483, tolerance = 0.0000001)

  x1 <- -10:10
  y1 <- -10:10
  f1 <- expand.grid(x = x1,y = y1)

  f1$risk <-
    apply(f1, 1, function(df1){
      cercospora_dk(as.numeric(df1["x"]),
                    as.numeric(df1["y"]),
                    1,1)
    })
  expect_equal(sum(f1$risk), 0.3824385, tolerance = 0.000001)


  # library(ggplot2)
  # f1 |>
  #   ggplot(aes(x,y)) +
  #   geom_tile(aes(fill = risk))



      })



# plot(cercospora_dk(1:200, 0,1,1))
# sum(cercospora_dk(1:20000, 0,1,1))
