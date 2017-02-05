Universal database log of data changes by parse the sql queries for PHP
========================================
The DatabaseChangeLog class help to log all update, delete, insert SQL queries into table _data_change_log_.
The class parse raw SQL or PDO query with statement only by add one string to code. 
In log will be save change of data and the userID, ip, userAgent and system(configurable).  
The tables and columns that need log may be configurable by each action (update, delete, insert). 

Installation
--------------------
###Download
[From Git](https://github.com/moledet/database-change-log)<br>
###Clone
```bash
git clone https://github.com/moledet/database-change-log.git Log
```

###Composer
```bash
php composer.phar require moledet/database-change-log
```
or add to yours _composer.json_ see [the documentation](https://getcomposer.org/doc/).
```json
 {
     "repositories": [
         {
             "url": "https://github.com/moledet/database-change-log.git",
             "type": "git"
         }
     ],
     "require": {
         "moledet/database-change-log": "*"
     }
 }
```
###Dependency
This class depends on [PHP-SQL-Parser](https://github.com/greenlion/PHP-SQL-Parser).

Usage
--------------------
###Config
You must config a database connection.
```php
 $config = array(
    'database'=>'mysql',
    'host'=>'localhost',
    'port'=>3306,
    'dbname'=>'test',
    'charset'=>'utf8',
    'user'=>'admin',
    'password'=>'secret'
 );

       
 DatabaseChangeLog::getInstance()->setConnection($config);
```

May config current user id (default 0), system name(default CRM) or list of tables|columns|actions that need log.
If not config the tables list - all tables changes will be logged.
```php
DatabaseChangeLog::getInstance()->setUserId(7);
DatabaseChangeLog::getInstance()->setSystemName('API');

$config = [
                    'user'=>[
                        'insert'=>['login','name','password']
                        'delete'=>'all',
                        'update'=>['login','name']
                     ],
                     'customers'=>'all',
           ];
           
DatabaseChangeLog::getInstance()->setLogTablesConfig($config);                 
```
###How to use
Need put call of log sql before run. You may override framework or ORM connection to run it before query.
```php
 $sql = "UPDATE user SET password='secret' WHERE id=7;";
 DatabaseChangeLog::getInstance()->log($sql);
 
 $framework->getConnection()->runSQL($sql);
```
Or PDO:
```php
 $query = 'UPDATE users SET bonus = bonus + ? WHERE id = ?';
 $stmt = $pdo->prepare($query);
 foreach ($data as $id => $bonus)
 {
    DatabaseChangeLog::getInstance()->log($query,[$bonus,$id]);
    $stmt->execute([$bonus,$id]);
 }
``` 


###Result
In table _data_change_log_ will be save the log of changes.

| id | action  | table  | column | newValue | oldValue | date | system | userId | ip | UserAgent | columnReference | operatorReference | valueReference|
| --- |:-------------:| -----:| -----:| :-------------:| ------:| -----:|:-------------:| -----:| -----:|:-------------:| -----:| -----:| -----:|
| 1 | update | customers| phone| 77777| 99999|  2017-02-02 10:33:32| CRM| 5| 127.0.0.1|Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.76 Safari/537.36|id|=|289460|
| 2 | delete | country| | null|null| 2017-02-03 11:33:22|API|1|127.1.1.7|Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.76 Safari/537.36|countryId|=|20|
| 3 | insert | user | name | Bob |null| 2017-02-04 15:31:52|API|1|127.1.1.7|Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.76 Safari/537.36|null|null|null|
| 5 | insert | user | phone | 89898 |null| 2017-02-04 15:31:52|API|1|127.1.1.7|Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.76 Safari/537.36|null|null|null| 
| 6 | insert | user | password | secret |null| 2017-02-04 15:31:52|API|1|127.1.1.7|Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.76 Safari/537.36|null|null|null|  