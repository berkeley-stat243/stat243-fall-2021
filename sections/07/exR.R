# This is an example R script for the server
hold = matrix(data = 1:9, nrow = 3, ncol = 3)

write.table(x = hold, file = "testMatrix.csv", sep = ",",
            row.names = FALSE, col.names = FALSE)