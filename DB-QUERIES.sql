create database santo_tomas;
drop database santo_tomas;
use santo_tomas;



-- ------------------------------------- MODIFY DB FOR EXECUTE AFTER ER --------------------------------------- --

ALTER TABLE COMPRA AUTO_INCREMENT = 1500;
ALTER TABLE BITACORA AUTO_INCREMENT = 10500;
ALTER TABLE CONTROL_COMPRA AUTO_INCREMENT = 2500;
ALTER TABLE SUCURSAL AUTO_INCREMENT = 1001;
ALTER TABLE DET_CAJA auto_increment = 2500;
ALTER TABLE PAGO_CLIENTE auto_increment = 1100;

SET lc_time_names = 'es_ES'; 

SHOW VARIABLES LIKE "%version%"; 

-- ALTER TABLE CUENTA_POR_COBRAR_CLIENTE AUTO_INCREMENT = 2500;
 -- ALTER TABLE TRASLADOS AUTO_INCREMENT = 2500;
 -- ALTER TABLE PRODUCTOS_TRASLADO AUTO_INCREMENT = 2500;
-- alter table cuenta_por_cobrar_cliente drop column saldo_disponible;

 	
--  ALTER TABLE MERCADERIA_PRESENTACIONES ADD utilidad_3 double default 0 AFTER utilidad_2;

	
--  ALTER TABLE CONFIGURACION_SISTEMA ADD factura_defecto BOOL AFTER ultimo_inicio;
  
--  ALTER TABLE CLIENTE ADD credito_disponible FLOAT DEFAULT 0 AFTER limite_credito;
--  ALTER TABLE DET_FACTURA ADD descripcion_detalle VARCHAR(200) AFTER id_stock;
--  ALTER TABLE DET_FACTURA ADD subtotal_detalle FLOAT AFTER descuento_det_factura;
--  ALTER TABLE PROVEEDOR ADD fecha_ingreso DATETIME DEFAULT NOW() AFTER telefono_proveedor;
--  ALTER TABLE CONFIGURACION_SISTEMA ADD impresion_defecto BOOL AFTER caja;
--  ALTER TABLE CONFIGURACION_SISTEMA ADD impresora VARCHAR(150) AFTER impresion_defecto;
--  ALTER TABLE CONFIGURACION_SISTEMA ADD copias INT AFTER impresora;
--  ALTER TABLE CONFIGURACION_SISTEMA ADD vista BOOL DEFAULT TRUE AFTER copias;
  

--  ALTER TABLE PRIVILEGIOS_USUARIO ADD kardex BOOL DEFAULT TRUE AFTER traslado_mercaderia;
    
    
-- ---------------------------- INSERT STATEMENTS FOR INDEPENDENCES  TABLES -------------------------------------------- -- 


-- ROL
INSERT INTO ROL VALUES ('ADMINISTRADOR',TRUE);
INSERT INTO ROL VALUES ('VENDEDOR', FALSE);
INSERT INTO ROL VALUES ('CAJERO', TRUE);
INSERT INTO ROL VALUES ('DATA BASE ADMIN', TRUE);
INSERT INTO ROL VALUES ('ROOT', TRUE);

-- UPDATE USUARIO SET ID_ROL = 'ROOT' WHERE ID_USUARIO = 'riveraedgar';



-- USUARIOS
INSERT INTO USUARIO VALUES ('riveraedgar','ADMINISTRADOR','1195','Edgar Rivera','riveraambrocio.edgar@gmail.com',TRUE,0,NOW(),TRUE);
INSERT INTO PRIVILEGIOS_USUARIO VALUES ('riveraedgar','ADMINISTRADOR',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,TRUE);
INSERT INTO USUARIO VALUES ('javiman','DATA BASE ADMIN','3256','Javier Batzibal','javierbatzibal@gmail.com',TRUE,0,NOW(),TRUE);
INSERT INTO PRIVILEGIOS_USUARIO VALUES ('javiman','DATA BASE ADMIN',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,TRUE);


-- TIPO_CLIENTE
INSERT INTO TIPO_CLIENTE VALUES (1001,'CREDITO',TRUE);
INSERT INTO TIPO_CLIENTE VALUES (NULL,'EFECTIVO',TRUE);


-- CLIENTES
INSERT INTO CLIENTE VALUES ('1648999-3',1001,'Edgar Enrique','Rivera Giron','6.ta Calle A Zona 6 Mixco','48636105',3000,3000,31,NOW(),TRUE);
INSERT INTO CLIENTE VALUES ('9956816-0',1002,'Edgar Enrique','Rivera Ambrocio','6.ta Calle A Zona 6 Mixco','30446633',0,0,0,NOW(),TRUE);
INSERT INTO CLIENTE VALUES ('C/F',1002,'Consumidor','Final','Ciudad','N/A',0,0,0,NOW(),TRUE);



-- ------ PROVEEDORES -------------
INSERT INTO PROVEEDOR VALUES (111,'N/A',' ',' ',' ',NOW(),TRUE);
INSERT INTO PROVEEDOR VALUES ('15C48','QWERTY','qwerty@gmail.com ','Zona 14 Las Limas','4857845',NOW(), TRUE);
INSERT INTO PROVEEDOR VALUES ('150D8','PROVEEDOR ALIENTICIO','paliment@gmail.com ','Ciudad Capital ','30446633',NOW(), TRUE);

-- -------------- MARCA ----------- --




-- ---- SUCURSALES
INSERT INTO TIPO_SUCURSAL VALUES (NULL,'CENTRAL',TRUE);
INSERT INTO TIPO_SUCURSAL VALUES (NULL,'SUCURSAL',TRUE);


INSERT INTO SUCURSAL VALUES(1001,1,'SANTO TOMAS - I','Central Tecpan','22457884',TRUE);
INSERT INTO SUCURSAL VALUES(1002,2,'SANTO TOMAS - II','24 av. 12-75','36251425',TRUE);




-- --- INGRESO DE CLASIFICACION MERCADERIA ----------------
INSERT INTO  CLASIFICACION_MERCADERIA VALUES (1,'ABARROTES');
INSERT INTO  CLASIFICACION_MERCADERIA VALUES (2,'ESPECIAS');


INSERT INTO TIPO_CAMBIO VALUES ('QUETZALES',1, true);
INSERT INTO TIPO_CAMBIO VALUES ('DOLARES',7.50,true);
INSERT INTO TIPO_CAMBIO VALUES ('MXN',3,true);


INSERT INTO CONFIGURACION_SISTEMA VALUES (111,'QUETZALES',FALSE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE, ' ', 1, TRUE);


SELECT * FROM CLASIFICACION_MERCADERIA;

 -- CAMBIOS PARA EL REGISTRO DE TRALADOS--
 /*
CREATE TABLE IF NOT EXISTS `santo_tomas`.`TRASLADOS` (
  `id_traslado` INT NOT NULL,
  `id_usuario` VARCHAR(25) NOT NULL,
  `traslado_de_sucursal` INT NOT NULL,
  `traslado_a_sucursal` INT NOT NULL,
  `fecha_traslado` DATETIME NULL,
  `numero_productos` INT NULL,
  `estado_traslado` TINYINT(1) NULL,
  `estado_tupla` TINYINT(1) NULL,
  PRIMARY KEY (`id_traslado`),
  INDEX `fk_TRASLADOS_USUARIO1_idx` (`id_usuario` ASC),
  INDEX `fk_TRASLADOS_SUCURSAL1_idx` (`traslado_de_sucursal` ASC),
  INDEX `fk_TRASLADOS_SUCURSAL2_idx` (`traslado_a_sucursal` ASC),
  CONSTRAINT `fk_TRASLADOS_USUARIO1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `santo_tomas`.`USUARIO` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_TRASLADOS_SUCURSAL1`
    FOREIGN KEY (`traslado_de_sucursal`)
    REFERENCES `santo_tomas`.`SUCURSAL` (`id_sucursal`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_TRASLADOS_SUCURSAL2`
    FOREIGN KEY (`traslado_a_sucursal`)
    REFERENCES `santo_tomas`.`SUCURSAL` (`id_sucursal`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `santo_tomas`.`PRODUCTOS_TRASLADO` (
  `id_productos_traslado` INT NOT NULL AUTO_INCREMENT,
  `id_traslado` INT NOT NULL,
  `id_mercaderia` VARCHAR(45) NOT NULL,
  `id_sucursal` INT NOT NULL,
  `unidades_trasladadas` FLOAT NULL,
  INDEX `fk_PRODUCTOS_TRASLADO_TRASLADOS1_idx` (`id_traslado` ASC),
  PRIMARY KEY (`id_productos_traslado`),
  INDEX `fk_PRODUCTOS_TRASLADO_MERCADERIA1_idx` (`id_mercaderia` ASC, `id_sucursal` ASC),
  CONSTRAINT `fk_PRODUCTOS_TRASLADO_TRASLADOS1`
    FOREIGN KEY (`id_traslado`)
    REFERENCES `santo_tomas`.`TRASLADOS` (`id_traslado`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_PRODUCTOS_TRASLADO_MERCADERIA1`
    FOREIGN KEY (`id_mercaderia` , `id_sucursal`)
    REFERENCES `santo_tomas`.`MERCADERIA` (`id_mercaderia` , `id_sucursal`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;*/

/*ALTER TABLE COMPRA ADD id_proveedor VARCHAR(45) NOT NULL AFTER id_compra;

UPDATE COMPRA SET id_proveedor = 111; 
ALTER TABLE COMPRA ADD CONSTRAINT fk_proveedor_compra_1 FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor);*/

