create database if not exists JMeterTest;

drop table if exists JMeterTest.People;
create table JMeterTest.People(id int not null auto_increment primary key, name varchar(50), surname varchar(100));

insert into JMeterTest.People(name, surname) values ("Amaia", "Aristi");
insert into JMeterTest.People(name, surname) values ("Carlos", "Cerezo");
insert into JMeterTest.People(name, surname) values ("Maite", "Martin");
insert into JMeterTest.People(name, surname) values ("Mireia", "Martin");
insert into JMeterTest.People(name, surname) values ("Susana", "Sala");

create user if not exists "JMeterUser" identified by "upvehu";
grant select, update on JMeterTest.People to "JMeterUser";
