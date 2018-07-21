mkdir <vagrant vm>
vagrant init centos/7
copy the files in this repo to <vagrant vm>
vagrant up
  
Note: Salt provision should deploy open-jdk package on centos vm.

Current error:
local:
----------
          ID: states
    Function: no.None
      Result: False
     Comment: No Top file or master_tops data matches found.
     Changes:

Summary for local
------------
Succeeded: 0
Failed:    1
------------

Can't find top.sls (base salt file)
