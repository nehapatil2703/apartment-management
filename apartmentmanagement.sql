if not exists (select * from sys.databases where name= 'apartmentmanagement')
    create DATABASE apartmentmanagement
go

use apartmentmanagement
go


--Down
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='fk_a_building_name')
ALTER TABLE apartment
    DROP CONSTRAINT fk_a_building_name
alter table tenant
    drop CONSTRAINT pk_t_tenant_id 
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='pk_t_tenant_id')
alter table tenant
    drop CONSTRAINT u_t_tenant_id
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='u_t_tenant_id')
alter table payment
    drop CONSTRAINT pk_p_payment_id 
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='pk_p_payment_id')
alter table payment
    drop CONSTRAINT u_p_payment_id
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='u_p_payment_id')
alter table owner
    drop CONSTRAINT pk_o_owner_id 
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='pk_o_owner_id')
alter table owner
    drop CONSTRAINT u_o_owner_id
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='u_o_owner_id')
alter table building
    drop CONSTRAINT pk_b_building_name 
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='pk_b_building_name')
alter table building
    drop CONSTRAINT u_b_building_name
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='u_b_building_name')
alter table apartment
    drop CONSTRAINT pk_a_apartment_id 
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='pk_a_apartment_id')
alter table apartment
    drop CONSTRAINT u_a_apartment_id
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME='u_a_apartment_id')

--Down-UP
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='building')
DROP TABLE building
GO
CREATE TABLE building (
  b_building_id int NOT NULL,
  b_building_name varchar(50) NOT NULL,
  b_address varchar(50) NOT NULL,
  b_owner_name varchar(150) NOT NULL,
  b_floors varchar(15) NOT NULL,
  CONSTRAINT pk_b_building_name primary key(b_building_name),
  CONSTRAINT u_b_building_name UNIQUE(b_building_name)
) 

GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='apartment')
DROP TABLE apartment
GO
CREATE TABLE apartment (
  a_apartment_id int NOT NULL,
  a_building_name varchar(50) NOT NULL,
  a_flat_number varchar(50) NOT NULL,
  a_tenant_name varchar(150) NOT NULL,
  a_rent int NOT NULL DEFAULT '0',
  a_start_date date NOT NULL,
  CONSTRAINT pk_a_apartment_id primary key(a_apartment_id),
  CONSTRAINT u_a_apartment_id UNIQUE(a_apartment_id)
) 
alter table apartment
add CONSTRAINT fk_a_building_name FOREIGN key (a_building_name) REFERENCES building(b_building_name)
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='owner')
DROP TABLE owner
GO
CREATE TABLE owner (
  o_owner_id int NOT NULL,
  o_owner_name varchar(50) NOT NULL,
  o_owner_contact varchar(100) NOT NULL,
  o_owner_address varchar(50) NOT NULL,
  CONSTRAINT pk_o_owner_id primary key(o_owner_id),
  CONSTRAINT u_o_owner_id UNIQUE(o_owner_id)
) 

GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='payment')
DROP TABLE payment
GO
CREATE TABLE payment (
  p_payment_id int NOT NULL,
  p_date date DEFAULT NULL,
  p_building_name varchar(50) NOT NULL,
  p_tenant_name varchar(50) NOT NULL,
  p_flat_num varchar(15) NOT NULL,
  p_paid_rent int NOT NULL DEFAULT '0',
  CONSTRAINT pk_p_payment_id primary key(p_payment_id),
  CONSTRAINT u_p_payment_id UNIQUE(p_payment_id)
) 

GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='tenant')
DROP TABLE tenant
GO
CREATE TABLE tenant (
  t_tenant_id int NOT NULL,
  t_tenant_name varchar(50) NOT NULL,
  t_tenant_contact varchar(100) NOT NULL,
  t_tenant_address varchar(50) NOT NULL,
  CONSTRAINT pk_t_tenant_id primary key(t_tenant_id),
  CONSTRAINT u_t_tenant_id UNIQUE(t_tenant_id)
) 

GO
INSERT INTO building (b_building_id, b_building_name, b_address, b_owner_name,b_floors) VALUES
(1, 'MCS Complex', 'street road ', 'john', '05'),
(2, 'Lyra', 'Lancaster Ave', 'neha', '04'),
(3, 'EOS', 'Livingston Ave', 'lekhit', '05'),
(4, 'Park Towera', 'Comstock Place', 'abhijit', '03'),
(5, 'View 34', 'University Place', 'Nia', '06');
GO

INSERT INTO apartment  
VALUES
(2, 'MCS Complex', '101', 'john', 10000, '2022-09-04'),
(3, 'MCS Complex', '102', 'Smith', 5000, '2022-09-06'),
(1, 'Lyra', '301', 'neha', 2000, '2023-01-01'),
(5, 'EOS', '401', 'lekhit', 3000, '2021-09-06'),
(4, 'View 34', '202', 'Nia', 5000, '2022-09-06')
GO

INSERT INTO owner (o_owner_id, o_owner_name, o_owner_contact, o_owner_address) VALUES
(1, 'bob', '123456789', 'stadium main road'),
(2, 'dan', '123546789', 'sumner ave'),
(3, 'bob', '123456789', 'stadium main road'),
(4, 'dan', '123546789', 'sumner ave'),
(5, 'Jay', '123456797', 'east syracuse');
GO

INSERT INTO payment (p_payment_id, p_date, p_building_name, p_tenant_name, p_flat_num, p_paid_rent) VALUES
(1, '2018-09-04', 'MCS Complex', 'john', '101', 10000),
(2, '2023-01-01', 'Lyra', 'neha', '301', 4000),
(3, '2022-09-06', 'View 34', 'Nia', '202', 10000);

GO

INSERT INTO tenant (t_tenant_id,t_tenant_name, t_tenant_contact, t_tenant_address) VALUES
(1, 'john', '123456789', 'street road texas');
GO

if exists(SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME='building_owner_tenant')
drop view building_owner_tenant
GO
CREATE VIEW building_owner_tenant AS
SELECT b.b_building_id as b_id, b.b_building_name as b_name, b.b_owner_name as o_name, t.t_tenant_id as t_id, t.t_tenant_name as t_name
FROM building as b
JOIN owner as o ON b.b_owner_name = o.o_owner_name
JOIN tenant as t ON b.b_building_name = t.t_tenant_address;
GO

drop procedure if exists update_payment
Go
CREATE PROCEDURE update_payment
    @payment_id int,
    @date date,
    @building_name varchar(50),
    @tenant_name varchar(50),
    @flat_num varchar(15),
    @paid_rent int
AS
BEGIN
    UPDATE payment
    SET 
        p_payment_id = @payment_id,
        p_date = @date,
        p_building_name = @building_name,
        p_tenant_name = @tenant_name,
        p_flat_num = @flat_num,
        p_paid_rent = @paid_rent
    WHERE p_payment_id = @payment_id
END
GO

select * from payment
exec dbo.update_payment 3, '2022-09-06', 'View 34', 'Nia', '202', 11000;



select * from apartment
select * from building
select * from owner
select * from payment
select * from tenant
GO
