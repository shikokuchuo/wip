library(promises)
library(mirai)

daemons(1)

promise_resolve(0) |> then(print)
mirai(1) |> then(print) |> then(print) |> then(print)
mirai(2) |> then(print) |> then(print)
promise_resolve(3) |> then(print)
while (!later::loop_empty()) {later::run_now(Inf); print("Shiny Reactivity")}

y <- 0
mirai(1) |> then(\(x) y <<- x) |> then(\(x) print(y - x))
mirai(2) |> then(\(x) y <<- x) |> then(\(x) print(y - x))
while (!later::loop_empty()) {later::run_now(Inf); print("Shiny Reactivity")}

y <- 0
mirai(1) |> then(\(x) y <<- x) |> then(\(x) print(y - x))
while (!later::loop_empty()) {later::run_now(Inf); print("Shiny Reactivity")}

daemons(0)
