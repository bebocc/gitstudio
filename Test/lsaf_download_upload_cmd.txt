* Upload a File 
java -jar lsaf_upload_download.jar -url "https://lsafprod.ondemand.sas.com" -u "LSAF_userID" -p "LSAF_PW" -action "Upload" -lsafArea "RS" -lsafPath "/SAS/Files/SAS/test/readme.txt" -winPath "C:\temp\readme.txt" -enableVersioning "Y"

* Upload and Expand Zip File
java -jar lsaf_upload_download.jar -url "https://lsafprod.ondemand.sas.com" -u "LSAF_userID" -p "LSAF_PW" -action "UploadAndExpandZip" -lsafArea "RS" -lsafPath "/SAS/Files/SAS/test" -winPath "C:\temp\temp.zip" -enableVersioning "Y"

* Upload  a Folder
java -jar lsaf_upload_download.jar -url "https://lsafprod.ondemand.sas.com" -u "LSAF_userID" -p "LSAF_PW" -action "UploadAndExpand" -lsafArea "RS" -lsafPath "/SAS/Files/SAS/test" -winPath "C:\temp"  -enableVersioning "Y"

* Download a File
java -jar lsaf_upload_download.jar -url "https://lsafprod.ondemand.sas.com" -u "LSAF_userID" -p "LSAF_PW" -action "DownloadFile" -lsafArea "RS" -lsafPath "/SAS/Files/SAS/test/Readme.txt" -winPath "C:\temp\Readme.txt"

* Download a Zip File and Expand
java -jar lsaf_upload_download.jar -url "https://lsafprod.ondemand.sas.com" -u "LSAF_userID" -p "LSAF_PW" -action "Download" -lsafArea "RS" -lsafPath "/SAS/Files/SAS/utilities/create_hierarchy" -winPath "C:\temp" 

* Download a Folder
java -jar lsaf_upload_download.jar -url "https://lsafprod.ondemand.sas.com" -u "LSAF_userID" -p "LSAF_PW" -action "Download" -lsafArea "RS" -lsafPath "/SAS/Files/SAS/utilities/create_hierarchy" -winPath "C:\temp" 


