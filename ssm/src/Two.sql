*******************************�����ѯ�������Ӳ�ѯ��*****************

��Ϊ�����Ӳ�ѯ?
�����Ӳ�ѯ�������ⲿ��ѯ�е�һ�л���С�
�����Ӳ�ѯ֮���Ա���Ϊ�����Ӳ�ѯ������Ϊ�Ӳ�ѯ��ȷ���ⲿ��ѯ�йء�
������Ĵ���Ҫ�������ⲿ��ѯ�а�����ÿһ���е�ֵʱ,ͨ������Ҫʹ�ù����Ӳ�ѯ��


select * from emp_hk
select * from dept_hk
--1:��ЩԱ����нˮdept_hk�ȹ�˾ƽ��нˮ��

select ename,salary
from emp_hk
where salary<(select avg(salary)from emp_hk);




--2.1����ЩԱ����нˮ��ʮ�Ų���ƽ��нˮ�ͣ�
select ename,salary
from emp_hk
where salary < (select avg(salary)from emp_hk where deptno=10);


--2.2��ЩԱ����нˮ�ȱ�����ƽ��нˮ�ͣ�:
select ename,salary
from emp_hk e
where salary<(select avg(salary)from emp_hk where deptno=e.deptno)

--3:��Щ���������˵ľ���()
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

--4��Щ�˲��Ǳ��˵ľ���
select ename
from emp_hk e
where not exists(select 1 from emp_hk where mgr=e.empno  )

select * from resource where id=1

select * 
from resource 
where resourceClassify=��װ��
having in (select * from resource where id=1001)

--5��Щ����û��Ա��
select dname
from dept_hk e
where not exists(select 1 from emp_hk where deptno=e.deptno)




--�ѿ������������б��е����໥����
--����ԭ��
--1����������ʱ�������������ɸѡ���
--2������ɸѡ�����Ч
 �����ĺ��:��������,Ч�ʼ���� (A��:1W����  B��:2W����   �����:10000*20000=2WW)
select *
from dept_hk,emp_hk ;   --�����ѿ���������


--*************************************�������************************************
--��1
create table one_o(
id int(8) primary key,
name varchar(20),
deptid int(8)
);
--������ݽ���һ
insert into one_o values(1,'A',1);
insert into one_o values(2,'B',1);
insert into one_o values(3,'C',2);
insert into one_o values(4,'D',null);

select *from one_o



--��2
create table two_o(
id int(8) primary key ,
name varchar(30)
);

--������ݽ���һ
insert into two_o values(1,'develop');
insert into two_o values(2,'account');
insert into two_o values(3,'research');

select *from two_o



--��ֵ���ӽ������������һ��������Ч�ʱ������ӵ�
select *
from one_o a,two_o b
where a.deptid=b.id;
--ȫ��ɨ�裬Ч�ʵ�


--���ű����
select *  
from A_hk a,B_hk b,C_hk c ...
where a.deptid=b.id and c.id=b.id ...;
--����ֵ����(�˽�)
select *   
from A_hk a,B_hk b
where a.deptid < b.id ;





--�����ӣ���������ڵ�ֵ���ӽ���������ű��е����ݣ�
select *
from one_o a join two_o b on a.deptid=b.id;
--������
select *
from one_o a join two_o b on a.deptid=b.id
              join three_o c on c.id=b.id ;
              
--�����ӣ������=�����ӽ����+�����ж��������
--�������ӣ�one_o(����) two_o(�ӱ�)
select *
from one_o a left outer join two_o b on a.deptid=b.id;
--��������
select *
from one_o a right outer join two_o b on a.deptid=b.id;

--ȫ�����ӣ�mysql��֧�֣�oracle֧�֣�
select *
from one_o a full outer join two_o b on a.deptid=b.id;

--ʹ��union ʵ��ȫ�����ӹ���
select *
from one_o a left outer join two_o b on a.deptid=b.id
union 
select *
from one_o a right outer join two_o b on a.deptid=b.id;




--�����ӣ���һ�ű������ű�����ѯ
--�ʺϳ����������νṹ��ƣ��������ӹ�ϵ-�����ϵ�����¼���ϵ��
--��ѯԱ����Ϣ��Ҫ��ͬʱ��ʾԱ����Ա���쵼����
select e2.ename Ա�� ,e1.ename �쵼
from emp_hk e1 join emp_hk e2 on e1.empno=e2.mgr ;


--MYSQL��ҳ:
--ʹ��limit a,b:a�������ݵ��±꣬�±��0��ʼ�� b��ȡ��������
--��ѯ��emp_hk������н�ʴ�С�������򣬻�ȡ���������ڰ˵�����
select salary
from emp_hk
order by salary desc
limit 4,4;

--���ݴ���
--�������
insert into two_o values(5,'H');���뵥������
insert into two_o(id,name) values(5,'H');���뵥������

--������������
create table three_o(
id int(8) primary key ,
name varchar(30)
);

insert into three_o 
select * from two_o ;

select * from Three_o 
select * from two_o

--�޸Ĳ���
update Three_o 
set name='AAAAAAAAA',id=4
where id=1;


--ɾ��������һ�����߶�����¼���ݣ�

delete from A_hk where id>=1 ; --����ɾ������

truncate table C_hk ; --��ձ��е�����  

drop table C_hk ; --ɾ����(���ݺͱ�ṹ�Ȳ�����)


--Delete��Truncate����
--1.Delete����ɾ������,��ṹ��Զ����,���Խ�������ع�
--2.truncate������� ,��ṹ��Զ����,�����Խ�������ع�
--3.dropɾ����(���ݺͱ�ṹ�Ȳ�����)



-------------------SQL������_01-------------------------
select * from student_hk
drop table student_hk;
--������
create table student_hk(
idcard int(18) primary key,
stuname varchar(22),
sax varchar(21)
);
--����ֶ�salary
alter table student_hk add salary double(7,2)default 0;


--������
create table student_hk(
id int(10) ,
score varchar(5),
subject varchar(10)
);
--��������

insert into student_hk values(1001,99,'����');
insert into student_hk values(1001,80,'��ѧ');    avg=93
insert into student_hk values(1001,100,'����');

insert into student_hk values(1002,80,'����');
insert into student_hk values(1002,40,'����');    avg=73
insert into student_hk values(1002,100,'��ѧ');

insert into student_hk values(1003,70,'����');
insert into student_hk values(1003,70,'����');    avg=76
insert into student_hk values(1003,88,'��ѧ');


insert into student_hk values(1004,60,'����');
insert into student_hk values(1004,60,'����');    
insert into student_hk values(1004,60,'��ѧ');

--��ѯ��student(id,score,subject)�����п�Ŀ�ɼ���
--60�����ϵ�ѧ����ƽ���ɼ�

���п�Ŀ�ɼ���60���ϵ�ѧ��
select  id
from student_hk e
where  exists(select 1 from student_hk where e.score<60)


select id as ѧ��, avg(score) as ƽ����
from student_hk 
group by id
having id<>(select  id
from student_hk e
where  exists(select 1 from student_hk where e.score<60))


select avg(score)
from student_hk a
where 60<=(select min(score) from student_hk where id=a.id  )
group by id


select avg(score) as ƽ����
from student_hk 
group by id
having min(score)>=60


-------------------SQL������_02-------------------------

--����1һ
create table userlist(
tellphone varchar(10) primary key,
account varchar(10),
rent numeric(10,2) 
);
insert into userlist values('4210001','AAAA',19.50);
insert into userlist values('4210002','AAAA',20.50);
insert into userlist values(4210003,'BBBB',100.00);
insert into userlist values(4210004,'CCCC',250.00);

--����2һ
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













