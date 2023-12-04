FUNCTION objects_print 
   RETURN VEHICLE_TAB 
IS
   -- l_count PLS_INTEGER;
   ADS VEHICLE_TAB := VEHICLE_TAB();
BEGIN
	-- SELECT count(*) into obj_count
	 -- FROM GEARBOX_VEHICLE_NEW_SIX_FOUR;
   ADS := VEHICLE_TAB();

	SELECT GEARBOX_VEHICLE_DATA_1 
	BULK COLLECT INTO ADS
	FROM GEARBOX_VEHICLE_NEW_SIX_FOUR;

	-- while obj_count > 0 loop
	-- end loop;
	
   -- extend_assign (dad_in); 
   -- extend_assign (mom_in);
   RETURN retval; 
END;
/

FUNCTION objects_print RETURN VEHICLE_TAB IS
   retval VEHICLE_TAB := VEHICLE_TAB(); -- Объявляем пустой массив

BEGIN
   SELECT GEARBOX_VEHICLE_DATA_1 
   INTO retval
   FROM GEARBOX_VEHICLE_NEW_SIX_FOUR;

   -- Другие действия с retval...

   RETURN retval; 
END;
/

BEGIN
    create_collection_table('STAFF', 'ORDERS');
END;
/
COMMIT;


  SELECT *
  FROM all_constraints
  WHERE r_constraint_name IN (
    SELECT constraint_name
    FROM all_constraints
    WHERE table_name = 'BRANCH'
  )
  AND table_name = 'ORDERS' AND OWNER = USER;


____END____.






--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
Триггер: Процедура, которая будет предоставлять скидку на сумму заказа:
при отправке товаров весом более 100 кг, дополнительные 5 килограмм можно отправить 
бесплатно. То есть, если вес груза больше 100 килограмм, то мы делим вес груза на 
стоимость доставки и умножаем это число на (масса груза – 5 киллограм).
если масса груза > 100 и < 200 кило, то бесплатно 5 кг
если масса груза > 200 и < 300 кило, то бесплатно 15 кг
если масса груза > 300 и < 400 кило, то бесплатно 25 кг
если масса груза > 500 и < 600 кило, то бесплатно 35 кг
если масса груза > 600 и < 700 кило, то бесплатно 45 кг
если груз больше 700 кило, то мы не принимаем такой заказ - ввести ограничение в таблицу.






-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
----------------------------------изменения после 18.09 парыы------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------


alter table Positions
drop column PST_employee_availability;

alter table Positions
drop column PST_english_A2_required;

alter table Positions
drop column PST_driver_license;

alter table Positions
add PST_employee_availability VARCHAR2(3);

alter table Positions
add PST_english_A2_required VARCHAR2(3);

alter table Positions
add PST_driver_license VARCHAR2(3);


					PST_employee_availability VARCHAR2(3) NOT NULL,
					PST_driver_license VARCHAR2(3) NOT NULL,
					PST_english_A2_required VARCHAR2(3) NOT NULL,

update Positions
set PST_employee_availability = 'No'
where Position_code = 1;

update Positions
set PST_employee_availability = 'Yes'
where Position_code = 2;

update Positions
set PST_employee_availability = 'No'
where Position_code = 3;

update Positions
set PST_employee_availability = 'No'
where Position_code = 4;

update Positions
set PST_employee_availability = 'Yes'
where Position_code = 5;
-----
update Positions
set PST_driver_license = 'No'
where Position_code = 1;

update Positions
set PST_driver_license = 'No'
where Position_code = 2;

update Positions
set PST_driver_license = 'Yes'
where Position_code = 3;

update Positions
set PST_driver_license = 'Yes'
where Position_code = 4;

update Positions
set PST_driver_license = 'No'
where Position_code = 5;
----
update Positions
set PST_english_A2_required = 'No'
where Position_code = 1;

update Positions
set PST_english_A2_required = 'Yes'
where Position_code = 2;

update Positions
set PST_english_A2_required = 'Yes'
where Position_code = 3;

update Positions
set PST_english_A2_required = 'No'
where Position_code = 4;

update Positions
set PST_english_A2_required = 'Yes'
where Position_code = 5;
-----

----------------------------------------------------

alter table Vehicles_sellers
drop column SLR_cars_num_bought_from_this_seller;

alter table Vehicles_sellers
drop column SLR_sales_launch_year;

------------
alter table Positions
modify (PST_employee_availability NOT NULL);

alter table Positions
modify (PST_driver_license NOT NULL);

alter table Positions
modify (PST_english_A2_required NOT NULL);

-------------------------------------------
alter table orders
drop column ORD_fragile;

alter table orders
add ORD_fragile VARCHAR2(3);

update orders
set ORD_fragile = 'Yes'
where Order_num = 7;

update orders
set ORD_fragile = 'No'
where Order_num = 12;

update orders
set ORD_fragile = 'No'
where Order_num = 10;

update orders
set ORD_fragile = 'No'
where Order_num = 4;

update orders
set ORD_fragile = 'No'
where Order_num = 5;

update orders
set ORD_fragile = 'No'
where Order_num = 6;

update orders
set ORD_fragile = 'No'
where Order_num = 7;

update orders
set ORD_fragile = 'No'
where Order_num = 8;

update orders
set ORD_fragile = 'No'
where Order_num = 9;

update orders
set ORD_fragile = 'Yes'
where Order_num = 10;

update orders
set ORD_fragile = 'Yes'
where Order_num = 11;

update orders
set ORD_fragile = 'No'
where Order_num = 12;

update orders
set ORD_fragile = 'No'
where Order_num = 13;

alter table orders
modify (ORD_fragile NOT NULL);
--------------------------------------------------------------
alter table orders
drop column ORD_completeness_check;

alter table orders
add ORD_completeness_check VARCHAR2(3);

update orders
set ORD_completeness_check = 'No'
where Order_num = 1;

update orders
set ORD_completeness_check = 'Yes'
where Order_num = 2;

update orders
set ORD_completeness_check = 'No'
where Order_num = 3;

update orders
set ORD_completeness_check = 'Yes'
where Order_num = 4;

update orders
set ORD_completeness_check = 'Yes'
where Order_num = 5;

update orders
set ORD_completeness_check = 'No'
where Order_num = 6;

update orders
set ORD_completeness_check = 'No'
where Order_num = 7;

update orders
set ORD_completeness_check = 'Yes'
where Order_num = 8;

update orders
set ORD_completeness_check = 'Yes'
where Order_num = 9;

update orders
set ORD_completeness_check = 'No'
where Order_num = 10;

update orders
set ORD_completeness_check = 'No'
where Order_num = 11;

update orders
set ORD_completeness_check = 'Yes'
where Order_num = 12;

update orders
set ORD_completeness_check = 'Yes'
where Order_num = 13;

alter table orders
modify (ORD_completeness_check NOT NULL);
------------------------------------------------------------
alter table orders
drop column ORD_cash_payment;

alter table orders
add ORD_cash_payment VARCHAR2(3);

update orders
set ORD_cash_payment = 'Yes'
where Order_num = 1;

update orders
set ORD_cash_payment = 'No'
where Order_num = 2;

update orders
set ORD_cash_payment = 'No'
where Order_num = 3;

update orders
set ORD_cash_payment = 'Yes'
where Order_num = 4;

update orders
set ORD_cash_payment = 'Yes'
where Order_num = 5;

update orders
set ORD_cash_payment = 'Yes'
where Order_num = 6;

update orders
set ORD_cash_payment = 'No'
where Order_num = 7;

update orders
set ORD_cash_payment = 'No'
where Order_num = 8;

update orders
set ORD_cash_payment = 'Yes'
where Order_num = 9;

update orders
set ORD_cash_payment = 'Yes'
where Order_num = 10;

update orders
set ORD_cash_payment = 'No'
where Order_num = 11;

update orders
set ORD_cash_payment = 'No'
where Order_num = 12;

update orders
set ORD_cash_payment = 'No'
where Order_num = 13;

alter table orders
modify (ORD_cash_payment NOT NULL);
---------------------------------------------------BASKET---------------------------------------------------

delete from basket where Departure_num = 1;
delete from basket where Departure_num = 2;
delete from basket where Departure_num = 3;
delete from basket where Departure_num = 4;
delete from basket where Departure_num = 5;


alter table basket 
add Basket_code INTEGER generated by default as identity(nocache);

alter table basket 
ADD CONSTRAINT basket_primary PRIMARY KEY (Basket_code);


begin
insert into Basket(Departure_num, Order_num) values(1,3);
insert into Basket(Departure_num, Order_num) values(2,5);
insert into Basket(Departure_num, Order_num) values(2,1);
insert into Basket(Departure_num, Order_num) values(3,2);
insert into Basket(Departure_num, Order_num) values(3,4);
insert into Basket(Departure_num, Order_num) values(3,6);
insert into Basket(Departure_num, Order_num) values(4,7);
insert into Basket(Departure_num, Order_num) values(1,9);
insert into Basket(Departure_num, Order_num) values(1,10);
insert into Basket(Departure_num, Order_num) values(1,11);
insert into Basket(Departure_num, Order_num) values(1,12);
insert into Basket(Departure_num, Order_num) values(5,13);
end;
/






//////////////////////////////////////////////////////
на всякий случай
CREATE TABLE aux_table(aux_Order_num INTEGER CONSTRAINT aux_order_number UNIQUE,
					aux_ORD_sender_name VARCHAR2(40) NOT NULL,
					aux_ORD_sender_address VARCHAR2(50) NOT NULL,
					aux_ORD_sender_phone CHAR(17) NOT NULL,
					aux_ORD_sending_office INTEGER NOT NULL,
					aux_ORD_employee_placing_the_order_num INTEGER NOT NULL,
					aux_ORD_package_weight DECIMAL(20,3) NOT NULL,
					aux_ORD_package_scope DECIMAL(20,3) NOT NULL,
					aux_ORD_package_receipt_date DATE NOT NULL,
					aux_ORD_declared_value_amount DECIMAL(30,3),
					aux_ORD_cash_on_dlvry_amount DECIMAL(30,3),
                    aux_ORD_arrival_date DATE,
					aux_ORD_recipient_name VARCHAR2(40) NOT NULL,
					aux_ORD_recipient_address VARCHAR2(50) NOT NULL,
					aux_ORD_recipient_phone CHAR(17) NOT NULL,
					aux_ORD_receiving_office INTEGER NOT NULL,
					aux_ORD_shipping_cost DECIMAL(30,3) NOT NULL,
					aux_ORD_deliv_type_code INTEGER NOT NULL,
					aux_ORD_fragile VARCHAR2(3) NOT NULL,
					aux_ORD_completeness_check VARCHAR2(3) NOT NULL,
					aux_ORD_cash_payment VARCHAR2(3) NOT NULL
);

CREATE OR REPLACE PROCEDURE copy_orders_to_aux_table
AS
	cursor orders_cursor is
	select * 
	from orders 
	where ORD_package_receipt_date BETWEEN TRUNC(SYSDATE, 'MONTH') AND SYSDATE;
		
	p_Order_num INTEGER;
	p_ORD_sender_name VARCHAR2(40);
	p_ORD_sender_address VARCHAR2(50);
	p_ORD_sender_phone CHAR(17);
	p_ORD_sending_office INTEGER;
	p_ORD_employee_placing_the_order_num INTEGER;
	p_ORD_package_weight DECIMAL(20,3);
	p_ORD_package_scope DECIMAL(20,3);
	p_ORD_package_receipt_date DATE;
	p_ORD_declared_value_amount DECIMAL(30,3);
	p_ORD_cash_on_dlvry_amount DECIMAL(30,3);
	p_ORD_arrival_date DATE;
	p_ORD_recipient_name VARCHAR2(40);
	p_ORD_recipient_address VARCHAR2(50);
	p_ORD_recipient_phone CHAR(17);
	p_ORD_receiving_office INTEGER;
	p_ORD_shipping_cost DECIMAL(30,3);
	p_ORD_deliv_type_code INTEGER;
	p_ORD_fragile VARCHAR2(3);
	p_ORD_completeness_check VARCHAR2(3);
	p_ORD_cash_payment VARCHAR2(3);	
	
	exp_unique_id exception;
	PRAGMA EXCEPTION_INIT (exp_unique_id, -00001);

begin

	OPEN orders_cursor;
	
	--OPEN orders_cursor;

	loop 
		fetch orders_cursor into p_Order_num,p_ORD_sender_name,
		p_ORD_sender_address,p_ORD_sender_phone,p_ORD_sending_office,
		p_ORD_employee_placing_the_order_num,p_ORD_package_weight,
		p_ORD_package_scope,p_ORD_package_receipt_date,
		p_ORD_declared_value_amount,p_ORD_cash_on_dlvry_amount,
		p_ORD_arrival_date,p_ORD_recipient_name,p_ORD_recipient_address,
		p_ORD_recipient_phone,p_ORD_receiving_office,p_ORD_shipping_cost,
		p_ORD_deliv_type_code,p_ORD_fragile,p_ORD_completeness_check,
		p_ORD_cash_payment;
		exit when orders_cursor%NOTFOUND;
		
		insert into aux_table(aux_Order_num,aux_ORD_sender_name,
		aux_ORD_sender_address,aux_ORD_sender_phone,aux_ORD_sending_office,
		aux_ORD_employee_placing_the_order_num,aux_ORD_package_weight,
		aux_ORD_package_scope,aux_ORD_package_receipt_date,
		aux_ORD_declared_value_amount,aux_ORD_cash_on_dlvry_amount,
		aux_ORD_arrival_date,aux_ORD_recipient_name,aux_ORD_recipient_address,
		aux_ORD_recipient_phone,aux_ORD_receiving_office,
		aux_ORD_shipping_cost,aux_ORD_deliv_type_code,aux_ORD_fragile,
		aux_ORD_completeness_check,aux_ORD_cash_payment)
		values (p_Order_num, p_ORD_sender_name, p_ORD_sender_address,
		p_ORD_sender_phone,	p_ORD_sending_office, p_ORD_employee_placing_the_order_num,
		p_ORD_package_weight, p_ORD_package_scope, p_ORD_package_receipt_date, 
		p_ORD_declared_value_amount, p_ORD_cash_on_dlvry_amount, p_ORD_arrival_date, 
		p_ORD_recipient_name, p_ORD_recipient_address, p_ORD_recipient_phone, 
		p_ORD_receiving_office,	p_ORD_shipping_cost, p_ORD_deliv_type_code, 
		p_ORD_fragile, p_ORD_completeness_check, p_ORD_cash_payment);
	end loop;
		
		close orders_cursor;
		
		DBMS_OUTPUT.PUT_LINE('The lines have been copied successfully');
	
exception
	WHEN exp_unique_id THEN
	DBMS_OUTPUT.PUT_LINE ('Ошибка №' || sqlcode || ' заказ с номером ' || p_Order_num || ' уже существует'); 
	WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('За текущий месяцев не было сделано ни одного заказа');
	WHEN CURSOR_ALREADY_OPEN THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка №' || sqlcode || '. Курсор уже открыт');
	when others then 
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);

END;
/