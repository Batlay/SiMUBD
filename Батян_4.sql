use university
/*DECLARE @a INT, @b numeric(10,2) 
SET @a = 20
SET @b = (@a+@a)/15
SELECT @b; --����� �� ����� ����������*/

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


/*DECLARE @mytable TABLE (id INT, myname CHAR(20) DEFAULT '������ ����')
INSERT INTO @mytable(id) VALUES (1)
INSERT INTO @mytable(id, myname) VALUES (2,'����� �������') 
SELECT * FROM @mytable*/

DECLARE @mytable TABLE(id INT,	myname CHAR (255) DEFAULT '������� ��������')
INSERT @mytable SELECT Id_facultet, Name_facultet FROM Facultet 
SELECT * FROM @mytable

use university
--������1
SELECT AVG(Salary) From Teachers

DECLARE @s float
SET @s = (SELECT AVG(Salary) From Teachers)
SET @s = @s * 123.34;
Select @s;

--������2
Select Stipendia from Students

DECLARE @stp int
SET @stp = (SELECT SUM(Stipendia) From Students)
Select @stp;

select * from groups
where Name_group != '914301' and Name_group != '914302'
--������3
DECLARE @k INT
SET @k = (SELECT COUNT(*) FROM Kafedra) 
SELECT @k

--������4 
DECLARE @temp TABLE(id INT,	date_updated DATETIME, age BIGINT, surname CHAR (255))
INSERT @temp VALUES (1,'22/10/2001 23:00:00', 24, '�������')
INSERT @temp SELECT Id_student, Date_updated, Age, Surname FROM Students
SELECT * FROM @temp


DECLARE @n INT 
DECLARE @res CHAR(30)
SET @n = (SELECT COUNT(*) FROM kafedra) 
IF @n >10 BEGIN
SET @res = '���������� ������ ������ 10' SELECT @res
END ELSE BEGIN
SET @res = '���������� ������ = ' + str(@n) SELECT @res
END

--������5
DECLARE @f INT 
DECLARE @fac_res CHAR(30)
SET @f = (SELECT COUNT(*) FROM Facultet) 
IF @f >=2 AND @f <= 4 BEGIN
SET @fac_res = '' SELECT @fac_res
END ELSE BEGIN
SET @fac_res = '����� ' + str(@f) + ' �����������' SELECT @fac_res
END

--������6
SELECT Year(Date_of_birth) FROM Students;
SELECT AVG(Year(Date_of_birth)) FROM Students

DECLARE @d int
DECLARE @d_res CHAR(30)
SET @d = (SELECT AVG(Year(Date_of_birth)) FROM Students) 
IF @d >='1980' AND @d <= '1999' BEGIN
SET @d_res = '' SELECT @d_res
END ELSE BEGIN
SET @d_res = '��. ��� �������� = ' + str(@d) SELECT @d_res
END


DECLARE @p INT SET @p = 1 WHILE @p <100
BEGIN
PRINT @p -- ����� �� ����� �������� ���������� 
IF (@p>40) AND (@p<50)
BREAK --����� � ���������� 1-� ������� �� ������
ELSE
SET @p = @p+rand()*10 
CONTINUE
END
 PRINT @p

 --������7
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
		INSERT @kaf VALUES (@i, '��� ����������')
	END
SELECT * FROM @kaf

USE University; 
GO
IF OBJECT_ID (N'dbo.ISOweek', N'FN') IS NOT NULL 
DROP FUNCTION dbo.ISOweek;


--������
GO
CREATE FUNCTION dbo.ISOweek (@DATE date) RETURNS CHAR(15)
WITH EXECUTE AS CALLER AS
BEGIN
DECLARE @man int; 
DECLARE @ISOweek char(15); 
SET @man= MONTH(@DATE)

IF (@man=1) SET @ISOweek='������'; 
IF (@man=2) SET @ISOweek='�������';
IF (@man=3) SET @ISOweek='����';
IF (@man=4) SET @ISOweek='������'; 
IF (@man=5) SET @ISOweek='���';
IF (@man=6) SET @ISOweek='����'; 
IF (@man=7) SET @ISOweek='����';
IF (@man=8) SET @ISOweek='������';
IF (@man=9) SET @ISOweek='��������'; 
IF (@man=10) SET @ISOweek='�������'; 
IF (@man=11) SET @ISOweek='������';
IF (@man=12) SET @ISOweek='�������';

RETURN(@ISOweek); 
END;

GO
SET DATEFIRST 1;
SELECT dbo.ISOweek('12.04.2004') AS '�����';


USE University; 
GO
IF OBJECT_ID (N'ufn_SalesByStore', N'IF') IS NOT NULL
DROP FUNCTION DEKAN.ufn_SalesByStore; 
GO
CREATE FUNCTION DEKAN.ufn_SalesByStore(@storeid int) RETURNS TABLE
AS RETURN (
SELECT d.Name_kafedra AS "�������", t.Position AS "���������",
SUM(t.Salary + t.RISE) AS "����� ��������" FROM KAFEDRA d, TEACHERS t
WHERE d.Id_kafedra =t.Id_kafedra and t.salary>@storeid
GROUP BY d.Name_kafedra, t.Position);

GO
SELECT * from dekan.ufn_SalesByStore(99);

--������8 | ���������������� �������, ������� ���������� ��������� � ���� �������, 
--������� ���� �������� ��������� �� �������� � ��������� �����. 
--��� ���� ������� ����� ���� �������� @city, � ������� �������� ���� ����������� �� ����� ���������� �����.

USE University; 
GO
IF OBJECT_ID (N'ufn_kaf_students', N'IF') IS NOT NULL
DROP FUNCTION DEKAN.ufn_kaf_students; 
GO
CREATE FUNCTION DEKAN.ufn_kaf_students(@city varchar(50)) RETURNS TABLE
AS RETURN (
SELECT d.Name_kafedra AS "�������", s.Surname AS "�������", g.Course AS "����"
FROM Students s
INNER JOIN  Groups g ON s.id_group=g.id_group 
INNER JOIN  Kafedra d ON g.id_kafedra=d.Id_kafedra
WHERE s.City like @city);

GO
SELECT * from dekan.ufn_kaf_students('�����');


--������ 3
GO
CREATE PROCEDURE Count_Assistent 
AS
Select count(position) from TEACHERS
where position='���������' 

EXECUTE Count_Assistent

--������ 4

GO
CREATE PROCEDURE Count_Assistent_Salary @Sum_salary as Int
AS
Select count(position) from TEACHERS
WHERE position='���������' and SALARY>=@Sum_salary 

EXEC Count_Assistent_Salary 100


--������8

GO
CREATE PROCEDURE Count_Assistent_Salary_Title @Sum_salary as Int, @Title as varchar(15)
AS
Select count(*) from TEACHERS
WHERE position like @Title and SALARY>=@Sum_salary 

EXEC Count_Assistent_Salary_Title 100, '%��%'

--������6
GO
CREATE PROCEDURE 
Count_Assistent_Itogo @Sum_salary Int, @Title Char(15) , @Itogo Int OUTPUT AS
Select @Itogo = count(*) from TEACHERS
WHERE SALARY>=@Sum_salary AND position LIKE @Title

Declare @q As int
EXEC Count_Assistent_Itogo 100, '%��%', @q output select @q 

--������7
GO
CREATE PROCEDURE checkname @param int AS
IF (SELECT Surname FROM STUDENTS WHERE Id_student = @param)
= '�����'
RETURN 1 ELSE RETURN 2

DECLARE @return_status int
EXECUTE @return_status = checkname 3 SELECT 'Return Status' = @return_status 

--������8
GO
CREATE PROC update_proc AS
UPDATE STUDENTS SET stipendia = stipendia-50

Select stipendia from students;

EXEC update_proc

--������9
GO
CREATE PROC select_zavkaf @fio CHAR(10) AS
SELECT * FROM kafedra WHERE fio_zavkaf=@fio

EXEC select_zavkaf '��� �.�.'

--������9 | ��������� update_proc_rise � ������� ���������� � ��������� �� ��������� @p real = 0.5
-- ��� ���������� �������� �������� � �������� � ������� TEACHER � �������� ���������� ���:
GO
CREATE PROC update_proc_rise @p float = 0.5 AS
UPDATE TEACHERS SET rise = rise + rise*@p

Select rise from teachers;

EXEC update_proc_rise 1.5

--������11
GO
CREATE PROC count_teacher
@d1 DATE, @d2 DATE, @c INT OUTPUT 
AS
SELECT @c=count(Id_teacher) from teachers 
WHERE Date_hire BETWEEN @d1 AND @d2 SET @c = ISNULL(@c,0)

DECLARE @c2 INT
EXEC count_teacher '01/01/2006', '31/12/2008', @c2 OUTPUT SELECT @c2

--�������1 | ������� ��� ���������� ������� �������������� �������� �+�, �- �, �*� � �/� 
--��� ������ ���������� ���� bigint
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

--�������2 | �������, ������������ ������� � ������������ ������� ��������
GO
CREATE FUNCTION DYNTAB (@State char(15))
RETURNS Table AS
RETURN SELECT surname, name, city FROM students WHERE city = @state


SELECT * FROM DYNTAB ('�����')
ORDER BY surname

--�������3 | �������, ����������� ������� ������ �� ���������,
-- ��������� � �������� ����������� �������
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


