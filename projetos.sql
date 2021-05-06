CREATE DATABASE project
GO
USE project
GO
 
CREATE TABLE projects (
id				INT			NOT NULL	IDENTITY(10001,1),
name			VARCHAR(45)	NOT NULL,
description		VARCHAR(45)	NULL,
date			VARCHAR(45)	NOT NULL
PRIMARY KEY(id)
)
GO
CREATE TABLE users (
id				INT			NOT NULL	IDENTITY,
name			VARCHAR(45)	NOT NULL,
username		VARCHAR(45)	NOT NULL	UNIQUE,
password		VARCHAR(45)	NOT NULL	DEFAULT('mudar123'),
email			VARCHAR(45)	NOT NULL
PRIMARY KEY(id)
)
GO
CREATE TABLE users_has_projects (
users_id	INT		NOT NULL,
projects_id	INT		NOT NULL
PRIMARY KEY(users_id,projects_id)
FOREIGN KEY(users_id) REFERENCES users(id),
FOREIGN KEY(projects_id) REFERENCES projects(id)
)
 
ALTER TABLE projects
ALTER COLUMN date DATE NOT NULL 
 
ALTER TABLE projects
ADD CONSTRAINT chk_dt CHECK(date > '2014-09-01')
 
 
EXEC sp_help users
 
ALTER TABLE users
DROP CONSTRAINT UQ__users__F3DBC57277CACA7C
 
ALTER TABLE users
ALTER COLUMN username VARCHAR(10) NOT NULL
 
ALTER TABLE users
ADD CONSTRAINT UQ__users__F3DBC57277CACA7C UNIQUE(username)
 
 
ALTER TABLE users
ALTER COLUMN password VARCHAR(8) NOT NULL
 
INSERT INTO users VALUES
('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo','Ti_paulo','123@456','paulo@empresa.com'),
('Ana','Rh_ana','123mudar','ana@empresa.com'),
('Clara','Ti_clara','123mudar','clara@empresa.com'),
('Aparecido','Rh_apareci','55@!cido','aparecido@empresa.com')
 
INSERT INTO projects VALUES
('Re-folha','Refatoração das Folhas','2014-09-05'),
('Manutenção PCs','Manutenção PCs','2014-09-05'),
('Auditoria', NULL, '2014-09-07')
 
INSERT INTO users_has_projects VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)
 
UPDATE projects
SET date = '2014-09-12'
WHERE id = 10002
 
UPDATE users 
SET username = 'Rh_cido'
WHERE name = 'Aparecido'
 
UPDATE users 
SET password = '888@*'
WHERE username = 'Rh_maria' AND password = '123mudar'
 
DELETE users_has_projects
WHERE users_id = 2 AND projects_id = 10002
 
SELECT * FROM users
SELECT * FROM projects
SELECT * FROM users_has_projects


/*
Considerando que o projeto 10001 durou 15 dias, fazer uma consulta que mostre o nome do
projeto, descrição, data, data_final do projeto realizado por usuário de e-mail
aparecido@empresa.com
*/

SELECT name, description, date  ,'2014-09-16'AS data_final ,
DATEADD(DAY,7, date) AS custo_total FROM projects
WHERE id IN (

	SELECT projects_id
	FROM users_has_projects
	WHERE users_id IN 
	(
		SELECT id
		FROM users
		WHERE email = 'aparecido@empresa.com' 
	)

)


/*
Fazer uma consulta que retorne o nome e o email dos usuários que estão envolvidos no
projeto de nome Auditoria
*/
SELECT name, email FROM users
WHERE id IN 
(
		SELECT users_id
		FROM users_has_projects
		WHERE projects_id IN
		(
			SELECT id
			FROM projects
			WHERE name = 'Auditoria'

		)
)

/*
Considerando que o custo diário do projeto, cujo nome tem o termo Manutenção, é de 79.85
e ele deve finalizar 16/09/2014, consultar, nome, descrição, data, data_final e custo_total doprojeto
*/

SELECT name, description, date AS data_inicio ,'2014-09-16'AS data_final ,
DATEDIFF(DAY, date, '2014-09-16')*79.85 AS custo_total FROM projects
WHERE name LIKE 'Manutenção%' 


