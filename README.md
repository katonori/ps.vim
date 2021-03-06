ps.vim
======

What is this?
------
**ps.vim** is a vim filetype plugin to add *ps mode*.
*ps mode* is a mode to view the result of *ps command* which shows you process list.
From *ps mode* buffer, you can rerun *ps command* and kill a process. 
**This ps mode is NOT postscript file mode.**

Requirement
------
ps command. The most UNIX like OS has this command by default.

How to install
------
Copy *ftplugin* and *plugin* directory to your vim script directory.
Or type `make install` to install these scripts to `~/.vim`. 

How to use
------
* Type below in vim.

        :PS

* Add alias to your shell like below

        alias vimps='ps aux | vim -c "set filetype=ps" -'

  then invoke below from your shell.

        vimps

Commands
------
|Name              | Description |
| ---------------- | ------------------- |
|PS  | Open new buffer and run *ps command* and enter *ps mode*. |
|PsRefresh   | Rerun *ps command* and update the current buffer.|
|PsKillWord  | Kill process that PID is the word under the cursor.|
|PsKillLine  | Kill process shown in the line under the cursor. You need to set the variable *g:PS_RegExRule* corretly. |
|PsKillAllLines  | Kill all the process shown in the selected region. You need to set the variable *g:PS_RegExRule* corretly. |
|PsOpenProcLine | Open /proc file system of the process under the cursor. |

Default key maps
------

### Normal mode

| Map          | Command            |
| ------------ | ------------------ |
|r   | PsRefresh    |
|K   | PsKillWord     |
|\<C-K\>   | PsKillLine     |
|p   | PsOpenProcLine |
|q   | Close buffer(:q!).|

### Visual mode

| Map          | Command            |
| ------------ | ------------------ |
|\<C-K\>   | PsKillAllLines    |


Variables
------

|Name                 | Default value     | Description |
| ------------------- | ----------------- | ----------- |
|PS\_PsCmd  | "ps aux"            | Specify the ps command. |
|PS\_KillCmd  | "kill -9"            | Specify the kill command. |
|PS\_RegExRule  | '\w\+\s\+\zs\d\+\ze'       | Specify the reguler expression rule to get the process ID from line. The default value assumes the PID is at the second column.|

This script can be configured by changing these variables. Use *let* command to set value to these variables like below.

     let PS_PsCmd = "ps axfu"
