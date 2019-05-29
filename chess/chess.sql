drop database if exists chess;

create database chess;

  use chess;

  create table Human (
    CPR int not null,
    name varchar(255),
    primary key (CPR)
  );

  create table Official (
    CPR int not null,
    Title varchar(50),
    primary key (CPR),
    foreign key (CPR) references Human (CPR)
  );

  create table Player (
    CPR int not null,
    Rank int,
    primary key (CPR),
    foreign key (CPR) references Human (CPR)
  );

  create table Game (
    GameId int,
    Black int unique,
    White int unique,
    Time timestamp,
    Winner bool,
    primary key (GameId),
    foreign key (Black) references Player (CPR),
    foreign key (White) references Player (CPR)
  );

  create table Record (
    OfficialCPR int not null,
    GameId int,
    primary key (GameId, OfficialCPR),
    foreign key (OfficialCPR) references Official (CPR),
    foreign key (GameId) references Game (GameId)
  );
