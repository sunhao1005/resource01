--创建数据库
create database sqlone ;
--建表
--int(6);整数类型，最大值999999
--double(6,2):小数，最大值9999.99
--char(12):定常字符类型，比如"gsdgsfgdgs"
--Varchar(12):可变字符类型，比如”hgsdfghdf“，
--nvarchar(12):可变字符类型，可读取中文
--text：文本字符串类型
--date：日期类型
--datetime：日期类型（常用）
--primary key:主键约束，非空且不允许重复
--auto_increment:主键自增长
--unique：唯一约束，唯一不允许重复
--删除表
drop table user_hk;
create table user_hk(
id int(6) primary key auto_increment ,
username Varchar(18) unique ,
pwd char(6) ,
price double(9,2) ,
regDate datetime ,
des text
);
--查询语句
select * from user_hk ;
--插入数据(添加的数据必须和表括号里面字段一致)
insert into user_hk
values(1001,'张三','1234',9999.9,'2018-8-27 10:48:55','多多关心')
--插入数据(添加的数据必须和表里面字段所有列一致)
insert into user_hk(username,pwd,price,regDate,des) 
values('李四','12345',999.9,'2018-8-27 10:48:55','多多关心')
insert into user_hk(username,pwd,price,regDate,des) 
values('王五','123456',6666.6,'2018-8-27 10:48:56','很高的v风格的')

--修改语句
update user_hk
set username='张三丰',pwd='7788',des='见过很多'
where id=1001 ;
--删除语句 
delete from user_hk
where id=1004 ;



--建表dept:部门表
create table dept_hk(
deptno int(2) primary key,
dname varchar(20),
location varchar(20)
);

--增加模拟数据：
insert into dept_hk values(10,'developer','北京');
insert into dept_hk values(20,'account','上海');
insert into dept_hk values(30,'sales','广州');
insert into dept_hk values(40,'operations','深圳');
 

--建表:员工表
drop table  emp_hk;
create table if not exists emp_hk(
empno int(4),          
ename varchar(20),     
job varchar(15),       
salary double(7,2),     
bonus double(7,2),      
hiredate date,          
mgr int(4),          
deptno int(10)       
);

--添加模拟数据
insert into emp_hk values(1001, '张无忌', 'Manager', 10000, 2000, '2012-3-10', 1005, 10);
insert into emp_hk values(1002, '刘#松', 'Analyst', 8000, 1000,  '2001-1-11', 1001, 10);
insert into emp_hk values(1003, '李一', 'Analyst', 9000, 1000,  '2011-1-10', 1001, 10);
insert into emp_hk values(1004, '郭芙蓉', 'Programmer', 5000, null, '2001-6-11', 1001, 10); 
insert into emp_hk values(1005, '张三丰', 'President', 15000, null, '2015-5-08', null, 20);
insert into emp_hk values(1006, '燕小六','Manager', 5000, 400, '2001-11-09', 1005, 20);
insert into emp_hk values(1007, '陆无双','clerk', 3000, 500, '2001-11-09', 1006, 20);
insert into emp_hk values(1008, '黄蓉','Manager', 5000, 500, '2001-5-09', 1005, 30);
insert into emp_hk values(1009, '韦小宝','salesman', 4000, null, '2020-8-09', 1008, 30);
insert into emp_hk values(1010, '郭靖','salesman', 4500, 500, '2010-10-09', 1008, 30);

select * from  dept_hk ;
select * from  emp_hk ;



********************查询语句*************************
--1:统计员工名字，月薪和年薪？ 别名：as（可以省略）
select ename,salary,salary*12 as salary_year
from emp_hk ;

--计算员工的月收入？使用函数ifnull(bonus,0)
select ename,salary,bonus,salary+ifnull(bonus,0) as salary_month
from emp_hk ;

--机构中有哪些职位？去重：distinct
select distinct job
from emp_hk ;

--薪水高于10000的员工数据？支持单行运算符：< <= > >= = <>(不等于号)
select *
from emp_hk 
where salary>10000 ;

--.职位是Analyst的员工数据
select *
from emp_hk 
where  job='Analyst' ;

--薪水大于五千且小于10000的员工数据[between a and b](闭区间) && ||
select *
from emp_hk 
where salary>5000&&salary<10000;

select *
from emp_hk 
where salary between 5000 and 10000 and salary<>5000 and salary<>10000 ;

--列出职位是manager或者analyst的员工
--or || in(1,2,3):符合其中之一就行
select *
from emp_hk 
where job in('manager','analyst');


--列出职位中有sales字符的员工数据？
--模糊查询like：_,单个字符  %：0个或多个字符 
select *
from emp_hk
where job like '%sales%';

--查询哪些员工没有奖金
select * from emp_hk where bonus is null  ;






***************************查询语句************************************
--组函数：count/ avg / sun / max / min (忽略空值)
--其中 avg / sum 针对数字操作
-- max / min 针对所有类型有效


--计算员工最高和最低薪水
select max(salary),min(salary)
from emp_hk;

--计算最早和最晚入职的员工
select max(hiredate),min(hiredate)
from emp_hk;


--统计公司工资，降序，，如果工资一样按入职时间早晚排序
--排序：使用 order by  字段名asc（升序：默认）| desc（降序）
select hiredate,salary
 from emp_hk
 order by salary desc ,hiredate desc;
 
 
 
 --按照部门计算每个部门的最高和最低薪水分别是多少
--分组：使用group by 字段
select deptno, max(salary),min(salary)
 from emp_hk
 group by deptno ;
 
 
 --平均薪水大于5000元的部门数据？   分组+条件筛选;having  组函数筛选不能使用where，使用having
select deptno ,avg(salary)
from emp_hk
group by deptno 
having avg(salary)>5000 ;

--薪水总和大于20000的部门数据
select deptno ,sum(salary)
from emp_hk
group by deptno 
having sum(salary)>20000 ;

--那些职位的人数超过两个人
select job ,count(job)
from emp_hk
group by job
having count(job)>2;


查询语句的基本顺序
select
from        表名
where       条件筛选
group by    列名
having      带组函数的条件筛选
order by    



****************************单表查询（子查询）*****************************
--子查询:查询语句的嵌套(其中一个查询是另外一个查询的条件)

--根据子查询返回的结果的行数： 
--返回一行：> < >= <= = <>   单行比较运算符,只能和一个数字比较
--返回多行：>ALL(大于最大) >ANY(大于最小) <ALL(小于最小) <ANY(小于最大) in







--查询最高薪水是谁
--查询最高薪水
select max(salary) from emp_hk;
--查询最高薪水的姓名
select ename
from emp_hk
where salary=15000;
--合并
select ename
from emp_hk
where salary=(select max(salary) from emp_hk);




--1谁的薪水比张无忌高
select salary from emp_hk where ename='张无忌'

select ename , salary
from emp_hk
where salary < (select salary from emp_hk where ename='张无忌');


--2谁和刘#松同部门？列出除了刘#松之外的员工名字
--刘#松的部门
select deptno from emp_hk where ename='刘#松';

--除了刘#松之外的员工名字
select ename
from emp_hk
where deptno=(select deptno from emp_hk where ename='刘#松')&& ename<>'刘#松';

--4哪个部门的人数比部门30的人数多
--部门30的人数
select count(deptno)
from emp_hk
where deptno=30;
--
select deptno
from emp_hk
group by deptno
having count(deptno)>(select count(deptno) from emp_hk where deptno=30);

select * from emp_hk;


--5.哪个部门的平均薪水比部门20的平均薪水高？
--部门20的平均薪水
select avg(salary) from emp_hk where deptno=20;
 --
select deptno
from emp_hk
group by deptno
having avg(salary)>(select avg(salary) from emp_hk where deptno=20)




--6.列出员工名字和职位，这些员工所在的部门平均薪水大于5000元? 
--员工所在的部门平均薪水大于5000元
 select deptno
 from emp_hk
 group by deptno
 having avg(salary)>5000;
 --
select ename,job
from emp_hk
where deptno in(select deptno from emp_hk group by deptno having avg(salary)>5000);

  



--7.谁是张无忌的下属？ select * from emp_hk;
--张无忌是哪个部门
select deptno
from emp_hk
where ename='张无忌';

--那些人与张无忌是一个部门
select ename
from emp_hk
where deptno in(select deptno from emp_hk where ename='张无忌')&&job<>'manager';





--8.每个部门拿最高薪水的是谁？(#####比较难#####)

select deptno,max(salary)
from emp_hk
group by deptno;

select deptno,ename,salary
from emp_hk
where(deptno,salary) in (select deptno,max(salary) from emp_hk group by deptno)

select deptno,ename,salary
from emp_hk
group by deptno
having max(salary);




select * from emp_hk;



 
--9.研发部(developer)有哪些职位？
--developer属于哪一个部门
select deptno
from dept_hk
where dname='developer';


select distinct job
from emp_hk
where deptno=(select deptno
from dept_hk
where dname='developer');

select * from emp_hk





























 
 



















