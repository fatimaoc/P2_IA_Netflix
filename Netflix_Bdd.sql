--Commentaire sur 1 ligne
/*Commentaire sur plusieurs lignes*/


--Connection à MySQL

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 30
Server version: 8.0.22-0ubuntu0.20.04.2 (Ubuntu)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

--On demande à SQL de nous montrer les Databases existantes

mysql> SHOW databases;
+--------------------+
| Database           |
+--------------------+
| car                |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.01 sec)

--1/CREATION DE LA DATAVASES NETFLIX

mysql> CREATE DATABASE Netflix ;

*Query OK, 1 row affected (0.01 sec)

mysql> SHOW databases
    -> ;
+--------------------+
| Database           |
+--------------------+
| netflix            |
| car                |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
6 rows in set (0.01 sec)

mysql> USE netflix
Database changed
mysql> SHOW tables;
Empty set (0.01 sec)

mysql> ;

--CREATION DES TABLES 
CREATE TABLE netflix_titles(

`show_id` int,
`type` varchar (7) not null,
`title` varchar (104),
`director` varchar (208),
`cast` varchar (771),
`country` varchar (123),
`date_added` varchar (19),
`release_year` int,
`rating` varchar (8),
`duration` varchar(10),
`listed_in` varchar (79),
`description` varchar (250));
Query OK, 0 rows affected (0.05 sec)

mysql> describe netflix_titles ;
+--------------+--------------+------+-----+---------+-------+
| Field        | Type         | Null | Key | Default | Extra |
+--------------+--------------+------+-----+---------+-------+
| show_id      | int          | YES  |     | NULL    |       |
| type         | varchar(7)   | NO   |     | NULL    |       |
| title        | varchar(104) | YES  |     | NULL    |       |
| director     | varchar(208) | YES  |     | NULL    |       |
| cast         | varchar(771) | YES  |     | NULL    |       |
| country      | varchar(123) | YES  |     | NULL    |       |
| date_added   | varchar(19)  | YES  |     | NULL    |       |
| release_year | int          | YES  |     | NULL    |       |
| rating       | varchar(8)   | YES  |     | NULL    |       |
| duration     | varchar(10)  | YES  |     | NULL    |       |
| listed_in    | varchar(79)  | YES  |     | NULL    |       |
| description  | varchar(250) | YES  |     | NULL    |       |
+--------------+--------------+------+-----+---------+-------+
12 rows in set (0.01 sec)

CREATE TABLE netflix_shows (
    `title` VARCHAR (64),
    `rating` VARCHAR (9),
    `ratingLevel` VARCHAR (126),
    `ratingDescription` INT NOT NULL,
    `release year` INT NOT NULL,
    `user rating score` VARCHAR (4),
    `user rating size` INT NOT NULL
);

mysql> CREATE TABLE netflix_shows (
    id INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR (64),
    `rating` VARCHAR (9),
    `ratingLevel` VARCHAR (126),z
    ratingDescription INT NOT NULL,
    release year INT NOT NULL,
    `user rating score` VARCHAR (4),
    `user rating size` INT NOT NULL
      PRIMARY KEY(id)
    );
Query OK, 0 rows affected (0.02 sec)

mysql> show tables ;
+-------------------+
| Tables_in_Netflix |
+-------------------+
| netflix_shows     |
| netflix_titles    |
+-------------------+
2 rows in set (0.01 sec)

--IMPORTATION DES DONNEES VIA DES FICHIERS CSV
mysql> LOAD DATA LOCAL INFILE '/home/fatimam/Documents/formation_ia/netflix_titles.csv' 
    -> INTO TABLE netflix_titles 
    -> FIELDS TERMINATED BY ',' 
    -> ENCLOSED BY '"'
    -> LINES TERMINATED BY '\r\n'
    -> IGNORE 1 LINES;
Query OK, 6234 rows affected (1.32 sec)
Records: 6234  Deleted: 0  Skipped: 0  Warnings: 0

LOAD DATA LOCAL INFILE '/home/fatimam/Documents/formation_ia/Netflix_Shows.csv'
INTO TABLE netflix.netflix_shows
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
Query OK, 1000 rows affected, 1395 warnings (0.10 sec)
Records: 1000  Deleted: 0  Skipped: 0  Warnings: 1395


--Titres de films de la table netflix_titles dont l'ID est inferieur stric à 80000000;

mysql> SELECT title FROM netflix_titles WHERE  show_id<80000000;

1346 rows in set (0.01 sec)

--AFFICHAGE DE TOUS LES DURÉES DES TV SHOW

mysql> SELECT duration FROM  netflix_titles WHERE type ='TV Show' ;

1969 rows in set (0.01 sec)

--AFFICHAGE DE TOUS LES NOMS DE FILMS COMMUNS AU 2 TABLES

mysql> SELECT netflix_titles.title  FROM netflix_titles INNER JOIN netflix_shows ON netflix_titles.title = netflix_shows.title;

522 rows in set (0.04 sec)


--CALCUL DE LA DUREE TOTALE DE TOUS LES FILMS

mysql> SELECT COUNT(ratingLevel) from netflix_shows WHERE ratingLevel >='$ratingLevel';
+--------------------+
| COUNT(ratingLevel) |
+--------------------+
|                941 |
+--------------------+
1 row in set (0.00 sec)

--COMPTE DES FILMS ET TV SHOWS POUR LESQUELS LES NOMS SONT LES MÊMES SUR LES 2 TABLES ET DONT 'RELEASE_YEAR' EST SUPÉRIEUR A 2016

mysql> SELECT COUNT(netflix_titles.title) 
    -> FROM netflix_titles INNER JOIN netflix_shows 
    -> ON netflix_titles.title = netflix_shows.title 
    -> WHERE netflix_titles.title = netflix_shows.title
    -> AND netflix_shows.release_year>2016 AND netflix_titles.release_year >2016
    -> ;
+-----------------------------+
| COUNT(netflix_titles.title) |
+-----------------------------+
|                         100 |
+-----------------------------+
1 row in set (0.02 sec)

--SUPPRESSION DE LA COLONNE 'RATING' DE LA TABLE 'netflix_shows'

ALTER TABLE netflix_shows
DROP COLUMN 'rating';

--SUPPRESSION DES 100 DERNIERS LIGNES DE LA TABLE 'netflix_shows'

/*On ne peut pas supprimer les 100 dernieres lignes de la table sans que la table n'est de clé
1/On drop la table existante*/

--2/On recrée la table avec un INDEX 

CREATE TABLE netflix_shows(
id INT NOT NULL AUTO_INCREMENT,
title varchar(64)            
, rating varchar(9)          
, ratingLevel varchar(126)      
, ratingDescription int  
, release_year int
, user_rating_score int
, user_rating_size float
,PRIMARY KEY(id)
);

mysql> DELETE FROM netflix_shows ORDER BY id DESC LIMIT 100;
Query OK, 100 rows affected (0.01 sec)

--AJOUT D'UN COMMENTAIRE DANS LE CHAMPS "ratingLevel"

UPDATE netflix_shows
SET netflix_shows.ratingLevel = 'ajout commentaire'
WHERE netflix_shows.title = "Marvel's Iron Fist";
