from pgdb import connect
from decimal import Decimal

if __name__ == '__main__':
    with connect(host="127.0.0.1:5432", user='pguser', password='pgpassword') as connection:
        with connection.cursor() as cursor:
            # query = "INSERT INTO test (id, decimal, bool, str, dt, date, time) VALUES (%(id)s, %(decimal)s, %(bool)s, %(str)s, %(dt)s, %(date)s, %(time)s)"
            query = "INSERT INTO test (id) VALUES (%s)"
            
            dict_params = {
                "id": 2, "decimal": Decimal("1.3"), "bool": False, "str": "'aaa', DROP TABLE test;", "dt": "2021-05-12 08:15:00", "date": "2021-05-12", "time": "00:11:22"
            }
            cursor.execute(query,  ("1); DROP TABLE test; CREATE TABLE test2(id INTEGER",))