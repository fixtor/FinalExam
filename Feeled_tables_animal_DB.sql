-- Заполнить низкоуровневые таблицы именами(животных), командами
-- которые они выполняют и датами рождения
use animal_database;
insert into camels(id, `name`, commands, datebirth, `type`)
values	(1, 'camel1', 'roam', '2023-05-26', 'pack_animals'),
		(2, 'camel2', 'roam', '2021-05-26', 'pack_animals'),
		(3, 'camel3', 'roam', '2016-05-26', 'pack_animals');

insert into horses(id, `name`, commands, datebirth, `type`)
values	(1, 'horse1', 'galoop', '2023-05-26', 'pack_animals'),
		(2, 'horse2', 'galoop', '2021-05-26', 'pack_animals'),
		(3, 'horse3', 'galoop', '2016-05-26', 'pack_animals');

insert into donkeys(id, `name`, commands, datebirth, `type`)
values	(1, 'donkey1', 'roar', '2023-05-26', 'pack_animals'),
		(2, 'donkey2', 'roar', '2021-05-26', 'pack_animals'),
		(3, 'donkey3', 'roar', '2016-05-26', 'pack_animals');

insert into dogs(id, `name`, commands, datebirth, `type`)
values	(1, 'dog1', 'sit', '2023-05-26', 'pet_animals'),
		(2, 'dog2', 'sit', '2021-05-26', 'pet_animals'),
		(3, 'dog3', 'sit', '2016-05-26', 'pet_animals');

insert into cats(id, `name`, commands, datebirth, `type`)
values	(1, 'cat1', 'eat', '2023-05-26', 'pet_animals'),
		(2, 'cat2', 'eat', '2021-05-26', 'pet_animals'),
		(3, 'cat3', 'eat', '2016-05-26', 'pet_animals');

insert into hamsters(id, `name`, commands, datebirth, `type`)
values	(1, 'hamster1', 'sleep', '2023-05-26', 'pet_animals'),
		(2, 'hamster2', 'sleep', '2021-05-26', 'pet_animals'),
		(3, 'hamster3', 'sleep', '2016-05-26', 'pet_animals');
        
insert into pack_animals(id, horse_id, camel_id, domkey_id)
values(1, 1, 1, 1),
	  (2, 2, 2, 2),
	  (3, 3, 3, 3);

insert into pet_animals(id, dog_id, cat_id, hamster_id)
values(1, 1, 1, 1),
	  (2, 2, 2, 2),
	  (3, 3, 3, 3);

-- Удалив из таблицы верблюдов, т.к. верблюдов решили перевезти в другой
-- питомник на зимовку. 
ALTER TABLE pack_animals DROP foreign key fk_pack_animals_camel1;
ALTER TABLE pack_animals DROP column camel_id;

-- Объединить таблицы лошади, и ослы в одну таблицу.
SELECT * FROM horses JOIN donkeys ON horses.id = donkeys.id;

-- Создать новую таблицу “молодые животные” в которую попадут все
-- животные старше 1 года, но младше 3 лет и в отдельном столбце с точностью
-- до месяца подсчитать возраст животных в новой таблице
drop table if exists young_animals;
create table young_animals (id int auto_increment primary key, `name` varchar(50), `type` varchar(50), age_months int);
INSERT INTO young_animals (`name`, `type`, age_months)  
SELECT * FROM (
  (SELECT `name`, `type`, (datediff(curdate(), datebirth)/30) AS age FROM  camels as c where datediff(curdate(), datebirth) > 365 AND datediff(curdate(), datebirth) < 1095)
  UNION 
  (SELECT `name`, `type`, (datediff(curdate(), datebirth)/30) AS age FROM horses as h where datediff(curdate(), datebirth) > 365 AND datediff(curdate(), datebirth) < 1095)
  UNION 
  (SELECT `name`, `type`, (datediff(curdate(), datebirth)/30) AS age FROM donkeys as d where datediff(curdate(), datebirth) > 365 AND datediff(curdate(), datebirth) < 1095) 
  UNION 
  (SELECT `name`, `type`, (datediff(curdate(), datebirth)/30) AS age FROM cats as ca where datediff(curdate(), datebirth) > 365 AND datediff(curdate(), datebirth) < 1095) 
  UNION 
  (SELECT `name`, `type`, (datediff(curdate(), datebirth)/30) AS age FROM dogs as dogs where datediff(curdate(), datebirth) > 365 AND datediff(curdate(), datebirth) < 1095) 
  UNION 
  (SELECT `name`, `type`, (datediff(curdate(), datebirth)/30) AS age FROM hamsters where datediff(curdate(), datebirth) > 365 AND datediff(curdate(), datebirth) < 1095)
) as y_a;

-- Объединить все таблицы в одну, при этом сохраняя поля, указывающие на
-- прошлую принадлежность к старым таблицам

drop table if exists new_animal;
create table new_animal(id int auto_increment primary key, `name` varchar(50), `type` varchar(50), commands varchar(50), datebirth DATE);
insert into new_animal(`name`, `type`, commands, datebirth)
SELECT * FROM (
select `name`, `type`, commands, datebirth from camels as ca 
union 
select `name`, `type`, commands, datebirth from horses as ho
union 
select `name`, `type`, commands, datebirth from donkeys as don
union 
select `name`, `type`, commands, datebirth from cats as cat
union 
select `name`, `type`, commands, datebirth from dogs as dogs
union 
select `name`, `type`, commands, datebirth from hamsters as ham) as n_a;