Если выполнить этот запрос (который вы прислали) серез консоль,


curl --location 'https://vd-appeis-vip.vd.ru/api/v2/check_client_data' \
-k  \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Cookie: XSRF-TOKEN=eyJpdiI6IkljQURITkQvQ0VnUWxqWDZpTU01bUE9PSIsInZhbHVlIjoiblQ1MW5nMFMzRWt1c2VXamp4TSttbUlGZ0l2dFJ5SithZWY4ei8rTEFBeDNWblNERjkrcXo4eXhkTVJrN3pqRERtNHl6dlRBSjVQT1lCQ1MwNWtsMEFvenRsMGRpZ3hQaXBoODQxWjllWmQrcmpXWGlVNXAzcXNRRVh4bTBwbVMiLCJtYWMiOiI0ODQ3YWE1ODg2YTZmNTZkODM1Y2JhMDIwMjFiYTliOTQ5ODczZjhiZTUwZDkyMzdiZmY5MzBhMTA2NmEwZGE3IiwidGFnIjoiIn0%3D; laravel-session=eyJpdiI6InB6SEJKREQyR1dsT29ZSVBIZkdLR1E9PSIsInZhbHVlIjoiME82YkxZOXlNeDVUZjM2NUhpZUw0dEhwb1hNeWVmR2FZRGZpdXY3UDlMQWwwT2NJdjJacnZ2M2FOcklSMU8zdHlTSjBVQWlUNVk0eG5qRURzOURVd3M0QjlTSlB3NkRzcHdmVUV0UDc1U2pUTHVoaDdvb3hRRlN0a0JzdndvMU4iLCJtYWMiOiIyOGVjOTUzOWExMDhmMzFkNDZmODAxZmU4ZjZmMWU5MjMyYTcwYzczNmFkOTBlYTE5OWQ2NjFjNGI2N2MzNWVjIiwidGFnIjoiIn0%3D' \
--data-urlencode 'hmac=321ef2772c0401699366e8494e49eaee' \
--data-urlencode 'request=%7B%22business-key%22%3A%22test%22%2C%22req_sum%22%3A%2210000%22%2C%22req_term%22%3A%221M%22%2C%22lastname%22%3A%22%D0%A2%D0%B5%D1%81%D1%82%D0%BE%D0%B2%22%2C%22firstname%22%3A%22%D0%A2%D0%B5%D1%81%D1%82%D0%BE%D0%B2%22%2C%22patronimic%22%3A%22%D0%A2%D0%B5%D1%81%D1%82%D0%BE%D0%B2%22%2C%22birthday%22%3A%221990-01-01%22%2C%22phone_mobile%22%3A%22%2B79000000000%22%2C%22email%22%3A%22test%40test.ru%22%2C%22inn%22%3Anull%2C%22gender%22%3A%22M%22%2C%22pass_serial%22%3A%220000%22%2C%22pass_number%22%3A%22000111%22%2C%22pass_issuer%22%3A%22%D0%A2%D0%9F%22%2C%22pass_issuer_code%22%3A%22123-123%22%2C%22pass_issue_date%22%3A%222008-01-01%22%2C%22birthplace%22%3A%22%D0%97%D0%B5%D0%BC%D0%BB%D1%8F%22%2C%22reg_address%22%3A%22%D0%9A%D0%B0%D0%BA%D0%BE%D0%B9-%D1%82%D0%BE+%D0%B0%D0%B4%D1%80%D0%B5%D1%81%22%2C%22fact_address%22%3A%22%D0%9A%D0%B0%D0%BA%D0%BE%D0%B9-%D1%82%D0%BE+%D0%B0%D0%B4%D1%80%D0%B5%D1%81%22%2C%22family_status%22%3A%22Single%22%2C%22emloyment_type%22%3A%22UNEMPLOYED%22%2C%22organization_type%22%3Anull%2C%22company_occupation%22%3Anull%2C%22position_type%22%3Anull%2C%22last_work_term%22%3A%222Y_AND_MORE%22%2C%22monthly_income%22%3A%2250000%22%7D' \
 > appeis_1.json

То я получаю 

{
    "debug_info": {
    ...
    },
    "run_data": [],
    "result": -1,
    "result_str": "HMAC не совпадает (gen=72154fe571255dd9807851bfe4d94b65, post=321ef2772c0401699366e8494e49eaee)"
}



в случае если я подставляю https://eis.vivadengi.ru/ 

curl --location 'https://eis.vivadengi.ru/api/v2/check_client_data' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Cookie: XSRF-TOKEN=eyJpdiI6IkljQURITkQvQ0VnUWxqWDZpTU01bUE9PSIsInZhbHVlIjoiblQ1MW5nMFMzRWt1c2VXamp4TSttbUlGZ0l2dFJ5SithZWY4ei8rTEFBeDNWblNERjkrcXo4eXhkTVJrN3pqRERtNHl6dlRBSjVQT1lCQ1MwNWtsMEFvenRsMGRpZ3hQaXBoODQxWjllWmQrcmpXWGlVNXAzcXNRRVh4bTBwbVMiLCJtYWMiOiI0ODQ3YWE1ODg2YTZmNTZkODM1Y2JhMDIwMjFiYTliOTQ5ODczZjhiZTUwZDkyMzdiZmY5MzBhMTA2NmEwZGE3IiwidGFnIjoiIn0%3D; laravel-session=eyJpdiI6InB6SEJKREQyR1dsT29ZSVBIZkdLR1E9PSIsInZhbHVlIjoiME82YkxZOXlNeDVUZjM2NUhpZUw0dEhwb1hNeWVmR2FZRGZpdXY3UDlMQWwwT2NJdjJacnZ2M2FOcklSMU8zdHlTSjBVQWlUNVk0eG5qRURzOURVd3M0QjlTSlB3NkRzcHdmVUV0UDc1U2pUTHVoaDdvb3hRRlN0a0JzdndvMU4iLCJtYWMiOiIyOGVjOTUzOWExMDhmMzFkNDZmODAxZmU4ZjZmMWU5MjMyYTcwYzczNmFkOTBlYTE5OWQ2NjFjNGI2N2MzNWVjIiwidGFnIjoiIn0%3D' \
--data-urlencode 'hmac=321ef2772c0401699366e8494e49eaee' \
--data-urlencode 'request=%7B%22business-key%22%3A%22test%22%2C%22req_sum%22%3A%2210000%22%2C%22req_term%22%3A%221M%22%2C%22lastname%22%3A%22%D0%A2%D0%B5%D1%81%D1%82%D0%BE%D0%B2%22%2C%22firstname%22%3A%22%D0%A2%D0%B5%D1%81%D1%82%D0%BE%D0%B2%22%2C%22patronimic%22%3A%22%D0%A2%D0%B5%D1%81%D1%82%D0%BE%D0%B2%22%2C%22birthday%22%3A%221990-01-01%22%2C%22phone_mobile%22%3A%22%2B79000000000%22%2C%22email%22%3A%22test%40test.ru%22%2C%22inn%22%3Anull%2C%22gender%22%3A%22M%22%2C%22pass_serial%22%3A%220000%22%2C%22pass_number%22%3A%22000111%22%2C%22pass_issuer%22%3A%22%D0%A2%D0%9F%22%2C%22pass_issuer_code%22%3A%22123-123%22%2C%22pass_issue_date%22%3A%222008-01-01%22%2C%22birthplace%22%3A%22%D0%97%D0%B5%D0%BC%D0%BB%D1%8F%22%2C%22reg_address%22%3A%22%D0%9A%D0%B0%D0%BA%D0%BE%D0%B9-%D1%82%D0%BE+%D0%B0%D0%B4%D1%80%D0%B5%D1%81%22%2C%22fact_address%22%3A%22%D0%9A%D0%B0%D0%BA%D0%BE%D0%B9-%D1%82%D0%BE+%D0%B0%D0%B4%D1%80%D0%B5%D1%81%22%2C%22family_status%22%3A%22Single%22%2C%22emloyment_type%22%3A%22UNEMPLOYED%22%2C%22organization_type%22%3Anull%2C%22company_occupation%22%3Anull%2C%22position_type%22%3Anull%2C%22last_work_term%22%3A%222Y_AND_MORE%22%2C%22monthly_income%22%3A%2250000%22%7D' \
 > eis_1.json
 
то получаю

{
  "hmac": "ed1df002846b2f8d2adf51f33bc8c223",
  "response": {
    "status": "FAIL",
    "message": "REQUEST: Не является корректным JSON"
  }
}



===========================================================
Несколько изменил запрос, используя тот же request

{"business-key":"test","req_sum":"10000","req_term":"1M","lastname":"Тестов","firstname":"Тестов","patronimic":"Тестов","birthday":"1990-01-01","phone_mobile":"+79000000000","email":"test@test.ru","inn":null,"gender":"M","pass_serial":"0000","pass_number":"000111","pass_issuer":"ТП","pass_issuer_code":"123-123","pass_issue_date":"2008-01-01","birthplace":"Земля","reg_address":"Какой-то+адрес","fact_address":"Какой-то+адрес","family_status":"Single","emloyment_type":"UNEMPLOYED","organization_type":null,"company_occupation":null,"position_type":null,"last_work_term":"2Y_AND_MORE","monthly_income":"50000"}

в тестовую форму 
https://eis.vivadengi.ru/test/v2

я получаю другой HMAC

630534748e5836fcf04fbf88af246b62







curl -i -X POST \
   -H "Content-Type:application/x-www-form-urlencoded" \
   -H "x-req-id:00e49c4f-4bfc-c96f-d682-1ea826574557" \
   -d "hmac=321ef2772c0401699366e8494e49eaee" \
   -d "request={\"business-key\":\"test\",\"req_sum\":\"10000\",\"req_term\":\"1M\",\"lastname\":\"Тестов\",\"firstname\":\"Тестов\",\"patronimic\":\"Тестов\",\"birthday\":\"1990-01-01\",\"phone_mobile\":\"+79000000000\",\"email\":\"test@test.ru\",\"inn\":null,\"gender\":\"M\",\"pass_serial\":\"0000\",\"pass_number\":\"000111\",\"pass_issuer\":\"ТП\",\"pass_issuer_code\":\"123-123\",\"pass_issue_date\":\"2008-01-01\",\"birthplace\":\"Земля\",\"reg_address\":\"Какой-то+адрес\",\"fact_address\":\"Какой-то+адрес\",\"family_status\":\"Single\",\"emloyment_type\":\"UNEMPLOYED\",\"organization_type\":null,\"company_occupation\":null,\"position_type\":null,\"last_work_term\":\"2Y_AND_MORE\",\"monthly_income\":\"50000\"}" \
 'https://vd-appeis-vip.vd.ru/api/v2/check_client_data'
 
Получаю
{
    "debug_info": {...},
    "run_data": [
    ],
    "result": -1,
    "result_str": "HMAC не совпадает (gen=630534748e5836fcf04fbf88af246b62, post=321ef2772c0401699366e8494e49eaee)"
}




При этом, если такой же запрос я отправляю на eis.vivadengi.ru





curl -i -X POST \
   -H "Content-Type:application/x-www-form-urlencoded" \
   -H "x-req-id:00e49c4f-4bfc-c96f-d682-1ea826574557" \
   -d "hmac=321ef2772c0401699366e8494e49eaee" \
   -d "request={\"business-key\":\"test\",\"req_sum\":\"10000\",\"req_term\":\"1M\",\"lastname\":\"Тестов\",\"firstname\":\"Тестов\",\"patronimic\":\"Тестов\",\"birthday\":\"1990-01-01\",\"phone_mobile\":\"+79000000000\",\"email\":\"test@test.ru\",\"inn\":null,\"gender\":\"M\",\"pass_serial\":\"0000\",\"pass_number\":\"000111\",\"pass_issuer\":\"ТП\",\"pass_issuer_code\":\"123-123\",\"pass_issue_date\":\"2008-01-01\",\"birthplace\":\"Земля\",\"reg_address\":\"Какой-то+адрес\",\"fact_address\":\"Какой-то+адрес\",\"family_status\":\"Single\",\"emloyment_type\":\"UNEMPLOYED\",\"organization_type\":null,\"company_occupation\":null,\"position_type\":null,\"last_work_term\":\"2Y_AND_MORE\",\"monthly_income\":\"50000\"}" \
 'https://eis.vivadengi.ru/api/v2/check_client_data'
 
 
 
 {
    "hmac": "dad8f1b8defb88b87d09c065765b0eb5",
    "response": {
        "status": "FAIL",
        "message": "HMAC: Некорректный hmac"
    }
}
