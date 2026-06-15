@rem ustawienia, wersja angielska
set en_dir="EN"
set input_dir_en=Files
set output_dir_in_zip_en="sadist-2-final-scream"
set output_zip_en="..\sadist2_1_10_en.zip"

rem ========== spakuj zip w wersji angielskiej =============
cd %en_dir%
del %output_zip_en%
ren %input_dir_en% %output_dir_in_zip_en%
"..\zip.exe" -r -9 %output_zip_en% %output_dir_in_zip_en%\*.*
ren %output_dir_in_zip_en% %input_dir_en%
cd ..