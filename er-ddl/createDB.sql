drop database Medical if exists;

create database Medical;

  use Medical;

  create table Doctor (
    DID int primary key auto_increment not null,
    Dname varchar(255)
  );

  create table Child (
    CID int primary key auto_increment not null,
    Cname varchar(255)
  );

  create table QualityAssurer (
    QAID int primary key auto_increment not null,
    QAname varchar(255)
  );

  create table LegalGuardian (
    CID integer not null,
    LGname varchar(255) not null,
    primary key (CID, LGname),
    foreign key (CID) references Child (CID)
  );

  create table Cures (
    CID int not null,
    DID int not null,
    since date,
    primary key (DID, CID),
    foreign key (DID) references Doctor (DID),
    foreign key (CID) references Child (CID)
  );

  create table Monitors (
    QAID int,
    DID int,
    CID int,
    grade int,
    primary key (DID, CID, QAID),
    foreign key (QAID) references QualityAssurer (QAID),
    foreign key (DID, CID) references Cures (DID, CID)
  );
