###################################_3_LABA_#############################
2.1)	горизонтальное обновляемое представление с условием (WHERE)

create or replace view view2_first AS
select * from staff 
where staff.stf_position_code in
(select position_code from positions
where positions.pst_name = 'Courier' or positions.pst_name = 'Employee')
WITH CHECK OPTION;
------
create or replace view view2_first AS
select * from staff 
where staff.stf_position_code = 1 or staff.stf_position_code = 3
WITH CHECK OPTION;
------
2.2) проверить обновляемость горизонтального представления с фразой 
WITH CHECK OPTION при помощи одной из инструкций UPDATE, DELETE, INSERT 
(привести примеры выполняющихся и не выполняющихся инструкций, объяснить);

insert into view2_first(STF_name,STF_birth_date,STF_address,STF_position_code,STF_email,STF_passport_details,STF_branch_num,STF_phone_num) 
values('Shobic I.P.',DATE '2003-01-11','Minsk, Braginskiy 1',2,'Shobic2003@gmail.com','HB3433353',1,'+375(44)500-66-12');

insert into view2_first(STF_name,STF_birth_date,STF_address,STF_position_code,STF_email,STF_passport_details,STF_branch_num,STF_phone_num) 
values('Dvornic K.T.',DATE '2003-05-06','Minsk, Charota ul 1-59',1,'Dvornic2003@gmail.com','HB2252352',1,'+375(44)521-65-15');

2.3)Создать вертикальное или смешанное необновляемое представление, предназначенное для работы с основной таблицей 
БД (в представлении должны содержаться сведения из основной дочерней таблицы и/или корзины (если есть), но вместо 
внешних ключей использовать связанные данные родительских таблиц, понятные конечному пользователю представления);
2.4) доказать необновляемость представления из предыдущего пункта, проверив возможность 
выполнения инструкций UPDATE, DELETE, INSERT над представлением. Сохранить полученный результат 
(сообщение об ошибке или об успешном выполнении), объяснить причины;
create or replace view view2_third AS
select distinct orders.order_num as order_number,
orders.ORD_package_receipt_date,
orders.ord_sender_name as order_sender_name,
branch.BR_address as sending_office_address,
delivery_type.dlv_delivery_method as delivery_method,
staff.stf_name as placing_the_order_employee_name
from orders
inner join branch on orders.ORD_sending_office = branch.branch_num
inner join delivery_type on orders.ORD_deliv_type_code = delivery_type.DLV_code
inner join staff on orders.ORD_employee_placing_the_order_num = staff.Staff_num
where to_char(orders.ORD_package_receipt_date, 'MM') = '03';

select * from view2_third;

delete from view2_third
where order_number = 1;

2.5) cоздать обновляемое представление для работы с одной из родительских таблиц 
индивидуальной БД и через него разрешить работу с данными только в рабочие дни 
(с понедельника по пятницу) и в рабочие часы (с 9:00 до 17:00) с учетом часового пояса.

CREATE OR REPLACE VIEW view2_fifth AS
SELECT *
FROM staff
WHERE (TO_CHAR(SYSDATE, 'D') BETWEEN '1' AND '5')
  AND (TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN '09:00' AND '17:00')
WITH CHECK OPTION;

select * from view2_fifth;
