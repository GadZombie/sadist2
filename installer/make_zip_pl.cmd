@rem ustawienia, wersja polska
set pl_dir="PL"
set input_dir_pl=Files
set output_dir_in_zip_pl="sadist-2-ostatni-krzyk"
set output_zip_pl="..\sadist2_1_10_pl.zip"

rem ========== spakuj zip w wersji polskiej =============
cd %pl_dir%
del %output_zip_pl%
ren %input_dir_pl% %output_dir_in_zip_pl%
"..\zip.exe" -r -9 %output_zip_pl% %output_dir_in_zip_pl%\*.*
ren %output_dir_in_zip_pl% %input_dir_pl%
cd ..