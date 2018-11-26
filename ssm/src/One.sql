--�������ݿ�
create database sqlone ;
--����
--int(6);�������ͣ����ֵ999999
--double(6,2):С�������ֵ9999.99
--char(12):�����ַ����ͣ�����"gsdgsfgdgs"
--Varchar(12):�ɱ��ַ����ͣ����硱hgsdfghdf����
--nvarchar(12):�ɱ��ַ����ͣ��ɶ�ȡ����
--text���ı��ַ�������
--date����������
--datetime���������ͣ����ã�
--primary key:����Լ�����ǿ��Ҳ������ظ�
--auto_increment:����������
--unique��ΨһԼ����Ψһ�������ظ�
--ɾ����
drop table user_hk;
create table user_hk(
id int(6) primary key auto_increment ,
username Varchar(18) unique ,
pwd char(6) ,
price double(9,2) ,
regDate datetime ,
des text
);
--��ѯ���
select * from user_hk ;
--��������(��ӵ����ݱ���ͱ����������ֶ�һ��)
insert into user_hk
values(1001,'����','1234',9999.9,'2018-8-27 10:48:55','������')
--��������(��ӵ����ݱ���ͱ������ֶ�������һ��)
insert into user_hk(username,pwd,price,regDate,des) 
values('����','12345',999.9,'2018-8-27 10:48:55','������')
insert into user_hk(username,pwd,price,regDate,des) 
values('����','123456',6666.6,'2018-8-27 10:48:56','�ܸߵ�v����')

--�޸����
update user_hk
set username='������',pwd='7788',des='�����ܶ�'
where id=1001 ;
--ɾ����� 
delete from user_hk
where id=1004 ;



--����dept:���ű�
create table dept_hk(
deptno int(2) primary key,
dname varchar(20),
location varchar(20)
);

--����ģ�����ݣ�
insert into dept_hk values(10,'developer','����');
insert into dept_hk values(20,'account','�Ϻ�');
insert into dept_hk values(30,'sales','����');
insert into dept_hk values(40,'operations','����');
 

--����:Ա����
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

--���ģ������
insert into emp_hk values(1001, '���޼�', 'Manager', 10000, 2000, '2012-3-10', 1005, 10);
insert into emp_hk values(1002, '��#��', 'Analyst', 8000, 1000,  '2001-1-11', 1001, 10);
insert into emp_hk values(1003, '��һ', 'Analyst', 9000, 1000,  '2011-1-10', 1001, 10);
insert into emp_hk values(1004, '��ܽ��', 'Programmer', 5000, null, '2001-6-11', 1001, 10); 
insert into emp_hk values(1005, '������', 'President', 15000, null, '2015-5-08', null, 20);
insert into emp_hk values(1006, '��С��','Manager', 5000, 400, '2001-11-09', 1005, 20);
insert into emp_hk values(1007, '½��˫','clerk', 3000, 500, '2001-11-09', 1006, 20);
insert into emp_hk values(1008, '����','Manager', 5000, 500, '2001-5-09', 1005, 30);
insert into emp_hk values(1009, 'ΤС��','salesman', 4000, null, '2020-8-09', 1008, 30);
insert into emp_hk values(1010, '����','salesman', 4500, 500, '2010-10-09', 1008, 30);

select * from  dept_hk ;
select * from  emp_hk ;



********************��ѯ���*************************
--1:ͳ��Ա�����֣���н����н�� ������as������ʡ�ԣ�
select ename,salary,salary*12 as salary_year
from emp_hk ;

--����Ա���������룿ʹ�ú���ifnull(bonus,0)
select ename,salary,bonus,salary+ifnull(bonus,0) as salary_month
from emp_hk ;

--����������Щְλ��ȥ�أ�distinct
select distinct job
from emp_hk ;

--нˮ����10000��Ա�����ݣ�֧�ֵ����������< <= > >= = <>(�����ں�)
select *
from emp_hk 
where salary>10000 ;

--.ְλ��Analyst��Ա������
select *
from emp_hk 
where  job='Analyst' ;

--нˮ������ǧ��С��10000��Ա������[between a and b](������) && ||
select *
from emp_hk 
where salary>5000&&salary<10000;

select *
from emp_hk 
where salary between 5000 and 10000 and salary<>5000 and salary<>10000 ;

--�г�ְλ��manager����analyst��Ա��
--or || in(1,2,3):��������֮һ����
select *
from emp_hk 
where job in('manager','analyst');


--�г�ְλ����sales�ַ���Ա�����ݣ�
--ģ����ѯlike��_,�����ַ�  %��0�������ַ� 
select *
from emp_hk
where job like '%sales%';

--��ѯ��ЩԱ��û�н���
select * from emp_hk where bonus is null  ;






***************************��ѯ���************************************
--�麯����count/ avg / sun / max / min (���Կ�ֵ)
--���� avg / sum ������ֲ���
-- max / min �������������Ч


--����Ա����ߺ����нˮ
select max(salary),min(salary)
from emp_hk;

--���������������ְ��Ա��
select max(hiredate),min(hiredate)
from emp_hk;


--ͳ�ƹ�˾���ʣ����򣬣��������һ������ְʱ����������
--����ʹ�� order by  �ֶ���asc������Ĭ�ϣ�| desc������
select hiredate,salary
 from emp_hk
 order by salary desc ,hiredate desc;
 
 
 
 --���ղ��ż���ÿ�����ŵ���ߺ����нˮ�ֱ��Ƕ���
--���飺ʹ��group by �ֶ�
select deptno, max(salary),min(salary)
 from emp_hk
 group by deptno ;
 
 
 --ƽ��нˮ����5000Ԫ�Ĳ������ݣ�   ����+����ɸѡ;having  �麯��ɸѡ����ʹ��where��ʹ��having
select deptno ,avg(salary)
from emp_hk
group by deptno 
having avg(salary)>5000 ;

--нˮ�ܺʹ���20000�Ĳ�������
select deptno ,sum(salary)
from emp_hk
group by deptno 
having sum(salary)>20000 ;

--��Щְλ����������������
select job ,count(job)
from emp_hk
group by job
having count(job)>2;


��ѯ���Ļ���˳��
select
from        ����
where       ����ɸѡ
group by    ����
having      ���麯��������ɸѡ
order by    



****************************�����ѯ���Ӳ�ѯ��*****************************
--�Ӳ�ѯ:��ѯ����Ƕ��(����һ����ѯ������һ����ѯ������)

--�����Ӳ�ѯ���صĽ���������� 
--����һ�У�> < >= <= = <>   ���бȽ������,ֻ�ܺ�һ�����ֱȽ�
--���ض��У�>ALL(�������) >ANY(������С) <ALL(С����С) <ANY(С�����) in







--��ѯ���нˮ��˭
--��ѯ���нˮ
select max(salary) from emp_hk;
--��ѯ���нˮ������
select ename
from emp_hk
where salary=15000;
--�ϲ�
select ename
from emp_hk
where salary=(select max(salary) from emp_hk);




--1˭��нˮ�����޼ɸ�
select salary from emp_hk where ename='���޼�'

select ename , salary
from emp_hk
where salary < (select salary from emp_hk where ename='���޼�');


--2˭����#��ͬ���ţ��г�������#��֮���Ա������
--��#�ɵĲ���
select deptno from emp_hk where ename='��#��';

--������#��֮���Ա������
select ename
from emp_hk
where deptno=(select deptno from emp_hk where ename='��#��')&& ename<>'��#��';

--4�ĸ����ŵ������Ȳ���30��������
--����30������
select count(deptno)
from emp_hk
where deptno=30;
--
select deptno
from emp_hk
group by deptno
having count(deptno)>(select count(deptno) from emp_hk where deptno=30);

select * from emp_hk;


--5.�ĸ����ŵ�ƽ��нˮ�Ȳ���20��ƽ��нˮ�ߣ�
--����20��ƽ��нˮ
select avg(salary) from emp_hk where deptno=20;
 --
select deptno
from emp_hk
group by deptno
having avg(salary)>(select avg(salary) from emp_hk where deptno=20)




--6.�г�Ա�����ֺ�ְλ����ЩԱ�����ڵĲ���ƽ��нˮ����5000Ԫ? 
--Ա�����ڵĲ���ƽ��нˮ����5000Ԫ
 select deptno
 from emp_hk
 group by deptno
 having avg(salary)>5000;
 --
select ename,job
from emp_hk
where deptno in(select deptno from emp_hk group by deptno having avg(salary)>5000);

  



--7.˭�����޼ɵ������� select * from emp_hk;
--���޼����ĸ�����
select deptno
from emp_hk
where ename='���޼�';

--��Щ�������޼���һ������
select ename
from emp_hk
where deptno in(select deptno from emp_hk where ename='���޼�')&&job<>'manager';





--8.ÿ�����������нˮ����˭��(#####�Ƚ���#####)

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



 
--9.�з���(developer)����Щְλ��
--developer������һ������
select deptno
from dept_hk
where dname='developer';


select distinct job
from emp_hk
where deptno=(select deptno
from dept_hk
where dname='developer');

select * from emp_hk





























 
 



















