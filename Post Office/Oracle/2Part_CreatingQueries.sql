-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ЗАПРОСЫ------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

3.1 УСЛОВНЫЙ:
отправители, входящие в первое отправление 

insert into Orders(ORD_sender_name,ORD_sender_address,ORD_sender_phone,ORD_sending_office,ORD_employee_placing_the_order_num,ORD_package_weight,ORD_package_scope,ORD_package_receipt_date,ORD_declared_value_amount,ORD_cash_on_dlvry_amount,ORD_fragile,ORD_completeness_check,ORD_arrival_date,ORD_recipient_name,ORD_recipient_address,ORD_recipient_phone,ORD_receiving_office,ORD_shipping_cost,ORD_deliv_type_code,ORD_cash_payment) values('Maurice Wilson','Minsk, 15th Street to Parachute','+375(44)113-77-12',1,3,200,0.011,DATE '2023-09-12',44,50,'No','Yes',NULL,'Apa Sherpa','Minsk, 2 to Baikal Str','+375(44)120-89-87',4,25.00,2,'Yes');
insert into Orders(ORD_sender_name,ORD_sender_address,ORD_sender_phone,ORD_sending_office,ORD_employee_placing_the_order_num,ORD_package_weight,ORD_package_scope,ORD_package_receipt_date,ORD_declared_value_amount,ORD_cash_on_dlvry_amount,ORD_fragile,ORD_completeness_check,ORD_arrival_date,ORD_recipient_name,ORD_recipient_address,ORD_recipient_phone,ORD_receiving_office,ORD_shipping_cost,ORD_deliv_type_code,ORD_cash_payment) values('Dorje Mingma','Minsk, 160 to East Street','+375(44)114-12-42',3,5,100,0.012,DATE '2023-09-10',23,400,'No','No',NULL,'Phurba Tashi Sherpa','Minsk, 2 to Starinovskaya Street','+375(44)121-22-31',2,96.40,1,'Yes');
insert into Orders(ORD_sender_name,ORD_sender_address,ORD_sender_phone,ORD_sending_office,ORD_employee_placing_the_order_num,ORD_package_weight,ORD_package_scope,ORD_package_receipt_date,ORD_declared_value_amount,ORD_cash_on_dlvry_amount,ORD_fragile,ORD_completeness_check,ORD_arrival_date,ORD_recipient_name,ORD_recipient_address,ORD_recipient_phone,ORD_receiving_office,ORD_shipping_cost,ORD_deliv_type_code,ORD_cash_payment) values('Shao Shi-Ching','Minsk, 1-7 lane viaduct','+375(44)115-64-21',1,6,800,0.023,DATE '2023-09-09',520,1000,'Yes','No',NULL,'Dorje Gyalgen Sherpa','Minsk, 22 st to Tomsk','+375(44)122-17-20',3,12.80,2,'No');
insert into Orders(ORD_sender_name,ORD_sender_address,ORD_sender_phone,ORD_sending_office,ORD_employee_placing_the_order_num,ORD_package_weight,ORD_package_scope,ORD_package_receipt_date,ORD_declared_value_amount,ORD_cash_on_dlvry_amount,ORD_fragile,ORD_completeness_check,ORD_arrival_date,ORD_recipient_name,ORD_recipient_address,ORD_recipient_phone,ORD_receiving_office,ORD_shipping_cost,ORD_deliv_type_code,ORD_cash_payment) values('Jake Breitenbach','Minsk, 18 to the Koltsov Street','+375(44)116-12-15',2,5,900,0.021,DATE '2023-09-11',100,1000,'No','Yes',NULL,'Mingma Tsiri Sherpa','Minsk, 33 st to Baikal','+375(44)124-31-24',3,19.12,1,'No');

insert into Basket (Departure_num, Order_num) values(1,9);
insert into Basket (Departure_num, Order_num) values(1,10);
insert into Basket (Departure_num, Order_num) values(1,11);
insert into Basket (Departure_num, Order_num) values(1,12);

select basket.Departure_num, Orders.ORD_sender_name
from basket 
inner join Orders
on Basket.Order_num = Orders.Order_num and Basket.Departure_num = 1
order by 2; 

3.2 ИТОГОВЫЙ:
количество заказов на каждое отправление 

insert into Orders(ORD_sender_name,ORD_sender_address,ORD_sender_phone,ORD_sending_office,ORD_employee_placing_the_order_num,ORD_package_weight,ORD_package_scope,ORD_package_receipt_date,ORD_declared_value_amount,ORD_cash_on_dlvry_amount,ORD_fragile,ORD_completeness_check,ORD_arrival_date,ORD_recipient_name,ORD_recipient_address,ORD_recipient_phone,ORD_receiving_office,ORD_shipping_cost,ORD_deliv_type_code,ORD_cash_payment) values('Lakpa Rita Sherpa','Minsk, 41 Draw a Street','+375(44)117-12-15',2,5,100,0.001,DATE '2023-09-11',104,300,'No','Yes',NULL,'Kenton Cool','Minsk, 43 st to Starobin','+375(44)126-31-24',3,10.12,1,'No');

insert into Departure(Vehicle_code,DPTR_sending_office_address,DPTR_staff_num,DPTR_driver_departure_date) values(3, 'Minsk, 6 to Krasnozvezdnaya Street', 4, DATE '2023-09-17');


insert into Basket (Departure_num, Order_num) values(5,13);

select basket.Departure_num, count(basket.order_num) orders_amount
from basket
group by basket.Departure_num
order by 1;

3.3 ПАРАМЕТРИЧЕСКИЙ:
заказы дешевле заданной стоимости

select orders.*
from orders
where orders.ORD_shipping_cost < &the_shipping_cost_limit
order by 1;

3.4 запрос на объединение.
вывести общий список отправителей и курьеров 

!!!!!!!!!!!!!!!!!!!нельзя понять, кто есть кто. нужно определять курьера и отправителя.
+ досчитать для отправителя кол-во отправленных посылок, а для курьера кол-во отправлений(доставленных)

select t1.sender_name, t1.orders_amount, t2.STF_name, t2.Departure_amount from 
(select orders.ORD_sender_name as sender_name, count(orders.order_num) as orders_amount
from orders 
group by orders.ORD_sender_name) t1
left outer join 
(select staff.STF_name, count(Departure.Departure_num) as Departure_amount
from staff 
inner join departure 
on staff.Staff_num = Departure.DPTR_staff_num
group by staff.STF_name) t2
on t2.Departure_amount >= 0;

------исправленный вариант
select t1.Courier_name as Person, t1.PST_name as role_name, departure_amount as departure_or_orders_amount from
(select distinct staff.STF_name as Courier_name, Positions.PST_name, count(Departure.Departure_num) as departure_amount
from Departure
inner join staff on Departure.DPTR_staff_num = staff.Staff_num 
inner join Positions on staff.STF_position_code = positions.Position_code
group by staff.STF_name,Positions.PST_name) t1
union select t2.ORD_sender_name,'Sender',t2.order_amount from
(select distinct orders.ORD_sender_name, count(orders.Order_num) as order_amount
from orders
group by ORD_sender_name) t2
order by role_name;
-------


3.5 итоговый запрос с использованием группировки по части поля с типом дата
суммарное количество заказов, оформленных по каждому дню, когда в целом были оформлены заказы
select ORD_package_receipt_date, count(order_num)
from orders 
group by ORD_package_receipt_date
order by 1;

суммарное количество отделений, оформлявших заказы по каждому дню, когда в целом были оформлены заказы

!!!!!!!!!!!!!!!!!!!!!!!!!!группировка по Части даты. какой день недели наиболее загруженный.

------исправленный вариант
select to_char(orders.ORD_package_receipt_date, 'D') as weekday, count(orders.order_num)
from orders
where to_char(orders.ORD_package_receipt_date, 'D') = '1'
group by to_char(orders.ORD_package_receipt_date, 'D') 
order by 1;

select to_char(orders.ORD_package_receipt_date, 'D') as weekday, count(orders.order_num)
from orders
group by to_char(orders.ORD_package_receipt_date, 'D') 
order by 1;

-------


select t1.ORD_package_receipt_date, count(Branch_num) from
(select distinct orders.ORD_package_receipt_date, branch.Branch_num
from branch
inner join orders
on branch.Branch_num = orders.ORD_sending_office) t1
group by t1.ORD_package_receipt_date
order by t1.ORD_package_receipt_date;

4.1	с внутренним соединением таблиц, используя стандартный синтаксис SQL (JOIN…ON, JOIN…USING или NATURAL JOIN), 
который не применялся в предыдущих запросах:

список сотрудников со списком номеров отделений, к которым эти сотрудники принадлежат

!!!!!!!!!!!!!!!!!!!!!!!! другой тип запроса

select branch.Branch_num, Staff.Staff_num, Staff.STF_name 
from branch
inner join Staff
on branch.Branch_num = staff.STF_branch_num
order by branch.Branch_num;

отправления, которые есть в basket, и для них выводим номер машины и адрес отделения
------исправленный вариант
select distinct departure.Vehicle_code, departure.DPTR_sending_office_address
from departure 
join basket 
using (departure_num)
order by 1;

select distinct departure_num, Vehicle_code, DPTR_sending_office_address
from departure d
join basket b
using (departure_num)
order by 1;
-------

количество авто, купленных компанией отделений у определенных дилеров - вывести список дилеров и кол-во купленных авто у каждого
select 

4.2 с внешним соединением таблиц, используя FULL JOIN, LEFT JOIN или RIGHT JOIN, при этом обязательным является наличие в 
БД данных, которые будут выводиться именно с выбранным оператором внешнего соединения

всевозможные типы кпп - присущие автомобилям в текущем автопарке

select gearbox.GEAR_type, Vehicle.VHC_model
from Gearbox
left outer join Vehicle
on gearbox.GEAR_code = vehicle.VHC_gear_code
order by 1;

4.3 с использованием предиката IN с подзапросом
вывести все должности, где необходимо высшее и среднее образование

select positions.PST_name
from positions
where positions.PST_min_level_of_education_code 
IN (select Education_levels.EDCT_LVL_code 
from Education_levels 
where Education_levels.EDCT_LVL_educational_background = 'Higher education' or Education_levels.EDCT_LVL_educational_background = 'General average');

4.4  с использованием предиката ANY/ALL с подзапросом

вывести всех сотрудников, чья зп больше чем средняя зп всех отделений

select t1.STF_name as employee_name, t1.PST_min_salary as salary from
(select staff.STF_name, positions.PST_min_salary
from Staff
inner join Positions
on staff.STF_position_code = positions.Position_code) t1
where t1.PST_min_salary > all(select avg(Positions.PST_min_salary)
from Staff
inner join Positions on staff.STF_position_code = positions.Position_code
inner join branch on staff.STF_branch_num = branch.Branch_num
group by branch.Branch_num);
----
select t1.STF_name as employee_name, t1.PST_min_salary as salary, t2.STF_branch_num as branch_num, t2.avg_salary as avg_salary from
(select staff.STF_name, positions.PST_min_salary, staff.STF_branch_num
from Staff
inner join Positions
on staff.STF_position_code = positions.Position_code) t1,
(select staff.STF_branch_num, avg(Positions.PST_min_salary) as avg_salary
from Staff
inner join Positions on staff.STF_position_code = positions.Position_code
inner join branch on staff.STF_branch_num = branch.Branch_num
group by staff.STF_branch_num) t2
where (t1.PST_min_salary > all t2.avg_salary) and t1.stf_branch_num = t2.STF_branch_num
order by 3;

4.5 с использованием предиката EXISTS/NOT EXISTS с подзапросом
вывести список работников, которые участвуют в процессе получения посылки от отправителя

select staff.STF_name from Staff
where exists (select 1 from Orders
where orders.ORD_employee_placing_the_order_num = staff.Staff_num);

2.Обновить одной командой информацию о максимальной рентной стоимости объектов, уменьшив стоимость квартир
на 5 %, а стоимость домов увеличив на 7 %.

Обновить одной командой информацию о зарплате сотрудников, уменьшив зарплату 
курьеров на 5 %, а зарплату работников увеличив на 7 %.

update Positions set PST_min_salary = 
case	
	when PST_name = 'Courier' then (PST_min_salary*0.97)
	when PST_name = 'Branch chief employee' then (PST_min_salary + PST_min_salary*0.07)
	when PST_name = 'Truck driver' then (PST_min_salary + PST_min_salary*0.07)
	when PST_name = 'Branch network CEO' then (PST_min_salary + PST_min_salary*0.07)
	when PST_name = 'Employee' then (PST_min_salary + PST_min_salary*0.07)
end;


alter table Positions
drop column PST_min_salary;

alter table Positions
add PST_min_salary number(38,3);

update Positions
set PST_min_salary = 800.0
where Position_code = 1;

update Positions
set PST_min_salary = 1500.0
where Position_code = 2;

update Positions
set PST_min_salary = 1000.0
where Position_code = 3;

update Positions
set PST_min_salary = 900.0
where Position_code = 4;

update Positions
set PST_min_salary = 2000.0
where Position_code = 5;
