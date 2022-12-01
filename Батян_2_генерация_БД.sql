
CREATE TABLE [dbo].[Facultet](
	[Id_facultet] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name_facultet] [varchar](255) NOT NULL,
	[FIO_decan] [varchar](255) NOT NULL,
	[Auditory_number] [varchar](50) NULL,
	[Korpus_number] [int] NULL,
	[Phone_decanat] [varchar](50) NULL, 
)


CREATE TABLE [dbo].[Groups](
	[Id_group] [int] NOT NULL PRIMARY KEY,
	[Name_group] [varchar](50) NOT NULL,
	[Year_post] [int] NOT NULL,
	[Course] [int] NOT NULL,
	[Students_count] [int] NULL,
)

CREATE TABLE [dbo].[Kafedra](
	[Id_kafedra] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Id_facultet] [int] NOT NULL,
	[Name_kafedra] [varchar](50) NOT NULL,
	[FIO_zavkaf] [varchar](50) NOT NULL,
	[Auditory_number] [varchar](50) NULL,
	[Korpus_number] [int] NULL,
	[Phone_kafedra] [varchar](50) NULL,
	[Teachers_count] [int] NULL 
)

CREATE TABLE [dbo].[Students](
	[Id_student] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Surname] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Third_name] [varchar](50) NULL,
	[Id_group] [int] NOT NULL,
	[Date_of_birth] [date] NOT NULL,
	[Gender] [varchar](50) NOT NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
)

CREATE TABLE [dbo].[Vedomost](
	[Id_vedomost] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Id_group] [int] NOT NULL,
	[Id_student] [int] NOT NULL,
	[Subject_name] [varchar](50) NOT NULL,
	[Mark] [int] NOT NULL,
)

ALTER TABLE [dbo].[Kafedra]  WITH CHECK ADD  CONSTRAINT [FK_Kafedra_Facultet] FOREIGN KEY([Id_facultet])
REFERENCES [dbo].[Facultet] ([Id_facultet])
ON UPDATE CASCADE
ON DELETE CASCADE

ALTER TABLE [dbo].[Kafedra] CHECK CONSTRAINT [FK_Kafedra_Facultet]

ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Students_Groups] FOREIGN KEY([Id_group])
REFERENCES [dbo].[Groups] ([Id_group])

ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Students_Groups]

ALTER TABLE [dbo].[Vedomost]  WITH CHECK ADD  CONSTRAINT [FK_Vedomost_Groups] FOREIGN KEY([Id_group])
REFERENCES [dbo].[Groups] ([Id_group])

ALTER TABLE [dbo].[Vedomost] CHECK CONSTRAINT [FK_Vedomost_Groups]

ALTER TABLE [dbo].[Vedomost]  WITH CHECK ADD  CONSTRAINT [FK_Vedomost_Students] FOREIGN KEY([Id_student])
REFERENCES [dbo].[Students] ([Id_student])

ALTER TABLE [dbo].[Vedomost] CHECK CONSTRAINT [FK_Vedomost_Students]

ALTER TABLE [dbo].[Facultet]  WITH CHECK ADD  CONSTRAINT [CK_Facultet_1] CHECK  (([Auditory_number] like '%[1-9]-[1-9]'))

ALTER TABLE [dbo].[Facultet] CHECK CONSTRAINT [CK_Facultet_1]

ALTER TABLE [dbo].[Facultet]  WITH CHECK ADD  CONSTRAINT [CK_Facultet_2] CHECK  (([Korpus_number]=(5) OR [Korpus_number]=(4) OR [Korpus_number]=(3) OR [Korpus_number]=(2) OR [Korpus_number]=(1)))

ALTER TABLE [dbo].[Facultet] CHECK CONSTRAINT [CK_Facultet_2]

ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [CK_Groups] CHECK  ((len([Name_group])=(6)))

ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [CK_Groups]

ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [CK_Groups_1] CHECK  (([Course]>(0) AND [Course]<=(4)))

ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [CK_Groups_1]

ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [CK_Groups_2] CHECK  (([Year_post]='2022' OR [Year_post]='2021' OR [Year_post]='2020' OR [Year_post]='2019'))

ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [CK_Groups_2]

ALTER TABLE [dbo].[Kafedra]  WITH CHECK ADD  CONSTRAINT [CK_Kafedra] CHECK  (([Korpus_number]=(5) OR [Korpus_number]=(4) OR [Korpus_number]=(3) OR [Korpus_number]=(2) OR [Korpus_number]=(1)))

ALTER TABLE [dbo].[Kafedra] CHECK CONSTRAINT [CK_Kafedra]

ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [CK_Students] CHECK  (([Gender]='Женский' OR [Gender]='Мужской'))

ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [CK_Students]

ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [CK_Students_1] CHECK  ((len([Phone])=(7)))

ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [CK_Students_1]

ALTER TABLE [dbo].[Vedomost]  WITH CHECK ADD  CONSTRAINT [CK_Vedomost] CHECK  (([Mark]>(0) AND [Mark]<=(10)))

ALTER TABLE [dbo].[Vedomost] CHECK CONSTRAINT [CK_Vedomost]
