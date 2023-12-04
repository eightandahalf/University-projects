--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------6 LABA------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
____TASK____: 
1.	Написать с помощью пакета DBMS_SQL динамическую процедуру или функцию, в которой заранее неизвестен текст 
команды SELECT. Предусмотреть возможность вывода разных результатов, в зависимости от количества передаваемых 
параметров.
order by. having. from two tables. exception(если ...)
:
передавать в качестве первого параметра имя таблицы, а в качестве второго параметра коллекцию из переменных, 
которые мы хотим вывести

написать динамическую процедуру, которая будет принимать параметры для выбора данных из таблиц, 
то есть сначала мы коннектим две таблицы, и выбираем из них какие-то данные, например зп для сотрудников,
чей возраст больше 25 лет. если что-то не соответствует, то raise exception.
1.	Открытие курсора (OPEN_CURSOR).
2.	Выполнение грамматического разбора (PARSE).
3.	Выполнение привязки всех входных переменных (BIND_VARIABLE).
4.	Описание элементов списка выбора (DEFINE_COLUMN).
5.	Исполнение запроса (EXECUTE).
6.	Считывание строк (FETCH).
7.	Запись результатов в переменные (COLUMN_VALUE).
8.	Закрытие курсора (CLOSE_CURSOR).


order - ok - by 
having - это count > чем что-то, если правильно понимаю
если есть having, то должен быть count
exception

тогда, select, который будет выбирать инфу об отправителях, которые оформили 
количество заказов за указанный год больше, чем указано во входном параметре, 
а также, которые оформляли заказ в отделении, указанном во входном параметре.

				1)тогда, я буду передавать данные о столбцах, для которых я хочу получить данные.
				2)имена двух таблиц, которые я буду связывать.
				3)столбец, по которому я буду осуществлять count. 
				4)значение, больше которого должен быть having count.
				5)столбец, по которому должен осуществляться order by.
				
поэтому я должен сделать типы, в котором буду отдельно перечислять стоблцы и т.п.
____CODE____:
///////MY procedure

create or replace procedure select_dynamic_sql( 
	p_column_to_select IN six_one_columns_to_select_type,
	p_from_table IN varchar2,
	p_type_of_join IN six_one_join_type,
	p_tables_to_join_type IN six_one_tables_to_join_type,
	p_on_conditions IN six_one_on_conditions_type,
	p_number_of_count_column_in_select in NUMBER,
	p_order_by_column IN NUMBER,
	p_having_condition IN six_one_having_condition_type
)
IS 
sqltext varchar2(2000) := 'SELECT';
space_comma varchar2(2) := ' ';
from_word varchar2(10) := 'FROM';
join_word varchar2(10) := 'JOIN';
on_word varchar2(10) := 'ON';
groupby_word varchar2(10) := 'GROUP BY';
having_word varchar2(15) := 'HAVING COUNT(';
count_word varchar2(10) := 'COUNT(';
right_bracket varchar2(10) := ')';
orderby_word char(9) := 'ORDER BY';

p_column_to_select_index number;
p_type_of_join_index number;
p_column_to_group_by_index number;
p_having_column_index number;
p_order_by_column_index number;
p_on_conditions_index number;

p_columns_counter number;
p_having_counter number;
p_asterisk_flag number;

s VARCHAR2 (250);
table_cursor number;
cnt INTEGER;

TYPE col_inf_type IS RECORD (name VARCHAR2 (50),
value VARCHAR2 (1000));

TYPE list_col_type IS TABLE OF col_inf_type;
list_col list_col_type := list_col_type ();

asterisk_and_smthng_else_in_select EXCEPTION;
PRAGMA EXCEPTION_INIT (asterisk_and_smthng_else_in_select, -00001);

begin
	dbms_output.enable(100000);
	
	p_column_to_select_index := p_column_to_select.FIRST;
	p_type_of_join_index := p_type_of_join.FIRST;
	p_column_to_group_by_index := p_column_to_select.FIRST;
	p_having_column_index := p_column_to_select.FIRST;
	p_order_by_column_index := p_column_to_select.FIRST;
	p_on_conditions_index := p_on_conditions.FIRST;

	p_asterisk_flag := 0;
	p_having_counter := 0;
	p_columns_counter := 1;
	
	dbms_output.PUT_LINE(p_column_to_group_by_index);


-- ПРОВЕРКА, НЕ ПЕРЕДАНА ЛИ ТОЛЬКО ЗВЕЗДОЧКА
WHILE p_column_to_select_index IS NOT NULL LOOP
	IF p_column_to_select(p_column_to_select_index) = '*' AND p_asterisk_flag = 0 THEN
		p_asterisk_flag := 1;
	ELSIF p_asterisk_flag = 1 THEN
		RAISE asterisk_and_smthng_else_in_select;
	END IF;

    p_column_to_select_index := p_column_to_select.NEXT(p_column_to_select_index);
END LOOP;

IF p_asterisk_flag = 1 THEN
-- ЗВЕЗДОЧКА В SELECT
   FOR c IN (SELECT column_name FROM all_tab_columns
			  WHERE owner = UPPER (USER)
			  AND table_name = UPPER (p_from_table))
   LOOP
	IF p_columns_counter = p_number_of_count_column_in_select THEN
		sqltext:= sqltext || space_comma || count_word || c.column_name || right_bracket;
		space_comma := ', ';

	ELSE 
		sqltext:=
		sqltext || space_comma || c.column_name;
		space_comma:= ',';
	END IF;
	
	p_columns_counter := p_columns_counter + 1;
	
	list_col.EXTEND;
	list_col (list_col.LAST).name := c.column_name;
	   END LOOP;
ELSE 
-- НЕ ЗВЕЗДОЧКА В SELECT 
	p_column_to_select_index := p_column_to_select.FIRST;

	-----SELECT
	WHILE p_column_to_select_index IS NOT NULL LOOP
		-- access the array element
			
		-- ПРИ ПОМОЩИ dbms_output ПРОВЕРИТЬ С КАКОГО ЧИСЛА НАЧИНАЕТСЯ ОТСЧЕТ: начало с единицы
		IF p_column_to_select_index = p_number_of_count_column_in_select then
			sqltext:= sqltext || space_comma || count_word || p_column_to_select(p_column_to_select_index) || right_bracket;
			space_comma := ', ';
		ELSE 	
			sqltext := sqltext || space_comma || p_column_to_select(p_column_to_select_index);
			space_comma := ', ';	
		END IF;
		
		list_col.EXTEND;
		list_col(list_col.LAST).name := p_column_to_select(p_column_to_select_index);

		p_column_to_select_index := p_column_to_select.NEXT(p_column_to_select_index);
	END LOOP;
END IF;

	space_comma:= ' ';
	
-----FROM
	-- access the array element
	sqltext:= sqltext || space_comma || from_word || space_comma || p_from_table;
	
	space_comma := ' ';

-----... JOIN ON
WHILE p_type_of_join_index IS NOT NULL LOOP
	dbms_output.put_line('TATATAT');

	-- access the array element
	IF p_on_conditions_index IS NOT NULL THEN
	dbms_output.put_line('BABABABAB');
	sqltext:= sqltext || space_comma || p_type_of_join(p_type_of_join_index) || space_comma || 
		join_word || space_comma || p_tables_to_join_type(p_type_of_join_index) || space_comma || on_word || 
		space_comma || p_on_conditions(p_type_of_join_index) || space_comma;
	-- now we will open array that contain ON conditions
	ELSE 
	dbms_output.put_line('HAHAHHAHAAH');
	sqltext:= sqltext || space_comma || p_type_of_join(p_type_of_join_index) || space_comma || 
		join_word || space_comma || p_tables_to_join_type(p_type_of_join_index) || space_comma;
	END IF;

	p_type_of_join_index := p_type_of_join.NEXT(p_type_of_join_index);
END LOOP;

	space_comma := ' ';
	
------GROUP BY
p_columns_counter := 1;
IF p_asterisk_flag = 1 THEN
	-- ЗВЕЗДОЧКА В SELECT
	FOR c IN (SELECT column_name FROM all_tab_columns
			  WHERE owner = UPPER (USER)
			  AND table_name = UPPER (p_from_table))
	LOOP
	IF p_columns_counter != p_number_of_count_column_in_select THEN
		if groupby_word != ' ' then
			sqltext := sqltext || space_comma || groupby_word;
			groupby_word := ' ';
		end if;

		sqltext:= sqltext || space_comma || c.column_name;
		space_comma := ', ';
	END IF;

	p_columns_counter := p_columns_counter + 1;
	END LOOP;
ELSE
	WHILE p_column_to_group_by_index IS NOT NULL LOOP
		-- access the array element
		IF p_column_to_group_by_index != p_number_of_count_column_in_select then
			IF groupby_word != ' ' THEN
				sqltext := sqltext || groupby_word;
				groupby_word := ' ';
			END IF;

			sqltext := sqltext || space_comma || p_column_to_select(p_column_to_group_by_index);
			space_comma := ', ';
		END IF;

		p_column_to_group_by_index := p_column_to_select.NEXT(p_column_to_group_by_index);
	END LOOP;
END IF;

	space_comma := ' ';

-----HAVING COUNT
p_columns_counter := 1;
IF p_asterisk_flag = 1 THEN
	-- ЗВЕЗДОЧКА В SELECT
	FOR c IN (SELECT column_name FROM all_tab_columns
			  WHERE owner = UPPER (USER)
			  AND table_name = UPPER (p_from_table))
	LOOP
	IF p_columns_counter = p_number_of_count_column_in_select THEN
		p_having_counter := p_having_counter + 1;
		sqltext := sqltext || space_comma || having_word || c.column_name || right_bracket || 
		space_comma || p_having_condition(p_having_counter);
	END IF;

	p_columns_counter := p_columns_counter + 1;
	END LOOP;
ELSE
	WHILE p_having_column_index IS NOT NULL LOOP
		-- access the array element
		if p_having_column_index = p_number_of_count_column_in_select then
			p_having_counter := p_having_counter + 1;
			sqltext := sqltext || space_comma || having_word || p_column_to_select(p_having_column_index) || right_bracket || 
			space_comma || p_having_condition(p_having_counter);
		end if;
		
		p_having_column_index := p_column_to_select.NEXT(p_having_column_index);
	END LOOP;
END IF;
	
	space_comma := ' ';

-----ORDER BY
p_columns_counter := 1;
IF p_asterisk_flag = 1 THEN
	-- ЗВЕЗДОЧКА В SELECT
	FOR c IN (SELECT column_name FROM all_tab_columns
			  WHERE owner = UPPER (USER)
			  AND table_name = UPPER (p_from_table))
	LOOP
	IF p_columns_counter = p_order_by_column THEN
		p_having_counter := p_having_counter + 1;
		sqltext := sqltext || space_comma || orderby_word || c.column_name;
	END IF;

	p_columns_counter := p_columns_counter + 1;
	END LOOP;
ELSE
	WHILE p_order_by_column_index IS NOT NULL LOOP
		-- access the array element
		IF p_order_by_column_index = p_order_by_column THEN
			sqltext := sqltext || space_comma || orderby_word || p_column_to_select(p_order_by_column_index);
		END IF;
		
		p_order_by_column_index := p_column_to_select.NEXT(p_order_by_column_index);
	END LOOP;
END IF;
	
	dbms_output.put_line(sqltext);
	
	-- here we will parsing sqltext=select
	
	table_cursor := DBMS_SQL.open_cursor;
	
	DBMS_SQL.parse (table_cursor, sqltext, DBMS_SQL.native);
	
	
	FOR i IN list_col.FIRST ..list_col.LAST
	LOOP
		DBMS_SQL.DEFINE_COLUMN (table_cursor, i, list_col(i).VALUE, 1000);
	END LOOP;

	cnt := DBMS_SQL.EXECUTE (table_cursor);
	
	-- DBMS_OUTPUT.put_line ('Введенный запрос '
						 -- || ' содержит '
						 -- || cnt
						 -- || ' строк.');
	cnt := 0;


	LOOP
		IF DBMS_SQL.fetch_rows(table_cursor) = 0 THEN
			EXIT;
		END IF;
		cnt := cnt + 1;
		s := cnt || '.';
		
		FOR i IN list_col.FIRST ..list_col.LAST
		LOOP
			DBMS_SQL.column_value(table_cursor, i, list_col(i).VALUE);
			s := s || ' ' || list_col(i).VALUE;
		END LOOP;
		
		DBMS_OUTPUT.put_line (SUBSTR (s, 1, 255));
	END LOOP;
	DBMS_SQL.close_cursor (table_cursor);

	EXCEPTION
	WHEN asterisk_and_smthng_else_in_select THEN
		DBMS_OUTPUT.PUT_LINE('В Select передана не только звездочка "*"');
	when others then 
	IF SQLCODE = -936 THEN
		  DBMS_OUTPUT.PUT_LINE('Ошибка: ORA-00936: Некорректные данные при перечислении стобцов в SELECT');
	ELSIF SQLCODE = -903 THEN
		  DBMS_OUTPUT.PUT_LINE('Ошибка: ORA-00903: Некорректные имена таблиц');
	ELSIF SQLCODE = -933 THEN
		  DBMS_OUTPUT.PUT_LINE('Ошибка: ORA-00933: Некорректно определен тип соединения таблиц');
	ELSIF SQLCODE = -920 THEN
		  DBMS_OUTPUT.PUT_LINE('Ошибка: ORA-00936: Некорректно введены условия');
	ELSE
	  DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
		END IF;

end;
/

//////////////CREATING NEW TYPES OF DATA
    -- declare an associative array type
    CREATE OR REPLACE TYPE six_one_columns_to_select_type IS TABLE OF varchar2(100);
	/
	CREATE OR REPLACE TYPE six_one_join_type IS TABLE OF varchar2(100);
	/
	CREATE OR REPLACE TYPE six_one_on_conditions_type IS TABLE OF varchar2(100);
	/
	CREATE OR REPLACE TYPE six_one_tables_to_join_type IS TABLE OF varchar2(100);
	/
	CREATE OR REPLACE TYPE six_one_having_condition_type IS TABLE OF varchar2(100);
	/

begin
dbms_output.put_line('hahahah');
end;
/


///////MY ANONYMOUS BLOCK
DECLARE
    six_one_columns_to_select six_one_columns_to_select_type := six_one_columns_to_select_type();
	six_one_from_table varchar2(100);
	six_one_type_of_join six_one_join_type := six_one_join_type();
	six_one_on_conditions six_one_on_conditions_type := six_one_on_conditions_type();
	six_one_number_of_count_column_in_select number;
	six_one_order_by_column number;
	six_one_tables_to_join six_one_tables_to_join_type := six_one_tables_to_join_type();
	six_one_having_condition six_one_having_condition_type := six_one_having_condition_type();
BEGIN
    -- six_one_columns_to_select := six_one_columns_to_select_type('ORDER_NUM', 
	-- 'ORD_SENDER_NAME', 'ORD_SENDER_ADDRESS', 'ORD_SENDER_PHONE');
	
    six_one_columns_to_select := six_one_columns_to_select_type('*');
	
	six_one_from_table := 'ORDERS';

    six_one_type_of_join := six_one_join_type('CROSS');
	-- six_one_type_of_join := six_one_join_type('INNER');

	six_one_tables_to_join := six_one_tables_to_join_type('BRANCH');
	-- six_one_tables_to_join := six_one_tables_to_join_type('POSITIONS');

	-- six_one_on_conditions := six_one_on_conditions_type('ORD_SENDING_OFFICE = BRANCH_NUM AND BRANCH_NUM = 1');
	-- six_one_on_conditions := six_one_on_conditions_type('ORD_SENDING_OFFICE = POSITION_CODE AND POSITION_CODE = 1');

	-- six_one_number_of_count_column_in_select := 1;
	
	six_one_order_by_column := 1;
	
	-- six_one_having_condition := six_one_having_condition_type('> 0');
	
	-- now we will call procedure
	
	select_dynamic_sql(six_one_columns_to_select, six_one_from_table,
	six_one_type_of_join, six_one_tables_to_join, six_one_on_conditions, six_one_number_of_count_column_in_select,
	six_one_order_by_column, six_one_having_condition);
	
END;
/
/////////////////////////////////////////////////////////////////////////////
____TESTING____:
____END____.


____TASK____: 
6.2. Написать, используя встроенный динамический SQL, процедуру создания в БД нового 
объекта (представления или таблицы) на основе существующей таблицы. Имя нового объекта 
должно формироваться динамически и проверяться на существование в словаре данных. В качестве 
входных параметров указать тип нового объекта, исходную таблицу, столбцы и количество строк, 
которые будут использоваться в запросе.
____CODE____:
CREATE OR REPLACE PROCEDURE six_two_CreateNewObject(
    p_object_type IN VARCHAR2,
    p_source_table IN VARCHAR2,
    p_columns IN VARCHAR2,
    p_row_count IN NUMBER
) AS
    v_new_object_name VARCHAR2(50);
    v_sql VARCHAR2(4000);
	v_count INTEGER;
    v_current_datetime VARCHAR2(30);
BEGIN
	-- Формирование имени нового объекта
	SELECT TO_CHAR(SYSDATE, 'YYYY_MM_DD_HH24_MI_SS') INTO v_current_datetime FROM DUAL;
    v_new_object_name := p_source_table || '_' || p_object_type || '_' || v_current_datetime;
	DBMS_OUTPUT.PUT_LINE(v_new_object_name);

    -- Проверка существования объекта в словаре данных
    BEGIN
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM user_objects WHERE object_name = UPPER(:1)' INTO v_count USING v_new_object_name; -- :1 - IT'S PLACEHOLDER FOR VARIABLE v_new_object_name
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка при проверке существования объекта: ' || SQLERRM);
            RETURN;
    END;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Объект с именем ' || v_new_object_name || ' уже существует.');
        RETURN;
    END IF;

    -- Создание нового объекта
    v_sql := 'CREATE ' || p_object_type || ' ' || v_new_object_name || ' AS SELECT ' || p_columns || ' FROM ' || p_source_table || ' WHERE ROWNUM <= ' || TO_CHAR(p_row_count);

    BEGIN
        EXECUTE IMMEDIATE v_sql;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ошибка при создании объекта: ' || SQLERRM);
            RETURN;
    END;

    DBMS_OUTPUT.PUT_LINE('Объект ' || v_new_object_name || ' успешно создан.');
END;
/

____TESTING____:
BEGIN
    six_two_CreateNewObject('TABLE', 'Orders', 'ORD_SHIPPING_COST, ONLY_SENDER_NAME, ONLY_SENDER_SURNAME, ONLY_SENDER_PATRONYMIC', 10);
END;
/
____END____.


____TASK____: 
6.3.1
Создать процедуру, которая принимает в качестве параметров имя таблицы и имена четырех полей в этой таблице. 
Первое поле она интерпретирует как ФИО, разбивает его на составляющие и заполняет три оставшихся поля. Если 
значение первого поля не может быть правильно проинтерпретировано как ФИО (отсутствует отчество, имя и отчество 
или в строке встречаются недопустимые символы), она помещает в первое поле из трех оставшихся значения ключа 
(ROWID) этой записи, а во втором и третьем выводит соответствующее сообщение об ошибке строчными и прописными 
буквами.
____CODE____:

ALTER TABLE orders 
ADD ( only_sender_name VARCHAR2(50), 
only_sender_surname VARCHAR2(50), 
only_sender_patronymic VARCHAR2(50));

---my---
CREATE OR REPLACE PROCEDURE SplitFullName(
    p_table_name IN VARCHAR2,
    p_full_name_field IN VARCHAR2,
    p_first_name_field IN VARCHAR2,
    p_last_name_field IN VARCHAR2,
    p_patronymic_field IN VARCHAR2
) AS
    v_sql VARCHAR2(4000);
BEGIN
    v_sql := 'DECLARE
        CURSOR c IS SELECT ROWID, ' || p_full_name_field || ' FROM ' || p_table_name || ';
        v_full_name VARCHAR2(100);
        v_first_name VARCHAR2(100);
        v_last_name VARCHAR2(100);
        v_patronymic VARCHAR2(100);
        v_rowid ROWID;
    BEGIN
        FOR r IN c LOOP
            v_full_name := r.' || p_full_name_field || ';


			IF REGEXP_SUBSTR(v_full_name, ''[^a-zA-Z ]+'', 1, 1) IS NULL AND REGEXP_SUBSTR(v_full_name, ''[a-zA-Z]+'', 1, 4) IS NULL AND
					REGEXP_SUBSTR(v_full_name, ''[a-zA-Z]+'', 1, 1) IS NOT NULL AND REGEXP_SUBSTR(v_full_name, ''[a-zA-Z]+'', 1, 2) IS NOT NULL AND 
					REGEXP_SUBSTR(v_full_name, ''[a-zA-Z]+'', 1, 3) IS NOT NULL AND LENGTH(REGEXP_SUBSTR(v_full_name,''[^ ]+'', 1, 1)) > 3 AND 
					LENGTH(REGEXP_SUBSTR(v_full_name,''[^ ]+'', 1, 2)) > 3 AND LENGTH(REGEXP_SUBSTR(v_full_name,''[^ ]+'', 1, 3)) > 3 THEN 	
                v_first_name := REGEXP_SUBSTR(v_full_name, ''[a-zA-Z]+'', 1, 1);
                v_last_name := REGEXP_SUBSTR(v_full_name, ''[a-zA-Z]+'', 1, 2);
                v_patronymic := REGEXP_SUBSTR(v_full_name, ''[a-zA-Z]+'', 1, 3);
			ELSIF REGEXP_SUBSTR(v_full_name, ''[^a-zA-Z ]+'', 1, 1) IS NOT NULL THEN
				v_first_name := v_rowid;
                v_last_name := ''there are invalid characters in the fio'';
                v_patronymic := ''THERE ARE INVALID CHARACTERS IN THE FIO'';
			ELSIF REGEXP_SUBSTR(v_full_name, ''[a-zA-Z]+'', 1, 4) IS NOT NULL THEN
				v_first_name := v_rowid;
                v_last_name := ''the fio contains more than 3 words'';
                v_patronymic := ''THE FIO CONTAINS MORE THAN 3 WORDS'';
			ELSIF REGEXP_SUBSTR(v_full_name, ''[a-zA-Z]+'', 1, 3) IS NULL THEN
				v_first_name := v_rowid;
                v_last_name := ''the fio contains less than 3 words'';
                v_patronymic := ''THE FIO CONTAINS LESS THAN 3 WORDS'';
			ELSIF LENGTH(REGEXP_SUBSTR(v_full_name,''[^ ]+'', 1, 1)) < 4 THEN
				v_first_name := v_rowid;
                v_last_name := ''name is too short'';
                v_patronymic := ''NAME IS TOO SHORT'';
			ELSIF LENGTH(REGEXP_SUBSTR(v_full_name,''[^ ]+'', 1, 2)) < 4 THEN
				v_first_name := v_rowid;
                v_last_name := ''surname is too short'';
                v_patronymic := ''SURNAME IS TOO SHORT'';
			ELSIF LENGTH(REGEXP_SUBSTR(v_full_name,''[^ ]+'', 1, 3)) < 4 THEN
				v_first_name := v_rowid;
                v_last_name := ''patronymic is too short'';
                v_patronymic := ''PATRONYMIC IS TOO SHORT'';
			ELSE 
			    v_first_name := v_rowid;
                v_last_name := ''invalid value of full name'';
                v_patronymic := ''INVALID VALUE OF FULL NAME'';
			END IF;

			v_rowid := r.ROWID;

            EXECUTE IMMEDIATE ''UPDATE ' || p_table_name || ' SET ' || p_first_name_field || ' = :1, ' || p_last_name_field || ' = :2, ' || p_patronymic_field || ' = :3 WHERE ROWID = :4'' USING v_first_name, v_last_name, v_patronymic, v_rowid;

		END LOOP;		
    END;';

    EXECUTE IMMEDIATE v_sql;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;
/

--------

____TESTING____:

BEGIN
    SplitFullName('Orders_TABLE_New', 'ORD_SENDER_NAME', 'ONLY_SENDER_NAME', 'ONLY_SENDER_SURNAME', 'ONLY_SENDER_PATRONYMIC');
END;
/
COMMIT;

----------------------------------------------------------------примеры
SELECT
  REGEXP_SUBSTR('500 Oracle Parkway, R,edwood Shores, CA',
                ',[^e]+,') "REGEXPR_SUBSTR"
  FROM DUAL;

шаблон представляет собой следующее: нужно найти подстроки, которые
обязательно начинаются и заканчиваются запятой, и которые не содержат в себе
ни одно 'e'. [^e] - значит не соответствие с символом в строке, т.е. 'e' нам не надо, а
+ значит одно или более вхождений, т.е. одно или более вхождений без 'e'

SELECT
  REGEXP_SUBSTR('500 Oracle Parkway,s, Redwood Shores, CA',
                ',[^dsf],') "REGEXPR_SUBSTR"
  FROM DUAL;

шаблон гласит, что должна быть найдена подстрока, с одним символом между двумя запятыми,
при этом этот символ не должен равнять d, s или f.

а вот так, SELECT
  REGEXP_SUBSTR('500 Oracle Parkway,s, Redwood Shores, CA',
                ',[^df],') "REGEXPR_SUBSTR"
  FROM DUAL; найдется символ и запятые
  
пример:SELECT
  REGEXP_SUBSTR('500 Oracle Parkway,s, Redwood Shores, CA',
                '[^ ]+', 1, 3) "REGEXPR_SUBSTR"
  FROM DUAL;

в результате будет "Parkway,s,", т.к. требуется 3-е вхождение маски, отсчет с начала строки
----------------------------------------------------------------примеры
____END____.


____TASK____:
6.4
Написать программу, которая позволит для двух указанных в параметрах таблиц существующей 
БД определить, есть ли между ними связь «один ко многим». Если связь есть, то на основе 
родительской таблицы создать новую, в которой будут присутствовать все поля старой и одно 
новое поле с типом коллекции, в котором при переносе данных помещаются все связанные 
записи из дочерней таблицы.
____CODE____:

проблема - каким-то образом, мне нужно создать тип данных, такой как в дочерней таблице.
но, при этом, чтобы это сделать. стоп. сейчас

------------------
тогда мне нужно извлечь все имена столбцов из таблицы orders и используя их определить тип данных.
для начала массив заполнить именами столбцов таблицы, а потом постепенно извлекая данные из массива
создать запрос на создание типа данных.

типо, потом динамически создать тип данных as object.., на основании его сделать таблицу типа этого типа object,
и потом попытаться этот тип данных запушить в ту новую таблицу

OK. МНЕ НУЖНО СДЕЛАТЬ ЧТО-ТО ТАКОЕ 

-------ЧТО-ТО ДЕЛАЛ, ОСТАВЛЮ НА ВСЯКИЙ_НАЧАЛО
CREATE OR REPLACE TYPE orders_row AS OBJECT (
ORDER_NUM orders.ORDER_NUM%ROWTYPE);
/

	CREATE OR REPLACE TYPE col_type AS OBJECT (name VARCHAR2(100));
	/
	
	CREATE OR REPLACE TYPE table_type AS table of col_type;
	/
	
DECLARE 
	columns_var table_type := table_type();
	column_value varchar2(100);
	child_table_name varchar2(50) := 'ORDERS';
	
	-- columns_var_index := columns_var.FIRST;	
	
	-- p_having_counter := 0;

	TYPE parts_table IS TABLE OF ORDERS%ROWTYPE;
	
BEGIN	
	FOR r IN (SELECT column_name FROM all_tab_columns
			WHERE table_name = child_table_name AND OWNER = USER) LOOP

        column_value := r.column_name;
        
		columns_var.EXTEND;
		columns_var(columns_var.LAST) := col_type(column_value);
    END LOOP;
	
	FOR i IN columns_var.FIRST..columns_var.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Key: ' || i || ', Value: ' || columns_var(i).name);
    END LOOP;
	


-- -----SELECT
-- WHILE columns_var_index IS NOT NULL LOOP
    -- -- access the array element
		
	-- -- ПРИ ПОМОЩИ dbms_output ПРОВЕРИТЬ С КАКОГО ЧИСЛА НАЧИНАЕТСЯ ОТСЧЕТ: начало с единицы
	-- IF columns_var_index = p_number_of_count_column_in_select then
		-- sqltext:= sqltext || space_comma || 'to_char(' || count_word || p_column_to_select(p_column_to_select_index) || right_bracket || ')';
		-- space_comma := ', ';
	-- ELSE 	
		-- sqltext := sqltext || space_comma || 'to_char(' || p_column_to_select(p_column_to_select_index) || ')';
		-- space_comma := ', ';	
	-- END IF;
	
	-- list_col.EXTEND;
	-- list_col(list_col.LAST).name := p_column_to_select(p_column_to_select_index);

    -- p_column_to_select_index := p_column_to_select.NEXT(p_column_to_select_index);
-- END LOOP;

end;
/
-------ЧТО-ТО ДЕЛАЛ, ОСТАВЛЮ НА ВСЯКИЙ_КОНЕЦ
----------------
r_constraint_name - Name of the unique constraint definition for the referenced table

-- если у таблицы две связи один ко многим, то могут быть ошибки
-- типо, таблица может быть и одна, но столбцов несколько
DECLARE
    first_table_name VARCHAR2(100) := 'BASKET';
    second_table_name VARCHAR2(100) := 'DEPARTURE';

	one_to_many_flag number := 0;

    parent_table_name VARCHAR2(100);
    child_table_name VARCHAR2(100);
    
	child_table_type VARCHAR2(100);
	
    v_ddl_for_object VARCHAR2(4000); -- Здесь укажите максимальную длину вашего DDL-текста
    v_ddl_for_table VARCHAR2(4000); -- Здесь укажите максимальную длину вашего DDL-текста

	new_table_name varchar2(100);

	child_r_constraint_name varchar2(100);
	
	-- child_table_column_conn varchar2(100);
	parent_table_column_conn varchar2(100);
	
	-- child_constraint_name varchar2(100);
	parent_constraint_name varchar2(100);

	object_type varchar2(100);
	type_to_check varchar2(100);
	check_value integer := 0;
	check_sql varchar2(300);
	drop_sql varchar2(300);
	
	sql_transfer varchar2(1000);
	
	nested_table_sql varchar2(1000);
	nested_check_value integer := 0;
	
	list_of_columns varchar2(1000);
	
    TYPE varchar2_collection IS TABLE OF VARCHAR2(4000); -- Используйте подходящий размер для вашего случая
    child_r_constraint_names varchar2_collection;
	child_constraint_name varchar2_collection;
	child_table_column_conn varchar2_collection := varchar2_collection();
	
BEGIN
  -- Проверка наличия связи "один ко многим"
	BEGIN
		SELECT r_constraint_name
		BULK COLLECT INTO child_r_constraint_names
		FROM all_constraints
		WHERE r_constraint_name IN (
		SELECT constraint_name
		FROM all_constraints
		WHERE table_name = first_table_name
		  )
		AND table_name = second_table_name AND OWNER = USER;
		
		FOR i IN 1..child_r_constraint_names.COUNT LOOP
			one_to_many_flag := 1;
		END LOOP;
		
		EXCEPTION
			when no_data_found then
			null;
	END;
	
	if one_to_many_flag = 0 then
		SELECT r_constraint_name
		BULK COLLECT INTO child_r_constraint_names
		FROM all_constraints
		WHERE r_constraint_name IN (
		SELECT constraint_name
		FROM all_constraints
		WHERE table_name = second_table_name
		  )
		AND table_name = first_table_name AND OWNER = USER;

		FOR i IN 1..child_r_constraint_names.COUNT LOOP
			one_to_many_flag := 2;
		END LOOP;
	end if;

	if one_to_many_flag = 0 then
		RAISE no_data_found;
	end if;
	
	FOR i IN 1..child_r_constraint_names.COUNT LOOP
		DBMS_OUTPUT.PUT_LINE(child_r_constraint_names(i));
	END LOOP;
	
	if one_to_many_flag = 1 then
		parent_table_name := first_table_name;
		child_table_name := second_table_name;
	else 
		parent_table_name := second_table_name;
		child_table_name := first_table_name;
	end if;		
	
	dbms_output.PUT_LINE('PARENT:');
	dbms_output.PUT_LINE(parent_table_name);
	dbms_output.PUT_LINE('CHILD:');
	dbms_output.PUT_LINE(child_table_name);

	IF child_r_constraint_names is not null THEN

		object_type := child_table_name || '_OBJ';
		-- проверка существования типа(типа таблицы), т.к. если он есть, нельзя будет replace-нуть orders_obj
		type_to_check := child_table_name || '_TAB';
		
		check_sql := 'SELECT 1 
		FROM ALL_OBJECTS
		WHERE OWNER = USER AND OBJECT_NAME = ''' || type_to_check || '''';
			
		BEGIN
			EXECUTE IMMEDIATE check_sql into check_value;
			EXCEPTION
				when no_data_found then
					check_value := 0;
		END;
		
		dbms_output.PUT_LINE(check_value);

		IF check_value = 0 THEN
				-- drop_sql := 'DROP TYPE ' || type_to_check;
				-- DBMS_OUTPUT.PUT_LINE(drop_sql);
				-- EXECUTE IMMEDIATE drop_sql;
			-- END IF;

			-- создаем тип данных типа дочерней таблицы, чтобы его можно было вставить в новую таблицу родителя
			SELECT
				'CREATE OR REPLACE TYPE ' || table_name || '_OBJ IS OBJECT (' ||
				LISTAGG(
					column_name || ' ' ||
					CASE data_type
						WHEN 'NUMBER' THEN 'NUMBER(' || data_length || ',' || data_scale || ')'
						WHEN 'VARCHAR2' THEN 'VARCHAR2(' || data_length || ')'
						WHEN 'CHAR' THEN 'CHAR(' || data_length || ')'
						ELSE data_type
					END, ',' || chr(10)
				) WITHIN GROUP (ORDER BY column_id) || ');'
			INTO v_ddl_for_object
			FROM user_tab_cols
			WHERE table_name = child_table_name AND column_name NOT LIKE 'SYS_%'
			GROUP BY table_name;

			SELECT
				'CREATE OR REPLACE TYPE ' || table_name || '_TAB IS TABLE OF ' || table_name || '_OBJ;'
			INTO v_ddl_for_table
			FROM user_tab_cols
			WHERE table_name = child_table_name
			GROUP BY table_name;

			-- Теперь можно выполнить DDL-запросы
			EXECUTE IMMEDIATE v_ddl_for_object;

			EXECUTE IMMEDIATE v_ddl_for_table;
			
		END IF;

		child_table_type := child_table_name || '_TAB';
		
		-- Если связь есть, создаем новую таблицу
		new_table_name := parent_table_name || '_' || child_table_name || '_new_six_four';
				
		--Надо проверить, если таблица с таким названием, если да, то..., если нет, то ... удалять ничего не надо
		
		check_sql := 'SELECT 1 
		FROM ALL_OBJECTS
		WHERE OWNER = USER AND OBJECT_NAME = ''' || UPPER(new_table_name) || '''';
			
		BEGIN
			EXECUTE IMMEDIATE check_sql into check_value;
			EXCEPTION
				when no_data_found then
					check_value := 0;
		END;

		dbms_output.PUT_LINE(check_value);

		dbms_output.PUT_LINE(new_table_name);
		dbms_output.PUT_LINE('CREATE TABLE ' || UPPER(new_table_name) || ' AS SELECT * FROM ' || parent_table_name);

		dbms_output.PUT_LINE('ALTER TABLE ' || UPPER(new_table_name) || ' ADD (' || child_table_name || '_data ' || child_table_type || ') NESTED TABLE ' || child_table_name || '_data STORE AS ' || child_table_name || '_' || parent_table_name || '_data_tab');
   

		IF check_value = 0 THEN
			EXECUTE IMMEDIATE 'CREATE TABLE ' || UPPER(new_table_name) || ' AS SELECT * FROM ' || parent_table_name;
			-- Добавляем новое поле с типом коллекции
			-- EXECUTE IMMEDIATE 'ALTER TABLE ' || UPPER(new_table_name) || ' ADD (' || child || '_data ' || child_table_type || ')'; -- возможно здесь будет oracle ругаться на тип данных
			-- ПОКА НЕ ДОШЛИ ДО ПОСЛЕДНЕГО ОГРАНИЧЕНИЯ, ДОБАВЛЯЕМ СТОЛБЦЫ			
			FOR i IN 1..child_r_constraint_names.COUNT LOOP
				EXECUTE IMMEDIATE 'ALTER TABLE ' || UPPER(new_table_name) || ' ADD (' || parent_table_name || '_' || child_table_name || '_data_'  || i || ' ' || child_table_type || ') NESTED TABLE ' || parent_table_name || '_' || child_table_name || '_data_' || i || ' STORE AS ' || parent_table_name || '_' || child_table_name || '_data_tab' || i;
				DBMS_OUTPUT.PUT_LINE(i);
			END LOOP;
		END IF;
			
		SELECT
		LISTAGG( column_name || ', ') WITHIN GROUP (ORDER BY column_id) 
		INTO list_of_columns
		FROM user_tab_cols
		WHERE table_name = child_table_name AND column_name NOT LIKE 'SYS_%'
		GROUP BY table_name;
		
		-- сейчас удалим последнюю запятую
		
		list_of_columns := SUBSTR(list_of_columns, 1, LENGTH(list_of_columns) - 2);

		DBMS_OUTPUT.PUT_LINE(list_of_columns);
		
-- мне осталось только на основании поиска foreign ограничений, вот этого, ты понял, найти столбцы, за которыми закреплены эти ограничения
-- Я МОГУ НАЙТИ ОДНО ОГРАНИЧЕНИЕ. НА ОСНОВАНИИ ЕГО НАЙТИ СТОЛБЕЦ В ТАБЛИЦЕ, ГДЕ ЭТО ОГРАНИЧЕНИЕ, А ПОТОМ НА ОСНОВАНИИ
-- ЭТОГО ЖЕ ОГРАНИЧЕНИЯ НАЙТИ СТОЛБЕЦ В ДРУГОЙ ТАБЛИЦЕ, ДЕТСКОЙ

		SELECT distinct r_constraint_name
		INTO parent_constraint_name
		FROM all_constraints
		WHERE r_constraint_name IN (
		SELECT constraint_name
		FROM all_constraints
		WHERE table_name = parent_table_name 
		  )
		AND table_name = child_table_name AND OWNER = USER;
					
		SELECT COLUMN_NAME
		INTO parent_table_column_conn
		FROM ALL_CONS_COLUMNS
		WHERE TABLE_NAME = parent_table_name AND OWNER = USER AND CONSTRAINT_NAME = parent_constraint_name;

		DBMS_OUTPUT.PUT_LINE(parent_table_column_conn);

		SELECT constraint_name
		BULK COLLECT INTO child_constraint_name
		FROM all_constraints
		WHERE r_constraint_name = parent_constraint_name AND OWNER = USER and table_name = child_table_name ;
		
		FOR i IN 1..child_constraint_name.COUNT LOOP
			DBMS_OUTPUT.PUT_LINE(child_constraint_name(i));
		END LOOP;
		
		FOR i IN 1..child_constraint_name.COUNT LOOP
			child_table_column_conn.extend;
			SELECT COLUMN_NAME
			INTO child_table_column_conn(i)
			FROM ALL_CONS_COLUMNS
			WHERE TABLE_NAME = child_table_name AND OWNER = USER AND CONSTRAINT_NAME = child_constraint_name(i);
		END LOOP;
		
		FOR i IN 1..child_table_column_conn.COUNT LOOP
			DBMS_OUTPUT.PUT_LINE(child_table_column_conn(i));
		END LOOP;

-- я получил названия столбцов таблице orders, которые foreign key для branch, и я могу пушить данные

		-- dbms_output.PUT_LINE(parent_table_column_conn);
		-- dbms_output.PUT_LINE(child_table_column_conn);

		-- надо сделать так, чтобы то, что после ковычек заработало, а потом уже составлять текст, чтобы можно было execute IMMEDIATE
			--Переносим данные
			FOR i IN 1..child_table_column_conn.COUNT LOOP
				sql_transfer := 'DECLARE v_' || child_table_name || ' ' || type_to_check || ';
				BEGIN 
				FOR r IN (SELECT ' || parent_table_column_conn || ' FROM ' || parent_table_name || ') LOOP
				SELECT ' || object_type || '(' || list_of_columns || ')' || '
				BULK COLLECT INTO v_' || child_table_name || '
				  FROM ' || child_table_name || '
				  WHERE ' || child_table_column_conn(i) || ' = r.' || parent_table_column_conn || ';
				  
				  UPDATE ' || UPPER(new_table_name) || '
				  SET ' || parent_table_name || '_' || child_table_name || '_data_' || i || ' = v_' || child_table_name || '
				  WHERE ' || parent_table_column_conn || ' = r.' || parent_table_column_conn || ';
				END LOOP;
				END;';

				
				dbms_output.PUT_LINE(sql_transfer);

				EXECUTE IMMEDIATE sql_transfer;
			END LOOP;


			--Переносим данные
			-- FOR r IN (SELECT * FROM parent_table_name) LOOP
			  -- SELECT *
			  -- BULK COLLECT INTO v_collection
			  -- FROM p_child_table_name
			  -- WHERE foreign_key = r.primary_key;
			  
			  -- UPDATE new_table_name
			  -- SET child_records = v_collection
			  -- WHERE primary_key = r.primary_key;
			-- END LOOP;
  END IF;
	
	EXCEPTION
		when no_data_found then
			dbms_output.PUT_LINE('there is no one-to-many relationship between the tables');

END;
/

____TESTING____:
как селектить коллекцию из таблицы?
SELECT GEARBOX_VEHICLE_DATA_1 FROM table(cast(GEARBOX_VEHICLE_NEW_SIX_FOUR)) ;
