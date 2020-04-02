:: mytool.bat --- 生成随机字符串
:: v1.00 / 2020/4/1 / Sheldon
@echo off 
:start
set len=
set StrList=
set i=0
:: ------------------- input --------------------
:input1
set /p len=input length or [?] for help or [d] to use default settings:
if "%len%" == "?" ( 
	goto usage
) else if "%len%" == "d" (
	set len=
	goto default
) else if "%len%" == "e" (
	exit /b
) else if "%len%" == "cm" (
	call :CustomMode
	goto default
) else if "%len%" GTR 10000 (
	echo ERROR, input a SMALLER number or use CUSTOM MODE
	set len=
	goto input1
)
set i=1

:input2
set /p mod=input the model number or [?] for help or [d] to use default settings:
if "%mod%" == "?" ( 
	goto usage
) else if "%mod%" == "1" (
	set StrList=0123456789
) else if "%mod%" == "2" (
	set StrList=abcdefghijklmnopqrstuvwxyz0123456789
) else if "%mod%" == "3" (
	set StrList=abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
) else if "%mod%" == "4" (
	set StrList=abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*:;,.-+
) else if "%mod%" == "5" (
	set StrList=abcdefghijklmnopqrstuvwxyz
) else if "%mod%" == "d" (
	set StrList=
	goto default
) else if "%mod%" == "" (
	set StrList=
	goto default
) else if "%mod%" == "e" (
	exit /b
) else (
	echo invalid, input again
	goto input2
)
:: ----------------------------------------------

:: ------------------ default -------------------
:default
set d_len=15
set d_StrList=abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*:;,.-+
if "%len%" == "" set "len=%d_len%"
if "%StrList%" == "" (
	set StrList=%d_StrList%
)
:: ----------------------------------------------

setlocal enabledelayedexpansion

rem ############## 计算字符串长度
call :StrLen "%StrList%"

:: ---------- generate random string ------------
set _out=
for /l %%n in (1 1 %len%) do (
	set /a pos = !random! %% StrLen
	for %%p in (!pos!) do set _out=!_out!!StrList:~%%p,1!
)
:: ----------------------------------------------

:: ------------- output and exit ----------------
echo,!_out!
set /p j=Type [e]xit or generate another key:
if "%j%" == "e" exit /b
goto start
:: ----------------------------------------------

:: --------------- 计算字符串长度 ----------------
:StrLen <string>
set _StrList=%StrList%
set StrLen=1

for %%a in (2048 1024 512 256 128 64 32 16) do (
	if "!_StrList:~%%a!" neq "" (
		set /a StrLen += %%a
		set _StrList=!_StrList:~%%a!
	)
)
set _StrList=!_StrList!fedcba9876543210
set /a StrLen += 0x!_StrList:~16,1!
goto :eof
:: ----------------------------------------------

:: ---------------- Custom Mode -----------------
:CustomMode
echo WARNING, CUSTOM MODE ON, RESTRICTIONS OFF
set /p len=input length:
set /p StrList=input string list:
goto :eof
:: ----------------------------------------------

:: ------------------- usage --------------------
:usage
echo,
echo How to use this tool? 
echo,
echo Default Settings: 
echo Length:15; String List: 0-9, a-z, A-Z and !@#$%^&*:;,.-+
echo,
echo Input length:
echo You should input a number NOT GREATER than 10000. 
echo You can also input: "?" to show this support, "d" or nothing to use default settings, "e" to exit this tool and "cm" to use Custom Mode.
echo,
echo Input mode:
echo You should input number 1-4 to use mode 1-4. "?", "e", "d", "" are also allowed, but you can't enter Custom Mode. 
echo Mode 1: String List: 0-9 ;
echo Mode 2: String List: 0-9 and a-z ;
echo Mode 3: String List: 0-9, a-z and  A-Z ;
echo Mode 4: String List: 0-9, a-z, A-Z and !@#$%^&*:;,.-+ ;
echo Mode 5: String List: a-z ;
echo,
echo In Custom Mode, you can input a number as large as you can, and you can also use your string list. 
echo,
if "%i%" == "0" (
	goto input1
) else if "%i%" == "1" (
	goto input2
)
:: ----------------------------------------------