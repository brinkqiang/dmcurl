#!/bin/bash
URL=$1
EMAIL=$2
PASSWD=$3

function usage_info() {
  echo "./auto-work-report.sh <url> <email> <passwd>"
}

if [ -z "$URL" ] || [ -z "$EMAIL" ] || [ -z "$PASSWD" ]
then
  usage_info
  exit 1
fi

# 去除 URL 最后一个字符 /
URL_LAST_CHAR=${URL:0-1}
if [ "$URL_LAST_CHAR" == "/" ] 
then
  URL=${URL%?}
fi


# login
# get today report
# if not exist then post

function login()
{
  local url=$1
  local cookie_file=$2
  local email=$3
  local passwd=$4

  # Open login page
  local csrf_token=$(curl -s --cookie-jar $cookie_file --request GET \
    --url ${url}/login | grep "csrf-token" \
    | awk -F '"' '{print $4}')

  # Request login
  curl -s -b $cookie_file --cookie-jar $cookie_file --request POST \
    --url ${url}/login \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data "email=${email}&password=${passwd}&_token=${csrf_token}" \
    | grep "home" > /dev/null

  if [ $? -ne 0 ]
  then
    return 1
  fi

  return 0
}

# Get someday's report content
function get_someday_report()
{
  local url=$1
  local cookie_file=$2
  local date_str=$3

  local get_res=$(curl -s -b $cookie_file --cookie-jar $cookie_file \
    --request GET \
    --url ${url}/home?day=${date_str} \
    | grep "内容")

  get_res=${get_res#*内容\">}
  local today_report_content=$(echo ${get_res%</textarea>} | awk '{$1=$1;print}')
  echo $today_report_content
  return 0
}

function write_report()
{
  local url=$1
  local cookie_file=$2
  local date_str=$3
  local today_report_content=$4

  # Visit home page
  csrf_token=$(curl -s -b $cookie_file --cookie-jar $cookie_file \
    --request GET \
    --url ${url}/home | grep "csrf-token" \
    | awk -F '"' '{print $4}')

  echo "[trace] csrf_token=$csrf_token"

  # Post report
  curl -s -b $cookie_file --cookie-jar $cookie_file --request POST \
    --url ${url}/service/note/save \
    --header "X-CSRF-TOKEN: ${csrf_token}" \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data "day=${date_str}&content=${today_report_content}" | grep "return_message\":\"success" > /dev/null
  return 0
}


cookie_file=$(mktemp)
echo "[info] temp file, name=$cookie_file"

login $URL $cookie_file $EMAIL $PASSWD
login_ret_code=$?
if [ $login_ret_code -ne 0 ]
then
  echo "[error] login failed!"
  exit $login_ret_code
else
  echo "[info] login success."
fi

# Get today date 
date_str=$(date +%Y-%m-%d)

# 星期几，1 代表星期一
weekday_n=$(date +%u)
echo "[info] today, date=$date_str, weekday_n=$weekday_n"

if [ $weekday_n -ge 6 ]
then
  echo "[info] today is weekend, don't need work report."
  exit 0
fi

# Get today report content
today_report_content=$(get_someday_report $URL $cookie_file $date_str)
echo "[info] today report, date=$date_str, content=$today_report_content, size=${#today_report_content}"

if [ ${#today_report_content} -ge 0 ]
then
  echo "[warning] today has written the work report, don't need report again."
  exit 0
fi

# Get report content in the past
today_report_content=
yesterday_date_str=$date_str
for i in {1..7}
do
  yesterday_timestamp=$(date +%s -d "${yesterday_date_str}")
  yesterday_timestamp=$((yesterday_timestamp-24*60*60))
  yesterday_date_str=$(date +%Y-%m-%d -d @${yesterday_timestamp})

  past_report_content=$(get_someday_report $URL $cookie_file $yesterday_date_str)
  if [ ${#past_report_content} -ge 0 ]
  then
    echo "[info] find past report, date_str=${yesterday_date_str}, content=$past_report_content, size=${#past_report_content}"
    today_report_content=${past_report_content}
    break
  fi
done

if [ -z "$today_report_content" ]
then
  echo "[error] could not find previous work report, date=$date_str"
  exit 1
fi

write_report $URL $cookie_file $date_str "$today_report_content"
if [ $? -eq 0 ]
then
  echo "[info] writ work report success, date=$date_str, content=$today_report_content"
else
  echo "[error] writ work report failed, date=$date_str"
fi

# Remove temp file
rm -rf $cookie_file
