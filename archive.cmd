@echo off

set cdDrive=D:
set archiveDrive=X:



color 9F
title GTC STUDY ARCHIVE TOOL
cd "C:\Program Files\CDBurnerXP"
for /f "tokens=2 delims==." %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
:name_prompt
cls
echo.
echo. This tool creates an image file from the CD or DVD that is currently in the drive.
echo. The image is then copied to the cloud-based archive drive.
echo. Optionally, it will erase the disk if the copy is successful.
echo.
set /p filename=Please enter the desired archive name: 
if '%filename:~3%'=='' goto name_prompt
set filename=%filename:|=-%
set filename=%filename:<=-%
set filename=%filename:>=-%
set filename=%filename:/=-%
set filename=%filename:\=-%
set filename=%filename::=-%
set filename=%filename:?=-%
set filename=%filename:"=-%
:erase_prompt
cls
echo.
echo. The file will be named %datetime%_%filename%.iso
echo.
set /p erase=Would you like to erase the disk after a successful archive? (y/n): 
if '%erase%'=='y' goto erase_choice_valid
if '%erase%'=='n' goto erase_choice_valid
goto erase_prompt
:erase_choice_valid
cdbxpcmd --burn-data -folder:%cdDrive%\ -iso:"%archiveDrive%\%datetime%_%filename%.iso" -format:iso -changefiledates
if not %errorlevel%==0 (
	color CF
	echo There was an error. Please try again or contact IT.
	echo Press any key to exit...
	pause > nul
	goto :EOF
)

if '%erase%'=='y' (
	cls
	echo.
	echo. Please wait while the CD is erased
	cdbxpcmd --erase %cdDrive% > %tmp%\cdbxpcmd.txt
	type "%tmp%\cdbxpcmd.txt" | find "Finished erasing the disc" && (
		cls
		color A0
		echo.
		echo. 
		echo. Success! The image file %datetime%_%filename%.iso was created.
		echo. The disk WAS ERASED.
		echo. Press any key to exit.
		pause > nul
		goto :EOF
	)
	cls
	color E0
	echo.
	echo. 
	echo. Partial Success. The image file %datetime%_%filename%.iso was created.
	echo. But the disk COULD NOT BE ERASED.
	echo. Maybe it's not an RW disk?
	echo. Press any key to exit.
	pause > nul
	goto :EOF
)
if '%erase%'=='n' (
	cls
	color A0
	echo.
	echo. 
	echo. Success! The image file %datetime%_%filename%.iso was created.
	echo. The disk was NOT erased.
	echo. Press any key to exit.
	pause > nul
	goto :EOF
)
