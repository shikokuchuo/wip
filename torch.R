library(torch)

obj <- list(a = "test",
            b = torch_tensor(c(1L, 2L, 1L)),
            c = c(3,4,5))
obj

# nanonext example -------------------------------------------------------------

# requires nanonext >= 0.9.0.9002
# install.packages("nanonext", repos = "shikokuchuo.r-universe.dev")
library(nanonext)

rf <- function(x) {
  if (inherits(x, "torch_tensor")) torch:::cpp_tensor_save(x, TRUE) else
    if (is.character(x)) torch:::cpp_tensor_load(x, NULL, TRUE)
}

refhook(rf)

s1 <- socket(listen = "inproc://tensor")
s2 <- socket(dial = "inproc://tensor")

s <- send(s1, obj)
s

r <- recv(s2)
r

# mirai example ----------------------------------------------------------------

# requires mirai >= 0.9.0.9022
# install.packages("mirai", repos = "shikokuchuo.r-universe.dev")
library(mirai)

daemons(n = 4L, refhook = rf)
daemons()

out <- vector(mode = "list", length = 100L)
for (i in seq_len(1000)) {
  out[[i]] <- mirai(torch::torch_matmul(obj, torch::torch_tensor(sample.int(10, 3))), obj = obj[[2L]])
}
data <- lapply(lapply(out, call_mirai), .subset2, "data")
data

daemons()
daemons(0)
