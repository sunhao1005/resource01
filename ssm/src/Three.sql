----------------------------------���������-------------------
--���ݿ����棺InnoDB��֧������
--��������ƣ���֤���ݵ������ԣ���������ת��ҵ��
--������ĸ�����Ҫ��(����)
--1.ԭ����,������һ��ԭ�Ӳ���,��һϵ�ж������.�����ԭ����ȷ������
--  Ҫôȫ�����Ҫô��ȫ��������.(Ҫôһ��ɹ�Ҫôһ��ʧ��)
--2.һ����,һ���������������,����ͱ��ύ.���ݺ���Դ�ʹ���һ�� 
--  ����ҵ������һ����״̬��.(�����˷��ʵ����ݶ���һ����)
--3.������,��������������ͬʱ������ͬ������,���ÿ�����ﶼӦ���� 
--  ����������뿪��,��ֹ������.(���������֮���Ƕ������ڵ�)
--4.�־���,һ���������,���۷���ʲôϵͳ����,���Ľ������Ӧ���ܵ�Ӱ��.
--  ���ݽ��г־û�����.(���ݳ־û����������ݿ���)


--MYsql��ο��������ύ������Ĭ�����Զ��ύģʽ��ʹ������ʱӦ�ȹر��Զ��ύ��
SET AUTOOCOMMIT =0���ر��Զ��ύ
SET AUTOOCOMMIT =1�������Զ��ύ

start transaction ����ʼһ������
rollback ��������ع������ݻص���������ĳ�ʼ״̬��Ҳ���Իص�ָ��λ�ã�
commit ���������ύ�����ݿ�

�������裺
SET AUTOOCOMMIT =0���ر��Զ��ύ
start transaction=0 ���ֶ���ʼһ������
--sq1
--sq2
--sq3
rollback ��������ع����ع�������ʼλ��
commit ���������ύ�����ݿ⣬���ݵĸı䱻ȷ�ϣ����лỰ���ܿ������ָĶ��������ϵ������ͷţ��������ݵ���ʱ�ռ䱻�ͷ�
SET AUTOOCOMMIT =1�����������ύģʽ���Զ��ύ
   
savepoint    ���񱣴��
savepoint aa
savepoint bb
savepoint cc
rollback to bb  ���񱣴��aa��bb��cc�����ᱻ�ͷ�


JDBC���������
try{
SET AUTOOCOMMIT =0���ر��Զ��ύ
--ҵ�����
--ҵ�����
--ҵ�����
commit ��
}
catch(Exception e){
rollback ;
}
finally{
SET AUTOOCOMMIT =1�����������ύģʽ���Զ��ύ���ָ����ݿ��������ã�
}

create table account(
nane varchar(20),
money double(11,2)
);

insert into account values ('person1',1000.00);
insert into account values ('person2',200.00);

select * from account

SET AUTOOCOMMIT =0
update account
savepoint a
set money=500.00
where name='person1'

update account
savepoint b
set money=700.00
where name='person2'

commit

SET AUTOOCOMMIT =1





����
create table �������ֶΣ� --�ֶα���Ͳ�ѯ�����������ֶ�һ��

alter ���޸Ľṹ
create table aaaaa(
id int(8)
);
select * from aaaaa

alter table aaaaa
 add name varchar(20);
 
alter table aaaaa
 add (salary varchar(20)not null default 0);

alter table aaaaa
 add (password varchar(20)not null default '6666');
 
 
--�޸����� passwordΪpwd
alter table aaaaa
change password pwd varchar(20)not null default '6666';


--�޸��е���������
alter table aaaaa
modify pwd char(10);
desc aaaaa;   --�鿴��ṹ

--ɾ����
alter table aaaaa
 drop column pwd;
 
 
 --���Ӷ���
alter table aaaaa
 add (sb int(10),nb int(10));
 
 --�޸Ķ����е���������
alter table aaaaa
modify column sb char(10),
modify column nb char(10);

--ɾ�����б�
alter table aaaaa
 drop column sb,
 drop column nb;
 
 ----�޸ı�������ֵ
alter table aaaaa auto_increment=1000;

--�Լ��У����У��޸��еĲ����������С�






***********************������Լ������*******************
primary key ������Լ����������
not null    :�ǿ�Լ��
unique      :ΨһԼ����������
foreign key  :���Լ��
index        ��Լ��



1������Լ�� ��primary key ��Ϊһ�Ҳ�Ϊ��

--�鿴���� 
show index from test_hk ; 
--��Լ��  ��ʽ  
ALTER TABLE test_hk ADD PRIMARY KEY(id) ;         --��������  
ALTER TABLE test_hk ADD UNIQUE KEY(id,name) ;     --Ψһ����
ALTER TABLE student_hk ADD FOREIGN KEY 
 (majorid) REFERENCES major_hk(id) ;              --���Լ��
ALTER TABLE test_hk ADD INDEX aaa (price) ;       --��ͨ����   
   
--1.����Լ�� ��д PK:primary key :Ψһ�Ҳ�Ϊ�� 
--�м�Լ��      
create table test_hk_01(   
  id int(6) primary key auto_increment    
)auto_increment=1000;  
show index from test_hk_01 ;    
--��Լ��    drop table test_hk_02 ;
create table test_hk_02(  
  id int(6) 
);
--Ϊ���������Լ��(ϵͳ�Զ�����)
ALTER TABLE test_hk_02 ADD PRIMARY KEY(id) ;  
--Ϊ���������Լ��(��Լ��ָ������test_hk_02_pk)
ALTER TABLE test_hk_02 ADD PRIMARY KEY test_hk_02_pk(id); 
--�鿴���� 
show index from test_hk_02 ; 
   
--2.�ǿ�Լ�� ��д NN:not null 
--�м�Լ�� 
create table test_hk_03( 
  id int(6) primary key auto_increment ,
  pwd varchar(22) not null      
);
show index from test_hk_03 ; 
--3.ΨһԼ�� ��д UK:unique key 
--�м�Լ��
create table test_hk_04(  
  id int(6) primary key auto_increment ,
  email varchar(22) unique ,
  pwd varchar(22) not null      
);
show index from test_hk_04 ; 
--��Լ��
create table test_hk_05(  
  id int(6) ,
  email varchar(22)  ,
  pwd varchar(22) not null      
);
ALTER TABLE test_hk_05 ADD PRIMARY KEY(id) ;  --��������  
ALTER TABLE test_hk_05 ADD UNIQUE KEY(email) ;
ALTER TABLE test_hk_05 ADD UNIQUE KEY test_hk_uk(email) ;
show index from test_hk_05 ; 





--���Լ��
create table test01(
id int(8) primary key,
name varchar(20)
);
insert into test01 values(20,'fdddd');
insert into test01 values(30,'dadsd');
insert into test01 values(40,'rerrew');
insert into test01 values(50,'ewretw');

create table test02(
id int(8),
name varchar(20),
score varchar(20),
major int(8)
);
--����һ�ͱ��������
alter table test02 add foreign key(major) references test01(id)
--������������
insert into test02 values(1001,'aaaa', 90,20);
--Υ�����Լ������
insert into test02 values(1001,'aaaa', 90,80);

select * from test02


--����

��ͨ����Index,��߲�ѯЧ��   
--��ĳ���ֶα�Ƶ����ѯʱ��:�������,������ѯЧ��     200W
   
--��ѯ����  
show index from book_hk ;

--�������������ַ�ʽ:

--1.�Զ���������(����Լ����ΨһԼ��)
drop table book_hk; --ɾ�������,��ǰ���������е������Զ�ɾ�� 
create table book_hk( 
  id int(4) primary key,
  name varchar(12) unique , 
  price double(6,2) 
); 
show index from book_hk ;

--2.�ֶ��������� 
�ھ�������ѯ����(��������)���ֶ���������. 
ALTER TABLE book_hk ADD INDEX (price) ;     --�����ͨ����
ALTER TABLE book_hk ADD INDEX aaa (price) ; --�����ͨ����(ָ��������)

select *
from ��
where price between 800 and 1000 ;

--ɾ������ 
drop index aaa on book_hk; 

create unique index uu on book_hk price  ;
ALTER TABLE test_hk_05 ADD UNIQUE KEY(email) ;



