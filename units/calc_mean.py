def calc_mean(i, n):
    import numpy as np
    np.random.seed(i)
    data = np.random.normal(size = n)
    return([np.mean(data), np.std(data)])


# We need a version of calc_mean() that takes a single input.
def calc_mean_vargs(inputs):
    import numpy as np
    np.random.seed(inputs[0])
    data = np.random.normal(size = inputs[1])
    return([np.mean(data), np.std(data)])


