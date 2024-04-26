exec InsertOperator 'ATM|营业员|营业员|ATM|营业员';

exec GetCardID;

exec insertCard @customerName = '王强', @PID = '230101200006191225', @telephone = '139-3624-1002', @customerAddress = '黑大';
exec insertCard @customerName = '李伟', @PID = '230102200006191232', @telephone = '139-3624-1005', @customerAddress = '黑大';

exec DepositMoney @customerName = '王强', @amount = 5000;
exec DepositMoney @customerName = '李伟', @amount = 150000;

exec TransferAccounts @fromName = '李伟', @toName = '王强', @amount = 10000;

exec AlterVip

exec GetMoney @customerName = '王强', @savingType = '活期', @amount = 5000.5;
exec GetMoney @customerName = '李伟', @savingType = '活期', @amount = 2000;


/* Test
	判断触发器是否有效（余额不足1元删卡）
*/
update cardInfo 
--测试能否自动删卡
set balance = 1
where customerID = (select customerID from customerInfo where customerName = '王强');
exec GetMoney @customerName = '王强', @savingType = '活期', @amount = 0.5;


/*
	TestGetMoney
*/
--测试异常数据 (取款0元）
exec GetMoney @customerName = '李伟', @savingType = '活期', @amount = 0;