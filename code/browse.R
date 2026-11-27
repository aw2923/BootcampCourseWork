
Exponential <- function(N0 = 1, r = 1, generations = 10) {
  # runs a simulation of exponential growth
  # returns a vector of length generations

    N <- rep(NA, generations)

    N[1] <- N0
    for (t in 2:generations) {
        N[t] <- N[t-1] * exp(r)
        browser() # insert a breakpoint
    }
    return (N)
}

plot(Exponential(), type="l", main="Exponential growth")

