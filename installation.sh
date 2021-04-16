#!/bin/bash
config_file="./config.yml"
remove_config_file="./config.yml"
actual_output_file="../../../Logs/installation_logs.txt"
config_template="./config.yml.template"
new_config_file="./config.yml"
filled_config_file="../../../ConfigFiles/Fill_config_file.yml"
source_to_copy_infra_structure_master="../../../ConfigFiles/infrastructure_master.csv"
destination_to_copy_infra_structure_master="../../development/postgres/infrastructure_master.csv"
source_to_copy_infra_parameter_file="../../../ConfigFiles/infra_parameters.txt"
destination_to_copy_infra_parameter_file="../../development/python/infra_parameters.txt"
source_to_copy_cQube_raw_data_fetch_parameters_file="../../../ConfigFiles/cQube-raw-data-fetch-parameters.txt"
destination_to_copy_cQube_raw_data_fetch_parameters_file="../../development/python/cQube-raw-data-fetch-parameters.txt"
test_result_file="../../../TestResult/status_file.txt"
s3_access_key=$(awk ''/^s3_access_key:' /{ if ($2 !~ /#.*/) {print $2}}' ./ConfigFiles/installation_testing_config.yml)
s3_secret_key=$(awk ''/^s3_secret_key:' /{ if ($2 !~ /#.*/) {print $2}}' ./ConfigFiles/installation_testing_config.yml)
git_branch=$(awk ''/^git_branch:' /{ if ($2 !~ /#.*/) {print $2}}' ./ConfigFiles/installation_testing_config.yml)

remove_config_file()
{
  rm "$remove_config_file"
}
copy_new_config_file()
{
  cp $config_template $new_config_file
}
copy_filled_config_file()
{
  cp $filled_config_file $new_config_file
}
copy_infrastructure_file()
{
  cp $source_to_copy_infra_structure_master $destination_to_copy_infra_structure_master
}
remove_infrastructure_file()
{
  rm $destination_to_copy_infra_structure_master
}
copy_infra_parameter_file()
{
  cp $source_to_copy_infra_parameter_file $destination_to_copy_infra_parameter_file
}
remove_infra_parameter_file()
{
  rm $destination_to_copy_infra_parameter_file
}
copy_cQube_raw_data_fetch_parameters_file()
{
  cp $source_to_copy_cQube_raw_data_fetch_parameters_file $destination_to_copy_cQube_raw_data_fetch_parameters_file
}
remove_cQube_raw_data_fetch_parameters_file()
{
  rm $destination_to_copy_cQube_raw_data_fetch_parameters_file
}
remove_whitespace()
{
  value=$1
  after_removal_of_space=$(echo $value | tr -d ' ')
}
check_error_messages()
{
  while IFS= read -r line
  do
    actual_value=$(echo $line | tr -d ' ')
    expected_value=$1
    if [ $actual_value = $expected_value ]
    then
       return 1
    fi
  done < "$actual_output_file"

}
txtrst=$(tput sgr0) # Text reset
txtred=$(tput setaf 1) # Red
txtgreen=$(tput setaf 10) #green
txtblue=$(tput setaf 21) #blue
git clone https://github.com/project-sunbird/cQube.git
cd cQube/ansible/installation_scripts/
sudo git checkout $git_branch
cp config.yml.template config.yml
remove_infrastructure_file
copy_infrastructure_file
remove_infra_parameter_file
copy_infra_parameter_file
remove_cQube_raw_data_fetch_parameters_file
copy_cQube_raw_data_fetch_parameters_file
sudo ./install.sh
sudo ./validate.sh | tee "$actual_output_file"

echo "${txtblue}Test Case:1********Checking error messages without filling config.yml testing is started**********""${txtrst}" >> "$test_result_file"
msg="Error - in state_code. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}state_code error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}state_code error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in static_datasource. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}static_datasource error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}static_datasource error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in management. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}management error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}management error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in system_user_name. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}system_username error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}system_username error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in db_password. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}db_password error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}db_password error message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in read_only_db_user. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}read_only_db_user error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}read_only_db_user message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in read_only_db_password. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}read_only_db_password error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}read_only_db_password message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_access_key. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_access_key error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_access_key message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_secret_key. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_secret_key error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_secret_key message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_input_bucket. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_input_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_input_bucket message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_output_bucket. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_output_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_output_bucket message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in s3_emission_bucket. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}s3_emission_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}s3_emission_bucket message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in local_ipv4_address. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}local_ipv4_address error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}local_ipv4_address message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in vpn_local_ipv4_address. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}vpn_local_ipv4_address error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}vpn_local_ipv4_address message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in api_endpoint. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}api_endpoint error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}api_endpoint message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in keycloak_adm_passwd. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}keycloak_adm_passwd error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}keycloak_adm_passwd message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in keycloak_adm_user. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}keycloak_adm_user error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}keycloak_adm_user message is not displayed""${txtrst}" >> "$test_result_file"
fi

msg="Error - in keycloak_config_otp. Unable to get the value. Please check."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}keycloak_config_otp error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}keycloak_config_otp message is not displayed""${txtrst}" >> "$test_result_file"
fi

echo "${txtblue}Test Case:2********Checking state_code by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/state_code:/state_code: gujarath/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid State code. Please refer the state_list file and enter the correct value."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid State code error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid State code errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking state_code by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:3********Checking diksha_columns by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/diksha_columns: false/diksha_columns: False/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Please enter either true or false for diksha_columns"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid diksha_columns error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid diksha_columns errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking diksha_columns by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:4********Checking static_datasource by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/static_datasource:/static_datasource: xyz/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Please enter either udise or state for static_datasource"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid static_datasource error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid static_datasource errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking static_datasource by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:5********Checking system_user_name by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/system_user_name:/system_user_name: xyz/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Please check the system_user_name."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid system_user_name error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid system_user_name errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking system_user_name by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:6********Checking db_name by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/db_name: cqube_db/db_name: 123/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Naming convention is not correct. Please change the value of db_name."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid db_name error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid db_name errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking db_name by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:7********Checking db_password by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/db_password:/db_password: cqube1@/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - db_password should contain atleast one uppercase, one lowercase, one special character and one number. And should be minimum of 8 characters."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid db_password error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid db_password errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking db_password by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:8********Checking read_only_db_user by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/read_only_db_user:/read_only_db_user: xyz123/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Naming convention is not correct. Please change the value of read_only_db_user."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid read_only_db_user error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid read_only_db_user errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking read_only_db_user by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:9********Checking read_only_db_password by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/read_only_db_password:/read_only_db_password: cqube1@/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - read_only_db_password should contain atleast one uppercase, one lowercase, one special character and one number. And should be minimum of 8 characters."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid read_only_db_password error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid read_only_db_password errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking read_only_db_password by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:10********Checking s3_access_key & s3_secret_key by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/s3_access_key:/s3_access_key: AKIA2YWRVRZFEH7DOHEI/g' "$config_file"
sed -i 's/s3_secret_key:/s3_secret_key: yHgZxIrdhuoDhLQmPsL6UyKDKrlMPjheFSgQt2gf/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid aws access or secret keys"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid s3_access_key & s3_secret_key error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid s3_access_key & s3_secret_key errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking read_only_db_password by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:11********Checking s3_input_bucket by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/s3_access_key:/s3_access_key: '$s3_access_key'/g' "$config_file"
sed -i 's/s3_secret_key:/s3_secret_key: '$s3_secret_key'/g' "$config_file"
sed -i 's/s3_input_bucket:/s3_input_bucket: cqube-z1-input/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - [ s3_input_bucket : cqube-z1-input ] Bucket not owned or not found. Please change the bucket name in config.yml"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid s3_input_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid s3_input_bucket errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking s3_input_bucket by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:12********Checking s3_output_bucket by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/s3_access_key:/s3_access_key: '$s3_access_key'/g' "$config_file"
sed -i 's/s3_secret_key:/s3_secret_key: '$s3_secret_key'/g' "$config_file"
sed -i 's/s3_output_bucket:/s3_output_bucket: cqube-z1-output/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - [ s3_output_bucket : cqube-z1-output ] Bucket not owned or not found. Please change the bucket name in config.yml"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid s3_output_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid s3_output_bucket errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking s3_output_bucket by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:13********Checking s3_emission_bucket by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/s3_access_key:/s3_access_key: '$s3_access_key'/g' "$config_file"
sed -i 's/s3_secret_key:/s3_secret_key: '$s3_secret_key'/g' "$config_file"
sed -i 's/s3_emission_bucket:/s3_emission_bucket: cqube-z1-emission/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - [ s3_emission_bucket : cqube-z1-emission ] Bucket not owned or not found. Please change the bucket name in config.yml"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid s3_emission_bucket error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid s3_emission_bucket errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking s3_emission_bucket by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:14********Checking local_ipv4_address by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/local_ipv4_address:/local_ipv4_address: 172.31.11/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid value for local_ipv4_address"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid local_ipv4_address error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid local_ipv4_address errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking local_ipv4_address by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:15********Checking vpn_local_ipv4_address by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/vpn_local_ipv4_address:/vpn_local_ipv4_address: 172.31.11/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Invalid value for vpn_local_ipv4_address"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid vpn_local_ipv4_address error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid vpn_local_ipv4_address errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking vpn_local_ipv4_address by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:16********Checking keycloak_adm_user by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/keycloak_adm_user:/keycloak_adm_user: xyz123/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Naming convention is not correct. Please change the value of keycloak_adm_user."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid keycloak_adm_user error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid keycloak_adm_user errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking keycloak_adm_user by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:17********Checking keycloak_adm_passwd by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/keycloak_adm_passwd:/keycloak_adm_passwd: cqube1@/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - keycloak_adm_passwd should contain atleast one uppercase, one lowercase, one special character and one number. And should be minimum of 8 characters."
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid keycloak_adm_passwd error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid keycloak_adm_passwd errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking keycloak_adm_passwd by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:18********Checking keycloak_config_otp by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/keycloak_config_otp:/keycloak_config_otp: False/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Please enter either true or false for keycloak_config_otp"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid keycloak_config_otp error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid keycloak_config_otp errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking keycloak_config_otp by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:19********Checking session_timeout by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/session_timeout: 7D/session_timeout: 29M/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Minutes should be between 30 and 5256000"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid session_timeout error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid session_timeout errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking session_timeout by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:20********Checking session_timeout by passing invalid parameters testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_new_config_file
sed -i 's/session_timeout: 7D/session_timeout: 3651D/g' "$config_file"
sudo ./validate.sh | tee "$actual_output_file"
msg="Error - Days should be between 1 and 3650"
remove_whitespace "$msg"
check_error_messages $after_removal_of_space
if [ $? = 1 ]
then
  echo "${txtgreen}Invalid session_timeout error message is displayed""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}Invalid session_timeout errors message is not displayed""${txtrst}" >> "$test_result_file"
fi
echo "********Checking session_timeout by passing invalid parameters testing is completed****************" >> "$test_result_file"

echo "${txtblue}Test Case:21********Filling the valid parameters in the config.yml file testing is started****************""${txtrst}" >> "$test_result_file"
remove_config_file
copy_filled_config_file
sudo ./install.sh | tee "$actual_output_file"
output=$(grep -c "CQube installed successfully!!" $actual_output_file)
if [ $output = 1 ]
then
  echo "${txtgreen}cQube installed successfully""${txtrst}" >> "$test_result_file"
else
  echo "${txtred}cQube is not installed successfully""${txtrst}" >> "$test_result_file"
fi
echo "********Filling the valid parameters in the config.yml file testing is completed****************" >> "$test_result_file"


