# requires nanonext >= 0.10.0.9000
library(nanonext)
library(torch)

obj <- list(a = 1, b = torch_tensor(c(1L, 2L, 1L)), c = torch_rand(c(2,2)))
obj

s1 <- socket(listen = "inproc://tensor")
s2 <- socket(dial = "inproc://tensor")

s <- send(s1, obj)
s

r <- recv(s2)
r

close(s2)
close(s1)

# recommend mirai >= 0.9.1.9025
library(mirai)
daemons(4L)
status()

m <- vector(mode = "list", length = 100L)
for (i in seq_along(m)) {
  m[[i]] <- mirai(c(obj, list(d = torch::torch_rand(c(1, n)))), obj = obj, n = i)
}
call_mirai(m[[1L]])[["data"]]
call_mirai(m[[100L]])[["data"]]

status()
daemons(0)

ten <- torch::torch_rand(c(1e3, 1e3))
m <- mirai(list(ten, torch::torch_rand(c(1e3, 1e3))), ten = ten)
m$data
call_mirai(m)$data
