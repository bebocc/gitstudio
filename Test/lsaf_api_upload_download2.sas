
%let userid = %str(USERID);
%let password = %nrbquote(PASSWORD);
%let url = %nrbquote(URL);

* Login to system - with or without proxy;
%lsaf_login(lsaf_url=%str(&url), lsaf_userid=%str(&userid), lsaf_password=%nrbquote(&password));

%let pc_zip_file = %str(C:/temp/test.zip);
%let pc_zip_file2 = %str(C:/temp/test2.zip);
%let lsaf_zip_path = %str(/SAS2/Project1/Analysis1/FolderA);

* Upload Zip file;
%lsaf_UploadAndExpand(local_path=%str(&pc_zip_file.),
                            lsaf_path=%str(&lsaf_zip_path.),
                            lsaf_versioning=1,
                            lsaf_version=%str(MAJOR),
                            lsaf_comment=%str(Uploaded from PC));


* Upload Zip file to add new versions or overwrite data;
%lsaf_UploadAndExpand(local_path=%str(&pc_zip_file.),
                            lsaf_path=%str(&lsaf_zip_path.),
                            lsaf_versioning=1,
                            lsaf_version=%str(MAJOR),
                            lsaf_comment=%str(Uploaded from PC2));


* Download full LSAF folder structure as zip - latest version only;
%lsaf_downloadAsZip(lsaf_path=%str(&lsaf_zip_path.),
                    local_path=%str(&pc_zip_file2.),
					lsaf_overwrite=1);

* Download single file						              
%*lsaf_downloadfile(lsaf_path=%str(/SAS/Project1/Files/Data/ae3.sas7bdat), lsaf_version=%str(1.2), 
                    local_path=%str(c:/SAS/Project1/Files/Data/ae3.sas7bdat));						              

* Logout;
%lsaf_logout();
