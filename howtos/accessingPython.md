# Access on your laptop via Anaconda

We recommend using the [Anaconda distribution of Python](https://www.anaconda.com/distribution/), though that is not required. You can download it [here](https://www.anaconda.com/distribution/#download-section). Make sure to choose Python 3.7 or 3.8 and not Python 2.7.

Once you've installed Python, please install the following packages: numpy, scipy, pandas, dask, dask.distributed, dask.bag, dask.array, dask.dataframe, dask.multiprocessing.

Assuming you installed the Anaconda Python, you should be able to do this:

```
conda install numpy scipy pandas dask
```

# Access via the SCF

## Python from the command line

Once you get your SCF account (which you'll need for our discussion of parallelization and big data and for PS6), you can access Python or IPython from the UNIX command line as soon as you login to an SCF server. Just SSH to an SCF Linux machine (e.g., arwen.berkeley.edu or radagast.berkeley.edu) and run 'python' or 'ipython' from the command line.

More details on using SSH are [here](https://statistics.berkeley.edu/computing/ssh). Note that if you have the Ubuntu subsystem for Windows, you can use SSH directly from the Ubuntu terminal.

## Python via Jupyter notebook

You can use a Jupyter notebook to run Python code from the [SCF JupyterHub](https://jupyter.stat.berkeley.edu) or the [Berkeley DataHub](https://datahub.berkeley.edu). Select `Start My Server`. Then, unless you are running long or parallelized code, just click `Spawn` (in other words, accept the default 'standalone' partition). On the next page select 'New' and 'Python 3'. 

To finish your session, click on `Control Panel` and `Stop My Server`. Do not click `Logout`.
