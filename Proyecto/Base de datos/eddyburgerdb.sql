-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-08-2017 a las 20:30:00
-- Versión del servidor: 10.1.19-MariaDB
-- Versión de PHP: 5.6.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `eddyburgerdb`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `reportedep` (IN `idVent` INT, IN `idProd` INT)  BEGIN
	
	SELECT * FROM detalleVenta JOIN Producto ON Producto_idProducto = idProd WHERE Ventas_idVentas = idVent;    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reporteve` (IN `idVent` INT)  BEGIN
	
	SELECT * FROM Ventas JOIN Empleado on idEmpleado = Empleado_idEmpleado WHERE idVentas = idVent;    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addCliente` (IN `nom` VARCHAR(45), IN `apellidoP` VARCHAR(100), IN `apellidoM` VARCHAR(100), IN `emaile` VARCHAR(100), IN `calle` VARCHAR(100), IN `num` VARCHAR(45), IN `col` VARCHAR(45), IN `cp` INT(5), IN `ciud` VARCHAR(45), IN `est` VARCHAR(45), IN `lad` VARCHAR(45), IN `tel` INT)  BEGIN
		DECLARE contar int;
		DECLARE ids int;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
		START TRANSACTION;
        
        IF(trim(nom) = '' OR trim(apellidoP) = '' OR trim(apellidoM) = '' OR trim(emaile) = '' OR trim(calle) = '' OR trim(num) = '' OR trim(col) = '' OR cp = 0 OR trim(ciud) = '' OR trim(est) = '' OR trim(lad) = '' OR tel = 0) THEN
			SELECT "FALTAN DATOS";
		ELSE
			SELECT count(*) INTO contar FROM Estado where estado = trim(est);
                IF (contar = 0) THEN
					INSERT INTO Estado VALUES(0, trim(est));
                    SELECT idEstado INTO ids FROM Estado where estado = trim(est);
				ELSE
					SELECT idEstado INTO ids FROM Estado where estado = trim(est);
				END IF;
			SELECT count(*) INTO contar FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = ids;
				IF (contar = 0) THEN
					INSERT INTO Ciudad VALUES(0, trim(ciud), ids);
                    SELECT idEstadoCiudad INTO ids FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = ids;
				ELSE
					SELECT idEstadoCiudad INTO ids FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = ids;
				END IF;
			SELECT count(*) INTO contar FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = ids;
				IF (contar = 0) THEN
					INSERT INTO Colonia VALUES(0, trim(col), cp, ids);
                    SELECT idColonia INTO ids FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = ids;
				ELSE
					SELECT idColonia INTO ids FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = ids;
				END IF;
			SELECT count(*) INTO contar FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = ids;
				IF (contar = 0) THEN
					INSERT INTO Direccion VALUES(0, trim(calle), trim(num), ids);
                    SELECT idDireccion INTO ids FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = ids;
				ELSE
					SELECT idDireccion INTO ids FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = ids;
				END IF;
			SELECT count(*) INTO contar FROM Cliente where nombre = trim(nom) and apellido_P = trim(apellidoP) and apellido_M = trim(apellidoM) and email = trim(emaile) and Direccion_idDireccion = ids;
				IF (contar = 0) THEN
					INSERT INTO Cliente VALUES(0, nom, apellidoP, apellidoM, emaile, ids);
                    SELECT idCliente INTO ids FROM Cliente where nombre = trim(nom) and apellido_P = trim(apellidoP) and apellido_M = trim(apellidoM) and email = trim(emaile) and Direccion_idDireccion = ids;
				ELSE
					SELECT idCliente INTO ids FROM Cliente where nombre = trim(nom) and apellido_P = trim(apellidoP) and apellido_M = trim(apellidoM) and email = trim(emaile) and Direccion_idDireccion = ids;
				END IF;
            SELECT count(*) INTO contar FROM Telefono_C where lada = trim(lad) and telefono = tel;
				IF(contar = 0) THEN
					INSERT INTO Telefono_C VALUES(0, trim(lad), tel, ids);
                    COMMIT;
				ELSE
					SELECT "Este Cliente ya existe";
					ROLLBACK;
                END IF;
		END IF;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addDetalleVenta` (IN `tProd` INT, IN `precio` FLOAT(9,2), IN `idProd` INT, IN `idVent` INT)  BEGIN
		DECLARE can INT;
        
	    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
	START TRANSACTION;
		IF(trim(tProd) = 0 OR trim(precio) = 0 OR trim(idProd) = 0 OR trim(idVent) = 0) THEN
			SELECT "FALTAN DATOS";
		ELSE
			SELECT count(*) INTO can FROM detalleVenta WHERE Producto_idProducto = trim(idProd) and Ventas_idVentas = trim(idVent);
            IF (can = 0) THEN
			INSERT INTO DetalleVenta SET cantidad = trim(tProd), precio = trim(precio), subtotal = trim(tProd)*trim(precio), Producto_idProducto = trim(idProd), Ventas_idVentas = trim(idVent);
            commit;
            ELSE
            UPDATE detalleVenta SET cantidad = trim(tProd) WHERE Ventas_idVentas = trim(idVent) AND Producto_idProducto = trim(idProd);
            commit;
            END IF;
		END IF;
        
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addEmpleado` (IN `nom` VARCHAR(45), IN `apellidoP` VARCHAR(100), IN `apellidoM` VARCHAR(100), IN `emaile` VARCHAR(100), IN `calle` VARCHAR(100), IN `num` VARCHAR(45), IN `col` VARCHAR(45), IN `cp` INT(5), IN `ciud` VARCHAR(45), IN `est` VARCHAR(45), IN `lad` VARCHAR(45), IN `tel` INT)  BEGIN
		DECLARE contar int;
		DECLARE ids int;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
		START TRANSACTION;
        
        IF(trim(nom) = '' OR trim(apellidoP) = '' OR trim(apellidoM) = '' OR trim(emaile) = '' OR trim(calle) = '' OR trim(num) = '' OR trim(col) = '' OR cp = 0 OR trim(ciud) = '' OR trim(est) = '' OR trim(lad) = '' OR tel = 0) THEN
			SELECT "FALTAN DATOS";
		ELSE
			SELECT count(*) INTO contar FROM Estado where estado = trim(est);
                IF (contar = 0) THEN
					INSERT INTO Estado VALUES(0, trim(est));
                    SELECT idEstado INTO ids FROM Estado where estado = trim(est);
				ELSE
					SELECT idEstado INTO ids FROM Estado where estado = trim(est);
				END IF;
			SELECT count(*) INTO contar FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = ids;
				IF (contar = 0) THEN
					INSERT INTO Ciudad VALUES(0, trim(ciud), ids);
                    SELECT idEstadoCiudad INTO ids FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = ids;
				ELSE
					SELECT idEstadoCiudad INTO ids FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = ids;
				END IF;
			SELECT count(*) INTO contar FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = ids;
				IF (contar = 0) THEN
					INSERT INTO Colonia VALUES(0, trim(col), cp, ids);
                    SELECT idColonia INTO ids FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = ids;
				ELSE
					SELECT idColonia INTO ids FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = ids;
				END IF;
			SELECT count(*) INTO contar FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = ids;
				IF (contar = 0) THEN
					INSERT INTO Direccion VALUES(0, trim(calle), trim(num), ids);
                    SELECT idDireccion INTO ids FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = ids;
				ELSE
					SELECT idDireccion INTO ids FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = ids;
				END IF;
			SELECT count(*) INTO contar FROM Empleado where nombre = trim(nom) and apellido_P = trim(apellidoP) and apellido_M = trim(apellidoM) and email = trim(emaile) and Direccion_idDireccion = ids;
				IF (contar = 0) THEN
					INSERT INTO Empleado VALUES(0, nom, apellidoP, apellidoM, emaile, ids);
                    SELECT idEmpleado INTO ids FROM Empleado where nombre = trim(nom) and apellido_P = trim(apellidoP) and apellido_M = trim(apellidoM) and email = trim(emaile) and Direccion_idDireccion = ids;
				ELSE
					SELECT idEmpleado INTO ids FROM Empleado where nombre = trim(nom) and apellido_P = trim(apellidoP) and apellido_M = trim(apellidoM) and email = trim(emaile) and Direccion_idDireccion = ids;
				END IF;
            SELECT count(*) INTO contar FROM Telefono_E where lada = trim(lad) and telefono = tel;
				IF(contar = 0) THEN
					INSERT INTO Telefono_E VALUES(0, trim(lad), tel, ids);
                    COMMIT;
				ELSE
					SELECT "Este empleado ya existe";
					ROLLBACK;
                END IF;
		END IF;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addProveedor` (IN `nom` VARCHAR(45), IN `emaile` VARCHAR(100), IN `calle` VARCHAR(100), IN `num` VARCHAR(45), IN `col` VARCHAR(45), IN `cp` INT(5), IN `ciud` VARCHAR(45), IN `est` VARCHAR(45), IN `lad` VARCHAR(45), IN `tel` INT)  BEGIN
		DECLARE contar int;
		DECLARE ids int;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
		START TRANSACTION;
        
        IF(trim(nom) = ''  OR trim(emaile) = '' OR trim(calle) = '' OR trim(num) = '' OR trim(col) = '' OR cp = 0 OR trim(ciud) = '' OR trim(est) = '' OR trim(lad) = '' OR tel = 0) THEN
			SELECT "FALTAN DATOS";
		ELSE
			SELECT count(*) INTO contar FROM Estado where estado = trim(est);
                IF (contar = 0) THEN
					INSERT INTO Estado VALUES(0, trim(est));
                    SELECT idEstado INTO ids FROM Estado where estado = trim(est);
				ELSE
					SELECT idEstado INTO ids FROM Estado where estado = trim(est);
				END IF;
			SELECT count(*) INTO contar FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = ids;
				IF (contar = 0) THEN
					INSERT INTO Ciudad VALUES(0, trim(ciud), ids);
                    SELECT idEstadoCiudad INTO ids FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = ids;
				ELSE
					SELECT idEstadoCiudad INTO ids FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = ids;
				END IF;
			SELECT count(*) INTO contar FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = ids;
				IF (contar = 0) THEN
					INSERT INTO Colonia VALUES(0, trim(col), cp, ids);
                    SELECT idColonia INTO ids FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = ids;
				ELSE
					SELECT idColonia INTO ids FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = ids;
				END IF;
			SELECT count(*) INTO contar FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = ids;
				IF (contar = 0) THEN
					INSERT INTO Direccion VALUES(0, trim(calle), trim(num), ids);
                    SELECT idDireccion INTO ids FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = ids;
				ELSE
					SELECT idDireccion INTO ids FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = ids;
				END IF;
			SELECT count(*) INTO contar FROM Proveedor where nombre = trim(nom)  and email = trim(emaile) and Direccion_idDireccion = ids;
				IF (contar = 0) THEN
					INSERT INTO Proveedor VALUES(0, nom, emaile, ids);
                    SELECT idProveedor INTO ids FROM Proveedor where nombre = trim(nom) and email = trim(emaile) and Direccion_idDireccion = ids;
				ELSE
					SELECT idProveedor INTO ids FROM Proveedor where nombre = trim(nom) and email = trim(emaile) and Direccion_idDireccion = ids;
				END IF;
            SELECT count(*) INTO contar FROM Telefono_P where lada = trim(lad) and telefono = tel;
				IF(contar = 0) THEN
					INSERT INTO Telefono_P VALUES(0, trim(lad), tel, ids);
                    COMMIT;
				ELSE
					SELECT "Este Proveedor ya existe";
					ROLLBACK;
                END IF;
		END IF;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addVenta` (IN `pago` FLOAT(9,2), IN `tProd` FLOAT(9,2), IN `idProd` INT, IN `idEmp` INT)  BEGIN
	DECLARE exist INT;
    DECLARE pre FLOAT(9,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
	START TRANSACTION;

		IF(trim(pago) = 0 OR trim(tProd) = 0 OR trim(idProd) = 0 OR trim(idEmp) = 0) THEN
			SELECT "Algunos datos estan vacios";
		ELSE
			SELECT count(*) INTO exist FROM Producto WHERE idProducto = trim(idProd);
			IF(exist <= 0) THEN
				SELECT "NO EXISTE EL PRODUCTO";
			ELSE
				INSERT INTO Ventas VALUES(0, 0, trim(pago), 0, NOW(), trim(idEmp));
                SELECT @idVent := LAST_INSERT_ID( );
                SET pre = (SELECT precio FROM Producto WHERE idProducto = idProd);
				CALL sp_addDetalleVenta(trim(tProd), trim(pre), trim(idProd), trim(@idVent));
                COMMIT;
			END IF;
		END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addVentaDetalle` (IN `pag` FLOAT(9,2), IN `idPro` INT, IN `can` FLOAT, IN `idEmp` INT)  BEGIN
		DECLARE contar int;
		DECLARE ids int;
		DECLARE pre float;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
		START TRANSACTION;
        
        IF (pag = 0 OR idPro = 0 OR idEmp = 0 OR can = 0) THEN
			SELECT "Faltan datos";
        ELSE
				INSERT INTO Ventas VALUES(0, 0, pag, 0, NOW(), idEmp);
                SELECT @idV:=last_insert_id();
                SELECT (precio) INTO pre FROM Producto where idProducto = idPro;
                INSERT INTO DetalleVenta VALUES(0, can, pre, (pre*can), @idV);
                UPDATE Producto SET stock = stock - can where idProducto = idProducto;
                UPDATE Ventas SET totalVenta = totalVenta + (pre*can), pago = pago - (pre*can) where idVentas = @idV;
				COMMIT;
        END IF;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delCliente` (IN `idCli` INT)  BEGIN
		DECLARE contar int;
		DECLARE idCi int;
		DECLARE idCo int;
		DECLARE idEs int;
		DECLARE idDir int;
		DECLARE ids int;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
		START TRANSACTION;
        
        IF (idCli = 0) THEN
			SELECT "FALTA EL ID DEL Cliente A ELIMINAR";
		ELSE
			SELECT Direccion_idDireccion INTO idDir FROM Cliente where idCliente = idCli;
            SELECT Colonia_idColonia INTO idCo FROM Direccion where idDireccion = idDir;
            SELECT Ciudad_idEstadoCiudad INTO idCi FROM Colonia where idColonia = idCo;
            SELECT Estado_idEstado INTO idEs FROM Ciudad where idEstadoCiudad = idCi;
            
            SELECT count(*) INTO contar FROM Cliente where Direccion_idDireccion = idDir;
				IF (contar > 1) THEN
					DELETE FROM Telefono_C where Cliente_idCliente = idCli;
					DELETE FROM Cliente where idCliente = idCli;
				ELSE
					DELETE FROM Telefono_C where Cliente_idCliente = idCli;
					DELETE FROM Cliente where idCliente = idCli;
				END IF;
			SELECT count(*) INTO contar FROM Direccion where Colonia_idColonia = idCo;
				IF (contar > 1) THEN
					DELETE FROM Direccion where idDireccion = idDir;
				ELSE
					DELETE FROM Direccion where idDireccion = idDir;
				END IF;		
			SELECT count(*) INTO contar FROM Colonia where Ciudad_idEstadoCiudad = idCi;
				IF (contar > 1) THEN
					DELETE FROM Colonia where idColonia = idCo;
				ELSE
					DELETE FROM Colonia where idColonia = idCi;
				END IF;
            SELECT count(*) INTO contar FROM Ciudad where Estado_idEstado = idEs;
				IF (contar > 1) THEN
					DELETE FROM Ciudad where idEstadoCiudad = idCi;
				ELSE
					DELETE FROM Ciudad where idEstadoCiudad = idEs;
					DELETE FROM Estado where idEstado = idEs;
				END IF;
                COMMIT;
		END IF;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delDetalleVenta` (IN `idVen` INT, IN `idProd` INT)  BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS LIMIT 1;
			ROLLBACK;
		END;
    START TRANSACTION;
		
        IF(trim(idVen) = 0) THEN
			SELECT "FALTA INFORMACIÓN PARA REALIZAR LA OPERACIÓN";
		ELSE
			IF(trim(idProd)=0) THEN
			DELETE FROM detalleVenta WHERE Ventas_idVentas = trim(idVen);
            CALL sp_delVenta(trim(idVen));
            COMMIT;
            ELSE
            DELETE FROM detalleVenta WHERE Ventas_idVentas = trim(idVen) AND Producto_idProducto = trim(idProd);
            CALL sp_delVenta(trim(idVen));
            COMMIT;
            END IF;
        END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delEmpleado` (IN `idEmp` INT)  BEGIN
		DECLARE contar int;
		DECLARE idCi int;
		DECLARE idCo int;
		DECLARE idEs int;
		DECLARE idDir int;
		DECLARE ids int;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
		START TRANSACTION;
        
        IF (idEmp = 0) THEN
			SELECT "FALTA EL ID DEL EMPLEADO A ELIMINAR";
		ELSE
			SELECT Direccion_idDireccion INTO idDir FROM Empleado where idEmpleado = idEmp;
            SELECT Colonia_idColonia INTO idCo FROM Direccion where idDireccion = idDir;
            SELECT Ciudad_idEstadoCiudad INTO idCi FROM Colonia where idColonia = idCo;
            SELECT Estado_idEstado INTO idEs FROM Ciudad where idEstadoCiudad = idCi;
            
            SELECT count(*) INTO contar FROM Empleado where Direccion_idDireccion = idDir;
				IF (contar = 1) THEN
					DELETE FROM Telefono_E where Empleado_idEmpleado = idEmp;
					DELETE FROM Empleado where idEmpleado = idEmp;
				END IF;
			SELECT count(*) INTO contar FROM Direccion where Colonia_idColonia = idCo;
				IF (contar > 1) THEN
					DELETE FROM Direccion where idDireccion = idDir;
				ELSE
					DELETE FROM Direccion where idDireccion = idDir;
                    SELECT * FROM Direccion;
				END IF;		
			SELECT count(*) INTO contar FROM Colonia where Ciudad_idEstadoCiudad = idCi;
				IF (contar > 1) THEN
					DELETE FROM Colonia where idColonia = idCo;
				ELSE
					DELETE FROM Colonia where idColonia = idCi;
				END IF;
            SELECT count(*) INTO contar FROM Ciudad where Estado_idEstado = idEs;
				IF (contar > 1) THEN
					DELETE FROM Ciudad where idEstadoCiudad = idCi;
				ELSE
					DELETE FROM Ciudad where idEstadoCiudad = idEs;
					DELETE FROM Estado where idEstado = idEs;
				END IF;
                COMMIT;
		END IF;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delProveedor` (IN `idProve` INT)  BEGIN
		DECLARE contar int;
		DECLARE idCi int;
		DECLARE idCo int;
		DECLARE idEs int;
		DECLARE idDir int;
		DECLARE ids int;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
		START TRANSACTION;
        
        IF (idProve = 0) THEN
			SELECT "FALTA EL ID DEL PROVEEDOR A ELIMINAR";
		ELSE
			SELECT Direccion_idDireccion INTO idDir FROM Proveedor where idProveedor = idProve;
            SELECT Colonia_idColonia INTO idCo FROM Direccion where idDireccion = idDir;
            SELECT Ciudad_idEstadoCiudad INTO idCi FROM Colonia where idColonia = idCo;
            SELECT Estado_idEstado INTO idEs FROM Ciudad where idEstadoCiudad = idCi;
            
            SELECT count(*) INTO contar FROM Proveedor where Direccion_idDireccion = idDir;
				IF (contar > 1) THEN
					DELETE FROM Telefono_P where Proveedor_idProveedor = idProve;
					DELETE FROM Proveedor where idProveedor = idProve;
				ELSE
					DELETE FROM Telefono_P where Proveedor_idProveedor = idProve;
					DELETE FROM Proveedor where idProveedor = idProve;
				END IF;
			SELECT count(*) INTO contar FROM Direccion where Colonia_idColonia = idCo;
				IF (contar > 1) THEN
					DELETE FROM Direccion where idDireccion = idDir;
				ELSE
					DELETE FROM Direccion where idDireccion = idDir;
				END IF;		
			SELECT count(*) INTO contar FROM Colonia where Ciudad_idEstadoCiudad = idCi;
				IF (contar > 1) THEN
					DELETE FROM Colonia where idColonia = idCo;
				ELSE
					DELETE FROM Colonia where idColonia = idCi;
				END IF;
            SELECT count(*) INTO contar FROM Ciudad where Estado_idEstado = idEs;
				IF (contar > 1) THEN
					DELETE FROM Ciudad where idEstadoCiudad = idCi;
				ELSE
					DELETE FROM Ciudad where idEstadoCiudad = idEs;
					DELETE FROM Estado where idEstado = idEs;
				END IF;
                COMMIT;
		END IF;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delVenta` (IN `idVen` INT)  BEGIN
	DECLARE ven INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
	START TRANSACTION;

		IF(trim(idVen) = 0) THEN
			SELECT "Algunos datos estan vacios";
		ELSE
			SELECT count(*) INTO ven FROM Ventas WHERE idVentas = trim(idVen);
			IF(ven <= 0) THEN
				SELECT "NO EXISTE LA VENTA";
			ELSE
				DELETE FROM Ventas WHERE idVentas = trim(idVen);
				-- CALL sp_delDetalleVenta(trim(idVen));
                COMMIT;
			END IF;
		END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateCliente` (IN `idCli` INT, IN `nom` VARCHAR(45), IN `apellidoP` VARCHAR(100), IN `apellidoM` VARCHAR(100), IN `emaile` VARCHAR(100), IN `calle` VARCHAR(100), IN `num` VARCHAR(45), IN `col` VARCHAR(45), IN `cp` INT(5), IN `ciud` VARCHAR(45), IN `est` VARCHAR(45), IN `lad` VARCHAR(45), IN `tel` INT)  BEGIN
		DECLARE contar int;
		DECLARE idCi int;
		DECLARE idCo int;
		DECLARE idEs int;
		DECLARE idDir int;
		DECLARE ids int;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
		START TRANSACTION;
        
        IF(idCli = 0 OR trim(nom) = '' OR trim(apellidoP) = '' OR trim(apellidoM) = '' OR trim(emaile) = '' OR trim(calle) = '' OR trim(num) = '' OR trim(col) = '' OR cp = 0 OR trim(ciud) = '' OR trim(est) = '' OR trim(lad) = '' OR tel = 0) THEN
			SELECT "FALTAN DATOS";
		ELSE
			SELECT Direccion_idDireccion INTO idDir FROM Cliente where idCliente = idCli;
            SELECT Colonia_idColonia INTO idCo FROM Direccion where idDireccion = idDir;
            SELECT Ciudad_idEstadoCiudad INTO idCi FROM Colonia where idColonia = idCo;
            SELECT Estado_idEstado INTO idEs FROM Ciudad where idEstadoCiudad = idCi;
            
            
            SELECT count(*) INTO contar FROM Estado where estado = trim(est) and idEstado = idEs;
                IF (contar = 0) THEN
					 SELECT count(*) INTO contar FROM Estado where estado = trim(est);
                IF(contar = 0) THEN
					UPDATE Estado SET estado = trim(est) where idEstado = idEs;
				ELSE
					SELECT idEstado INTO idEs FROM Estado where estado = trim(est);
				END IF;
				END IF;
                
			SELECT count(*) INTO contar FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = idEs and idEstadoCiudad = idCi;
				IF (contar = 0) THEN
					SELECT count(*) INTO contar FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = idEs;
				IF(contar = 0) THEN
                
                IF(ids=0) THEN
					SET ids = 0;
					UPDATE Ciudad SET ciudad = trim(ciud) where idEstadoCiudad = idCi;
				ELSE
					UPDATE Ciudad SET ciudad = trim(ciud), Estado_idEstado = idEs where idEstadoCiudad = idCi;
                END IF;
                ELSE
					SELECT idEstadoCiudad INTO idCi FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = idEs;
				END IF;
				END IF;
                
                
			SELECT count(*) INTO contar FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = idCi and idColonia = idCo;
				IF (contar = 0) THEN
					SELECT count(*) INTO contar FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = idCi;
				IF (contar = 0) THEN
                IF (ids = 0) THEN
					SET ids = 0;
                    UPDATE Colonia SET colonia = trim(col), codigoPostal = cp where idColonia = idCo;
				ELSE
					UPDATE Colonia SET colonia = trim(col), codigoPostal = cp, Ciudad_idEstadoCiudad = idCi where idColonia = idCo;
                END IF;
                ELSE
					SELECT idColonia INTO idCo FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = idCi;
				END IF;
				END IF;
			
            
            SELECT count(*) INTO contar FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = idCo and idDireccion = idDir;
				IF (contar = 0) THEN
					SELECT count(*) INTO contar FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = idCo;
				IF (contar = 0) THEN
                IF (ids = 0) THEN
					SET ids = 0;
					UPDATE Direccion SET calle_dir = trim(calle), no_dir = trim(num) where idDireccion = idDir;
				ELSE
					UPDATE Direccion SET calle_dir = trim(calle), no_dir = trim(num), Colonia_idColonia = idCo where idDireccion = idDir;
				END IF;
                ELSE
					SELECT idDireccion INTO idDir FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = idCo;
				END IF;
				END IF;
			
            
            SELECT count(*) INTO contar FROM Cliente where nombre = trim(nom) and apellido_P = trim(apellidoP) and apellido_M = trim(apellidoM) and email = trim(emaile) and Direccion_idDireccion = idDir and idCliente = idCli;
				IF (contar = 0) THEN
					SELECT count(*) INTO contar FROM Cliente where nombre = trim(nom) and apellido_P = trim(apellidoP) and apellido_M = trim(apellidoM) and email = trim(emaile) and Direccion_idDireccion = idDir;
                IF (contar = 0) THEN
                IF (ids = 0) THEN
					SET ids = 0;
					UPDATE Cliente SET nombre = nom, apellido_P = apellidoP, apellido_M = apellidoM, email = emaile where idCliente = idCli;
				ELSE
                    UPDATE Cliente SET nombre = trim(nom), apellido_P = trim(apellidoP), apellido_M = trim(apellidoM), email = trim(emaile), Direccion_idDireccion = idDir where idCliente = idCli;
				END IF;
                END IF;
				END IF;
            
            
            SELECT count(*) INTO contar FROM Telefono_C where lada = trim(lad) and telefono = tel and Cliente_idCliente = idCli;
				IF(contar = 0) THEN
					UPDATE Telefono_C SET lada = trim(lad), telefono = tel where Cliente_idCliente = idCli;
                    COMMIT;
				ELSE
					COMMIT;
                END IF;
		END IF;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateDetVen` (IN `tProd` FLOAT(9,2), IN `idProd` INT, IN `idVen` INT, IN `pre` FLOAT(9,2))  BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS LIMIT 1;
			ROLLBACK;
		END;
    START TRANSACTION;
		IF (trim(tProd) = 0 AND trim(idProd) = 0 AND trim(idVen) = 0 AND trim(pre) = 0) THEN
			SELECT "NO HAY NADA POR HACER";
		ELSE
        IF (trim(idProd) = 0 OR trim(idVen) = 0) THEN
			SELECT "FALTAN DATOS";
        ELSE
			IF (trim(tProd) = 0) THEN
				IF (trim(pre) = 0) THEN
					SELECT "NO HAY NADA POR HACER";
				ELSE
					UPDATE detalleVenta SET precio = pre, subtotal = trim(tProd)*pre WHERE Producto_idProducto = idProd AND Ventas_idVentas = idVen;
                END IF;
			ELSE
				IF (trim(pre) = 0) THEN
					UPDATE detalleVenta SET cantidad = trim(tProd), subtotal = trim(tProd)*pre WHERE Producto_idProducto = idProd AND Ventas_idVentas = idVen;
                ELSE
					UPDATE detalleVenta SET cantidad = trim(tProd), precio = pre, subtotal = trim(tProd)*pre WHERE Producto_idProducto = idProd AND Ventas_idVentas = idVen;
                END IF;
            END IF;
        END IF;
        END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateProveedor` (IN `idProve` INT, IN `nom` VARCHAR(45), IN `emaile` VARCHAR(100), IN `calle` VARCHAR(100), IN `num` VARCHAR(45), IN `col` VARCHAR(45), IN `cp` INT(5), IN `ciud` VARCHAR(45), IN `est` VARCHAR(45), IN `lad` VARCHAR(45), IN `tel` INT)  BEGIN
		DECLARE contar int;
		DECLARE idCi int;
		DECLARE idCo int;
		DECLARE idEs int;
		DECLARE idDir int;
		DECLARE ids int;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS LIMIT 1;
				ROLLBACK;
			END; 
            
		START TRANSACTION;
        
        IF(idProve = 0 OR trim(nom) = '' OR trim(emaile) = '' OR trim(calle) = '' OR trim(num) = '' OR trim(col) = '' OR cp = 0 OR trim(ciud) = '' OR trim(est) = '' OR trim(lad) = '' OR tel = 0) THEN
			SELECT "FALTAN DATOS";
		ELSE
			SELECT Direccion_idDireccion INTO idDir FROM Proveedor where idProveedor = idProve;
            SELECT Colonia_idColonia INTO idCo FROM Direccion where idDireccion = idDir;
            SELECT Ciudad_idEstadoCiudad INTO idCi FROM Colonia where idColonia = idCo;
            SELECT Estado_idEstado INTO idEs FROM Ciudad where idEstadoCiudad = idCi;
            
            
            SELECT count(*) INTO contar FROM Estado where estado = trim(est) and idEstado = idEs;
                IF (contar = 0) THEN
					 SELECT count(*) INTO contar FROM Estado where estado = trim(est);
                IF(contar = 0) THEN
					UPDATE Estado SET estado = trim(est) where idEstado = idEs;
				ELSE
					SELECT idEstado INTO idEs FROM Estado where estado = trim(est);
				END IF;
				END IF;
                
			SELECT count(*) INTO contar FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = idEs and idEstadoCiudad = idCi;
				IF (contar = 0) THEN
					SELECT count(*) INTO contar FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = idEs;
				IF(contar = 0) THEN
                
                IF(ids=0) THEN
					SET ids = 0;
					UPDATE Ciudad SET ciudad = trim(ciud) where idEstadoCiudad = idCi;
				ELSE
					UPDATE Ciudad SET ciudad = trim(ciud), Estado_idEstado = idEs where idEstadoCiudad = idCi;
                END IF;
                ELSE
					SELECT idEstadoCiudad INTO idCi FROM Ciudad where ciudad = trim(ciud) and Estado_idEstado = idEs;
				END IF;
				END IF;
                
                
			SELECT count(*) INTO contar FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = idCi and idColonia = idCo;
				IF (contar = 0) THEN
					SELECT count(*) INTO contar FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = idCi;
				IF (contar = 0) THEN
                IF (ids = 0) THEN
					SET ids = 0;
                    UPDATE Colonia SET colonia = trim(col), codigoPostal = cp where idColonia = idCo;
				ELSE
					UPDATE Colonia SET colonia = trim(col), codigoPostal = cp, Ciudad_idEstadoCiudad = idCi where idColonia = idCo;
                END IF;
                ELSE
					SELECT idColonia INTO idCo FROM Colonia where colonia = trim(col) and codigoPostal = cp and Ciudad_idEstadoCiudad = idCi;
				END IF;
				END IF;
			
            
            SELECT count(*) INTO contar FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = idCo and idDireccion = idDir;
				IF (contar = 0) THEN
					SELECT count(*) INTO contar FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = idCo;
				IF (contar = 0) THEN
                IF (ids = 0) THEN
					SET ids = 0;
					UPDATE Direccion SET calle_dir = trim(calle), no_dir = trim(num) where idDireccion = idDir;
				ELSE
					UPDATE Direccion SET calle_dir = trim(calle), no_dir = trim(num), Colonia_idColonia = idCo where idDireccion = idDir;
				END IF;
                ELSE
					SELECT idDireccion INTO idDir FROM Direccion where calle_dir = trim(calle) and no_dir = trim(num) and Colonia_idColonia = idCo;
				END IF;
				END IF;
			
            
            SELECT count(*) INTO contar FROM Proveedor where nombre = trim(nom) and email = trim(emaile) and Direccion_idDireccion = idDir and idProveedor = idProve;
				IF (contar = 0) THEN
					SELECT count(*) INTO contar FROM Proveedor where nombre = trim(nom)  and email = trim(emaile) and Direccion_idDireccion = idDir;
                IF (contar = 0) THEN
                IF (ids = 0) THEN
					SET ids = 0;
					UPDATE Proveedor SET nombre = nom, email = emaile where idProveedor = idProve;
				ELSE
                    UPDATE Proveedor SET nombre = trim(nom), email = trim(emaile), Direccion_idDireccion = idDir where idProveedor = idProve;
				END IF;
                END IF;
				END IF;
            
            
            SELECT count(*) INTO contar FROM Telefono_P where lada = trim(lad) and telefono = tel and Proveedor_idProveedor = idProve;
				IF(contar = 1) THEN
					UPDATE Telefono_P SET lada = trim(lad), telefono = tel where Proveedor_idProveedor = idProve;
                    COMMIT;
				ELSE
					COMMIT;
                END IF;
		END IF;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateVenta` (IN `pag` FLOAT(9,2), IN `tProd` FLOAT(9,2), IN `idProd` INT, IN `idEmp` INT, IN `idVen` INT)  BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS LIMIT 1;
			ROLLBACK;
		END;
    START TRANSACTION;
		IF (trim(pag) = 0 AND trim(tProd) = 0 AND trim(idProd) = 0 AND trim(idEmp)) THEN
			SELECT "NO HAY NADA POR HACER";
		ELSE
			IF (trim(pag) = 0) THEN
                SET @pre = (SELECT precio FROM Producto WHERE idProducto = idProd);
				CALL sp_updateDetVen(tProd, idProd, idEmp, idVen, @pre);
			ELSE
				UPDATE Ventas SET pago = pag WHERE idVentas = idVen;
                SET @pre = (SELECT precio FROM Producto WHERE idProducto = idProd);
				CALL sp_updateDetVen(tProd, idProd, idVen, @pre);
            END IF;
		END IF;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `reporte` (`idVent` INT) RETURNS LONGTEXT CHARSET utf8 COLLATE utf8_spanish2_ci BEGIN
	DECLARE reporte LONGTEXT;
	SET reporte = (SELECT * FROM Ventas JOIN detalleVenta ON idVentas = Ventas_idVentas JOIN Empleado on idEmpleado = Empleado_idEmpleado WHERE idVentas = idVent);
    RETURN reporte;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `tempSubtotal` (`pre` INT, `cant` INT) RETURNS FLOAT(9,2) BEGIN
	DECLARE subtotal FLOAT(9,2);
    SET subtotal = pre * cant;
    RETURN subtotal;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `ultimoidV` () RETURNS INT(11) BEGIN
	DECLARE id INT;
    SET id = (SELECT max(idVentas) FROM Ventas);
    RETURN id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `idCategoria` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish2_ci NOT NULL,
  `descripcion` varchar(300) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`idCategoria`, `nombre`, `descripcion`) VALUES
(1, 'DULCES', 'Dulces y paletas'),
(2, 'Refresco', 'Refrescos de todas las marcas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudad`
--

CREATE TABLE `ciudad` (
  `idEstadoCiudad` int(11) NOT NULL,
  `ciudad` varchar(45) COLLATE utf8_spanish2_ci NOT NULL,
  `Estado_idEstado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `ciudad`
--

INSERT INTO `ciudad` (`idEstadoCiudad`, `ciudad`, `Estado_idEstado`) VALUES
(2, 'Acambaro', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ci_sessions`
--

CREATE TABLE `ci_sessions` (
  `id` varchar(128) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `data` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `ci_sessions`
--

INSERT INTO `ci_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES
('03vbfg27g50s4bt3r43nsr17qsbojecf', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('08pi5c9173lfmik29hm7n2eidi5lhm8a', '127.0.0.1', 1502405496, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430353439363b),
('0bl35tsuc7t6hnt8b4qq4f4f4bl9d2qe', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('0eihfal8h51vd5h5b7qnmv86g26nngvd', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('0gn7ksfeqceuuajf5cnngjnlp0gk53bd', '127.0.0.1', 1502424394, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432343130383b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('0hefd8i22alci0bnr07g0bjtkvs8ma61', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313431393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('0ogep9bf8f14b3rvtd3pnkc9vhee2cav', '127.0.0.1', 1502421562, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313536303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('0pl5uc8haf0kp9o94lj5usgjng28j16o', '127.0.0.1', 1502422886, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432323838353b),
('0ttqqmud7qs8d7j64n7sklunjoautvj1', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('0v18odulbrmc41kcrddcl0vo216h7qt3', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('0vbmklue2vgh4pssavajdo142sh1m74i', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('12ib5a30u4rovjpk0s9q0sv9e77vnc7k', '127.0.0.1', 1502420884, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432303736363b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('137fmcidrhj4fd26sj8v85amq455q2u7', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('1490c4482pn8cgnjd2ljlaqi8go9lere', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('15ua5v22r83f8m0sh5qe71b5gu5lma02', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('18ik12b3vgah10759i4n94an1f36ophj', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('18kn89occdlhkb2dlr318314e19tjqoo', '127.0.0.1', 1502422949, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432323934383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('1ak9on2cpfclgh5m8rulu5i61159mq2p', '127.0.0.1', 1502467377, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436373037323b6c6f67696e7c623a313b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b),
('1f5ne0k16tlrb1q1n4r07jhn3jm0qv1h', '127.0.0.1', 1502441167, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323434303937383b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('1g70fgp51ojott540a8tvotu9t2ps28l', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('1hocm7d7a2niuq5mss0eqbq3e3kpu5k9', '127.0.0.1', 1502427821, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373832303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('1j6rvo288bndc74f96osp698jbgs0429', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('1no9nh9jrc6okm90d97vg7baspd5dugl', '127.0.0.1', 1502353197, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335323931363b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('1qjtet185s2qeu0q17a23a0k5ogl0fd6', '127.0.0.1', 1502421455, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313431343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('21uca358qql68vv297rnunn81mc0lglm', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('22gtaljc35j0uk62ao8l1l2fnc8utjjt', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('27ee6is9rrrklkirr0gliibsmf27540v', '127.0.0.1', 1502405317, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430353331373b),
('2ada55dpp90klla8iou9fgo986995o45', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('2c03cls9g549djp970begt0e00n5p408', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('2d4t2eeuqt567ut4dqq622pghhdl3kmj', '127.0.0.1', 1502420230, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323431393939393b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('2je722sadhmp448fjkmkp7m4kvtfronm', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('2p8h01k633f7j07mnpbjet0h0cuoaeh7', '127.0.0.1', 1502436052, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433363035313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('2s4l3g1pf3d1duurfhpd4ngmch7tuton', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('2sgmq72gh1na52ffretj0tr1382u1oia', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('2tstunbbsi39iprjdvvi935vrmrtot9d', '127.0.0.1', 1502428675, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432383637353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('2v66l2j4l6rlapenoeag669ehob0a6cd', '127.0.0.1', 1502425672, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432353433393b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('33l12l3p9d0m96d8rj7clgmsvrs41b23', '127.0.0.1', 1502433262, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433323937313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('3649pg1ca66pm2mcn5l075m9e98ibhif', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('397toudlbnak3gq5o8nk1pc9iboupngi', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('39k1crd7d2eig1d66j8t9tl586q0mdjr', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('39le3ubgahlm73ncsr6espo1lc20jc2i', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('3huuapt45et9ns22aamss94cb7n71slo', '127.0.0.1', 1502356131, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335363038333b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('3k5rhgu83c3qudtpcc26p9aitdehnqmh', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('3lss4lrp2osrurq8erd47lhnsernvv31', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('3o8speak62h7713s5ll25rf6181l0922', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('41cm9677h3me0uqflave38uudmea083c', '127.0.0.1', 1502434340, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433343034343b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('4262k4qd5983rnrm4tgaeosbuomjqfus', '127.0.0.1', 1502436090, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433353830323b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('429eb11lkuo8b2pkjsu785r1ai9looin', '127.0.0.1', 1502439498, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433383935383b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('42hcr5hjjkupbpch7oeopdo45eib1vfa', '127.0.0.1', 1502404415, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430343134303b),
('47nmnspf1vg449027ns9as3n2cqt705o', '127.0.0.1', 1502423063, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333036323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('489uq751ohimrllrigsko9qhp80aralb', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('49ja5vle1g5ltct4ik6sicp7uvr9bgdo', '127.0.0.1', 1502473412, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437333230323b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('4bkoji2630tlbmp0kb0e1ob028m18sbv', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('4eo6llc7ugtfq2ncc8u1lrf1fap0h7fg', '127.0.0.1', 1502423167, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432323838353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('4eu5omm8s7i1q0sdub835a8ik2nioj4e', '127.0.0.1', 1502437925, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433373636383b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('4hcvs6lasevokpgaetgqsn7cpognlrp1', '127.0.0.1', 1502470712, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437303730303b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('4j57dnotr6hu2n79ltjqd83p14empdjt', '127.0.0.1', 1502421562, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313536303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('4nr6vph4urlbct4qv7a1hj87ee3rh4au', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('4ripb88mhmlllus4h0illpqa6u5opibd', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('4ssq2ahc5rdus73qhknslrh733d6r4ae', '127.0.0.1', 1502419466, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323431393433383b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a303b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('4u6qgfrhd1ramnddl0iam0ep9bkp1ku2', '127.0.0.1', 1502421562, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313536323b),
('50aud9r5qbpq2gidt9stq23s83ks4l40', '127.0.0.1', 1502401622, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430313632323b),
('55qbl6keh2lo4dh5gpol95s9l3hjjb7p', '127.0.0.1', 1502472014, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437313832343b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('5a0h28ludl5ervt1qc0krslaa8kvbkpb', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('5hk0le17purqb718jjp1u2bqsbseu173', '127.0.0.1', 1502354853, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335343535363b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('5mc4hldv5cnsqe9nbnhf3nnbv5qeeh86', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('5pik3q1poupsnbmbetev5047u87p5i7v', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('5s6rgdmri0ovjtkjn14o6pv34pre3fvv', '127.0.0.1', 1502403558, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430333337373b),
('5sl5ruuc3599c6ugp8re2vlg9shd89qq', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('61k3hh281ohdv9plj61l9svh4n65kq94', '127.0.0.1', 1502421571, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313537313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226f6c64223b7d),
('61lkhvjn9sud25eadhld5e17uddja7jt', '127.0.0.1', 1502433508, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433333331343b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('61o4irhdtepd13cq62o1tgcvm675r1gp', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('62husbrkeqp3tqojhi1utr51cr526pfj', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('662fdj8k91vdidlmhtmhmvhprttq01cm', '127.0.0.1', 1502427203, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373230323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('6but5035vcpsn8oj1frdbvuh2isepri8', '127.0.0.1', 1502426934, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432363933343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('6d6ueb9gmo4qhqrum0slkuce17aqsq6b', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('6diieng7vr0ljbhimmqc1m89k6dg5uok', '127.0.0.1', 1502428842, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432383630353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('6e6gvmbdp1giegq74akmmdfmmfi0da7k', '127.0.0.1', 1502381283, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338303937303b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('6md4c8aquk2uostg9upg16kmhqtb1jg5', '127.0.0.1', 1502424131, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432343133313b),
('6uhu0rrifvvoivq8leoot47kea8k4tag', '127.0.0.1', 1502442185, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323434323137323b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('6ukmmmc8vsnkqfn0ap065bhv3qva7km6', '127.0.0.1', 1502351994, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335313730393b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('6uohig1iijgaupkmpq9849428mp43lj3', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('70vk0k072npojqmivdcej9l2eds3au4i', '127.0.0.1', 1502427419, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373138313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('71i5vkqr3k6dks0qclddfov75mct14f5', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('7a0sak4ipdnkqqajokfcqj82sc27182t', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('7b7e7aq2d32b09rf8obt3b988i863jqv', '127.0.0.1', 1502379425, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323337393339323b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('7cvogk85b9ovuo6tk2c1eb61avu16gpb', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313431393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('7d77g6084l1d3j8rucu83o3t99cebeab', '127.0.0.1', 1502384734, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338343731343b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('7hmrik4b5onglhlbpp0mfclu9678io14', '127.0.0.1', 1502385933, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338353738313b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('7o4tkrg6trlgj7tknki9f8uphjtoprut', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('809mo7mru90175oqbsqrgs0ro6ml7iai', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('82iab9960nea5pd1fbofkj25v6otrqf3', '127.0.0.1', 1502428225, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432383232353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('83c816a2tu23oip6atmp9cq3rl4lhpil', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('8gjul5ithccpgkt7joc3inahpssdqnpi', '127.0.0.1', 1502427418, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373431383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('8iar18e1jilr7qcr8j0c02rj13sl3tfl', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('8jbh14spuso00dtiecaf7go3d1ji3319', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('8jluavattv373ddhog1hbgl3cgk11nqf', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('8k94d2pijajcrbvbvs2eb7f70gi5jec0', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('8l7lrratf4k3su8rlnk3o9k8phdgkoji', '127.0.0.1', 1502405986, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430353636313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('8m0b8n0trj8d61igqkdc8o6uvdj11vom', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('8n6hv6pn48slidri6jl1avthpakb0fin', '127.0.0.1', 1502471203, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437313035353b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('8or0i6cbi2rr4vhb3jlt8pc0r7aarl7l', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313233393b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('8sj4a1lv2iq04j65v6t9lhh6psuop7uh', '127.0.0.1', 1502423270, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333237303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('8st1g71p06pfgd01l5f8e7jdvt8remc1', '127.0.0.1', 1502405364, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430353336343b),
('8t8r3kd7sj5mersj3quipm7t5ctr4bqr', '127.0.0.1', 1502406089, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430363038393b),
('93g6jep2290rn506i21eumr4c1um8obo', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313530353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('96igtnqqjuq40kijadldqgueilttdiub', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('99mrtdavbbt0ips50rnoauvn72l7huqu', '127.0.0.1', 1502403401, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430333430313b),
('9aisrnmvgjppncu9b20f1hko84d4eokk', '127.0.0.1', 1502422099, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313937303b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('9c7oh1v2lpg7a8l4pm25vcle3o44hs8o', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('9j6t7g96sipuou4lkf04phscke4k648q', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('9nsrvkat8gt56a741ac2u4s6i2hd7r1p', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('9q8928huqie5o6h0cdaj710pnn80h45i', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('9qf89fodvucuqccgo5h6ifa80kke4beg', '127.0.0.1', 1502383252, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338323937313b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('9rtcdvp54tibvso0mfm5ahr786jvgr9c', '127.0.0.1', 1502464513, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436343530333b),
('9t9ic7vm38inh1avqbt5q16u0k6qv0ll', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313530373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('9thpai5qskhb9lmrkpmgj1kob20bd0e4', '127.0.0.1', 1502404103, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430333833333b),
('9vbvpg9mevds46arpkua3h98pmp7eg7a', '127.0.0.1', 1502464879, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436343831373b6c6f67696e7c623a313b),
('a48ks8kl57n2e8fqghbr6shu8c0bg1t2', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('a7n75l9o5tbp2a5of6o01qup0bjfkh8b', '127.0.0.1', 1502437159, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433363836313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('a8cgo22t9a8sp3kup19bsvntqkh8qm97', '127.0.0.1', 1502426393, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432363337353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('aim3j6jbe1g0dq8afineeq3cs5g5f2su', '127.0.0.1', 1502421681, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ar967dn0cc5hf74bhckfkq0ddiei926v', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('aujq918rp44unt60l1bt5m4gc3pvdsbq', '127.0.0.1', 1502429513, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432393531333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('aup7ee24fm35dsroqffnp8oaag2k3baj', '127.0.0.1', 1502428840, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432383834303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('avd5likegle0gfj7eqd972tktgr7jshp', '127.0.0.1', 1502421455, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313431363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('b54h8gaumd9rqqlicnsghti5luumj83r', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('b8g1ib35l19ul13b4mggvpvqcvajkina', '127.0.0.1', 1502469038, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436383934333b69647c733a323a223131223b6e616d657c733a373a226d617269616e6f223b656d61696c7c733a31393a226d617269616e6f40686f746d61696c2e636f6d223b75736572547970657c693a303b6c6f67696e7c623a313b),
('b8phtvg9c46oovj66fqg3i34hlt3d0tr', '127.0.0.1', 1502423510, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333530393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('bammb0uqsnehgbtnkgulbfnuenopu9rr', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('bh4r3aokeops7mpqfbgt5pcnfeepafqi', '127.0.0.1', 1502427593, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373539333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('bhann64q312qdacjhiic0mc8a0ae99hv', '127.0.0.1', 1502424078, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432343037383b),
('bi3t1jrkne6f6imd1f842vsvemkkcgkn', '127.0.0.1', 1502405420, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430353432303b),
('bi43nf1eg9tjekrm2f3phpvfkf2hesgt', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('bitlms65b6fh8af2hfk8di2tokhjmrv7', '127.0.0.1', 1502405804, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430353830343b),
('bju2fd3m5qordum5teltn7ojkek2g985', '127.0.0.1', 1502428324, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432383332333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('blggiaebbf78fb7mq9ovchvmoobb0fnk', '127.0.0.1', 1502407624, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430373339363b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('btvin56228s1c043cu19q6tsa1sblodn', '127.0.0.1', 1502424619, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432343435353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('c09sj9hdcrmqet9imrrp92sl29j85fd8', '127.0.0.1', 1502433901, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433333634303b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('c1oiqbpu8etrc1ao2qjoujtdn2qgppk7', '127.0.0.1', 1502468180, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436373839363b69647c733a323a223131223b6e616d657c733a373a226d617269616e6f223b656d61696c7c733a31393a226d617269616e6f40686f746d61696c2e636f6d223b75736572547970657c693a303b6c6f67696e7c623a313b),
('c7k655krc3okd1pvfvg30kub4sq0egf1', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313530393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('c83bsae41l5e2gl4boe6gnkpfdoqnf1u', '127.0.0.1', 1502429332, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432393333323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('c8pc5p25d30ht66htihdeqp59t1jfrin', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('cd6ipcedn1jg9von19ld3pt7snmbhv44', '127.0.0.1', 1502379172, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323337383931303b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('cdavnnvsql3afht21lrf8none4nob46u', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ceae0510oh240scf23jep5rn6972mvvs', '127.0.0.1', 1502439598, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433393530333b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('cejl2ub0vavspa7i9ikp7d3ubgp0dno7', '127.0.0.1', 1502428590, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432383239343b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('cidcctslnvrn3jd2lhp7iraq7tc4gkm4', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ckec98t8rbv5koqcke31517mg2sfcb5i', '127.0.0.1', 1502353812, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335333537393b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('ckmjqdgla5v98v9tefvs8jr4hdjdbgmh', '127.0.0.1', 1502350035, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323334393834343b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('cnb48ni2ul62347h705h0g7cq7ig9crj', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('cpc2jk7dns281su2aik20lpkv34va56u', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('cpugsc11tt8afrej1apvscikb6rii8gv', '127.0.0.1', 1502426277, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432363035323b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('csu5n3ri4idgmqbf1d10ev2pmdrv9mkp', '127.0.0.1', 1502466817, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436363338393b6c6f67696e7c623a313b),
('d2fb4302uc582dvgvkidioih924khk90', '127.0.0.1', 1502386712, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338363531333b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('d2t877dd8mhurlkcnlcc8iqn5dgq597h', '127.0.0.1', 1502427375, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373337353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('d4o4m45ilsiv5nmrpkijg62nbj8mueqa', '127.0.0.1', 1502425972, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432353734303b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('d4tjqrvl8emogdae9ugk17gfnhiaj0td', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('d7921oiets6f6h1ung7n2b5uf18nevak', '127.0.0.1', 1502427267, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373236373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('d7elbf8i1k9iup4phv0kqu9kdou87cfk', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313633393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('d89284r9uh581ejnptrqat32d07vqltp', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('db32gluruk5lfs83jiciaeh2eb6nhj6p', '127.0.0.1', 1502427323, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373332333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('dbh4jo6gd8nav4dp4r3kc7r9bs0edjrm', '127.0.0.1', 1502434989, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433343833383b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('dbuqmhkcgr3cn381sp9od44slktl7thm', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('dd0aqbq7heop1fij04vhhdnb1m12e90i', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('dh6b5f5318t6bjet12botnivm6354u19', '127.0.0.1', 1502468241, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436383231343b69647c733a323a223131223b6e616d657c733a373a226d617269616e6f223b656d61696c7c733a31393a226d617269616e6f40686f746d61696c2e636f6d223b75736572547970657c693a303b6c6f67696e7c623a313b),
('dmh6ck8uuc7g5at6tif4bue53dtdepe0', '127.0.0.1', 1502423021, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333032303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('dmli1eivdrmj27ecf2taaok6cnvvjpfg', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('dns3p5122crrplhrdomrnqktkoomcl60', '127.0.0.1', 1502349521, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323334393234373b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('dp2hnd1odrl513fonrcv3odfim28q270', '127.0.0.1', 1502441788, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323434313530333b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('dui1315brdsd3ghn23kkjpq6rousd38s', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d);
INSERT INTO `ci_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES
('dv1ma41p7rsuu08i9rsp89o8gf9u0ees', '127.0.0.1', 1502421685, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313633383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('dv501h1f4qq7kdsdtlsk1uljpl6u1q7l', '127.0.0.1', 1502380787, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338303634363b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('dv9f0egg7vhfssoeor45l475as8lcprf', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('e19mdenm3iouu9oovd2l98g16490r799', '127.0.0.1', 1502387379, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338363839323b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('e1pjdnh8brlvhafnvhbsd2mn55v0m2pe', '127.0.0.1', 1502354202, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335333931353b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('ea84sni9ab1ouq905huco8osstongs5n', '127.0.0.1', 1502382926, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338323636373b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('egfvatlas5j34bf39unnb6vn8clt4jlb', '127.0.0.1', 1502406006, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430353938363b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('egjok0mq9lper20p4t2gvth2r0mv8qj7', '127.0.0.1', 1502354525, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335343234353b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('eo2okbavv78jclhp0c1tt340jnhobuhm', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('eo3ia4gj2429bq4n3235oekouc8jtedu', '127.0.0.1', 1502435271, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433353136363b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('ergnrkfafcs8727tld61tcue1iieuqg7', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('f0h2oalh3qnsqirviqb7ek23j8i831ni', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('f5tjv9nivqdp567skntj34qcsdu24r18', '127.0.0.1', 1502468840, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436383534313b69647c733a323a223131223b6e616d657c733a373a226d617269616e6f223b656d61696c7c733a31393a226d617269616e6f40686f746d61696c2e636f6d223b75736572547970657c693a303b6c6f67696e7c623a313b),
('f9b1fp6r2spgf89cbcp521p588evrh07', '127.0.0.1', 1502426937, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432363737313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('f9i0lvhi13m3kg1vpui11laupq2na8sv', '127.0.0.1', 1502427696, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373639363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('famu2a72brmratjr7c35sugi6k0825i9', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('faq44ukvmj9mboittmkv80dap7f6oeb4', '127.0.0.1', 1502421685, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313633373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('fd745jthuc90rhndpgpuchqr34rb58bc', '127.0.0.1', 1502421562, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('fecciotgghbtaud8blj748iok05gl8aq', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313530343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('fenhgg0a3joj5a2qbocbvgo9pbg10c3v', '127.0.0.1', 1502421562, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ff6nu4d6crg69dinj0he9fml12gsplm5', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('fg78j2eq68opoc6sijdoog9brbaft9np', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('fgmba3m1d0aas51i5h9c4cetjge0cine', '127.0.0.1', 1502434843, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433343834333b),
('fps9oja6767s4dfidb1sj7st27t3bilh', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('fsvpqucresjb9gr053a85142vq2rrskf', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('g0dcp6kb4gnt8lh3933fa3tc77rvtfi6', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('g1ri4993u36c3t93ondq3p2slhrkf335', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313530383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('g1s57qpf6fqlm6q4sh7k8da5u7vkqift', '127.0.0.1', 1502435982, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433353938323b),
('g370a5apmal21eoa99jmufjvddg3rlif', '127.0.0.1', 1502422099, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432323039393b),
('g5491obb046cq8emh3fvjdfco5g2kpjq', '127.0.0.1', 1502405524, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430353331373b),
('g61mbr04k3tuhj7rc32a83j4ha5mj56q', '127.0.0.1', 1502423789, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333738393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('gf7lrgvd50jeg57cilkpf790bubgnj2l', '127.0.0.1', 1502428226, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373933383b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('gfk95r05268bret4j801nla6b5ih1chb', '127.0.0.1', 1502434653, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433343335353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('gk7qcmbt76ljah6qsa42lk9bootub0ti', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('glhfjnbtmos4bnv9o3gmu0ghg46236fi', '127.0.0.1', 1502422342, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432323334323b),
('gm550celh8t5e77i2dda9cbju81b5nmq', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('gmf3ooveepjsmu9etdbbfghm2v1pvbts', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('gojmicubscvfc0akloq3o86icj52m3u6', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('gpe6glap10t36uij1e25pim65rc4hhed', '127.0.0.1', 1502427938, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373933383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('gqbamde7ddqhc8heceg4gqb84oaeho3n', '127.0.0.1', 1502421681, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('gqbsj3eelo8i9bkm4mbdk2a3uunoas0f', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('gubbjee6gtbbn2ahd0jagfdbc2aaornn', '127.0.0.1', 1502423142, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333134323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('guv432psh5fq6g34vj1o9ktk6cf3i4bb', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('h0p727s4gj2kmpon6krd3mehd8bm6bij', '127.0.0.1', 1502356013, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335353731353b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('h3laqk6fm38r4dadu8ef5ahj8b22kcvm', '127.0.0.1', 1502407995, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430373733343b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c733a313a2230223b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('h48d42v8ovn13iv14dlkb0nbgj36ehr8', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313530343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('h7ios0v6dbhbu17v6pt3rbs0cu06cf4b', '127.0.0.1', 1502472028, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437323032383b),
('h87ipaefklq2g0rde4f15qaig9nq6cn7', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ha02uupim33r8fvogfl4edub9femkl47', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('hbksl4s9o97k3hljt2iut5p9g53u7nms', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('hfktn4t0flas393epsukggdl9sj0fntv', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313530363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ho5r299mbfb4ro9ddh1bhc4rt33q3dmi', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('hr8jgotid4702rkatfis90bs9b2rn8q5', '127.0.0.1', 1502435270, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433353236393b),
('htacq5onqfg8odui8egc6qea29gc3393', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('htqlu09ejqe5b46jqap7eumjbqdie1u0', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('hvnvbk1ndq3df72adoc4gcmled9l00lr', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('i38vpq3o217i9me11q8ljm0kfihl772t', '127.0.0.1', 1502472657, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437323635373b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('i40qgk0ncoecu02h582856fb4f508u1k', '127.0.0.1', 1502438356, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433383131393b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('ig3nnfe514odhekoov5u6v4mfllajj0l', '127.0.0.1', 1502436029, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433363032383b),
('ihkeln0itj3tokqkson7ogdfniop6n3d', '127.0.0.1', 1502466299, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436353736363b6c6f67696e7c623a313b),
('ihrnetipcq49debo0i4gk6l2hjm91l52', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ii1rm2nt28iifigktf4hf569tvtvkvfm', '127.0.0.1', 1502436000, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433363030303b),
('ijacmgbbu8qv24rqa8tgi2043jqei4dq', '127.0.0.1', 1502434988, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433343938383b),
('inraiok9l1k4qvenkjffvnruoeto3j2v', '127.0.0.1', 1502378350, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323337383139323b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('ipgjekr64oc70bla45b7893stu22u2tj', '127.0.0.1', 1502421455, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313431363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('iqt8itj85lubr1672805uhr5e2qrptgr', '127.0.0.1', 1502424113, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432343131333b),
('j0m3qktqdb2asso9b278frhbdu88s594', '127.0.0.1', 1502383535, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338333239383b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('j2cpsq5k8ohgfbk56q1fvniht2115vtb', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('j2svjbka7k2nqs6jeh0kpl0im1uufbl6', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('j3pq1bptmfvqg6oj2esnarjnmfeutbg5', '127.0.0.1', 1502378190, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323337373838333b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('j9h1jje0nef434p8iq65n13jj5vkklu7', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('jb3hp680gav59t1umo2vj4l1n69gku32', '127.0.0.1', 1502421455, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313431373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('jbaecacalen32naqgs3pprvrab8db7ni', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('jdt3eeotgum1ejs9862qgeu2riptdprd', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('je031so9opuhrk95lj665u6kgn3jt778', '127.0.0.1', 1502429518, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432393232393b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('ji160uj5odehqn41vjnlac470mnaeigb', '127.0.0.1', 1502421681, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('jo95o2i1ejfr01g7pm38qr2lb2lvl3uu', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('jru5ev775kua38786nli5vm00h68sm8t', '127.0.0.1', 1502422342, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432323334313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('jsv8mrm8fra43ilhg8ivmmppbgrk20g4', '127.0.0.1', 1502384286, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338343134393b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('jt9ue8ns49731ehkev3i7gebmj00ngkv', '127.0.0.1', 1502473605, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437333531303b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('juct1avtfao77rtvang7uutu1e40j3ha', '127.0.0.1', 1502426846, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432363834363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('jun238boc53m82s03p0s2h3e57708pgs', '127.0.0.1', 1502442786, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323434323738363b),
('juphnek6infg7f5eqacsl4s3pd3ifogp', '127.0.0.1', 1502427857, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373835373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('k4065qffivub7aj5ivb6414mdn7dgd9m', '127.0.0.1', 1502421681, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('k4adnn5k2o2164rt8l3g9kqgp4p119vg', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('kcub6gg733tupvlfstfc2jirm15okl9v', '127.0.0.1', 1502423165, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333136353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('kels17oa3jpuni0mgsligb33l13mfbkq', '127.0.0.1', 1502442109, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323434313832323b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('kf67c9dqr1d5779c8vaoc1njtj2nsroj', '127.0.0.1', 1502431360, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433313037363b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('kfjjjc5fv25kjbdg70dds6oa7e516iuh', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('kh6vl3ogo0dkscrfeeb1jkcmbo9f1jd0', '127.0.0.1', 1502423974, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333937343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('kkrqjmsbe6okpdlgh7pgvnno3lmpdumg', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('klhgpkp1ag20rfs4l7mlru2l2hbmgftm', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ko0hrsa8r0ngtgueka10mquino4u7e3m', '127.0.0.1', 1502351127, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335303932353b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('ksm6t8dmn7ucg3bsi5sqe25stas0i12b', '127.0.0.1', 1502469536, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436393436343b6c6f67696e7c623a313b69647c733a323a223131223b6e616d657c733a373a226d617269616e6f223b66756c6c4e616d657c733a32313a226d617269616e6f20526f626c6573204e75c3b16573223b656d61696c7c733a31393a226d617269616e6f40686f746d61696c2e636f6d223b75736572547970657c693a303b),
('l167ms5mr55v4akhnh3jo8qs0eknv4mm', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('l1ano5a26s0husgjqg9l8tuvn08h3hcv', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('l2521veg0jl0pli81s55k0o5c4d4gbj6', '127.0.0.1', 1502430323, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433303137333b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('l3nkqn74an21qmkje3gl67jp8a9jgehv', '127.0.0.1', 1502437593, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433373239353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('l46r2rjkokqcmo4d73aeri43n2egknk1', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313435303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('l4qrf9v9ibk2ojdsruquqvt0ivvqnpe2', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('l4sgp60tfsh9hd4rsuru232f3ujjk8om', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('l5pvnd95dassanvakttlfema4a80ohp6', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('l7mm3bf9i7l259mrt0pf5v5m8ib0pfp5', '127.0.0.1', 1502434894, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433343839343b),
('l8c7ne37f7cddggol1qvuf79i4ljdub6', '127.0.0.1', 1502424506, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432343530363b),
('l9up30t2j5dtpg9hrrq4g3loeoucomq2', '127.0.0.1', 1502406988, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430363736353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('lbv2b7hbs3u46te37p4u6mq12lb0q1i1', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('lcbmolpedtt2ce1llpmk84pmsoalk42i', '127.0.0.1', 1502424079, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333738393b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('lj04va744i796d8sfh363tvj3ngeesci', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('lmjobsdfo5a1t4sgeeubm29e0rdj3cvc', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('lnlbtel8d8o3as4uqsba67n0bfisclt0', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('lolesgaeqitu4f4tom789g0sgdunk9ku', '127.0.0.1', 1502421455, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313431353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('lqv2bqdjgddtrpkjuevi8nen6scvtcd1', '127.0.0.1', 1502436136, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433363131383b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('lrqoof0t4pqvfkkb42troh2t52fef14p', '127.0.0.1', 1502470387, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437303237373b6c6f67696e7c623a313b69647c733a323a223131223b6e616d657c733a373a226d617269616e6f223b66756c6c4e616d657c733a32313a226d617269616e6f20526f626c6573204e75c3b16573223b656d61696c7c733a31393a226d617269616e6f40686f746d61696c2e636f6d223b75736572547970657c693a303b),
('lrrorokd5sdmcjj58vhf6b1qheqojvfd', '127.0.0.1', 1502423510, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333236353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226f6c64223b7d),
('ltie58hrfbb0vdloa7ds1bqpkoab653d', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('m3o7covi9u8tvcnb1j6ro4hhutr7im6n', '127.0.0.1', 1502352067, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335323036363b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('m6pujfeho8na0bb344dqe6pnm4jcdu47', '127.0.0.1', 1502401176, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430313131353b),
('maufi70lhh96e481mmaomtdbtcul16l9', '127.0.0.1', 1502405375, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430353337353b),
('mbinjj1dpp1hehdolefl0scjtudju79j', '127.0.0.1', 1502423338, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333333383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('mjf7o8ktljlh0cht2grromsukn6mhgr2', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('mlfvtr0e74vlrvvjfsto925r9n5qlem0', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('mnb29qvskttrkt9hsvrl71dsogb2d19m', '127.0.0.1', 1502421685, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313633363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('mqqm8porpsdmbdkpktit0f3pktbnb7ml', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('n6cgd7ii3a94v2bob3m1aajquflet4f4', '127.0.0.1', 1502421571, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313537313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226f6c64223b7d),
('na39jatj9t8vnf1kmifb3fom2jnjjhos', '127.0.0.1', 1502408120, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430383130393b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c733a313a2230223b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('nadbcqmq1du6hbsgo57cqeuf6ge3gq0e', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('nbbmsuqboo7svkf8d06jofiortejg8ll', '127.0.0.1', 1502350829, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335303538393b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('ncqk750d39ia8g6h96qpi63l90u03tbd', '127.0.0.1', 1502419163, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323431393037353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c733a313a2230223b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('nh3bku8er1g2nkqa5cb3koer3flcb9bq', '127.0.0.1', 1502467672, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436373337373b6c6f67696e7c623a313b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b),
('nj39u8v8v73po2q2ru0gu9be0g8stu3j', '127.0.0.1', 1502406498, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430363239393b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('nm2e5cb5mqqdejhv1lgjf0mk2ib0k524', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('nmqb73clptbich03s3q1rb16jg6aea7p', '127.0.0.1', 1502419156, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323431393135363b),
('noafgis48qvj1mfkeguoijg42k37keg4', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('np6jskam9oc20idn290r9kj0j3l3n76d', '127.0.0.1', 1502385779, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338353435343b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('nr84rp9negmtl618ml7bn3hahi1oinoo', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('nr9cafc8b2s1oqpbat61psq3pma37jnp', '127.0.0.1', 1502429790, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432393536353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('nrr7b1i790j9q3g2tdd5t3o5v0oocno5', '127.0.0.1', 1502432912, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433323633393b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('nsqmd42i7d3b3qs2h1qlsnal2bgcqf5h', '127.0.0.1', 1502421681, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('nstuqodc4bhg2f063bf7i97e05aqsu3m', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ntvqf7kv808uftv1qh4vl9feovfu354p', '127.0.0.1', 1502464235, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436343135313b),
('nukqr4r0ggjbc964lrvjkcb16pdhrpne', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('o0faukp77j3oemh74g3v092s3ql2m4qj', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('o1kso91fqu9sodb6pnteud610d5nf5gu', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('o29ejft5rmebu2pffuss6qdaatscqo6a', '127.0.0.1', 1502421570, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313530353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('o33bvjb346pnm2cqterr5d95g38bn5tc', '127.0.0.1', 1502380034, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323337393838343b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('oaqgc6vp6jphhr4n5thsannhu6s8j8or', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('obeks1u1c16lepvmon05lgsi4nvuna8s', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('obs28vmq1gt5dh99bs6500m6vte9tr91', '127.0.0.1', 1502381642, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338313633323b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('obv8e2rca4b1dbqb1hg2asp51p2pnt68', '127.0.0.1', 1502428761, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432383736313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ok83kvlsun7dpi5od7d6dmurfom0u0kd', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('oston3eahkjc9unv6l8cbkod50n840j7', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('osu2d14lqq1mdc2heck3ibitr0lmuarf', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ovn672irpklgkr7qc0hfhdmdsh2klvfk', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('p1bavj7ou3kgu3b5ui51chc7c5lqaj0k', '127.0.0.1', 1502404490, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430343434383b),
('p4979k9deac0226bq2604ohctpqaied7', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313431383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('pajb250hb89k8k4p9vl73kuja06eln2v', '127.0.0.1', 1502421685, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313633373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('par2htve4a30obkqdhtmk4eal9qofube', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('pbg6e1sesn4qi8tragbpg33l7t179iu3', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('pbqtuouen0t03h6v4dupcl1el6dt2v72', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('pe5703l0cvvoi2nucv3bg6maso6d1vs5', '127.0.0.1', 1502421562, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313536313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('pfouvmi0ohcugbibdtg640532hiu8o4n', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('pg6k5lgu4anknocomt65tdqon47m8gg6', '127.0.0.1', 1502435196, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433353139363b),
('piu997uhmiijilug1qu53hfpereqmkf9', '127.0.0.1', 1502436118, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433363131383b),
('pqpapcjldib40fl18mnfvsbds8is4pns', '127.0.0.1', 1502421562, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ps6ta4jugcnmm9ne99envmbvqsqsmncr', '127.0.0.1', 1502440304, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433393936363b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('ps99i9jip12c0i5cl8hf4nc5ufh1t52b', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('pt2lrgd2gs2kabpkkh3i1skeqoi855vd', '127.0.0.1', 1502421681, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d);
INSERT INTO `ci_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES
('ptkfjfo9hjqv8teqn2btketf3jksjm1j', '127.0.0.1', 1502423047, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432333034373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ptpd7dm95ofrsrb1514sgr18pra3pc7k', '127.0.0.1', 1502421454, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('pvnuqmpujiluc3lp4v2sb4klk9j2n4m8', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('q18nli3avr9a8c3gp0p7j0bh4n2rpfuk', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('q29pj55mcpusei8bdbk2u8b69hhnj59q', '127.0.0.1', 1502427294, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373239343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('qbt5l6gsj8goup1dne7mt1a9svt5ol0v', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('qepgctmjh7lipltg0hti11chtfb4cph5', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('qg6nuk9vrbkcknjr39i88cfn5inke2cq', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('qkpg5s3ogi3ejqej3k89uorgvq0kbf8l', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('qpdvqfa3p6rg1d3p3mfkuqsj1m92sadu', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('qrfeat36fblenjnh7p6lg5kabup03icf', '127.0.0.1', 1502407356, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430373037343b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('qs19rifvsbrcinj709dhklbdudj6hq6a', '127.0.0.1', 1502383693, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338333636323b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('qt80gul88ubbd03a1u0li09uhfaogvno', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('qum31p551li02tgbl18ggs9qdfde14gu', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('quvmdp8uou0af29ghj8ajhko2eoppql0', '127.0.0.1', 1502427858, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432373538333b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('qv7igd01tledm56fpra23t8iuupooseo', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('r00dhrnon9nf45hh4ll64126kgctv6q7', '127.0.0.1', 1502421755, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313537313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('r0902sci0ls786ap0344rqf92r0hgd5n', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('r0lgkkggtg8hbnvag71c107tfu8ps6mr', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('r2mhfrdbtj4larfv42c4aboakop1vra9', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('r91npfbl7vfii99vic4hr1of0nl012n9', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('r9qi48a8hpbdnrfcvshen0rq61fjtrnr', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('rcs62884r99bhtjd15d7725omf9leeuj', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('rdavso3t4fro63mkfa3q4b8li4vtr056', '127.0.0.1', 1502402952, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430323738333b),
('ri0q3qckuhij35qkim9nbet85v9048bd', '127.0.0.1', 1502421562, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('rj8tq46gtpomdve7qini5vc97h89jfiu', '127.0.0.1', 1502421453, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313432373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('rqf5l3jtkmefc27mqfovu0f7k38lk2h4', '127.0.0.1', 1502421564, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('rrrjr56l0istfa5ca7h0uh1md90o479g', '127.0.0.1', 1502424361, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432343336313b),
('rs1bmkvftn2q4759kpn7at34sh6cucrc', '127.0.0.1', 1502421455, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313431343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('rsfnlov38iie3f0ih5bd9huogdvd6b3m', '127.0.0.1', 1502421682, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('s6glotbj89n1t2qvq6a2fhrc08bhvp2k', '127.0.0.1', 1502425384, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432353039333b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('s8uc0msj1sid0gqdlonku2j54acn4fsv', '127.0.0.1', 1502465548, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323436353235393b6c6f67696e7c623a313b),
('sba67qh6ae3uu91rabur2bgt2djqdqph', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('sbm5kh9flhaps31d7dpdmubodrf5hf0g', '127.0.0.1', 1502421562, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('sdk02elaac49itpflth53ie58dlr9tp9', '127.0.0.1', 1502429274, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432393237333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('sei4pfthrf4k61532ldul321od7sga6g', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('sepsuup797o0ub4oodh40b8fl2dlt5pb', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('slngav2j791ptrg4uucrlo6r1hkkc2mv', '127.0.0.1', 1502420766, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432303436353b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('sm15vn74efsu6ml4rs1c96k4380d0106', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532353b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('smmr1mn0h3t3s24ft0u9b4ha5du7hqts', '127.0.0.1', 1502421566, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('srnghutb7bmkek72nbp1gd2mcnpmqnvq', '127.0.0.1', 1502421452, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313433363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ssb060us9828r5j1l3b7aoj73drpa6jd', '127.0.0.1', 1502474228, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437343035383b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('suegn80votvkl8751k41upae6c9n5ur7', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('t3vc2us4dn2qc1kcj5e1i6337rgd475r', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('t5g8d00gsirmamd464j3mnlcte3n6rge', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('t5vn2ltcbgfce5h88fse7nmulblqd8nn', '127.0.0.1', 1502426392, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432363339313b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('tboglqna6d4g9g9jffbnsdllkehv9v63', '127.0.0.1', 1502350369, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335303138373b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('tek61cf440n89of3ru5e3hqq5sv16d7l', '127.0.0.1', 1502435974, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433353937343b),
('th8frf2b0f8ar1922r4jodggs19pf4na', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('thnpq0g9hihdq4dgqae5ernafggj4cti', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('tjh45mh8744bm7uds2qsagovkl6bi05i', '127.0.0.1', 1502429239, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432393233383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('tp7f00omo82if9lquvciif0m7h0a0g0b', '127.0.0.1', 1502381629, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323338313332373b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('tqcp9fhle8e3pib2iok5sg20r3tbrpqm', '127.0.0.1', 1502472528, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437323233333b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('trdspua0164bphgian04fgggh9pe9nor', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('tro7oq449ee3j0k315nbm7kqvce3116r', '127.0.0.1', 1502421568, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('tsuvprq9dn4ns0krs1b6n18f17mld8v3', '127.0.0.1', 1502421681, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636383b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('tv2jn8b3g6pe88jo23kcpp7nke92esgf', '127.0.0.1', 1502421569, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313531373b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('u09v149ajbel9tqqt5m9bfvgbtt7d2pl', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('u2579fjmg8aheplco170e2908reef0k2', '127.0.0.1', 1502438563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433383434313b69647c733a313a2231223b6e616d657c733a343a224c756973223b75736572547970657c693a303b6c6f67696e7c623a313b),
('u6ar570fcihunm3227l0v9mplobkjrl0', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('u8h3q9af9th4s4vq13elrjt7s1r3v0bt', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313634303b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('ubnqmmj59uomvnp3du72552kevijg8eg', '127.0.0.1', 1502434928, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433343932383b),
('uk7p4gr6nks09v7n4k49ln751hm5k7de', '127.0.0.1', 1502404984, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323430343937363b),
('unkjk5f3noh0uqejs8vjgp3a368rucvk', '127.0.0.1', 1502472655, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323437323635353b69647c733a323a223135223b6e616d657c733a393a22416c656a616e64726f223b75736572547970657c693a313b70726976697c733a313a2231223b6c6f67696e7c623a313b),
('usphbl5g93d1rfop1cl1727ggr646jgf', '127.0.0.1', 1502435802, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433353830323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('uv5psmsqb3b8c11tfgisp7rgrm264ugg', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('v11c1bho0vato69v64cukkldmkhr6eqq', '127.0.0.1', 1502421683, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313635323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('v99n44u4fm49g6ov2e6521sn1650p5oi', '127.0.0.1', 1502421684, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313633393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('vcb97m8kdk6p567fnkju8j18h0pjnl6k', '127.0.0.1', 1502421680, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313637343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('vdfm8s217tq5fe2a07shoa6ftcqokao9', '127.0.0.1', 1502355117, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335353032343b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('ve5ui4tpcm94k3qdivicotvhdctcea13', '127.0.0.1', 1502421685, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313633363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('vh4mhqfbhhi04dm5cte7g1o1g99rcnhd', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313532363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('vhipiv44tntknpu13b94p7qrt4uquvfb', '127.0.0.1', 1502421681, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636363b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('viq6jojetlglkvasjipde0ge8bfe5gdj', '127.0.0.1', 1502421567, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313533333b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('vm57q6ub5ugiqv0c9pqei0frs3bm1e6e', '127.0.0.1', 1502421563, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313535323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('vnaaa3pujdii2rlq2uvn02t8dlnb3168', '127.0.0.1', 1502435979, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323433353937393b),
('vqafgh70cfhvg4r2knigf9gu1okb2tfg', '127.0.0.1', 1502424394, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432343339343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('vqfibdn3pbo6ol0kl5jlmvgd3qfbv35a', '127.0.0.1', 1502421451, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313434323b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('vsebr1mn45l139u7tkg8na6t8tg9880c', '127.0.0.1', 1502421565, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313534343b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d),
('vt04nn3t1r0s5mrc674houqnbsg7350u', '127.0.0.1', 1502351600, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323335313332313b69647c733a313a2239223b6e616d657c733a343a224a75616e223b75736572547970657c693a303b6c6f67696e7c623a313b636172745f636f6e74656e74737c613a333a7b733a31303a22636172745f746f74616c223b643a34383b733a31313a22746f74616c5f6974656d73223b643a333b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b613a393a7b733a323a226964223b733a313a2231223b733a343a226e616d65223b733a31373a22546f727461206465206d696c616e657361223b733a353a227072696365223b643a31363b733a333a22717479223b643a333b733a353a2273746f636b223b733a313a2234223b733a393a2275726c496d6167656e223b733a32373a2230376136652d68616d62757267756573612d646f626c652e6a7067223b733a31313a226465736372697063696f6e223b733a37383a22546f727461206465206d696c616e65736120646520706f6c6c6f2c20636f6e206c6563687567612c206a69746f6d6174652c2061677561636174652c206d61796f6e65736120792073616c73612e223b733a353a22726f776964223b733a33323a226334636134323338613062393233383230646363353039613666373538343962223b733a383a22737562746f74616c223b643a34383b7d7d),
('vus2qv4g6sd697qegtedv8bf98h46l81', '127.0.0.1', 1502421681, 0x5f5f63695f6c6173745f726567656e65726174657c693a313530323432313636393b637c693a313b5f5f63695f766172737c613a313a7b733a313a2263223b733a333a226e6577223b7d);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idCliente` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish2_ci NOT NULL,
  `apellido_P` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `apellido_M` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `Direccion_idDireccion` int(11) NOT NULL,
  `password` varchar(10) COLLATE utf8_spanish2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idCliente`, `nombre`, `apellido_P`, `apellido_M`, `email`, `Direccion_idDireccion`, `password`) VALUES
(7, 'Juan', 'Perdcdez', 'Hernandez', 'Juan@hotmail.com', 2, 'llakl'),
(9, 'Juan', 'Pez', 'Hernandez', 'Juan@hotmail.com', 2, 'jklñlknbjk'),
(10, 'Updtaed', 'Updated', 'Updated', 'Update@updated.com', 26, 'Updateswsw'),
(11, 'mariano', 'Robles', 'Nuñes', 'mariano@hotmail.com', 31, '12345678');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `colonia`
--

CREATE TABLE `colonia` (
  `idColonia` int(11) NOT NULL,
  `colonia` varchar(45) COLLATE utf8_spanish2_ci NOT NULL,
  `codigoPostal` varchar(45) COLLATE utf8_spanish2_ci NOT NULL,
  `Ciudad_idEstadoCiudad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `colonia`
--

INSERT INTO `colonia` (`idColonia`, `colonia`, `codigoPostal`, `Ciudad_idEstadoCiudad`) VALUES
(130, 'Independencia', '38600', 2),
(131, 'Acámbaro Centro', '38600', 2),
(132, 'Guadalupe Victoria', '38600', 2),
(133, 'Loma Bonita III', '38610', 2),
(134, 'Loma Bonita II', '38610', 2),
(135, 'Loma Bonita', '38610', 2),
(136, 'Real del Puente', '38612', 2),
(137, 'El Vergel', '38612', 2),
(138, 'El Mirador', '38612', 2),
(139, 'Villas del Sol', '38613', 2),
(140, 'La Vega del Socorro', '38613', 2),
(141, 'Las Flores', '38614', 2),
(142, 'Loma Dorada', '38615', 2),
(143, 'Rancho Grande', '38620', 2),
(144, 'El Derramadero', '38623', 2),
(145, 'Campamento FF.CC. (La Cochinilla)', '38624', 2),
(146, 'Los Laureles', '38625', 2),
(147, 'Guadalupe', '38630', 2),
(148, 'Universo', '38630', 2),
(149, 'Malayas II', '38630', 2),
(150, 'Benjamín Méndez', '38630', 2),
(151, 'Solidaridad Ferrocarrilera', '38630', 2),
(152, 'Girasoles', '38630', 2),
(153, 'Las Arboledas', '38640', 2),
(154, 'Valle de Acámbaro', '38642', 2),
(155, 'Chicoazen', '38650', 2),
(156, 'La Cantera', '38650', 2),
(157, 'Lomas Verdes', '38650', 2),
(158, 'Los Pinos', '38650', 2),
(159, 'Vista Hermosa', '38650', 2),
(160, '22 de Marzo', '38652', 2),
(161, 'La Cima', '38653', 2),
(162, 'El Capulín', '38653', 2),
(163, 'Vista Alegre', '38653', 2),
(164, 'La Soledad', '38654', 2),
(165, 'Catalina Gómez de Larrondo', '38660', 2),
(166, 'Camelinas', '38663', 2),
(167, 'Enrique Velasco Ibarra', '38664', 2),
(168, 'San Isidro 2', '38670', 2),
(169, 'San Isidro 1', '38670', 2),
(170, 'Paraíso Dorado', '38672', 2),
(171, 'Pedregal de los Álamos', '38673', 2),
(172, 'Los Sauces', '38674', 2),
(173, 'La Laja', '38675', 2),
(174, 'Everardo Morales', '38676', 2),
(175, '22 de Abril', '38676', 2),
(176, 'Las Malayas', '38679', 2),
(177, 'Emilio Carranza', '38680', 2),
(178, 'Bellavista', '38682', 2),
(179, 'Jacarandas', '38683', 2),
(180, 'Los Balcones', '38683', 2),
(181, 'Agrícola Oriental', '38683', 2),
(182, 'Luis Echeverría', '38683', 2),
(183, 'Las Águilas', '38683', 2),
(184, 'La Cańada', '38683', 2),
(185, 'Camelinas II', '38684', 2),
(186, 'Río Blanco', '38689', 2),
(187, 'San Pedro', '38730', 2),
(188, 'Parácuaro', '38730', 2),
(189, 'San Francisco', '38730', 2),
(190, 'Tres Marías', '38733', 2),
(191, 'Puerto Ferrer', '38733', 2),
(192, 'San Felipe', '38733', 2),
(193, 'Velázquez', '38733', 2),
(194, 'La Concepción', '38733', 2),
(195, 'Alfredo Soto', '38733', 2),
(196, 'Guadalupe Soto', '38733', 2),
(197, 'Miguel Uribe Arriola', '38733', 2),
(198, 'La Mesa de San José', '38734', 2),
(199, 'San José de las Pilas', '38734', 2),
(200, 'Moncloa', '38734', 2),
(201, 'San Luis de los Agustinos [Desarrollo Ecoturí', '38734', 2),
(202, 'Santa Rosa de Lima', '38734', 2),
(203, 'Emeterio Tovar', '38734', 2),
(204, 'El Astillero', '38734', 2),
(205, 'El Fresno Santa Rosa', '38734', 2),
(206, 'Huanumo (Santa Isabel)', '38734', 2),
(207, 'San Luis de los Agustinos', '38734', 2),
(208, 'La Chicharronera (Camino Blanco)', '38734', 2),
(209, 'El Piloncillo', '38734', 2),
(210, 'La Cajeta', '38735', 2),
(211, 'Monte Prieto', '38735', 2),
(212, 'Ninguno [Distribuidora Automotriz]', '38735', 2),
(213, 'Loreto (Teresa)', '38735', 2),
(214, 'Gil Rodríguez', '38735', 2),
(215, 'Las Palomas', '38735', 2),
(216, 'Los Rangeles', '38735', 2),
(217, 'Santa Fe', '38735', 2),
(218, 'Ampliación San Juan Viejo', '38735', 2),
(219, 'Los Coss (El Establo)', '38735', 2),
(220, 'Hacienda San Cristóbal', '38735', 2),
(221, 'Rodrigo Acevedo Cardona', '38735', 2),
(222, 'San Felipe de Jesús', '38735', 2),
(223, 'Juan Paredes', '38735', 2),
(224, 'Mauro Montoya Palacios', '38735', 2),
(225, 'San Juan Viejo', '38735', 2),
(226, 'El Zarpazo', '38735', 2),
(227, 'Ernesto A. Coss Tirado', '38735', 2),
(228, 'Ninguno [Escuela Tecnológica Agropecuaria]', '38735', 2),
(229, 'Hacienda de Guadalupe (El Rancho)', '38735', 2),
(230, 'Isaías Zúńiga (Colonia Ramírez)', '38735', 2),
(231, 'La Ceba', '38735', 2),
(232, 'La Lomita', '38735', 2),
(233, 'Granja la Herradura', '38736', 2),
(234, 'San José (Campo Hermoso)', '38736', 2),
(235, 'Dulces Nombres', '38736', 2),
(236, 'José López', '38736', 2),
(237, 'José Tirado (La Noria)', '38736', 2),
(238, 'Las Maravillas', '38736', 2),
(239, 'Los Sauces (La Troje)', '38736', 2),
(240, 'Severiano Tovar Martínez', '38736', 2),
(241, 'Jaral del Refugio', '38736', 2),
(242, 'Francisco Lara Guerrero', '38736', 2),
(243, 'Paredón Chiquito', '38736', 2),
(244, 'El Maguey', '38736', 2),
(245, 'La Granja', '38736', 2),
(246, 'San Juan Bosco (El Maguey)', '38736', 2),
(247, 'Víctor López Camacho', '38736', 2),
(248, 'San Ramón', '38736', 2),
(249, 'El Camino', '38736', 2),
(250, 'Ignacio Lara', '38736', 2),
(251, 'Loretito de las Casas', '38736', 2),
(252, 'La Trinidad', '38736', 2),
(253, 'La Carpa', '38737', 2),
(254, 'Corral de Piedras', '38737', 2),
(255, 'San Juan Rancho Viejo (Hacienda Nueva)', '38737', 2),
(256, 'La Providencia', '38737', 2),
(257, 'Los Ángeles (El Carrizo)', '38737', 2),
(258, 'Las Trancas (Los Milagros)', '38737', 2),
(259, 'El Bordo de Uribe', '38737', 2),
(260, 'El Tenorio', '38737', 2),
(261, 'El Fresno', '38737', 2),
(262, 'Providencia de San Agustin', '38740', 2),
(263, 'Inchamácuaro (Chamacuarillo)', '38740', 2),
(264, 'La Guadalupana', '38740', 2),
(265, 'Chamácuaro', '38740', 2),
(266, 'Obrajuelo', '38740', 2),
(267, 'San Agustín', '38740', 2),
(268, 'Nicolás Cárdenas', '38740', 2),
(269, 'El Espańol', '38740', 2),
(270, 'Hacienda el Coyote', '38740', 2),
(271, 'Ninguno [Centro de Capacitación Magisterial]', '38740', 2),
(272, 'La Charca (Los Altos)', '38740', 2),
(273, 'La Tinajita', '38743', 2),
(274, 'La Pila de los Árboles', '38743', 2),
(275, 'Las Moras', '38743', 2),
(276, 'Puerto de las Cabras', '38745', 2),
(277, 'San Rafael', '38746', 2),
(278, 'Pinos de Inchamácuaro', '38746', 2),
(279, 'San Diego de Alcalá (Hacienda de San Diego)', '38747', 2),
(280, 'La Lagunilla', '38747', 2),
(281, 'Los Órganos de Arriba', '38747', 2),
(282, 'Adolfo Ruiz Cortínez', '38747', 2),
(283, 'Las Partidas', '38747', 2),
(284, 'Nicasio Calderón', '38747', 2),
(285, 'Las Jícamas (La Purísima)', '38747', 2),
(286, 'El Gonzaleńo', '38747', 2),
(287, 'Los Órganos (Los Órganos de Abajo)', '38747', 2),
(288, 'Parada la Merced', '38747', 2),
(289, 'La Cajeta', '38747', 2),
(290, 'Chupícuaro (Nuevo Chupícuaro)', '38750', 2),
(291, 'Cereso Chupicuaro', '38753', 2),
(292, 'Ejido San Ramón', '38754', 2),
(293, 'Los Ángeles', '38754', 2),
(294, 'San José de Medina', '38754', 2),
(295, 'Nicolás Tapia (El Paredón)', '38754', 2),
(296, 'La Aurora', '38754', 2),
(297, 'Pablo Morales López Valdez', '38754', 2),
(298, 'San Cayetano', '38754', 2),
(299, 'El Tecolote', '38754', 2),
(300, 'La Purísima Concepción', '38754', 2),
(301, 'Pedro Ortiz Zárraga', '38754', 2),
(302, 'Piedras de Amolar', '38755', 2),
(303, 'Atanasio Torres Castro', '38755', 2),
(304, 'Santiaguillo', '38755', 2),
(305, 'Gaytán del Refugio', '38755', 2),
(306, 'Las Cruces', '38755', 2),
(307, 'El Sauz', '38755', 2),
(308, 'Loma Linda', '38755', 2),
(309, 'Los Árboles (Gúmaro Escobar)', '38755', 2),
(310, 'La Encarnación', '38756', 2),
(311, 'Rosendo Ortiz', '38757', 2),
(312, 'San Vicente Munguía', '38757', 2),
(313, 'La Crucita', '38757', 2),
(314, 'Presa Solís [Campamento]', '38758', 2),
(315, 'Ninguno [Deshidratadora]', '38758', 2),
(316, 'San Pedro (La Placa)', '38758', 2),
(317, 'Arroyo de la Luna', '38760', 2),
(318, 'Los Remedios', '38760', 2),
(319, 'La Loma', '38760', 2),
(320, 'Santa Inés', '38760', 2),
(321, 'San Nicolás de Tolentino', '38763', 2),
(322, 'Bertha Cruz Santos (El Puente)', '38763', 2),
(323, 'Arroyo Colorado', '38763', 2),
(324, 'La Cabańa', '38763', 2),
(325, 'La Divina Providencia', '38763', 2),
(326, 'San Marcos', '38763', 2),
(327, 'La Chivería', '38763', 2),
(328, 'San Francisco de la Piedad (La Codorniz)', '38763', 2),
(329, 'Agustín Rivas Ramírez', '38764', 2),
(330, 'La Cantera Dos', '38764', 2),
(331, 'La Joya', '38764', 2),
(332, 'La Laja', '38764', 2),
(333, 'San Antonio', '38764', 2),
(334, 'El Burladero', '38764', 2),
(335, 'La Verónica', '38764', 2),
(336, 'Colinas del Real', '38764', 2),
(337, 'Piedad Sánchez', '38764', 2),
(338, 'Chulavista', '38764', 2),
(339, 'El Paraíso', '38765', 2),
(340, 'La Trinidad', '38765', 2),
(341, 'Buenavista de Ballesteros (El Zopilote)', '38765', 2),
(342, 'La Florida', '38765', 2),
(343, 'Bertha Rivas López', '38765', 2),
(344, 'Panteón', '38765', 2),
(345, 'Solís', '38765', 2),
(346, 'Hacienda Real de Acámbaro', '38765', 2),
(347, 'Juan José Velázquez Torres', '38765', 2),
(348, 'Santa Elena', '38765', 2),
(349, 'La Trinidad Vieja', '38765', 2),
(350, 'José Jesús Nieves Ramírez', '38765', 2),
(351, 'Agua Caliente', '38765', 2),
(352, 'Valle Cuauhtémoc', '38765', 2),
(353, 'San Miguel', '38766', 2),
(354, 'San Miguel del Puerto', '38766', 2),
(355, 'El Negrito (La Barranca)', '38767', 2),
(356, 'La Presa de Santa Inés', '38767', 2),
(357, 'El Rodeo', '38767', 2),
(358, 'Iramuco', '38770', 2),
(359, 'San Juan (El Zapote)', '38770', 2),
(360, 'La Ortiga', '38773', 2),
(361, 'La Cańada', '38773', 2),
(362, 'El Cerrito (El Palillo)', '38773', 2),
(363, 'Isla Cerro Grande (Isla Chanaco)', '38773', 2),
(364, 'Buenavista (Los Moscos)', '38773', 2),
(365, 'Parcialidad', '38774', 2),
(366, 'San Isidro', '38774', 2),
(367, 'Salvador Hernández', '38774', 2),
(368, 'La Puerta del Monte', '38775', 2),
(369, 'El Cuije', '38775', 2),
(370, 'Cútaro', '38776', 2),
(371, 'San José de las Pilas', '38777', 2),
(372, 'Andocutín', '38780', 2),
(373, 'La Merced', '38783', 2),
(374, 'San Francisco Rancho Viejo', '38783', 2),
(375, 'David Espitia Guijón', '38783', 2),
(376, 'Guadalupe Pérez López', '38783', 2),
(377, 'Palo Blanco del Refugio', '38783', 2),
(378, 'El Romero', '38783', 2),
(379, 'Los Fresnos', '38783', 2),
(380, 'Amparo Baltazar Carmona (Pozo Uno)', '38783', 2),
(381, 'El Ranchito', '38783', 2),
(382, 'La Purísima', '38783', 2),
(383, 'San Juan Jaripeo', '38783', 2),
(384, 'El Puente del Carrizo (Parada del Carrizo)', '38783', 2),
(385, 'Pantaleón', '38784', 2),
(386, 'El Moral', '38784', 2),
(387, 'Hilario Torres Patińo', '38784', 2),
(388, 'La Soledad', '38784', 2),
(389, 'Santa Clara', '38784', 2),
(390, 'Seis de Abril', '38784', 2),
(391, 'México Nuevo', '38785', 2),
(392, 'San Mateo Tócuaro', '38785', 2),
(393, 'Los Mezquites', '38785', 2),
(394, 'San José de La Peńa', '38785', 2),
(395, 'Víctor Ávila Ávalos', '38785', 2),
(396, 'Piedras Chinas', '38785', 2),
(397, 'Sociedad Emiliano Zapata', '38785', 2),
(398, 'Los Desmontes', '38786', 2),
(399, 'La Mora (La Chumbacua)', '38786', 2),
(400, 'Las Antenas', '38786', 2),
(401, 'Las Malayas (La Providencia)', '38787', 2),
(402, 'Rancho Luna', '38787', 2),
(403, 'San Diego [Forrajera]', '38787', 2),
(404, 'Santa María', '38787', 2),
(405, 'Gas Viejo', '38787', 2),
(406, 'Gloria Sosa', '38787', 2),
(407, 'Jesús Ruiz Ruiz (San Miguel)', '38787', 2),
(408, 'Arroyo del Agua Clarita (Pozo Progreso Uno)', '38787', 2),
(409, 'Eduardo Morales Herrejón', '38787', 2),
(410, 'Hospital General', '38787', 2),
(411, 'Héctor López', '38787', 2),
(412, 'Alejandro Rangel Amado', '38787', 2),
(413, 'Granja Gorgorita', '38787', 2),
(414, 'Providencia', '38787', 2),
(415, 'Rancho Unión (Ángel Núńez)', '38787', 2),
(416, 'San Lorenzo', '38787', 2),
(417, 'Granja el Refugio', '38787', 2),
(418, 'La Esperanza (Hilario Hernández)', '38787', 2),
(419, 'Francisco Solache (Rancho Cantarranas)', '38787', 2),
(420, 'La Granja (Rancho la Alegría)', '38787', 2),
(421, 'Las Compuertas', '38787', 2),
(422, 'Llano del Derramadero', '38787', 2),
(423, 'Los Álamos', '38787', 2),
(424, 'Montana', '38787', 2),
(425, 'El Balastre (La Loma del Zapote)', '38787', 2),
(426, 'La Escondida', '38787', 2),
(427, 'La Granja Hernández', '38787', 2),
(428, 'Los Pinos', '38787', 2),
(429, 'Puente de Fierro [Invernadero]', '38787', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contacto`
--

CREATE TABLE `contacto` (
  `idContacto` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(200) NOT NULL,
  `comentario` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `contacto`
--

INSERT INTO `contacto` (`idContacto`, `nombre`, `email`, `comentario`) VALUES
(1, 'mariano Robles Nuñes', 'mariano@hotmail.com', 'jdledjwdjewldjej'),
(2, 'mariano Robles Nuñes', 'mariano@hotmail.com', 'jdledjwdjewldjej');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallepedido`
--

CREATE TABLE `detallepedido` (
  `Producto_idProducto` int(11) NOT NULL,
  `cantidad` double(9,2) NOT NULL,
  `precio` double(9,2) NOT NULL,
  `subtotal` double(9,2) NOT NULL,
  `Pedidos_idPedidos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `detallepedido`
--

INSERT INTO `detallepedido` (`Producto_idProducto`, `cantidad`, `precio`, `subtotal`, `Pedidos_idPedidos`) VALUES
(1, 1.00, 16.00, 16.00, 3),
(1, 2.00, 16.00, 32.00, 4),
(1, 3.00, 16.00, 48.00, 5),
(1, 3.00, 16.00, 48.00, 6),
(1, 3.00, 16.00, 48.00, 7),
(1, 3.00, 16.00, 48.00, 8),
(1, 3.00, 16.00, 48.00, 9),
(1, 3.00, 16.00, 48.00, 10),
(1, 3.00, 16.00, 48.00, 11),
(1, 1.00, 16.00, 16.00, 12),
(2, 1.00, 7.50, 7.50, 4),
(2, 2.00, 7.50, 15.00, 5),
(2, 2.00, 7.50, 15.00, 6),
(2, 2.00, 7.50, 15.00, 7),
(2, 2.00, 7.50, 15.00, 8),
(2, 2.00, 7.50, 15.00, 9),
(2, 2.00, 7.50, 15.00, 10),
(2, 2.00, 7.50, 15.00, 11),
(2, 1.00, 7.50, 7.50, 12),
(3, 1.00, 7.00, 7.00, 13);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direccion`
--

CREATE TABLE `direccion` (
  `idDireccion` int(11) NOT NULL,
  `calle_dir` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `no_dir` varchar(45) COLLATE utf8_spanish2_ci NOT NULL,
  `Colonia_idColonia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `direccion`
--

INSERT INTO `direccion` (`idDireccion`, `calle_dir`, `no_dir`, `Colonia_idColonia`) VALUES
(2, 'dwda', 'wdwdw', 136),
(24, 'actualizada', 'sqsq', 133),
(25, 'Udated', 'Updated', 135),
(26, 'Udated', 'Updated', 131),
(31, 'hidalgo', '2345-B', 131);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

CREATE TABLE `empleado` (
  `idEmpleado` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish2_ci NOT NULL,
  `apellido_P` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `apellido_M` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_spanish2_ci NOT NULL,
  `Direccion_idDireccion` int(11) NOT NULL,
  `password` varchar(64) COLLATE utf8_spanish2_ci NOT NULL,
  `privi` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`idEmpleado`, `nombre`, `apellido_P`, `apellido_M`, `email`, `Direccion_idDireccion`, `password`, `privi`) VALUES
(1, 'manuela', 'Lopez', 'Rojas', 'emple@em.com', 2, '1234', 0),
(2, 'manuec', 'Lopez', 'Rojas', 'empleado@em.com', 2, '', 0),
(8, 'dadsd', 'dw', 'wdw', 'wdw@dhbdsh.com', 2, 'cccsscs', 1),
(14, 'csdcd', 'njij', 'ijijij', 'jiijiji', 2, 'scsscssdcds', 1),
(15, 'Alejandro', 'Onofre', 'Cornejo', 'ajandro43@hotmail.com', 2, '12345678', 1),
(16, 'wdls', 'llkdlwk', 'lkdl', 'ldwdlw@lfl.com', 24, 'wddww', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `idEstado` int(11) NOT NULL,
  `estado` varchar(45) COLLATE utf8_spanish2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`idEstado`, `estado`) VALUES
(1, 'Guanajuato');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marca`
--

CREATE TABLE `marca` (
  `idMarca` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `marca`
--

INSERT INTO `marca` (`idMarca`, `nombre`) VALUES
(2, 'Coca-cola'),
(1, 'SONRIX');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ofertas`
--

CREATE TABLE `ofertas` (
  `idGaleria` int(11) NOT NULL,
  `urlImagen` varchar(500) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `titulo` varchar(100) CHARACTER SET utf8 DEFAULT '0',
  `texto` varchar(500) CHARACTER SET utf8 DEFAULT '0',
  `fecha` date DEFAULT '0000-00-00',
  `hora` time DEFAULT NULL,
  `botonText` varchar(20) COLLATE utf32_spanish2_ci NOT NULL DEFAULT 'Saber más',
  `Empleado_idEmpleado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_spanish2_ci;

--
-- Volcado de datos para la tabla `ofertas`
--

INSERT INTO `ofertas` (`idGaleria`, `urlImagen`, `titulo`, `texto`, `fecha`, `hora`, `botonText`, `Empleado_idEmpleado`) VALUES
(5, '03591-fondos-de-dragones.jpg', 'Productos', 'tenemos un amplio surtido de productos que satisfacen las necesidades básicas del hogar', '2017-08-10', '07:43:25', 'Saber más', 1),
(6, 't2.jpg', 'Prueba nuestros productos', 'Te invitamos a visitarnos y probar nuestros productos', '2016-12-02', '17:18:06', 'Saber más', 2),
(7, 't3.jpg', 'Ingredientes frescos', 'Los ingredientes usados en la elaboración de nuestros productos son frescos', '2016-12-02', '17:19:37', 'Saber más', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `idPedidos` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `total` int(11) NOT NULL,
  `estatus` tinyint(1) NOT NULL,
  `Cliente_idCliente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`idPedidos`, `fecha`, `total`, `estatus`, `Cliente_idCliente`) VALUES
(3, '0000-00-00', 16, 1, 10),
(4, '0000-00-00', 40, 2, 10),
(5, '0000-00-00', 63, 0, 10),
(6, '0000-00-00', 63, 0, 10),
(7, '0000-00-00', 63, 2, 10),
(8, '0000-00-00', 63, 0, 10),
(9, '0000-00-00', 63, 1, 10),
(10, '0000-00-00', 63, 0, 10),
(11, '0000-00-00', 63, 0, 10),
(12, '0000-00-00', 24, 2, 9),
(13, '2017-08-10', 7, 0, 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idProducto` int(11) NOT NULL,
  `urlImagen` varchar(200) COLLATE utf8_spanish2_ci NOT NULL,
  `nombre` varchar(150) COLLATE utf8_spanish2_ci NOT NULL,
  `descripcion` varchar(300) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `precio` float NOT NULL,
  `stock` float NOT NULL,
  `Marca_idMarca` int(11) NOT NULL,
  `Categoria_idCategoria` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idProducto`, `urlImagen`, `nombre`, `descripcion`, `precio`, `stock`, `Marca_idMarca`, `Categoria_idCategoria`) VALUES
(1, '07a6e-hamburguesa-doble.jpg', 'Torta de milanesa', 'Torta de milanesa de pollo, con lechuga, jitomate, aguacate, mayonesa y salsa.', 16, 4, 1, 1),
(2, '42bb1-_mg_5405.jpg', 'Refresco', '600ml', 7.5, 14, 1, 1),
(3, '49e61-hot-dog-sr-dog.jpg', 'Agua', 'Agua natural de 600ml', 7, 14, 1, 1),
(4, '891da-436471.jpg', 'jamón', '1 kg de jamon de pavo', 10, 50, 1, 1),
(5, 'd4c97-wallhaven-245159.jpg', 'Producto prue', 'prueba de producto', 1233, 112, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `slider`
--

CREATE TABLE `slider` (
  `idImagen` int(11) NOT NULL,
  `urlImagen` varchar(500) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `texto` varchar(200) CHARACTER SET utf8 DEFAULT '0',
  `titulo` varchar(200) CHARACTER SET utf8 NOT NULL,
  `botonText` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT 'Saber más',
  `Empleado_idEmpleado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `slider`
--

INSERT INTO `slider` (`idImagen`, `urlImagen`, `texto`, `titulo`, `botonText`, `Empleado_idEmpleado`) VALUES
(1, 'uploads/slider/fondop.jpg', 'Conoce los productos que te ofrecemos', 'Somos EDDY BURGUER', 'Saber más', 0),
(2, 'uploads/slider/torta.jpg', 'Productos de calidad.', 'Variedad', 'Saber más', 0),
(3, 'uploads/slider/torta2.jpg', 'El tamaño justo para satisfacer tu hambre.', 'Precio justo', 'Saber más', 0),
(4, 'uploads/slider/torta3.jpg', 'Variedad en nuestros productos.', 'Conócenos', 'Saber más', 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`idCategoria`);

--
-- Indices de la tabla `ciudad`
--
ALTER TABLE `ciudad`
  ADD PRIMARY KEY (`idEstadoCiudad`,`Estado_idEstado`),
  ADD KEY `fk_Ciudad_Estado1_idx` (`Estado_idEstado`);

--
-- Indices de la tabla `ci_sessions`
--
ALTER TABLE `ci_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ci_sessions_timestamp` (`timestamp`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idCliente`,`Direccion_idDireccion`),
  ADD KEY `fk_Cliente_Direccion1_idx` (`Direccion_idDireccion`);

--
-- Indices de la tabla `colonia`
--
ALTER TABLE `colonia`
  ADD PRIMARY KEY (`idColonia`,`Ciudad_idEstadoCiudad`),
  ADD KEY `fk_Colonia_Ciudad1_idx` (`Ciudad_idEstadoCiudad`);

--
-- Indices de la tabla `contacto`
--
ALTER TABLE `contacto`
  ADD PRIMARY KEY (`idContacto`);

--
-- Indices de la tabla `detallepedido`
--
ALTER TABLE `detallepedido`
  ADD PRIMARY KEY (`Producto_idProducto`,`Pedidos_idPedidos`),
  ADD KEY `fk_Producto_has_Pedidos_Pedidos1_idx` (`Pedidos_idPedidos`),
  ADD KEY `fk_Producto_has_Pedidos_Producto1_idx` (`Producto_idProducto`);

--
-- Indices de la tabla `direccion`
--
ALTER TABLE `direccion`
  ADD PRIMARY KEY (`idDireccion`,`Colonia_idColonia`),
  ADD KEY `fk_Direccion_Colonia1_idx` (`Colonia_idColonia`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`idEmpleado`,`Direccion_idDireccion`),
  ADD KEY `fk_Empleado_Direccion1_idx` (`Direccion_idDireccion`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`idEstado`);

--
-- Indices de la tabla `marca`
--
ALTER TABLE `marca`
  ADD PRIMARY KEY (`idMarca`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`);

--
-- Indices de la tabla `ofertas`
--
ALTER TABLE `ofertas`
  ADD PRIMARY KEY (`idGaleria`,`Empleado_idEmpleado`),
  ADD KEY `fk_ofertas_empleado` (`Empleado_idEmpleado`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`idPedidos`,`Cliente_idCliente`),
  ADD KEY `fk_Pedidos_Cliente1_idx` (`Cliente_idCliente`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idProducto`,`Categoria_idCategoria`,`Marca_idMarca`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  ADD KEY `fk_Producto_Marca_idx` (`Marca_idMarca`),
  ADD KEY `fk_Producto_Categoria1_idx` (`Categoria_idCategoria`);

--
-- Indices de la tabla `slider`
--
ALTER TABLE `slider`
  ADD PRIMARY KEY (`idImagen`,`Empleado_idEmpleado`),
  ADD KEY `fk_slider_empleado` (`Empleado_idEmpleado`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `idCategoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `ciudad`
--
ALTER TABLE `ciudad`
  MODIFY `idEstadoCiudad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT de la tabla `colonia`
--
ALTER TABLE `colonia`
  MODIFY `idColonia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=430;
--
-- AUTO_INCREMENT de la tabla `contacto`
--
ALTER TABLE `contacto`
  MODIFY `idContacto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `direccion`
--
ALTER TABLE `direccion`
  MODIFY `idDireccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;
--
-- AUTO_INCREMENT de la tabla `empleado`
--
ALTER TABLE `empleado`
  MODIFY `idEmpleado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT de la tabla `estado`
--
ALTER TABLE `estado`
  MODIFY `idEstado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `marca`
--
ALTER TABLE `marca`
  MODIFY `idMarca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `ofertas`
--
ALTER TABLE `ofertas`
  MODIFY `idGaleria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `idPedidos` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idProducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `slider`
--
ALTER TABLE `slider`
  MODIFY `idImagen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ciudad`
--
ALTER TABLE `ciudad`
  ADD CONSTRAINT `fk_Ciudad_Estado1` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `fk_Cliente_Direccion1` FOREIGN KEY (`Direccion_idDireccion`) REFERENCES `direccion` (`idDireccion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `colonia`
--
ALTER TABLE `colonia`
  ADD CONSTRAINT `fk_Colonia_Ciudad1` FOREIGN KEY (`Ciudad_idEstadoCiudad`) REFERENCES `ciudad` (`idEstadoCiudad`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detallepedido`
--
ALTER TABLE `detallepedido`
  ADD CONSTRAINT `fk_Producto_has_Pedidos_Pedidos1` FOREIGN KEY (`Pedidos_idPedidos`) REFERENCES `pedidos` (`idPedidos`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Producto_has_Pedidos_Producto1` FOREIGN KEY (`Producto_idProducto`) REFERENCES `producto` (`idProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `direccion`
--
ALTER TABLE `direccion`
  ADD CONSTRAINT `fk_Direccion_Colonia1` FOREIGN KEY (`Colonia_idColonia`) REFERENCES `colonia` (`idColonia`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD CONSTRAINT `fk_Empleado_Direccion1` FOREIGN KEY (`Direccion_idDireccion`) REFERENCES `direccion` (`idDireccion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ofertas`
--
ALTER TABLE `ofertas`
  ADD CONSTRAINT `fk_ofertas_empleado` FOREIGN KEY (`Empleado_idEmpleado`) REFERENCES `empleado` (`idEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_Pedidos_Cliente1` FOREIGN KEY (`Cliente_idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `fk_Producto_Categoria1` FOREIGN KEY (`Categoria_idCategoria`) REFERENCES `categoria` (`idCategoria`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Producto_Marca` FOREIGN KEY (`Marca_idMarca`) REFERENCES `marca` (`idMarca`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `slider`
--
ALTER TABLE `slider`
  ADD CONSTRAINT `fk_slider_empleado` FOREIGN KEY (`Empleado_idEmpleado`) REFERENCES `empleado` (`idEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
