--script
USE [master]
GO
/****** Object:  Database [ATM]    Script Date: 04/24/2024 14:59:00 ******/
CREATE DATABASE [ATM] ON  PRIMARY 
( NAME = N'ATM', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\ATM.mdf' , SIZE = 2304KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ATM_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\ATM_log.LDF' , SIZE = 576KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ATM] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ATM].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ATM] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [ATM] SET ANSI_NULLS OFF
GO
ALTER DATABASE [ATM] SET ANSI_PADDING OFF
GO
ALTER DATABASE [ATM] SET ANSI_WARNINGS OFF
GO

ALTER DATABASE [ATM] SET ARITHABORT OFF
GO
ALTER DATABASE [ATM] SET AUTO_CLOSE ON
GO
ALTER DATABASE [ATM] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [ATM] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [ATM] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [ATM] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [ATM] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [ATM] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [ATM] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [ATM] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [ATM] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [ATM] SET  ENABLE_BROKER
GO
ALTER DATABASE [ATM] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [ATM] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [ATM] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [ATM] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [ATM] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [ATM] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [ATM] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [ATM] SET  READ_WRITE
GO
ALTER DATABASE [ATM] SET RECOVERY SIMPLE
GO
ALTER DATABASE [ATM] SET  MULTI_USER
GO
ALTER DATABASE [ATM] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [ATM] SET DB_CHAINING OFF
GO
USE [ATM]
GO
/****** Object:  Table [dbo].[customerInfo]    Script Date: 04/24/2024 14:59:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[customerInfo](
	[customerID] [int] IDENTITY(1,1) NOT NULL,
	[customerName] [varchar](20) NOT NULL,
	[PID] [char](18) NOT NULL,
	[telephone] [char](13) NOT NULL,
	[customerAddress] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cardNO]    Script Date: 04/24/2024 14:59:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cardNO](
	[cardID] [char](19) NOT NULL,
	[IsUse] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cardID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[userInfo]    Script Date: 04/24/2024 14:59:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userInfo](
	[userID] [uniqueidentifier] NOT NULL,
	[userType] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[userID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[GetCardID]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--2.随机生成10张新卡
CREATE proc [dbo].[GetCardID]
as 
begin
	declare @i int  = 0; 
	declare @d1 int, @d2 int, @result char(19);
	
	while @i < 10
	begin
		--生成两组4位数字
		set @d1 = ABS(CHECKSUM(NEWID())) % 9000 + 1000;
		set @d2 = ABS(CHECKSUM(NEWID())) % 9000 + 1000;

		set @result = '2022 0676 ' + cast(@d1 as char(4)) +' '+ cast(@d2 as char(4));
	
		if not exists(select 1 from cardNo where cardID = @result)
		begin
			insert into dbo.cardNO(cardID) values(@result);
			set @i = @i + 1;
		end
	end
end
GO
/****** Object:  Table [dbo].[transInfo]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[transInfo](
	[transID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [uniqueidentifier] NOT NULL,
	[userType] [varchar](20) NOT NULL,
	[transDate] [datetime] NOT NULL,
	[transType] [varchar](20) NOT NULL,
	[cardID] [char](19) NOT NULL,
	[transMoney] [money] NOT NULL,
	[curTransID] [varchar](500) NULL,
	[remark] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[transID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LogInfo]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LogInfo](
	[logID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [uniqueidentifier] NOT NULL,
	[userType] [varchar](20) NOT NULL,
	[opDate] [datetime] NOT NULL,
	[transType] [varchar](50) NOT NULL,
	[remark] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[logID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[InsertOperator]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--1.插入操作员 
CREATE proc [dbo].[InsertOperator](
	@string varchar(50)
)
as 
begin
	declare @operatorToInsert varchar(6);

	while charindex('|', @string)> 0
	begin
		--获取待插入的操作员
		set @operatorToInsert = substring(@string, 1, charindex('|', @string) - 1);
		insert into userInfo (userType) values(@operatorToInsert);

		--删除字符串中已插入的部分，为下次迭代做准备
		set @string = substring(@string ,charindex('|', @string) + 1, len(@string));
	end
		--插入最后一个操作员
		set @operatorToInsert = @string;
		insert into userInfo (userType) values(@operatorToInsert);
	
end
GO
/****** Object:  StoredProcedure [dbo].[WriteLogInfo]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[WriteLogInfo](
	@transType varchar(20)
)
as
begin
	declare @userID uniqueidentifier;
	declare @userType varchar(20);

	select top 1 @userID = userID, @userType = userType from userInfo;

	insert into LogInfo(userID, userType, transType)
	values(@userID, @userType, @transType);
end
GO
/****** Object:  Table [dbo].[cardInfo]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cardInfo](
	[cardID] [char](19) NOT NULL,
	[curTYpe] [char](5) NOT NULL,
	[savingType] [char](8) NOT NULL,
	[openDate] [datetime] NOT NULL,
	[openMoney] [money] NOT NULL,
	[balance] [money] NOT NULL,
	[pass] [char](6) NOT NULL,
	[IsReportLoss] [bit] NOT NULL,
	[customerID] [int] NOT NULL,
	[IsVIP] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cardID] ASC,
	[savingType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[AlterVip]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AlterVip]
as
begin
	declare @customerID int;

	-- 声明一个游标用于遍历满足条件的客户
	declare curCustomers cursor for
		select customerID
		from cardInfo
		where balance > 80000;

	-- 打开游标
	open curCustomers;
	fetch next from curCustomers into @customerID;

	-- 循环遍历游标中的每个客户，将符合条件的设置为VIP
	while @@FETCH_STATUS = 0
	begin
		update cardInfo
		set IsVip = 'true'
		where  customerID = @customerID;

		-- 继续从游标中获取下一个客户ID
		fetch next from curCustomers into @customerID;
	end
	-- 关闭游标
	close curCustomers;

	-- 释放游标所占用的资源
	deallocate curCustomers;
end
GO
/****** Object:  StoredProcedure [dbo].[InsertCard]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--3.开户
CREATE proc [dbo].[InsertCard](
	@customerName varchar(20),
	@PID char(18),
	@telephone char(13),
	@customerAddress varchar(50)
	
)
as
begin 
	declare @newCardID char(19), @customerID int ;

	--将传入的参数保存到客户信息表
	insert into customerInfo(customerName, PID, telephone, customerAddress)
	values(@customerName, @PID, @telephone, @customerAddress);

	--选择一张未被使用的卡
	select top 1 @newCardID = cardID
	from cardNO
	where IsUse = 'false';

	update cardNO
	set IsUse = 'true'
	where cardID = @newCardID;
	
	set @customerID = (select customerID from customerInfo where customerName = @customerName)
	
	insert into cardInfo(cardID, savingType, openMoney, balance, IsReportLoss, customerID)
	values(@newCardID, '活期', 1, 1, 'false', @customerID); 

	--写日志表
	exec WriteLogInfo @transType = '开户';
end
GO
/****** Object:  StoredProcedure [dbo].[WriteTransInfo]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[WriteTransInfo](
	@customerID int,
	@transType varchar(20),
	@transMoney money
)
as
begin
	declare @userID uniqueidentifier;
	declare @userType varchar(20);
	declare @cardID char(19);

	select @cardID = cardID
	from cardInfo
	where customerID = @customerID;

	select top 1 @userID = userID, @userType = userType from userInfo;

	insert into transInfo (userID, userType, transType, cardID, transMoney) 
	values (@userID, @userType, @transType, @cardID, @transMoney);

end
GO
/****** Object:  Trigger [DeleteCard]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[DeleteCard]
on [dbo].[cardInfo]
after update 
as 
begin 
	if exists(select * from inserted i where i.balance < 1)
	begin
		declare @customerID int;
		
		select top 1 @customerID = customerID from inserted
		
		delete from cardInfo where customerID = @customerID
		
		--写日志表
		exec WriteLogInfo @transType = '销户';
		
		print '余额不足一元， 已经删除该卡';
	end
end
GO
/****** Object:  StoredProcedure [dbo].[DepositMoney]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--4.存款
CREATE proc [dbo].[DepositMoney](
	@customerName varchar(20),
	@amount money 
)
as
begin
	declare @customerID int;

	select @customerID = customerID 
	from customerInfo
	where customerName = @customerName;

	--写交易信息表
	exec WriteTransInfo @customerID = @customerID, @transType = '存入', @transMoney = @amount;

	--写日志表
	exec WriteLogInfo @transType = '存入';

	update cardInfo 
	set balance += @amount
	where customerID = @customerID
end
GO
/****** Object:  StoredProcedure [dbo].[GetMoney]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetMoney] (
	@customerName varchar(20),
	@savingType char(8),
	@amount money
)
as
begin
	declare @balance money, @customerID int;

	declare @result varchar(30);

	select @customerID = customerID
	from customerInfo 
	where customerName = @customerName;
	
	select @balance = balance
	from cardInfo
	where customerID = @customerID
	
	if @balance >= @amount and @amount > 0 
	begin 
		exec WriteTransInfo @customerID = @customerID, @transType = '支取', @transMoney = @amount;
		exec WriteLogInfo @transType = '支取';
		
		print '取款成功，余额为 ' + cast(@balance - @amount as nvarchar(20)) + 'RMB';

		update cardInfo
		set balance = balance - @amount
		where customerID = @customerID;
		
	end

	else if @balance < @amount  
	begin
		print '余额不足，取款失败';
	end

	else
	begin
		print '取款金额异常，操作终止';
		return
	end
end
GO
/****** Object:  StoredProcedure [dbo].[TransferAccounts]    Script Date: 04/24/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--5.转账
CREATE proc [dbo].[TransferAccounts](
	@fromName varchar(20),
	@toName varchar(20),
	@amount money
)
as
begin
	declare @fromID int, @toID int;
	declare @balance money;

	select @fromID = customerID
	from customerInfo
	where customerName = @fromName

	select @toID = customerID
	from customerInfo
	where customerName = @toName

	select @balance = balance
	from cardInfo
	where customerID = @fromID

	--若钱不够，直接return
	if @balance < @amount
	begin
		print '转账失败！（账户余额不足）'
		return
	end

	--写日志表
	exec WriteLogInfo @transType = '转账';

	--转账过程（通过事务）
	begin transaction 

	declare @done int;
	set @done = 0;

	--写交易信息表
	exec WriteTransInfo @customerID = @fromID, @transType = '支取', @transMoney = @amount;

	update cardInfo
	set balance -= @amount
	where customerID = @fromID;

	--写交易信息表
	exec WriteTransInfo @customerID = @fromID, @transType = '存入', @transMoney = @amount;

	update cardInfo
	set balance += @amount
	where customerID = @toID;

	if @@error = 0
		commit transaction;
	else 
		rollback transaction;
end
GO
/****** Object:  Default [DF__cardNO__IsUse__1FCDBCEB]    Script Date: 04/24/2024 14:59:00 ******/
ALTER TABLE [dbo].[cardNO] ADD  DEFAULT ('false') FOR [IsUse]
GO
/****** Object:  Default [DF__userInfo__userID__20C1E124]    Script Date: 04/24/2024 14:59:00 ******/
ALTER TABLE [dbo].[userInfo] ADD  DEFAULT (newid()) FOR [userID]
GO
/****** Object:  Default [DF__transInfo__trans__21B6055D]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[transInfo] ADD  DEFAULT (getdate()) FOR [transDate]
GO
/****** Object:  Default [DF__LogInfo__opDate__22AA2996]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[LogInfo] ADD  DEFAULT (getdate()) FOR [opDate]
GO
/****** Object:  Default [DF__cardInfo__curTYp__239E4DCF]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo] ADD  DEFAULT ('RMB') FOR [curTYpe]
GO
/****** Object:  Default [DF__cardInfo__openDa__24927208]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo] ADD  DEFAULT (getdate()) FOR [openDate]
GO
/****** Object:  Default [DF__cardInfo__pass__25869641]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo] ADD  DEFAULT ('888888') FOR [pass]
GO
/****** Object:  Default [DF__cardInfo__IsVIP__267ABA7A]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo] ADD  DEFAULT ('false') FOR [IsVIP]
GO
/****** Object:  Check [CK__customerI__telep__276EDEB3]    Script Date: 04/24/2024 14:59:00 ******/
ALTER TABLE [dbo].[customerInfo]  WITH CHECK ADD CHECK  (([telephone] like '___-____-____'))
GO
/****** Object:  Check [CK__customerInf__PID__286302EC]    Script Date: 04/24/2024 14:59:00 ******/
ALTER TABLE [dbo].[customerInfo]  WITH CHECK ADD CHECK  ((len([PID])=(15) OR len([PID])=(18)))
GO
/****** Object:  Check [CK__cardNO__cardID__29572725]    Script Date: 04/24/2024 14:59:00 ******/
ALTER TABLE [dbo].[cardNO]  WITH CHECK ADD CHECK  (([cardID] like '2022 0676 ____ ____'))
GO
/****** Object:  Check [CK__cardNO__IsUse__2A4B4B5E]    Script Date: 04/24/2024 14:59:00 ******/
ALTER TABLE [dbo].[cardNO]  WITH CHECK ADD CHECK  (([IsUse]='false' OR [IsUse]='true'))
GO
/****** Object:  Check [CK__userInfo__userTy__2B3F6F97]    Script Date: 04/24/2024 14:59:00 ******/
ALTER TABLE [dbo].[userInfo]  WITH CHECK ADD CHECK  (([userType]='营业员' OR [userType]='ATM'))
GO
/****** Object:  Check [CK__transInfo__trans__2C3393D0]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[transInfo]  WITH CHECK ADD CHECK  (([transType]='支取' OR [transType]='存入'))
GO
/****** Object:  Check [CK__transInfo__trans__2D27B809]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[transInfo]  WITH CHECK ADD CHECK  (([transMoney]>(0)))
GO
/****** Object:  Check [CK__transInfo__userT__2E1BDC42]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[transInfo]  WITH CHECK ADD CHECK  (([userType]='营业员' OR [userType]='ATM'))
GO
/****** Object:  Check [CK__LogInfo__transTy__2F10007B]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[LogInfo]  WITH CHECK ADD CHECK  (([transType]='其他' OR [transType]='修改密码' OR [transType]='挂失' OR [transType]='销户' OR [transType]='开户' OR [transType]='转账' OR [transType]='支取' OR [transType]='存入'))
GO
/****** Object:  Check [CK__LogInfo__userTyp__300424B4]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[LogInfo]  WITH CHECK ADD CHECK  (([userType]='营业员' OR [userType]='ATM'))
GO
/****** Object:  Check [CK__cardInfo__cardID__30F848ED]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo]  WITH CHECK ADD CHECK  (([cardID] like '____ ____ ____ ____'))
GO
/****** Object:  Check [CK__cardInfo__IsRepo__31EC6D26]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo]  WITH CHECK ADD CHECK  (([IsReportLoss]='false' OR [IsReportLoss]='true'))
GO
/****** Object:  Check [CK__cardInfo__openMo__32E0915F]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo]  WITH CHECK ADD CHECK  (([openMoney]>=(1)))
GO
/****** Object:  Check [CK__cardInfo__pass__33D4B598]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo]  WITH CHECK ADD CHECK  (([pass] like '______'))
GO
/****** Object:  Check [CK__cardInfo__saving__34C8D9D1]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo]  WITH CHECK ADD CHECK  (([savingType]='定期' OR [savingType]='定活两便' OR [savingType]='活期'))
GO
/****** Object:  ForeignKey [FK__transInfo__userI__35BCFE0A]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[transInfo]  WITH CHECK ADD FOREIGN KEY([userID])
REFERENCES [dbo].[userInfo] ([userID])
GO
/****** Object:  ForeignKey [FK__LogInfo__userID__36B12243]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[LogInfo]  WITH CHECK ADD FOREIGN KEY([userID])
REFERENCES [dbo].[userInfo] ([userID])
GO
/****** Object:  ForeignKey [FK__cardInfo__custom__37A5467C]    Script Date: 04/24/2024 14:59:01 ******/
ALTER TABLE [dbo].[cardInfo]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[customerInfo] ([customerID])
GO
