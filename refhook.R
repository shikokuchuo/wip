library(torch)

tensor <- torch_tensor(c(1,2,1))
tensor

ser <- function(x) torch:::cpp_tensor_save(x, base64 = TRUE)
unser <- function(x) torch:::cpp_tensor_load(x, device = NULL, base64 = TRUE)

r <- serialize(tensor, NULL, refhook = ser)
s <- unserialize(r, refhook = unser)
s

l <- list(a = "test", b = tensor)
l

p <- serialize(l, NULL, refhook = ser)
q <- unserialize(p, refhook = unser)
q
