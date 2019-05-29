drop database if exists volleyball;

create database volleyball;

use volleyball;

create table Team (
  TID int not null,
  Name varchar(255),
  primary key (TID)
);

create table GuestTeam (
  TID int not null,
  primary key (TID),
  foreign key (TID) references Team (TID)
);

create table RegisteredTeam (
  TID int not null,
  RegID int,
  primary key (TID),
  foreign key (TID) references Team (TID)
);

create table VolleyBallMatch (
  MID int not null,
  Time TIMESTAMP,
  primary key (MID)
);

create table Plays (
  HomeID int not null,
  AwayID int not null,
  MID int not null,
  primary key (HomeId, AwayID),
  foreign key (HomeID) references Team (TID),
  foreign key (AwayID) references Team (TID),
  foreign key (MID) references VolleyBallMatch (MID)
);

create table SetInMatch (
  MID int not null,
  Number int not null auto_increment,
  primary key (Number),
  foreign key (MID) references VolleyBallMatch (MID) on delete cascade
);
