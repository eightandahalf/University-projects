-------------------------------------------------------------------------------------------------------------------
---------------------------------------------4 LABA----------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
set serveroutput on
 
1.	СОЗДАТЬ ПРОЦЕДУРУ.
____TASK____: ВЫВЕСТИ ВСЮ ИНФУ О РАБОТНИКЕ С ID = 1.
____CODE____:
create or replace procedure staff_info(in_staff_num number)
is
p_info staff%rowtype;
begin
select * into p_info
from staff
where staff_num = in_staff_num;

dbms_output.put_line(p_info.stf_name || '   ' ||
p_info.stf_birth_date || '   ' || p_info.stf_address || '   ' || p_info.stf_position_code || '   ' || 
p_info.stf_email || '   ' || p_info.stf_passport_details || '   ' || 
p_info.stf_branch_num || '   ' || p_info.stf_phone_num || '   ');

exception
	when others then
		dbms_output.put_line(SQLERRM);
END;
/
____TESTING____:
BEGIN
staff_info(1);
EXECUTE staff_info(1);
end;
____END____.
2.	СОЗДАТЬ ФУНКЦИЮ.
____TASK____: посчитать возраст сотрудника с опредленным фио и вывести инфу о всех сотрудниках компании, которые старше этого сотрудника
____CODE____:
Dedischev P.A.
create or replace function get_staff_age(
	staff_name staff.STF_name%TYPE,
	dateval date default sysdate
)
return VARCHAR2	
is
result interval year to month;
s_birth_date staff.STF_birth_date%type;
begin
select STF_birth_date into s_birth_date from staff
where staff.STF_name = staff_name;
result := (dateval - s_birth_date) year to month;
return result;
end;
/ 
____TESTING____:
SELECT STF_name, stf_birth_date, get_staff_age (STF_name) 
FROM staff 
WHERE (sysdate - stf_birth_date) YEAR TO MONTH > get_staff_age ('Dedischev P.A.');
____END____.

3.1. Создать процедуру, копирующую строки с информацией о заказах за текущий месяц, 
во вспомогательную таблицу используя явный курсор или курсорную переменную, а также 
атрибуты курсора;

____TASK____: Создать процедуру в oracle, копирующую строки с информацией о заказах за текущий месяц, 
во вспомогательную таблицу используя явный курсор или курсорную переменную, а также атрибуты курсора, 
которая использует пакет DBMS_OUTPUT для вывода результатов работы в SQL*Plus, а также, которая 
предусматривает секцию обработки исключительных ситуаций, причем обязательно использовать как 
предустановленные исключительные ситуации, так и собственные (например, стоит 
контролировать наличие в БД значений, передаваемых в процедуры и функции как параметры.

обработка искл.ситуация будет заключаться в том, что если id заказа будет повторяться,
то будет появляться сообщение 

CREATE TABLE aux_table(aux_Order_num INTEGER CONSTRAINT aux_order_number UNIQUE,
					aux_ORD_sender_name VARCHAR2(40) NOT NULL,
					aux_ORD_sender_address VARCHAR2(50) NOT NULL,
					aux_ORD_sender_phone CHAR(17) NOT NULL,
					aux_ORD_sending_office VARCHAR2(255) NOT NULL,
					aux_ORD_employee_placing_the_order_num VARCHAR2(255) NOT NULL,
					aux_ORD_package_weight DECIMAL(20,3) NOT NULL,
					aux_ORD_package_scope DECIMAL(20,3) NOT NULL,
					aux_ORD_package_receipt_date DATE NOT NULL,
					aux_ORD_declared_value_amount DECIMAL(30,3),
					aux_ORD_cash_on_dlvry_amount DECIMAL(30,3),
					aux_ORD_fragile VARCHAR2(3) NOT NULL,
					aux_ORD_completeness_check VARCHAR2(3) NOT NULL,
                    aux_ORD_arrival_date DATE,
					aux_ORD_recipient_name VARCHAR2(40) NOT NULL,
					aux_ORD_recipient_address VARCHAR2(50) NOT NULL,
					aux_ORD_recipient_phone CHAR(17) NOT NULL,
					aux_ORD_receiving_office VARCHAR2(255) NOT NULL,
					aux_ORD_shipping_cost DECIMAL(30,3) NOT NULL,
					aux_ORD_deliv_type_code VARCHAR2(255) NOT NULL,
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
	p_ORD_sending_office VARCHAR2(255);
	p_ORD_employee_placing_the_order_num VARCHAR2(255);
	p_ORD_package_weight DECIMAL(20,3);
	p_ORD_package_scope DECIMAL(20,3);
	p_ORD_package_receipt_date DATE;
	p_ORD_declared_value_amount DECIMAL(30,3);
	p_ORD_cash_on_dlvry_amount DECIMAL(30,3);
	p_ORD_fragile VARCHAR2(3);
	p_ORD_completeness_check VARCHAR2(3);
	p_ORD_arrival_date DATE;
	p_ORD_recipient_name VARCHAR2(40);
	p_ORD_recipient_address VARCHAR2(50);
	p_ORD_recipient_phone CHAR(17);
	p_ORD_receiving_office VARCHAR2(255);
	p_ORD_shipping_cost DECIMAL(30,3);
	p_ORD_deliv_type_code VARCHAR2(255);
	p_ORD_cash_payment VARCHAR2(3);	
	
	exp_unique_id exception;
	PRAGMA EXCEPTION_INIT (exp_unique_id, -00001);

begin

	OPEN orders_cursor;
	
	--OPEN orders_cursor;

	loop 
	begin
		fetch orders_cursor into p_Order_num,p_ORD_sender_name,
		p_ORD_sender_address,p_ORD_sender_phone,p_ORD_sending_office,
		p_ORD_employee_placing_the_order_num,p_ORD_package_weight,
		p_ORD_package_scope,p_ORD_package_receipt_date,
		p_ORD_declared_value_amount,p_ORD_cash_on_dlvry_amount,
		p_ORD_fragile,p_ORD_completeness_check,p_ORD_arrival_date,
		p_ORD_recipient_name,p_ORD_recipient_address,
		p_ORD_recipient_phone,p_ORD_receiving_office,p_ORD_shipping_cost,
		p_ORD_deliv_type_code,p_ORD_cash_payment;
		
		exit when orders_cursor%NOTFOUND;
		
		insert into aux_table(aux_Order_num,aux_ORD_sender_name,
		aux_ORD_sender_address,aux_ORD_sender_phone,aux_ORD_sending_office,
		aux_ORD_employee_placing_the_order_num,aux_ORD_package_weight,
		aux_ORD_package_scope,aux_ORD_package_receipt_date,
		aux_ORD_declared_value_amount,aux_ORD_cash_on_dlvry_amount,
		aux_ORD_fragile,aux_ORD_completeness_check,aux_ORD_arrival_date,
		aux_ORD_recipient_name,aux_ORD_recipient_address,
		aux_ORD_recipient_phone,aux_ORD_receiving_office,
		aux_ORD_shipping_cost,aux_ORD_deliv_type_code,aux_ORD_cash_payment)
		values (p_Order_num, p_ORD_sender_name, p_ORD_sender_address,
		p_ORD_sender_phone,	p_ORD_sending_office, p_ORD_employee_placing_the_order_num,
		p_ORD_package_weight, p_ORD_package_scope, p_ORD_package_receipt_date, 
		p_ORD_declared_value_amount, p_ORD_cash_on_dlvry_amount, 
		p_ORD_fragile, p_ORD_completeness_check,p_ORD_arrival_date, 
		p_ORD_recipient_name, p_ORD_recipient_address, p_ORD_recipient_phone, 
		p_ORD_receiving_office,	p_ORD_shipping_cost, p_ORD_deliv_type_code, 
		p_ORD_cash_payment);
				
		exception
		WHEN exp_unique_id THEN
		DBMS_OUTPUT.PUT_LINE ('Ошибка №' || sqlcode || ' заказ с номером ' || p_Order_num || ' уже существует'); 
		when others then 
		DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);

	end;

	end loop;
		
		close orders_cursor;
		
		update aux_table
		set aux_ORD_sending_office = (
		  select (to_char(BR_max_storage_capacity) || ' ' || BR_principal_employee_name || ' ' || BR_principal_employee_phone || ' ' || BR_address || ' ' || to_char(BR_employee_num) || ' ' || to_char(BR_ceo_director))
		  from branch
		  where branch.branch_num = to_number(aux_table.aux_ORD_sending_office) and VALIDATE_CONVERSION(aux_table.aux_ORD_sending_office as NUMBER) = 1
		) where VALIDATE_CONVERSION(aux_ORD_sending_office as NUMBER) = 1;	
		
		update aux_table
		set aux_ORD_employee_placing_the_order_num = (
		  select (STF_name || ' ' || STF_birth_date || ' ' || STF_address || ' ' || to_char(STF_position_code) || ' ' || STF_email || ' ' || STF_passport_details || ' ' || to_char(STF_branch_num) || ' ' ||  STF_phone_num)
		  from staff
		  where staff.Staff_num = to_number(aux_table.aux_ORD_employee_placing_the_order_num) and VALIDATE_CONVERSION(aux_table.aux_ORD_employee_placing_the_order_num as NUMBER) = 1
		) where VALIDATE_CONVERSION(aux_ORD_employee_placing_the_order_num as NUMBER) = 1;	

		update aux_table
		set aux_ORD_receiving_office = (
		  select (to_char(BR_max_storage_capacity) || ' ' || BR_principal_employee_name || ' ' || BR_principal_employee_phone || ' ' || BR_address || ' ' || to_char(BR_employee_num) || ' ' || to_char(BR_ceo_director))
		  from branch
		  where branch.branch_num = to_number(aux_table.aux_ORD_receiving_office) and VALIDATE_CONVERSION(aux_table.aux_ORD_receiving_office as NUMBER) = 1
		) where VALIDATE_CONVERSION(aux_ORD_receiving_office as NUMBER) = 1;	

		update aux_table
		set aux_ORD_deliv_type_code = (
		  select DLV_delivery_method
		  from Delivery_type
		  where Delivery_type.DLV_code = to_number(aux_table.aux_ORD_deliv_type_code) and VALIDATE_CONVERSION(aux_table.aux_ORD_deliv_type_code as NUMBER) = 1
		) where VALIDATE_CONVERSION(aux_ORD_deliv_type_code as NUMBER) = 1;	

		DBMS_OUTPUT.PUT_LINE('The lines have been copied successfully');
	
exception
	WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('За текущий месяцев не было сделано ни одного заказа');
	WHEN CURSOR_ALREADY_OPEN THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка №' || sqlcode || '. Курсор уже открыт');
	when others then 
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);

END;
/
-------------------------------------------------------------------------------------------------------------------
____TESTING____:
	EXECUTE copy_orders_to_aux_table;
____END____.

3.2. ____TASK____: Написать функцию, которая выводит информацию о отправителях, которые оформили 
количество заказов за указанный год больше, чем указано во входном параметре. 
Возвращать общее количество подписчиков. 
	используя явный курсор или курсорную переменную, а также атрибуты курсора;
	используя пакет DBMS_OUTPUT для вывода результатов работы в SQL*Plus;
	предусмотреть секцию обработки исключительных ситуаций, причем обязательно использовать как предустановленные 
исключительные ситуации, так и собственные (например, стоит контролировать наличие в БД значений, передаваемых в процедуры и функции как параметры
____CODE____:
CREATE OR REPLACE FUNCTION subscribers_with_more_subscriptions(year IN NUMBER, threshold IN NUMBER) RETURN NUMBER IS
   CURSOR subscriber_cursor IS
      SELECT ORD_sender_name, ORD_sender_address, ORD_sender_phone, COUNT(order_num) AS orders_count
      FROM orders
      WHERE EXTRACT(YEAR FROM ORD_package_receipt_date) = year
      GROUP BY ORD_sender_name, ORD_sender_address, ORD_sender_phone
      HAVING COUNT(order_num) > threshold;
	  
	f_ORD_sender_name VARCHAR2(40);
	f_ORD_sender_address VARCHAR2(50);
	f_ORD_sender_phone CHAR(17);
	orders_count NUMBER;
	total_subscribers NUMBER := 0;

	correct_year exception;
	PRAGMA EXCEPTION_INIT (correct_year, -20001);

	correct_threshold exception;
	PRAGMA EXCEPTION_INIT (correct_threshold, -20002);

BEGIN

	IF year > EXTRACT(YEAR FROM sysdate) THEN
		RAISE_APPLICATION_ERROR(-20001, 'Неверный год: ' || year);
	END IF;
	
	IF threshold < 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'Пороговое значение заказов должно быть больше 0');
	END IF;

	-- если не открыть курсор, то будет внутренняя ошибка с номером ORA-01001 INVALID_CURSOR
    OPEN subscriber_cursor;


    -- Перебираем результаты курсора
    LOOP
        FETCH subscriber_cursor INTO f_ORD_sender_name, f_ORD_sender_address, f_ORD_sender_phone, orders_count;
        EXIT WHEN subscriber_cursor%NOTFOUND;

        -- Выводим результаты в SQL*Plus
        DBMS_OUTPUT.PUT_LINE(
            'Имя отправителя: ' || f_ORD_sender_name ||
            ', Адрес отправителя: ' || f_ORD_sender_address ||
            ', Телефон отправителя: ' || f_ORD_sender_phone ||
            ', количество заказов: ' || orders_count);

        -- Увеличиваем счетчик общего количества подписчиков
        total_subscribers := total_subscribers + 1;

    END LOOP;

    -- Закрываем курсор
    CLOSE subscriber_cursor;

    -- Возвращаем общее количество подписчиков
    RETURN total_subscribers;
EXCEPTION
    WHEN correct_year THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN correct_threshold THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('В таблице orders нет данных за указанный год.');
	when INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Вы не корректно работаете с курсором');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLCODE || ' - ' || SQLERRM);   
END;
/
---------------------------------------------------
____TESTING____:
DECLARE
    total_subscribers NUMBER;
BEGIN
    total_subscribers := subscribers_with_more_subscriptions(2022, 1);
    DBMS_OUTPUT.PUT_LINE('Количество подписчиков, оформивших более одной подписки за год 2023: ' || total_subscribers);
END;
/
____END____.

3.3.	
____TASK____: 
Создать локальную программу, изменив код ранее написанной процедуры или функции
____CODE____:
CREATE OR REPLACE FUNCTION local_subscribers_with_more_subscriptions(year IN NUMBER, threshold IN NUMBER) RETURN NUMBER IS
   CURSOR subscriber_cursor IS
      SELECT ORD_sender_name, ORD_sender_address, ORD_sender_phone, COUNT(order_num) AS orders_count
      FROM orders
      WHERE EXTRACT(YEAR FROM ORD_package_receipt_date) = year
      GROUP BY ORD_sender_name, ORD_sender_address, ORD_sender_phone
      HAVING COUNT(order_num) > threshold;
	  
	f_ORD_sender_name VARCHAR2(40);
	f_ORD_sender_address VARCHAR2(50);
	f_ORD_sender_phone CHAR(17);
	orders_count NUMBER;
	total_subscribers NUMBER := 0;
	
	correct_year exception;
	PRAGMA EXCEPTION_INIT (correct_year, -20001);

	correct_threshold exception;
	PRAGMA EXCEPTION_INIT (correct_threshold, -20002);
	
	FUNCTION correct_year_checking (year in Number)
	return Number
	IS
	result Number := 0;
	BEGIN
	IF year > EXTRACT(YEAR FROM sysdate) THEN
	result := 1;
	END IF;
	RETURN result;
	END correct_year_checking;

BEGIN	
	if correct_year_checking(year) = 1 then	
	RAISE_APPLICATION_ERROR(-20001, 'Неверный год: ' || year);
	end if;
	
	IF threshold < 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'Пороговое значение заказов должно быть больше 0');
	END IF;

	-- если не открыть курсор, то будет внутренняя ошибка с номером ORA-01001 INVALID_CURSOR
    OPEN subscriber_cursor;


    -- Перебираем результаты курсора
    LOOP
        FETCH subscriber_cursor INTO f_ORD_sender_name, f_ORD_sender_address, f_ORD_sender_phone, orders_count;
        EXIT WHEN subscriber_cursor%NOTFOUND;

        -- Выводим результаты в SQL*Plus
        DBMS_OUTPUT.PUT_LINE(
            'Имя отправителя: ' || f_ORD_sender_name ||
            ', Адрес отправителя: ' || f_ORD_sender_address ||
            ', Телефон отправителя: ' || f_ORD_sender_phone ||
            ', количество заказов: ' || orders_count);

        -- Увеличиваем счетчик общего количества подписчиков
        total_subscribers := total_subscribers + 1;

    END LOOP;

    -- Закрываем курсор
    CLOSE subscriber_cursor;

    -- Возвращаем общее количество подписчиков
    RETURN total_subscribers;
EXCEPTION
    WHEN correct_year THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN correct_threshold THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('В таблице orders нет данных за указанный год.');
	when INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Вы не корректно работаете с курсором');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLCODE || ' - ' || SQLERRM);   
END;
/
---------------------------------------------------
____TESTING____:
DECLARE
    total_subscribers NUMBER;
BEGIN
    total_subscribers := local_subscribers_with_more_subscriptions(2022, 0);
    DBMS_OUTPUT.PUT_LINE('Количество подписчиков, оформивших более одной подписки за год 2023: ' || total_subscribers);
END;
/
____END____.
4.	
____TASK____: 
Написать перегруженные программы, используя для этого ранее созданную процедуру или функцию.
____CODE____:
DECLARE
threshold_num   VARCHAR2 (50) := '1';
threshold_varchar   NUMBER := 1;
total_subscribers NUMBER;

   
	FUNCTION local_subscribers_with_more_subscriptions(year IN NUMBER, threshold IN NUMBER) RETURN NUMBER IS
   CURSOR subscriber_cursor IS
      SELECT ORD_sender_name, ORD_sender_address, ORD_sender_phone, COUNT(order_num) AS orders_count
      FROM orders
      WHERE EXTRACT(YEAR FROM ORD_package_receipt_date) = year
      GROUP BY ORD_sender_name, ORD_sender_address, ORD_sender_phone
      HAVING COUNT(order_num) > threshold;
	  
	f_ORD_sender_name VARCHAR2(40);
	f_ORD_sender_address VARCHAR2(50);
	f_ORD_sender_phone CHAR(17);
	orders_count NUMBER;
	total_subscribers NUMBER := 0;
	
	correct_year exception;
	PRAGMA EXCEPTION_INIT (correct_year, -20001);

	correct_threshold exception;
	PRAGMA EXCEPTION_INIT (correct_threshold, -20002);
	
	FUNCTION correct_year_checking (year in Number)
	return Number
	IS
	result Number := 0;
	BEGIN
	IF year > EXTRACT(YEAR FROM sysdate) THEN
	result := 1;
	END IF;
	RETURN result;
	END correct_year_checking;

BEGIN	
	if correct_year_checking(year) = 1 then	
	RAISE_APPLICATION_ERROR(-20001, 'Неверный год: ' || year);
	end if;
	
	IF threshold < 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'Пороговое значение заказов должно быть больше 0');
	END IF;

	-- если не открыть курсор, то будет внутренняя ошибка с номером ORA-01001 INVALID_CURSOR
    OPEN subscriber_cursor;


    -- Перебираем результаты курсора
    LOOP
        FETCH subscriber_cursor INTO f_ORD_sender_name, f_ORD_sender_address, f_ORD_sender_phone, orders_count;
        EXIT WHEN subscriber_cursor%NOTFOUND;

        -- Выводим результаты в SQL*Plus
        DBMS_OUTPUT.PUT_LINE(
            'Имя отправителя: ' || f_ORD_sender_name ||
            ', Адрес отправителя: ' || f_ORD_sender_address ||
            ', Телефон отправителя: ' || f_ORD_sender_phone ||
            ', количество заказов: ' || orders_count);

        -- Увеличиваем счетчик общего количества подписчиков
        total_subscribers := total_subscribers + 1;

    END LOOP;

    -- Закрываем курсор
    CLOSE subscriber_cursor;

    -- Возвращаем общее количество подписчиков
    RETURN total_subscribers;
EXCEPTION
    WHEN correct_year THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN correct_threshold THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('В таблице orders нет данных за указанный год.');
	when INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Вы не корректно работаете с курсором');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLCODE || ' - ' || SQLERRM);   
END;

	FUNCTION local_subscribers_with_more_subscriptions(year IN NUMBER, threshold IN VARCHAR2) RETURN NUMBER IS
   CURSOR subscriber_cursor IS
      SELECT ORD_sender_name, ORD_sender_address, ORD_sender_phone, COUNT(order_num) AS orders_count
      FROM orders
      WHERE EXTRACT(YEAR FROM ORD_package_receipt_date) = year
      GROUP BY ORD_sender_name, ORD_sender_address, ORD_sender_phone
      HAVING COUNT(order_num) > threshold;
	  
	threshold_num Number;
	f_ORD_sender_name VARCHAR2(40);
	f_ORD_sender_address VARCHAR2(50);
	f_ORD_sender_phone CHAR(17);
	orders_count NUMBER;
	total_subscribers NUMBER := 0;
		
	correct_year exception;
	PRAGMA EXCEPTION_INIT (correct_year, -20001);

	correct_threshold exception;
	PRAGMA EXCEPTION_INIT (correct_threshold, -20002);
	
	FUNCTION correct_year_checking (year in Number)
	return Number
	IS
	result Number := 0;
	BEGIN
	IF year > EXTRACT(YEAR FROM sysdate) THEN
	result := 1;
	END IF;
	RETURN result;
	END correct_year_checking;

BEGIN	
	threshold_num := TO_NUMBER(threshold);

	if correct_year_checking(year) = 1 then	
	RAISE_APPLICATION_ERROR(-20001, 'Неверный год: ' || year);
	end if;
	
	IF threshold < 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'Пороговое значение заказов должно быть больше 0');
	END IF;

	-- если не открыть курсор, то будет внутренняя ошибка с номером ORA-01001 INVALID_CURSOR
    OPEN subscriber_cursor;


    -- Перебираем результаты курсора
    LOOP
        FETCH subscriber_cursor INTO f_ORD_sender_name, f_ORD_sender_address, f_ORD_sender_phone, orders_count;
        EXIT WHEN subscriber_cursor%NOTFOUND;

        -- Выводим результаты в SQL*Plus
        DBMS_OUTPUT.PUT_LINE(
            'Имя отправителя: ' || f_ORD_sender_name ||
            ', Адрес отправителя: ' || f_ORD_sender_address ||
            ', Телефон отправителя: ' || f_ORD_sender_phone ||
            ', количество заказов: ' || orders_count);

        -- Увеличиваем счетчик общего количества подписчиков
        total_subscribers := total_subscribers + 1;

    END LOOP;

    -- Закрываем курсор
    CLOSE subscriber_cursor;

    -- Возвращаем общее количество подписчиков
    RETURN total_subscribers;
EXCEPTION
    WHEN correct_year THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN correct_threshold THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('В таблице orders нет данных за указанный год.');
	when INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Вы не корректно работаете с курсором');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLCODE || ' - ' || SQLERRM);   
END;

BEGIN
    total_subscribers := local_subscribers_with_more_subscriptions(2022, threshold_num);
	total_subscribers := local_subscribers_with_more_subscriptions(2022, threshold_varchar);
END;
/
____TESTING____:
____END____.
5.	
____TASK____: 
Объединить все процедуры и функции, в том числе перегруженные, в пакет.
____CODE____:
CREATE OR REPLACE PACKAGE my_package IS

PROCEDURE copy_orders_to_aux_table;

FUNCTION local_subscribers_with_more_subscriptions(year IN NUMBER, threshold IN NUMBER) RETURN NUMBER;

FUNCTION local_subscribers_with_more_subscriptions(year IN NUMBER, threshold IN VARCHAR2) RETURN NUMBER ;
PRAGMA RESTRICT_REFERENCES (local_subscribers_with_more_subscriptions, WNDS);

END my_package;
/

CREATE OR REPLACE PACKAGE BODY my_package IS

PROCEDURE copy_orders_to_aux_table
AS
	cursor orders_cursor is
	select * 
	from orders 
	where ORD_package_receipt_date BETWEEN TRUNC(SYSDATE, 'MONTH') AND SYSDATE;
			
	p_Order_num INTEGER;
	p_ORD_sender_name VARCHAR2(40);
	p_ORD_sender_address VARCHAR2(50);
	p_ORD_sender_phone CHAR(17);
	p_ORD_sending_office VARCHAR2(255);
	p_ORD_employee_placing_the_order_num VARCHAR2(255);
	p_ORD_package_weight DECIMAL(20,3);
	p_ORD_package_scope DECIMAL(20,3);
	p_ORD_package_receipt_date DATE;
	p_ORD_declared_value_amount DECIMAL(30,3);
	p_ORD_cash_on_dlvry_amount DECIMAL(30,3);
	p_ORD_fragile VARCHAR2(3);
	p_ORD_completeness_check VARCHAR2(3);
	p_ORD_arrival_date DATE;
	p_ORD_recipient_name VARCHAR2(40);
	p_ORD_recipient_address VARCHAR2(50);
	p_ORD_recipient_phone CHAR(17);
	p_ORD_receiving_office VARCHAR2(255);
	p_ORD_shipping_cost DECIMAL(30,3);
	p_ORD_deliv_type_code VARCHAR2(255);
	p_ORD_cash_payment VARCHAR2(3);	
	
	exp_unique_id exception;
	PRAGMA EXCEPTION_INIT (exp_unique_id, -00001);

begin

	OPEN orders_cursor;
	
	--OPEN orders_cursor;

	loop 
	begin
		fetch orders_cursor into p_Order_num,p_ORD_sender_name,
		p_ORD_sender_address,p_ORD_sender_phone,p_ORD_sending_office,
		p_ORD_employee_placing_the_order_num,p_ORD_package_weight,
		p_ORD_package_scope,p_ORD_package_receipt_date,
		p_ORD_declared_value_amount,p_ORD_cash_on_dlvry_amount,
		p_ORD_fragile,p_ORD_completeness_check,p_ORD_arrival_date,
		p_ORD_recipient_name,p_ORD_recipient_address,
		p_ORD_recipient_phone,p_ORD_receiving_office,p_ORD_shipping_cost,
		p_ORD_deliv_type_code,p_ORD_cash_payment;
		
		exit when orders_cursor%NOTFOUND;
		
		insert into aux_table(aux_Order_num,aux_ORD_sender_name,
		aux_ORD_sender_address,aux_ORD_sender_phone,aux_ORD_sending_office,
		aux_ORD_employee_placing_the_order_num,aux_ORD_package_weight,
		aux_ORD_package_scope,aux_ORD_package_receipt_date,
		aux_ORD_declared_value_amount,aux_ORD_cash_on_dlvry_amount,
		aux_ORD_fragile,aux_ORD_completeness_check,aux_ORD_arrival_date,
		aux_ORD_recipient_name,aux_ORD_recipient_address,
		aux_ORD_recipient_phone,aux_ORD_receiving_office,
		aux_ORD_shipping_cost,aux_ORD_deliv_type_code,aux_ORD_cash_payment)
		values (p_Order_num, p_ORD_sender_name, p_ORD_sender_address,
		p_ORD_sender_phone,	p_ORD_sending_office, p_ORD_employee_placing_the_order_num,
		p_ORD_package_weight, p_ORD_package_scope, p_ORD_package_receipt_date, 
		p_ORD_declared_value_amount, p_ORD_cash_on_dlvry_amount, 
		p_ORD_fragile, p_ORD_completeness_check,p_ORD_arrival_date, 
		p_ORD_recipient_name, p_ORD_recipient_address, p_ORD_recipient_phone, 
		p_ORD_receiving_office,	p_ORD_shipping_cost, p_ORD_deliv_type_code, 
		p_ORD_cash_payment);
				
		exception
		WHEN exp_unique_id THEN
		DBMS_OUTPUT.PUT_LINE ('Ошибка №' || sqlcode || ' заказ с номером ' || p_Order_num || ' уже существует'); 
		when others then 
		DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);

	end;

	end loop;
		
		close orders_cursor;
		
		update aux_table
		set aux_ORD_sending_office = (
		  select (to_char(BR_max_storage_capacity) || ' ' || BR_principal_employee_name || ' ' || BR_principal_employee_phone || ' ' || BR_address || ' ' || to_char(BR_employee_num) || ' ' || to_char(BR_ceo_director))
		  from branch
		  where branch.branch_num = to_number(aux_table.aux_ORD_sending_office) and VALIDATE_CONVERSION(aux_table.aux_ORD_sending_office as NUMBER) = 1
		) where VALIDATE_CONVERSION(aux_ORD_sending_office as NUMBER) = 1;	
		
		update aux_table
		set aux_ORD_employee_placing_the_order_num = (
		  select (STF_name || ' ' || STF_birth_date || ' ' || STF_address || ' ' || to_char(STF_position_code) || ' ' || STF_email || ' ' || STF_passport_details || ' ' || to_char(STF_branch_num) || ' ' ||  STF_phone_num)
		  from staff
		  where staff.Staff_num = to_number(aux_table.aux_ORD_employee_placing_the_order_num) and VALIDATE_CONVERSION(aux_table.aux_ORD_employee_placing_the_order_num as NUMBER) = 1
		) where VALIDATE_CONVERSION(aux_ORD_employee_placing_the_order_num as NUMBER) = 1;	

		update aux_table
		set aux_ORD_receiving_office = (
		  select (to_char(BR_max_storage_capacity) || ' ' || BR_principal_employee_name || ' ' || BR_principal_employee_phone || ' ' || BR_address || ' ' || to_char(BR_employee_num) || ' ' || to_char(BR_ceo_director))
		  from branch
		  where branch.branch_num = to_number(aux_table.aux_ORD_receiving_office) and VALIDATE_CONVERSION(aux_table.aux_ORD_receiving_office as NUMBER) = 1
		) where VALIDATE_CONVERSION(aux_ORD_receiving_office as NUMBER) = 1;	

		update aux_table
		set aux_ORD_deliv_type_code = (
		  select DLV_delivery_method
		  from Delivery_type
		  where Delivery_type.DLV_code = to_number(aux_table.aux_ORD_deliv_type_code) and VALIDATE_CONVERSION(aux_table.aux_ORD_deliv_type_code as NUMBER) = 1
		) where VALIDATE_CONVERSION(aux_ORD_deliv_type_code as NUMBER) = 1;	

		DBMS_OUTPUT.PUT_LINE('The lines have been copied successfully');
	
exception
	WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('За текущий месяцев не было сделано ни одного заказа');
	WHEN CURSOR_ALREADY_OPEN THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка №' || sqlcode || '. Курсор уже открыт');
	when others then 
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);

END copy_orders_to_aux_table;

FUNCTION local_subscribers_with_more_subscriptions(year IN NUMBER, threshold IN NUMBER) RETURN NUMBER IS
   CURSOR subscriber_cursor IS
      SELECT ORD_sender_name, ORD_sender_address, ORD_sender_phone, COUNT(order_num) AS orders_count
      FROM orders
      WHERE EXTRACT(YEAR FROM ORD_package_receipt_date) = year
      GROUP BY ORD_sender_name, ORD_sender_address, ORD_sender_phone
      HAVING COUNT(order_num) > threshold;
	  
	f_ORD_sender_name VARCHAR2(40);
	f_ORD_sender_address VARCHAR2(50);
	f_ORD_sender_phone CHAR(17);
	orders_count NUMBER;
	total_subscribers NUMBER := 0;
	
	correct_year exception;
	PRAGMA EXCEPTION_INIT (correct_year, -20001);

	correct_threshold exception;
	PRAGMA EXCEPTION_INIT (correct_threshold, -20002);
	
	FUNCTION correct_year_checking (year in Number)
	return Number
	IS
	result Number := 0;
	BEGIN
	IF year > EXTRACT(YEAR FROM sysdate) THEN
	result := 1;
	END IF;
	RETURN result;
	END correct_year_checking;

BEGIN	
	if correct_year_checking(year) = 1 then	
	RAISE_APPLICATION_ERROR(-20001, 'Неверный год: ' || year);
	end if;
	
	IF threshold < 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'Пороговое значение заказов должно быть больше 0');
	END IF;

	-- если не открыть курсор, то будет внутренняя ошибка с номером ORA-01001 INVALID_CURSOR
    OPEN subscriber_cursor;


    -- Перебираем результаты курсора
    LOOP
        FETCH subscriber_cursor INTO f_ORD_sender_name, f_ORD_sender_address, f_ORD_sender_phone, orders_count;
        EXIT WHEN subscriber_cursor%NOTFOUND;

        -- Выводим результаты в SQL*Plus
        DBMS_OUTPUT.PUT_LINE(
            'Имя отправителя: ' || f_ORD_sender_name ||
            ', Адрес отправителя: ' || f_ORD_sender_address ||
            ', Телефон отправителя: ' || f_ORD_sender_phone ||
            ', количество заказов: ' || orders_count);

        -- Увеличиваем счетчик общего количества подписчиков
        total_subscribers := total_subscribers + 1;

    END LOOP;

    -- Закрываем курсор
    CLOSE subscriber_cursor;

    -- Возвращаем общее количество подписчиков
    RETURN total_subscribers;
EXCEPTION
    WHEN correct_year THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN correct_threshold THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('В таблице orders нет данных за указанный год.');
	when INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Вы не корректно работаете с курсором');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLCODE || ' - ' || SQLERRM);   
END local_subscribers_with_more_subscriptions;

FUNCTION local_subscribers_with_more_subscriptions(year IN NUMBER, threshold IN VARCHAR2) RETURN NUMBER IS
   CURSOR subscriber_cursor IS
      SELECT ORD_sender_name, ORD_sender_address, ORD_sender_phone, COUNT(order_num) AS orders_count
      FROM orders
      WHERE EXTRACT(YEAR FROM ORD_package_receipt_date) = year
      GROUP BY ORD_sender_name, ORD_sender_address, ORD_sender_phone
      HAVING COUNT(order_num) > threshold;
	  
	threshold_num Number;
	f_ORD_sender_name VARCHAR2(40);
	f_ORD_sender_address VARCHAR2(50);
	f_ORD_sender_phone CHAR(17);
	orders_count NUMBER;
	total_subscribers NUMBER := 0;
		
	correct_year exception;
	PRAGMA EXCEPTION_INIT (correct_year, -20001);

	correct_threshold exception;
	PRAGMA EXCEPTION_INIT (correct_threshold, -20002);
	
	FUNCTION correct_year_checking (year in Number)
	return Number
	IS
	result Number := 0;
	BEGIN
	IF year > EXTRACT(YEAR FROM sysdate) THEN
	result := 1;
	END IF;
	RETURN result;
	END correct_year_checking;

BEGIN	
	threshold_num := TO_NUMBER(threshold);

	if correct_year_checking(year) = 1 then	
	RAISE_APPLICATION_ERROR(-20001, 'Неверный год: ' || year);
	end if;
	
	IF threshold < 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'Пороговое значение заказов должно быть больше 0');
	END IF;

	-- если не открыть курсор, то будет внутренняя ошибка с номером ORA-01001 INVALID_CURSOR
    OPEN subscriber_cursor;


    -- Перебираем результаты курсора
    LOOP
        FETCH subscriber_cursor INTO f_ORD_sender_name, f_ORD_sender_address, f_ORD_sender_phone, orders_count;
        EXIT WHEN subscriber_cursor%NOTFOUND;

        -- Выводим результаты в SQL*Plus
        DBMS_OUTPUT.PUT_LINE(
            'Имя отправителя: ' || f_ORD_sender_name ||
            ', Адрес отправителя: ' || f_ORD_sender_address ||
            ', Телефон отправителя: ' || f_ORD_sender_phone ||
            ', количество заказов: ' || orders_count);

        -- Увеличиваем счетчик общего количества подписчиков
        total_subscribers := total_subscribers + 1;

    END LOOP;

    -- Закрываем курсор
    CLOSE subscriber_cursor;

    -- Возвращаем общее количество подписчиков
    RETURN total_subscribers;
EXCEPTION
    WHEN correct_year THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN correct_threshold THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('В таблице orders нет данных за указанный год.');
	when INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Вы не корректно работаете с курсором');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLCODE || ' - ' || SQLERRM);
		return 0;
END local_subscribers_with_more_subscriptions;

END my_package;

/

____TESTING____:

____END____.
6.	
____TASK____: 
Написать анонимный PL/SQL-блок, в котором будут вызовы реализованных функций и 
процедур пакета с различными характерными значениями параметров для проверки 
правильности работы основных задач и обработки исключительных ситуаций.
____CODE____:
-- Использование пакета

DECLARE
year NUMBER := 2023;
--year NUMBER := 2023;
--year NUMBER := 2024;

--threshold_num NUMBER := 1;
--threshold_varchar CHAR(1) := '1';

threshold_num NUMBER := 0;
threshold_varchar CHAR(1) := '0';

--threshold_num NUMBER := 3;
threshold_varchar1 CHAR(3) := 'abc';

BEGIN
my_package.copy_orders_to_aux_table;
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('Количество подписчиков, оформивших более ' || threshold_num || ' подписки за год ' || year || ' : ' || my_package.local_subscribers_with_more_subscriptions(year, threshold_num));
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('Количество подписчиков, оформивших более ' || threshold_num || ' подписки за год ' || year || ' : ' || my_package.local_subscribers_with_more_subscriptions(year, threshold_varchar));
DBMS_OUTPUT.PUT_LINE('Количество подписчиков, оформивших более ' || threshold_num || ' подписки за год ' || year || ' : ' || my_package.local_subscribers_with_more_subscriptions(year, threshold_varchar1));
END;
/

____TESTING____:
____END____.
--------------------------

удалил что-то

delete from orders where order_num = 6;
insert into Orders(ORD_sender_name,ORD_sender_address,ORD_sender_phone,ORD_sending_office,ORD_employee_placing_the_order_num,ORD_package_weight,ORD_package_scope,ORD_package_receipt_date,ORD_declared_value_amount,ORD_cash_on_dlvry_amount,ORD_fragile,ORD_completeness_check,ORD_arrival_date,ORD_recipient_name,ORD_recipient_address,ORD_recipient_phone,ORD_receiving_office,ORD_shipping_cost,ORD_deliv_type_code,ORD_cash_payment) values('Petr Petrovich','Minsk, 12 Poaw a Street','+375(44)111-11-15',1,5,80,0.001,DATE '2023-10-03',50,250,'No','Yes',NULL,'Jack Harlow','Minsk, 22 st to Selmash','+375(44)166-31-24',3,10.20,1,'No');


delete from orders where order_num = 10;
insert into Orders(ORD_sender_name,ORD_sender_address,ORD_sender_phone,ORD_sending_office,ORD_employee_placing_the_order_num,ORD_package_weight,ORD_package_scope,ORD_package_receipt_date,ORD_declared_value_amount,ORD_cash_on_dlvry_amount,ORD_fragile,ORD_completeness_check,ORD_arrival_date,ORD_recipient_name,ORD_recipient_address,ORD_recipient_phone,ORD_receiving_office,ORD_shipping_cost,ORD_deliv_type_code,ORD_cash_payment) values('Hanna Michalevich','Minsk, 13 Ualskay a Street','+375(44)107-12-15',2,5,50,0.001,DATE '2023-10-03',100,150,'No','Yes',NULL,'Kanye West','Minsk, 43 st to Belitsa','+375(44)906-31-24',3,10.02,1,'No');

--------------------------

PROCEDURE copy_orders_to_aux_table;

FUNCTION local_subscribers_with_more_subscriptions(year IN NUMBER, threshold IN NUMBER) RETURN NUMBER;

FUNCTION local_subscribers_with_more_subscriptions(year IN NUMBER, threshold IN VARCHAR2) RETURN NUMBER ;