You have several options for UNIX command-line access. You'll need to choose one of these and get it working.

### Mac OS (on your personal machine):

Open a Terminal by going to Applications -> Utilities -> Terminal

### Windows (on your personal machine):

1.  You may be able to use the Ubuntu bash shell available in Windows.

    Your PC must be running a 64-bit version of Windows 10 Anniversary Update or later (build 1607+).

    Please see these links for more information:

    http://blog.revolutionanalytics.com/2017/12/r-in-the-windows-subsystem-for-linux.html

    https://msdn.microsoft.com/en-us/commandline/wsl/install_guide
    
    For more detailed instructions, see the [Windows and Linux](./windowsAndLinux.md) tutorial.

2. (Not recommended) There's an older program called cygwin that provides a UNIX command-line interface.

Note that when you install Git on Windows, you will get Git Bash. While you can use this to control Git, the functionality is limited so this will not be enough for general UNIX command-line access for the course.

### Linux (on your personal machine):

If you have access to a Linux machine, you very likely know how to access a terminal.

### Access via DataHub (provided by UC Berkeley's Data Science Education Program)

1) Go to [https://datahub.berkeley.edu](https://datahub.berkeley.edu)
2) Click on `Sign in with bCourses`, sign in via CalNet, and authorize DataHub to have access to your account.
3) In the mid-upper right, click on `New` and `Terminal`.
4) To end your session, click on `Control Panel` and `Stop My Server`. Note that `Logout` will not end your running session, it will just log you out of it.

### Access via the Statistical Computing Facility (SCF)

With an SCF account (available [here](https://scf.berkeley.edu/account), you can access a bash shell in the ways listed below. 

Those of you in the Statistics Department should be in the process of getting an SCF account. Everyone else will need an SCF account when we get to the unit on parallel computing, but you can request an account now if you prefer.

1. You can login to our various Linux servers and access a bash shell that way. Please see [http://statistics.berkeley.edu/computing/access](http://statistics.berkeley.edu/computing/access).

2. You can also access a bash shell via the SCF JupyterHub interface; please see the `accessingPython.md` instructions but when you click on `New`, choose `Terminal`. This is very similar to the DataHub functionality discussed above. 

