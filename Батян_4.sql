use university
/*DECLARE @a INT, @b numeric(10,2) 
SET @a = 20
SET @b = (@a+@a)/15
SELECT @b; --вывод на экран результата*/

/*use university
DECLARE @a INT
SELECT @a = COUNT(*) FROM Students
SELECT @a*/

use university
DECLARE @str CHAR(30)
SELECT @str = Surname FROM Students 
SELECT @str

DECLARE @a INT
SET @a = (SELECT COUNT(*) FROM Groups) 
SELECT @a


/*DECLARE @mytable TABLE (id INT, myname CHAR(20) DEFAULT 'Иванов Иван')
INSERT INTO @mytable(id) VALUES (1)
INSERT INTO @mytable(id, myname) VALUES (2,'Игорь Троцкий') 
SELECT * FROM @mytable*/

DECLARE @mytable TABLE(id INT,	myname CHAR (255) DEFAULT 'Введите название')
INSERT @mytable SELECT Id_facultet, Name_facultet FROM Facultet 
SELECT * FROM @mytable

use university
--Запрос1
SELECT AVG(Salary) From Teachers

DECLARE @s float
SET @s = (SELECT AVG(Salary) From Teachers)
SET @s = @s * 123.34;
Select @s;

--Запрос2
Select Stipendia from Students

DECLARE @stp int
SET @stp = (SELECT SUM(Stipendia) From Students)
Select @stp;

select * from groups
where Name_group != '914301' and Name_group != '914302'
--Запрос3
DECLARE @k INT
SET @k = (SELECT COUNT(*) FROM Kafedra) 
SELECT @k

--Запрос4 
DECLARE @temp TABLE(id INT,	date_updated DATETIME, age BIGINT, surname CHAR (255))
INSERT @temp VALUES (1,'22/10/2001 23:00:00', 24, 'Студент')
INSERT @temp SELECT Id_student, Date_updated, Age, Surname FROM Students
SELECT * FROM @temp


DECLARE @n INT 
DECLARE @res CHAR(30)
SET @n = (SELECT COUNT(*) FROM kafedra) 
IF @n >10 BEGIN
SET @res = 'Количество кафедр больше 10' SELECT @res
END ELSE BEGIN
SET @res = 'Количество кафедр = ' + str(@n) SELECT @res
END

--Запрос5
DECLARE @f INT 
DECLARE @fac_res CHAR(30)
SET @f = (SELECT COUNT(*) FROM Facultet) 
IF @f >=2 AND @f <= 4 BEGIN
SET @fac_res = '' SELECT @fac_res
END ELSE BEGIN
SET @fac_res = 'Всего ' + str(@f) + ' факультетов' SELECT @fac_res
END

--Запрос6
SELECT Year(Date_of_birth) FROM Students;
SELECT AVG(Year(Date_of_birth)) FROM Students

DECLARE @d int
DECLARE @d_res CHAR(30)
SET @d = (SELECT AVG(Year(Date_of_birth)) FROM Students) 
IF @d >='1980' AND @d <= '1999' BEGIN
SET @d_res = '' SELECT @d_res
END ELSE BEGIN
SET @d_res = 'Ср. год рождения = ' + str(@d) SELECT @d_res
END


DECLARE @p INT SET @p = 1 WHILE @p <100
BEGIN
PRINT @p -- вывод на экран значения переменной 
IF (@p>40) AND (@p<50)
BREAK --выход и выполнение 1-й команды за циклом
ELSE
SET @p = @p+rand()*10 
CONTINUE
END
 PRINT @p

 --Запрос7
DECLARE @i INT
DECLARE @count INT
DECLARE @kaf TABLE(id INT,	kafedra_name varchar(50))

INSERT @kaf SELECT Id_kafedra, Name_kafedra FROM Kafedra
SELECT @i = Id_kafedra FROM Kafedra
SET @count = (Select Count(*) From Kafedra)

WHILE @count <10
	BEGIN
		SET @i= @i +1
		SET @count= @count+1
		INSERT @kaf VALUES (@i, 'Имя неизвестно')
	END
SELECT * FROM @kaf

USE University; 
GO
IF OBJECT_ID (N'dbo.ISOweek', N'FN') IS NOT NULL 
DROP FUNCTION dbo.ISOweek;


--Пример
GO
CREATE FUNCTION dbo.ISOweek (@DATE date) RETURNS CHAR(15)
WITH EXECUTE AS CALLER AS
BEGIN
DECLARE @man int; 
DECLARE @ISOweek char(15); 
SET @man= MONTH(@DATE)

IF (@man=1) SET @ISOweek='Январь'; 
IF (@man=2) SET @ISOweek='Февраль';
IF (@man=3) SET @ISOweek='Март';
IF (@man=4) SET @ISOweek='Апрель'; 
IF (@man=5) SET @ISOweek='Май';
IF (@man=6) SET @ISOweek='Июнь'; 
IF (@man=7) SET @ISOweek='Июль';
IF (@man=8) SET @ISOweek='Август';
IF (@man=9) SET @ISOweek='Сентябрь'; 
IF (@man=10) SET @ISOweek='Октябрь'; 
IF (@man=11) SET @ISOweek='Ноябрь';
IF (@man=12) SET @ISOweek='Декабрь';

RETURN(@ISOweek); 
END;

GO
SET DATEFIRST 1;
SELECT dbo.ISOweek('12.04.2004') AS 'Месяц';


USE University; 
GO
IF OBJECT_ID (N'ufn_SalesByStore', N'IF') IS NOT NULL
DROP FUNCTION DEKAN.ufn_SalesByStore; 
GO
CREATE FUNCTION DEKAN.ufn_SalesByStore(@storeid int) RETURNS TABLE
AS RETURN (
SELECT d.Name_kafedra AS "Кафедра", t.Position AS "Должность",
SUM(t.Salary + t.RISE) AS "Сумма зарплаты" FROM KAFEDRA d, TEACHERS t
WHERE d.Id_kafedra =t.Id_kafedra and t.salary>@storeid
GROUP BY d.Name_kafedra, t.Position);

GO
SELECT * from dekan.ufn_SalesByStore(99);

--Запрос8 | Пользовательская функция, которая возвращает результат в виде таблицы, 
--выводит всех учащихся студентов по кафедрам с указанием курса. 
--При этом функция имеет один параметр @city, с помощью которого есть ограничение на город проживания Минск.

USE University; 
GO
IF OBJECT_ID (N'ufn_kaf_students', N'IF') IS NOT NULL
DROP FUNCTION DEKAN.ufn_kaf_students; 
GO
CREATE FUNCTION DEKAN.ufn_kaf_students(@city varchar(50)) RETURNS TABLE
AS RETURN (
SELECT d.Name_kafedra AS "Кафедра", s.Surname AS "Фамилия", g.Course AS "Курс"
FROM Students s
INNER JOIN  Groups g ON s.id_group=g.id_group 
INNER JOIN  Kafedra d ON g.id_kafedra=d.Id_kafedra
WHERE s.City like @city);

GO
SELECT * from dekan.ufn_kaf_students('Минск');


--Пример 3
GO
CREATE PROCEDURE Count_Assistent 
AS
Select count(position) from TEACHERS
where position='Ассистент' 

EXECUTE Count_Assistent

--Пример 4

GO
CREATE PROCEDURE Count_Assistent_Salary @Sum_salary as Int
AS
Select count(position) from TEACHERS
WHERE position='Ассистент' and SALARY>=@Sum_salary 

EXEC Count_Assistent_Salary 100


--Запрос8

GO
CREATE PROCEDURE Count_Assistent_Salary_Title @Sum_salary as Int, @Title as varchar(15)
AS
Select count(*) from TEACHERS
WHERE position like @Title and SALARY>=@Sum_salary 

EXEC Count_Assistent_Salary_Title 100, '%нт%'

--Пример6
GO
CREATE PROCEDURE 
Count_Assistent_Itogo @Sum_salary Int, @Title Char(15) , @Itogo Int OUTPUT AS
Select @Itogo = count(*) from TEACHERS
WHERE SALARY>=@Sum_salary AND position LIKE @Title

Declare @q As int
EXEC Count_Assistent_Itogo 100, '%нт%', @q output select @q 

--Пример7
GO
CREATE PROCEDURE checkname @param int AS
IF (SELECT Surname FROM STUDENTS WHERE Id_student = @param)
= 'Батян'
RETURN 1 ELSE RETURN 2

DECLARE @return_status int
EXECUTE @return_status = checkname 3 SELECT 'Return Status' = @return_status 

--Пример8
GO
CREATE PROC update_proc AS
UPDATE STUDENTS SET stipendia = stipendia-50

Select stipendia from students;

EXEC update_proc

--Пример9
GO
CREATE PROC select_zavkaf @fio CHAR(10) AS
SELECT * FROM kafedra WHERE fio_zavkaf=@fio

EXEC select_zavkaf 'Доа А.В.'

--Запрос9 | Процедура update_proc_rise с входным параметром и значением по умолчанию @p real = 0.5
-- для увеличения значения надбавки к зарплате в таблице TEACHER в заданное количество раз:
GO
CREATE PROC update_proc_rise @p float = 0.5 AS
UPDATE TEACHERS SET rise = rise + rise*@p

Select rise from teachers;

EXEC update_proc_rise 1.5

--Пример11
GO
CREATE PROC count_teacher
@d1 DATE, @d2 DATE, @c INT OUTPUT 
AS
SELECT @c=count(Id_teacher) from teachers 
WHERE Date_hire BETWEEN @d1 AND @d2 SET @c = ISNULL(@c,0)

DECLARE @c2 INT
EXEC count_teacher '01/01/2006', '31/12/2008', @c2 OUTPUT SELECT @c2

--Задание1 | Функция для выполнения четырех арифметических операций “+”, “- ”, “*” и “/” 
--над целыми операндами типа bigint
GO
CREATE FUNCTION Calculator (@Opd1 bigint,
@Opd2 bigint,
@Oprt char(1) = '*') RETURNS bigint
AS BEGIN
DECLARE @Result bigint SET @Result =
CASE @Oprt
WHEN '+' THEN @Opd1 + @Opd2 WHEN '-' THEN @Opd1 - @Opd2
WHEN '*' THEN @Opd1 * @Opd2 WHEN '/' THEN @Opd1 / @Opd2 ELSE 0
END
Return @Result END

GO
SELECT dbo.Calculator(4,5, '+'),
dbo. Calculator(3,7, '*')- dbo.Calculator(64,4,'/')*2

--Задание2 | Функция, возвращающая таблицу с динамическим набором столбцов
GO
CREATE FUNCTION DYNTAB (@State char(15))
RETURNS Table AS
RETURN SELECT surname, name, city FROM students WHERE city = @state


SELECT * FROM DYNTAB ('Минск')
ORDER BY surname

--Задание3 | Функция, разбивающая входную строку на подстроки,
-- используя в качестве разделителя пробелы
GO
CREATE FUNCTION Parse (@String nvarchar (500))
RETURNS @tabl TABLE
(Number int IDENTITY (1,1) NOT NULL,
Substr nvarchar (30)) AS
BEGIN
DECLARE @Str1 nvarchar (500), @Pos int SET @Str1 = @String
WHILE 1>0 BEGIN
SET @Pos = CHARINDEX(' ', @Str1) IF @POS>0
BEGIN
INSERT INTO @tabl
VALUES (SUBSTRING (@Str1,1,@Pos)) END
ELSE BEGIN
INSERT INTO @tabl VALUES (@Str1) BREAK
END END RETURN END



DECLARE @TestString nvarchar (500)
Set @TestString = 'SQL Server 2019' 
SELECT * FROM Parse ('SQL Server 2019')


