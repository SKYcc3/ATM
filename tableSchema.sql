create table userInfo(
	userID uniqueidentifier primary key default newID(),
	userType varchar(20) not null check(userType in('ATM','营业员'))
);
create table customerInfo(
	customerID int primary key identity(1,1),
	customerName varchar(20) not null,
	PID char(18) not null unique check(len(PID) = 15 or len(PID) = 18),
	telephone char(13) not null check(telephone like'___-____-____'),
	customerAddress varchar(50)
);
create	table transInfo(
	transID int primary key identity(1,1),
	userID uniqueidentifier not null,
	userType varchar(20) not null check(userType in ('ATM', '营业员')),
	transDate datetime not null default getdate(),
	transType varchar(20) not null check(transType in ('存入', '支取')),
	cardID char(19) not null,
	transMoney money not null check(transMoney > 0),
	curTransID varchar(500),
	remark varchar(50)

	foreign key (userID) references userInfo(userID)
);
create table cardInfo(
	cardID char(19) not null check(cardID like '____ ____ ____ ____'),
	curTYpe char(5) not null default 'RMB',
	savingType char(8) not null check(savingType in('活期', '定活两便', '定期')),
	openDate datetime not null default current_timestamp,
	openMoney money not null check(openMoney >= 1),
	balance money not null,
	pass char(6) not null default '888888' check(pass like '______'),
	IsReportLoss bit  not null check(IsReportLoss in('true','false')),
	customerID int not null,
	IsVIP bit not null default 'false',
	
	primary key (cardID, savingType),
	foreign key (customerID) references customerInfo(customerID) 
);

create table LogInfo(
	logID int primary key identity(1,1),
	userID uniqueidentifier not null,
	userType varchar(20) not null check(userType in('ATM','营业员')),
	opDate datetime not null default current_timestamp,
	transType varchar(50) not null check(transType in('存入','支取','转账','开户','销户','挂失','修改密码','其他')),
	remark varchar(50),
	
	foreign key (userID) references userInfo(userID)
);

create table cardNO (
	cardID char(19) primary key check(cardID like '2022 0676 ____ ____'),
	IsUse bit not null default 'false' check(IsUse in('true','false'))
);
