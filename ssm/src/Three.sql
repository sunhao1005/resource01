----------------------------------事务处理机制-------------------
--数据库引擎：InnoDB，支持事务
--事务处理机制：保证数据的完整性（比如银行转账业务）
--事物的四个基本要素(特征)
--1.原子性,事务是一个原子操作,由一系列动作组成.事务的原子性确保动作
--  要么全部完成要么完全不起作用.(要么一起成功要么一起失败)
--2.一致性,一旦所有事务动作完成,事务就被提交.数据和资源就处于一种 
--  满足业务规则的一致性状态中.(所有人访问的数据度是一样的)
--3.隔离性,可能有许多事务会同时处理相同的数据,因此每个事物都应该与 
--  其他事务隔离开来,防止数据损坏.(事物和事物之间是独立存在的)
--4.持久性,一旦事务完成,无论发生什么系统错误,它的结果都不应该受到影响.
--  数据进行持久化操作.(数据持久化保存在数据库中)


--MYsql如何控制事务提交？？？默认是自动提交模式（使用事务时应先关闭自动提交）
SET AUTOOCOMMIT =0；关闭自动提交
SET AUTOOCOMMIT =1；开启自动提交

start transaction ：开始一个事物
rollback ：将事务回滚，数据回到本次事物的初始状态（也可以回到指定位置）
commit ：将事务提交给数据库

事务处理步骤：
SET AUTOOCOMMIT =0；关闭自动提交
start transaction=0 ：手动开始一个事物
--sq1
--sq2
--sq3
rollback ：将事务回滚，回滚到事务开始位置
commit ：将事务提交给数据库，数据的改变被确认，所有会话都能看到这种改动，数据上的锁被释放，保存数据的临时空间被释放
SET AUTOOCOMMIT =1；开启事务提交模式，自动提交
   
savepoint    事务保存点
savepoint aa
savepoint bb
savepoint cc
rollback to bb  事务保存点aa，bb，cc，都会被释放


JDBC事务处理机制
try{
SET AUTOOCOMMIT =0；关闭自动提交
--业务代码
--业务代码
--业务代码
commit ；
}
catch(Exception e){
rollback ;
}
finally{
SET AUTOOCOMMIT =1；设置事务提交模式，自动提交（恢复数据库事务设置）
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





表复制
create table 表名（字段） --字段必须和查询语句里面虚表字段一致

alter ：修改结构
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
 
 
--修改列名 password为pwd
alter table aaaaa
change password pwd varchar(20)not null default '6666';


--修改列的数据类型
alter table aaaaa
modify pwd char(10);
desc aaaaa;   --查看表结构

--删除列
alter table aaaaa
 drop column pwd;
 
 
 --增加多列
alter table aaaaa
 add (sb int(10),nb int(10));
 
 --修改多列列的数据类型
alter table aaaaa
modify column sb char(10),
modify column nb char(10);

--删除多列表
alter table aaaaa
 drop column sb,
 drop column nb;
 
 ----修改表自增长值
alter table aaaaa auto_increment=1000;

--对加列，减列，修改列的操作谨慎进行。






***********************常见的约束类型*******************
primary key ：主键约束（索引）
not null    :非空约束
unique      :唯一约束（索引）
foreign key  :外键约束
index        ：约束



1：主键约束 ：primary key ：为一且不为空

--查看索引 
show index from test_hk ; 
--表级约束  格式  
ALTER TABLE test_hk ADD PRIMARY KEY(id) ;         --主键索引  
ALTER TABLE test_hk ADD UNIQUE KEY(id,name) ;     --唯一索引
ALTER TABLE student_hk ADD FOREIGN KEY 
 (majorid) REFERENCES major_hk(id) ;              --外键约束
ALTER TABLE test_hk ADD INDEX aaa (price) ;       --普通索引   
   
--1.主键约束 简写 PK:primary key :唯一且不为空 
--列级约束      
create table test_hk_01(   
  id int(6) primary key auto_increment    
)auto_increment=1000;  
show index from test_hk_01 ;    
--表级约束    drop table test_hk_02 ;
create table test_hk_02(  
  id int(6) 
);
--为表添加主键约束(系统自动命名)
ALTER TABLE test_hk_02 ADD PRIMARY KEY(id) ;  
--为表添加主键约束(给约束指定名字test_hk_02_pk)
ALTER TABLE test_hk_02 ADD PRIMARY KEY test_hk_02_pk(id); 
--查看索引 
show index from test_hk_02 ; 
   
--2.非空约束 简写 NN:not null 
--列级约束 
create table test_hk_03( 
  id int(6) primary key auto_increment ,
  pwd varchar(22) not null      
);
show index from test_hk_03 ; 
--3.唯一约束 简写 UK:unique key 
--列级约束
create table test_hk_04(  
  id int(6) primary key auto_increment ,
  email varchar(22) unique ,
  pwd varchar(22) not null      
);
show index from test_hk_04 ; 
--表级约束
create table test_hk_05(  
  id int(6) ,
  email varchar(22)  ,
  pwd varchar(22) not null      
);
ALTER TABLE test_hk_05 ADD PRIMARY KEY(id) ;  --主键索引  
ALTER TABLE test_hk_05 ADD UNIQUE KEY(email) ;
ALTER TABLE test_hk_05 ADD UNIQUE KEY test_hk_uk(email) ;
show index from test_hk_05 ; 





--外键约束
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
--给表一和表二添加外键
alter table test02 add foreign key(major) references test01(id)
--给表二添加数据
insert into test02 values(1001,'aaaa', 90,20);
--违反外键约束条件
insert into test02 values(1001,'aaaa', 90,80);

select * from test02


--索引

普通索引Index,提高查询效率   
--当某个字段被频繁查询时候:添加索引,提升查询效率     200W
   
--查询索引  
show index from book_hk ;

--创建索引的两种方式:

--1.自动创建索引(主键约束和唯一约束)
drop table book_hk; --删除表操作,当前表里面所有的索引自动删除 
create table book_hk( 
  id int(4) primary key,
  name varchar(12) unique , 
  price double(6,2) 
); 
show index from book_hk ;

--2.手动创建索引 
在经常做查询的列(非主键列)上手动创建索引. 
ALTER TABLE book_hk ADD INDEX (price) ;     --添加普通索引
ALTER TABLE book_hk ADD INDEX aaa (price) ; --添加普通索引(指定索引名)

select *
from 表
where price between 800 and 1000 ;

--删除索引 
drop index aaa on book_hk; 

create unique index uu on book_hk price  ;
ALTER TABLE test_hk_05 ADD UNIQUE KEY(email) ;



