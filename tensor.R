# requires nanonext >= 0.9.0.9000
library(nanonext)
library(torch)

a <- torch_tensor(c(1,2,1))

s1 <- socket(listen = "inproc://tensor")
s2 <- socket(dial = "inproc://tensor")

s <- send(s1, a, mode = "raw")
s

r <- recv(s2, mode = "tensor")
r
