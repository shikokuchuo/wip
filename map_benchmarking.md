
## purrr benchmarking

### Comparison of `purrr::map(in_parallel())` with `furrr::future_map()`

Setup (using 8 parallel processes):

``` r
library(purrr)
library(mirai)
library(furrr)
#> Loading required package: future
daemons(8)
#> [1] 8
plan(multisession, workers = 8)
```

Use blog model fitting example:

``` r
slow_lm <- function(formula, data) {
  Sys.sleep(0.1)  # Simulate computational complexity
  lm(formula, data)
}
```

Benchmark on mtcars:

``` r
purrr_map <- function() {
    mtcars |>
    split(mtcars$cyl) |>
    map(in_parallel(\(df) slow_lm(mpg ~ wt + hp, data = df), slow_lm = slow_lm))
}

furrr_map <- function() {
  mtcars |>
    split(mtcars$cyl) |>
    future_map(\(df) slow_lm(mpg ~ wt + hp, data = df))
}

bench::mark(purrr_map(), furrr_map())
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 2 × 6
#>   expression       min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>  <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 purrr_map()    105ms    106ms      9.41   830.2KB     0   
#> 2 furrr_map()    414ms    417ms      2.40    22.3MB     3.60
```

Benchmark on diamonds:

``` r
purrr_map <- function(data = ggplot2::diamonds) {
  data |>
    split(data$color) |>
    map(in_parallel(\(df) slow_lm(price ~ carat + clarity, data = df), slow_lm = slow_lm))
}

furrr_map <- function(data = ggplot2::diamonds) {
  data |>
    split(data$color) |>
    future_map(\(df) slow_lm(price ~ carat + clarity, data = df))
}

bench::mark(purrr_map(), furrr_map())
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 2 × 6
#>   expression       min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>  <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 purrr_map()    145ms    145ms      6.85    34.3MB     3.43
#> 2 furrr_map()    870ms    870ms      1.15    77.2MB     3.45
```
