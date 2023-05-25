-- Active: 1681969449391@@127.0.0.1@3306
CREATE USER 'test_user'@'%' IDENTIFIED BY 'password';

SELECT User, Host FROM mysql.user;

GRANT SELECT,UPDATE,INSERT ON test_database . test_database.tableOne, test_database.tableTwo TO 'test_user'@'%';

FLUSH PRIVILEGES;

-- GRANT ALL PRIVILEGES ON test_database . * TO 'test_user'@'localhost';

SHOW GRANTS FOR 'test_user'@'localhost';

CONNECT userok@"192.168.242.165" IDENTIFIED "qvRdWtKf9h"; 


   DNS-суффикс подключения . . . . . :
   Локальный IPv6-адрес канала . . . : fe80::e0af:d1c3:d8e5:3cf2%4
   IPv4-адрес. . . . . . . . . . . . : 192.168.242.22
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . : 192.168.242.1

Адаптер Ethernet VirtualBox Host-Only Network:

   DNS-суффикс подключения . . . . . :
   Локальный IPv6-адрес канала . . . : fe80::375f:2003:1d57:cad4%13
   IPv4-адрес. . . . . . . . . . . . : 192.168.56.1
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . :

C:\Windows\System32>cd C:\Program Files\MySQL\MySQL Workbench 8.0 CE

C:\Program Files\MySQL\MySQL Workbench 8.0 CE>mysql.exe -u userok -p
Enter password: **********
ERROR 1045 (28000): Access denied for user 'userok'@'localhost' (using password: YES)

C:\Program Files\MySQL\MySQL Workbench 8.0 CE>mysql.exe -u userok@"192.168.252.165" -p
Enter password: **********
ERROR 1045 (28000): Access denied for user 'userok@192.168.252.165'@'localhost' (using password: YES)

C:\Program Files\MySQL\MySQL Workbench 8.0 CE>mysql.exe -h 192.168.252.165 -u userok -p
Enter password: **********
ERROR 2003 (HY000): Can't connect to MySQL server on '192.168.252.165' (10060)

C:\Program Files\MySQL\MySQL Workbench 8.0 CE>mysql.exe -h localhost -u userok43 -p
Enter password:
ERROR 1045 (28000): Access denied for user 'userok43'@'localhost' (using password: NO)

C:\Program Files\MySQL\MySQL Workbench 8.0 CE>mysql.exe -h localhost -u userok43 -p
Enter password: ************
ERROR 1045 (28000): Access denied for user 'userok43'@'localhost' (using password: YES)

C:\Program Files\MySQL\MySQL Workbench 8.0 CE>mysql.exe -h localhost -u userok43 -p dXb%WQdXb%WQ
Enter password:
ERROR 1045 (28000): Access denied for user 'userok43'@'localhost' (using password: NO)

C:\Program Files\MySQL\MySQL Workbench 8.0 CE>
