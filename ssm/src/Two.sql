*******************************单表查询（关联子查询）*****************

何为关联子查询?
关联子查询会引用外部查询中的一列或多列。
这种子查询之所以被称为关联子查询，是因为子查询的确与外部查询有关。
当问题的答案需要依赖于外部查询中包含的每一行中的值时,通常就需要使用关联子查询。


select * from emp_hk
select * from dept_hk
--1:那些员工的薪水dept_hk比公司平均薪水低

select ename,salary
from emp_hk
where salary<(select avg(salary)from emp_hk);




--2.1：那些员工的薪水比十号部门平均薪水低？
select ename,salary
from emp_hk
where salary < (select avg(salary)from emp_hk where deptno=10);


--2.2那些员工的薪水比本部门平均薪水低？:
select ename,salary
from emp_hk e
where salary<(select avg(salary)from emp_hk where deptno=e.deptno)

--3:那些人是其他人的经理()
select distinct mgr  from emp_hk where mgr is not null;

select ename
from emp_hk e
where empno in(select distinct mgr  from emp_hk where mgr is not null);

select ename
from emp_hk e
where job in('Manager','President');

select ename
from emp_hk e
where  exists(select 1 from emp_hk where mgr=e.empno  )

--4那些人不是别人的经理
select ename
from emp_hk e
where not exists(select 1 from emp_hk where mgr=e.empno  )

select * from resource where id=1

select * 
from resource 
where resourceClassify=安装包
having in (select * from resource where id=1001)

--5那些部门没有员工
select dname
from dept_hk e
where not exists(select 1 from emp_hk where deptno=e.deptno)




--笛卡儿集现象：所有表中的行相互连接
--产生原因
--1：多表操作的时候，忘记添加条件筛选语句
--2：条件筛选语句无效
 产生的后果:数据冗余,效率级其低 (A表:1W数据  B表:2W数据   结果集:10000*20000=2WW)
select *
from dept_hk,emp_hk ;   --产生笛卡尔集现象


--*************************************多表连接************************************
--表1
create table one_o(
id int(8) primary key,
name varchar(20),
deptid int(8)
);
--添加数据进表一
insert into one_o values(1,'A',1);
insert into one_o values(2,'B',1);
insert into one_o values(3,'C',2);
insert into one_o values(4,'D',null);

select *from one_o



--表2
create table two_o(
id int(8) primary key ,
name varchar(30)
);

--添加数据进表一
insert into two_o values(1,'develop');
insert into two_o values(2,'account');
insert into two_o values(3,'research');

select *from two_o



--等值连接结果集和内连接一样，但是效率比内连接低
select *
from one_o a,two_o b
where a.deptid=b.id;
--全表扫描，效率低


--三张表操作
select *  
from A_hk a,B_hk b,C_hk c ...
where a.deptid=b.id and c.id=b.id ...;
--不等值连接(了解)
select *   
from A_hk a,B_hk b
where a.deptid < b.id ;





--内连接：结果集等于等值连接结果集（两张表共有的数据）
select *
from one_o a join two_o b on a.deptid=b.id;
--多表操作
select *
from one_o a join two_o b on a.deptid=b.id
              join three_o c on c.id=b.id ;
              
--外连接：结果集=内连接结果集+主表中多余的数据
--左外连接：one_o(主表) two_o(从表)
select *
from one_o a left outer join two_o b on a.deptid=b.id;
--右外连接
select *
from one_o a right outer join two_o b on a.deptid=b.id;

--全外连接（mysql不支持，oracle支持）
select *
from one_o a full outer join two_o b on a.deptid=b.id;

--使用union 实现全外连接功能
select *
from one_o a left outer join two_o b on a.deptid=b.id
union 
select *
from one_o a right outer join two_o b on a.deptid=b.id;




--自连接：将一张表当成两张表来查询
--适合场景：是树形结构设计（表述父子关系-家族关系，上下级关系）
--查询员工信息，要求同时显示员工和员工领导姓名
select e2.ename 员工 ,e1.ename 领导
from emp_hk e1 join emp_hk e2 on e1.empno=e2.mgr ;


--MYSQL分页:
--使用limit a,b:a代表数据的下标，下标从0开始的 b：取几条数据
--查询表emp_hk，按照薪资大小进行排序，获取第五条至第八的数据
select salary
from emp_hk
order by salary desc
limit 4,4;

--数据处理
--插入语句
insert into two_o values(5,'H');插入单条数据
insert into two_o(id,name) values(5,'H');插入单条数据

--批量插入数据
create table three_o(
id int(8) primary key ,
name varchar(30)
);

insert into three_o 
select * from two_o ;

select * from Three_o 
select * from two_o

--修改操作
update Three_o 
set name='AAAAAAAAA',id=4
where id=1;


--删除操作（一条或者多条记录数据）

delete from A_hk where id>=1 ; --逐条删除数据

truncate table C_hk ; --清空表中的数据  

drop table C_hk ; --删除表(数据和表结构度不存在)


--Delete和Truncate区别
--1.Delete逐条删除数据,表结构永远存在,可以进行事物回滚
--2.truncate清空数据 ,表结构永远存在,不可以进行事物回滚
--3.drop删除表(数据和表结构度不存在)



-------------------SQL笔试题_01-------------------------
select * from student_hk
drop table student_hk;
--创建表
create table student_hk(
idcard int(18) primary key,
stuname varchar(22),
sax varchar(21)
);
--添加字段salary
alter table student_hk add salary double(7,2)default 0;


--创建表
create table student_hk(
id int(10) ,
score varchar(5),
subject varchar(10)
);
--插入数据

insert into student_hk values(1001,99,'物理');
insert into student_hk values(1001,80,'数学');    avg=93
insert into student_hk values(1001,100,'体育');

insert into student_hk values(1002,80,'生物');
insert into student_hk values(1002,40,'地理');    avg=73
insert into student_hk values(1002,100,'数学');

insert into student_hk values(1003,70,'生物');
insert into student_hk values(1003,70,'地理');    avg=76
insert into student_hk values(1003,88,'数学');


insert into student_hk values(1004,60,'生物');
insert into student_hk values(1004,60,'地理');    
insert into student_hk values(1004,60,'数学');

--查询表student(id,score,subject)中所有科目成绩在
--60分以上的学生的平均成绩

所有科目成绩在60以上的学生
select  id
from student_hk e
where  exists(select 1 from student_hk where e.score<60)


select id as 学号, avg(score) as 平均分
from student_hk 
group by id
having id<>(select  id
from student_hk e
where  exists(select 1 from student_hk where e.score<60))


select avg(score)
from student_hk a
where 60<=(select min(score) from student_hk where id=a.id  )
group by id


select avg(score) as 平均分
from student_hk 
group by id
having min(score)>=60


-------------------SQL笔试题_02-------------------------

--建表1一
create table userlist(
tellphone varchar(10) primary key,
account varchar(10),
rent numeric(10,2) 
);
insert into userlist values('4210001','AAAA',19.50);
insert into userlist values('4210002','AAAA',20.50);
insert into userlist values(4210003,'BBBB',100.00);
insert into userlist values(4210004,'CCCC',250.00);

--建表2一
create table charge(
tellphone varchar(10) primary key,
fee01 numeric(10,2),
fee02 numeric(10,2),
fee03 numeric(10,2),
fee04 numeric(10,2)
);


insert into charge values(4210001,11.00,12.00,13.00,14.00);
insert into charge values(4210002,21.00,22.00,23.00,24.00);
insert into charge values(4210003,31.00,32.00,33.00,34.00);

distinct

select  account  ,count(account),sum(rent),ifnull(fee01),0),ifnull(fee02),0),ifnull(fee03),0),ifnull(fee04),0)
from userlist a left outer join charge b on a.tellphone=b.tellphone
group by a.account






select  account,count(account) as users,sum(rent) as rent,
ifnull(fee01,0) f01,
ifnull(fee02,0) f02,
ifnull(fee03,0) f03,
ifnull(fee04,0) f04
from userlist a left outer join charge b on a.tellphone=b.tellphone
group by account



















select * from userlist
select * from charge













