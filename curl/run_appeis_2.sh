
curl --location 'https://vd-appeis-vip.vd.ru/api/v2/check_client_data' \
-k \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'hmac=a295e12a92f538e54f2e7a6588249416' \
--data-urlencode 'request={"business-key":"abcdef-ghijklmop-qrstuv-wxyz","req_sum":"40000.00","req_term":"12M","lastname":"ИВАНОВ","firstname":"ИВАН","patronimic":"ИВАНОВИЧ","birthday":"01.01.2000","phone_mobile":"+79111111111","email":"ivanov1@mail.ru","inn":"12345678910","gender":"M","pass_serial":"2220","pass_number":"000000","pass_issuer":"Московским РОВД","pass_issuer_code":"111-111","pass_issue_date":"10.10.2005","birthplace":"Москва","reg_address":"Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123","fact_address":"Байконур г., ул. им Генерал-полковника А.А.Максимова, д. 12а, 123","family_status":"MARRIED","emloyment_type":"EMPLOYED","organization_type":"COMMERCIAL_ORGANIZATION","company_occupation":"COMMERCE","position_type":"MANAGEMENT","last_work_term":"2Y_AND_MORE","monthly_income":"50000.00"}'  \
> appeis_2.json