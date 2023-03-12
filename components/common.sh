

 exitcode(){
if [ $1 -ne 0 ]; then
 echo -e "$2:" "\e[31m FAILURE \e[0m"
 exit 2
else
 echo -e "$2:" "\e[32m SUCCESS \e[0m"
 return
fi
}