# KV_DWH_Tarantool


 - Как работать с Key-Value DWH:
 - Когда сервер запущен, используя утилиту cURL(предположительно, любую другую тоже), отправляем запросы на localhost:port (8003, по умолчанию):

GET:       ```$ curl "localhost:8003?key-name" ```

	Ответ в формате «value-name» (изменений в хранилище не происходит)
	404, если такого ключа не существует
  
DELETE:    ```$ curl -X DELETE "localhost:8003?key-name"```

	Ответ в формате «key-name, value-name» (удаляется кортеж по этому ключу)
	404, если такого ключа не существует
  
POST:     ```     $ curl -d "key=key-name&value=value%20name" localhost:8003```

	Ответ в формате «value-name» (в хранилище добавляется кортеж)
	400, если не соблюден формат "key=key-name&value=value%20name"
	409, если такой ключ существует (в этом случае используй PUT)
	p.s. %20 — пробел
  
PUT:             ```$ curl -X PUT -d «key-name=new-value» localhost:8003```

	Кортеж в хранилище по ключу обновляется
	400, если не соблюден формат "key=key-name&value=value%20name"
	404, если такого ключа не существует
  

  > Все действия, в т.ч. ошибки логируются в var/log/tarantool/kv.log
  
  > Запуск: ```$ sudo tarantool kv.lua ```или ```$ sudo tarantoolctl start kv``` 
  
  > (файл должен лежать в etc/tarantool/instances.enabled/kv.lua)
