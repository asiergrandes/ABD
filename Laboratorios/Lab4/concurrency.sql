-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 17-03-2023 a las 09:34:53
-- Versión del servidor: 8.0.32-0ubuntu0.20.04.2
-- Versión de PHP: 7.4.3-4ubuntu2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `concurrency`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckResults` ()  begin
select 'Isolation level' as 'Showing:';
select @@TRANSACTION_ISOLATION;
select 'Variables table' as 'Showing:';
select * from concurrency.variables;
select 'Sum of A,B,C,D,E,F:' as 'Showing:';
select sum(value) from concurrency.variables where name REGEXP '[A-F]';
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROCEDURE_A` ()  BEGIN
#Parametros con los que vamos a trabajar
DECLARE pX INT;
DECLARE pT INT;
DECLARE pA INT;
DECLARE pY INT;

#Estas son las variables del programa
DECLARE FLAG BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET FLAG=1;
DECLARE CONTINUE HANDLER FOR SQLWARNING SET FLAG=1;

#INICIAMOS EL BUCLE
REPEAT
	SET FLAG =0;
	START TRANSACTION;
    ##########################
    #BLOQUEOS
    SELECT * FROM variables WHERE name='X' FOR UPDATE;
    SELECT * FROM variables WHERE name='T' FOR UPDATE;
    SELECT * FROM variables WHERE name='A' FOR UPDATE;
    SELECT * FROM variables WHERE name='Y' FOR SHARE;
    #READ(X)
	SELECT value INTO pX FROM variables WHERE name='X';
	
	#X=X+1
	SELECT pX+1 INTO pX;
	
	#WRITE(X)
	UPDATE variables SET value=pX WHERE name='X';
	
	#READ(T)
	SELECT value INTO pT FROM variables WHERE name='T';
	
	#READ(A)
	SELECT value INTO pA FROM variables WHERE name='A';
	
	#READ(Y)
	SELECT value INTO pY FROM variables WHERE name='Y';
	
	#T=T+Y
	SELECT pT+pY INTO pT;
	
	#A=A+Y
	SELECT pA+pY INTO pA;
	
	#WRITE(T)
	UPDATE variables SET value=pT WHERE name='T';
	
	#WRITE(A)
	UPDATE variables SET value=pA WHERE name='A';
    ##########################
	IF FLAG THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
UNTIL NOT FLAG END REPEAT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROCEDURE_B` ()  BEGIN
#Parametros con los que vamos a trabajar
DECLARE pY INT;
DECLARE pT INT;
DECLARE pB INT;
DECLARE pZ INT;

#Estas son las variables del programa
DECLARE FLAG BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET FLAG=1;
DECLARE CONTINUE HANDLER FOR SQLWARNING SET FLAG=1;

#INICIAMOS EL BUCLE
REPEAT
	SET FLAG =0;
	START TRANSACTION;
    ##########################
    #BLOQUEOS
    SELECT * FROM variables WHERE name='Y' FOR UPDATE;
	SELECT * FROM variables WHERE name='T' FOR UPDATE;    
    SELECT * FROM variables WHERE name='B' FOR UPDATE;
    SELECT * FROM variables WHERE name='Z' FOR SHARE;
    
    #READ(Y)
	SELECT value INTO pY FROM variables WHERE name='Y';
	
	#Y=Y+1
	SELECT pY+1 INTO pY;
	
	#WRITE(Y)
	UPDATE variables SET value=pY WHERE name='Y';
	
	#READ(T)
	SELECT value INTO pT FROM variables WHERE name='T';
	
	#READ(B)
	SELECT value INTO pB FROM variables WHERE name='B';
	
	#READ(Z)
	SELECT value INTO pZ FROM variables WHERE name='Z';
	
	#T=T+Z
	SELECT pT+pZ INTO pT;
	
	#B=B+Z
	SELECT pB+pZ INTO pB;
	
	#WRITE(T)
	UPDATE variables SET value=pT WHERE name='T';
	
	#WRITE(B)
	UPDATE variables SET value=pB WHERE name='B';
    ##########################
	IF FLAG THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
UNTIL NOT FLAG END REPEAT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROCEDURE_C` ()  BEGIN
#Parametros con los que vamos a trabajar
DECLARE pZ INT;
DECLARE pT INT;
DECLARE pC INT;
DECLARE pX INT;

#Estas son las variables del programa
DECLARE FLAG BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET FLAG=1;
DECLARE CONTINUE HANDLER FOR SQLWARNING SET FLAG=1;

#INICIAMOS EL BUCLE
REPEAT
	SET FLAG =0;
	START TRANSACTION;
    ##########################
    #BLOQUEOS
    SELECT * FROM variables WHERE name='Z' FOR UPDATE;
    SELECT * FROM variables WHERE name='T' FOR UPDATE;
    SELECT * FROM variables WHERE name='C' FOR UPDATE;
    SELECT * FROM variables WHERE name='X' FOR SHARE;
    
    #READ(Z)
	SELECT value INTO pZ FROM variables WHERE name='Z';
	
	#Z=Z+1
	SELECT pZ +1 INTO pZ;
	
	#WRITE(Z)
	UPDATE variables SET value=pZ WHERE name='Z';
	
	#READ(T)
	SELECT value INTO pT FROM variables WHERE name='T';
	
	#READ(C)
	SELECT value INTO pC FROM variables WHERE name='C';
	
	#READ(X)
	SELECT value INTO pX FROM variables WHERE name='X';
	
	#T=T+X
	SELECT pT+pX INTO pT;
	
	#C=C+X
	SELECT pC+pX INTO pC;
	
	#WRITE(T)
	UPDATE variables SET value=pT WHERE name='T';
	
	#WRITE(C)
	UPDATE variables SET value=pC WHERE name='C';
    ##########################
	IF FLAG THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
UNTIL NOT FLAG END REPEAT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROCEDURE_D` ()  BEGIN
#Parametros con los que vamos a trabajar
DECLARE pT INT;
DECLARE pD INT;
DECLARE pZ INT;
DECLARE pX INT;

#Estas son las variables del programa
DECLARE FLAG BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET FLAG=1;
DECLARE CONTINUE HANDLER FOR SQLWARNING SET FLAG=1;

#INICIAMOS EL BUCLE
REPEAT
	SET FLAG =0;
	START TRANSACTION;
    ##########################
    SELECT * FROM variables WHERE name='T' FOR UPDATE;
    SELECT * FROM variables WHERE name='D' FOR UPDATE;
    SELECT * FROM variables WHERE name='X' FOR UPDATE;
    SELECT * FROM variables WHERE name='Z' FOR SHARE;
    
    
	#READ(T)
	SELECT value INTO pT FROM variables WHERE name='T';
	
	#READ(D)
	SELECT value INTO pD FROM variables WHERE name='D';
	
	#READ(Z)
	SELECT value INTO pZ FROM variables WHERE name='Z';
	
	#T=T+Z
	SELECT pT+pZ INTO pT;
	
	#D=D+Z 
	SELECT pD+pZ INTO pD;
	
	#WRITE(T)
	UPDATE variables SET value=pT WHERE name='T';
	
	#WRITE(D)
	UPDATE variables SET value=pD WHERE name='D';
	
	#READ(X)
	SELECT value INTO pX FROM variables WHERE name='X';
	
	#X=X-1
	SELECT pX-1 INTO pX;
	
	#WRITE(X)
	UPDATE variables SET value=pX WHERE name='X';
	##########################
	IF FLAG THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
UNTIL NOT FLAG END REPEAT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROCEDURE_E` ()  BEGIN
#Parametros con los que vamos a trabajar
DECLARE pT INT;
DECLARE pE INT;
DECLARE pX INT;
DECLARE pY INT;

#Estas son las variables del programa
DECLARE FLAG BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET FLAG=1;
DECLARE CONTINUE HANDLER FOR SQLWARNING SET FLAG=1;

#INICIAMOS EL BUCLE
REPEAT
	SET FLAG =0;
	START TRANSACTION;
    ##########################
    SELECT * FROM variables WHERE name='T' FOR UPDATE;
    SELECT * FROM variables WHERE name='E' FOR UPDATE;
    SELECT * FROM variables WHERE name='X' FOR SHARE;
    SELECT * FROM variables WHERE name='Y' FOR UPDATE;
    
	#READ(T)
	SELECT value INTO pT FROM variables WHERE name='T';
	
	#READ(E)
	SELECT value INTO pE FROM variables WHERE name='E';
	
	#READ(X)
	SELECT value INTO pX FROM variables WHERE name='X';
	
	#T=T+X
	SELECT pT+pX INTO pT;
	
	#E=E+X 
	SELECT pE+pX INTO pE;
	
	#WRITE(T)
	UPDATE variables SET value=pT WHERE name='T';
	
	#WRITE(E)
	UPDATE variables SET value=pE WHERE name='E';
	
	#READ(Y)
	SELECT value INTO pY FROM variables WHERE name='Y';
	
	#Y=Y-1
	SELECT pY-1 INTO pY;
	
	#WRITE(Y)
	UPDATE variables SET value=pY WHERE name='Y';
	##########################
	IF FLAG THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
UNTIL NOT FLAG END REPEAT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROCEDURE_F` ()  BEGIN
#Parametros con los que vamos a trabajar
DECLARE pT INT;
DECLARE pF INT;
DECLARE pY INT;
DECLARE pZ INT;

#Estas son las variables del programa
DECLARE FLAG BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET FLAG=1;
DECLARE CONTINUE HANDLER FOR SQLWARNING SET FLAG=1;

#INICIAMOS EL BUCLE
REPEAT
	SET FLAG =0;
	START TRANSACTION;
    ##########################
    SELECT * FROM variables WHERE name='T' FOR UPDATE;
    SELECT * FROM variables WHERE name='F' FOR UPDATE;
    SELECT * FROM variables WHERE name='Y' FOR SHARE;
    SELECT * FROM variables WHERE name='Z' FOR UPDATE;
    
	#READ(T)
	SELECT value INTO pT FROM variables WHERE name='T';
	
	#READ(F)
	SELECT value INTO pF FROM variables WHERE name='F';
	
	#READ(Y)
	SELECT value INTO pY FROM variables WHERE name='Y';
	
	#T=T+Y
	SELECT pT+pY INTO pT;
	
	#F=F+Y 
	SELECT pF+pY INTO pF;
	
	#WRITE(T)
	UPDATE variables SET value=pT WHERE name='T';
	
	#WRITE(F)
	UPDATE variables SET value=pF WHERE name='F';
	
	#READ(Z)
	SELECT value INTO pZ FROM variables WHERE name='Z';
	
	#Z=Z-1
	SELECT pZ-1 INTO pZ;
	
	#WRITE(Z)
	UPDATE variables SET value=pZ WHERE name='Z';
	##########################
	IF FLAG THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
UNTIL NOT FLAG END REPEAT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `variables`
--

CREATE TABLE `variables` (
  `name` varchar(1) DEFAULT NULL,
  `value` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `variables`
--

INSERT INTO `variables` (`name`, `value`) VALUES
('X', 0),
('Y', 0),
('Z', 0),
('A', 0),
('B', 0),
('C', 0),
('D', 0),
('E', 0),
('F', 0),
('T', 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
