-- Active: 1681969449391@@127.0.0.1@3306@lipatov_kr
-- Active: 1681969449391@@127.0.0.1@3306@cr_lab_lipatov

CREATE TABLE owners (
    owner_id INT AUTO_INCREMENT PRIMARY KEY,
    passport VARCHAR(11),
    FCS VARCHAR(250),
    CHECK (passport REGEXP '^[0-9]{4}-[0-9]{6}$')
);

CREATE TABLE cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT,
    year_of_issue INT,
    category VARCHAR(1),
    CHECK (year_of_issue > 1900),
    CHECK (category  IN("A", "B", "C", "M"))
);

CREATE TABLE vehile_appearance (
    car_id INT,
    mark VARCHAR(65),
    color VARCHAR(30),
    price INT
);

INSERT INTO owners VALUES(1, '2342-324234', 'Lipatov Maxim Sergeevich');
INSERT INTO owners VALUES(2, '2134-123456', 'Semyonov Roman Sergeevich');
INSERT INTO owners VALUES(3, '1234-324234', 'Proverkov Proverk Proverkovich');


INSERT INTO cars VALUES(1, 1, 2000, "A");
INSERT INTO cars VALUES(2, 1, 1910, "B");
INSERT INTO cars VALUES(3, 2, 1950, "C");
INSERT INTO cars VALUES(4, 3, 2020, "M");

INSERT INTO vehile_appearance VALUES(1, 'BMW', "green", 10000);
INSERT INTO vehile_appearance VALUES(2, 'Toyota', "yellow", 12312412);
INSERT INTO vehile_appearance VALUES(3, 'Nissan', "blue", 23578923);
INSERT INTO vehile_appearance VALUES(4, 'Lada', "white", 239866874);


-- 1. определить автомобили данного года выпуска, марка которых
-- содержит буквы «С», «М», или «Б». Отсортировать по
-- убыванию;
SELECT * FROM cars, vehile_appearance WHERE cars.car_id = vehile_appearance.car_id and cars.category IN ("B", "C", "M") ORDER BY cars.car_id DESC;

-- 2. определить количество автомобилей для каждого владельца;
SELECT FCS, COUNT(car_id) AS car_count FROM owners, cars WHERE owners.owner_id = cars.owner_id GROUP BY FCS;

-- 3. определить среднюю и максимальную цены автомобилей
-- каждой марки для некоторого года выпуска;
SELECT cars.car_id, vehile_appearance.mark, AVG(vehile_appearance.price), MAX(vehile_appearance.price) FROM cars, vehile_appearance WHERE cars.car_id = vehile_appearance.car_id GROUP BY vehile_appearance.mark;

-- 4. определить, есть ли владельцы черных или белых Мерседесов
-- 1996 г. выпуска, категория которых «В» или «С»;

SELECT owners.FCS, cars.car_id FROM owners, cars, vehile_appearance WHERE cars.car_id = vehile_appearance.car_id 
AND vehile_appearance.mark = "Mercedes" AND (vehile_appearance.color = "white" or vehile_appearance.color = "black") AND cars.category IN ("B", "C")
GROUP BY owners.FCS;

-- 5. определить количество автомобилей зарегистрованных за
-- последний год;

SELECT cars.car_id, cars.year_of_issue, INT(YEAR(CURRENT_DATE)) FROM cars GROUP BY cars.car_id;

-- 6. среди средних цен марок автомобилей найти максимальную
-- цену;

SELECT AVG(vehile_appearance.price) FROM vehile_appearance;

-- 7. определить владельцев заданного года получения прав, у
-- которых имеются автомобили, цена которых больше средней
-- цены всех автомобилей.
