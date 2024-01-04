select city 
		from offices 
order by city;

select employeenumber, lastname, firstname, extension  
		from employees 
		where officecode = 4;

select ProductCode, ProductName, ProductVendor, quantityinstock, productline 
		from products  
		where quantityinstock between 200 and 1200;

select Productcode, ProductName,  productvendor, 
			buyprice, MSRP   
		from products  
		where MSRP = ( 
 		select min(msrp) from products);

select ProductName, (MSRP - BuyPrice) as PROFIT   
		from products  
	order by profit desc limit 1;

select distinct country, count(*) as customers
		from customers
		group by country
			having count(*) = 2 
order by 1 asc;

select p.productcode, productname, 
			count(ordernumber) as OrderCount  	
		from products p join orderdetails o on p.productcode = o.productcode     
group by productcode, productname 
having OrderCount = 25;

select employeenumber, 
			concat(firstname," ",lastname) as name 
 	from employees 
    where reportsto in ('1002', '1102');

select employeenumber, lastname, firstname 
		from employees 
		where reportsto is null;

select productname, productline  
	      from products 
	      where productline = "Classic Cars"  
	         and productname like "195%" 
order by productname;

select count(ordernumber),  
			monthname(orderdate) as ordermonth  
		from  orders  
		where extract(year from orderdate) = '2004' group by ordermonth 
order by 1 desc limit 1;

select lastname, firstname 
		from employees e left outer join customers c on e.employeenumber = c.salesrepemployeenumber 
where customername is null  
		and jobtitle = 'Sales Rep';

select customername , country 
		from customers c left outer join orders o on c.customernumber = o.customernumber 
where o.customernumber is null    
	  and country = 'Switzerland';
      
select customername, sum(quantityordered) as totalq 
		from customers c  
			join orders o on c.customernumber = o.customernumber 
          join orderdetails d on o.ordernumber = d.ordernumber 
group by customername  
having totalq > 1650;

create table if not exists TopCustomers ( 
 	Customernumber int not null,  
	ContactDate    DATE not null, 
     OrderTotal 	decimal(9,2) not null default 0, constraint PKTopCustomers primary key (CustomerNumber) 
 );
 
insert into TopCustomers 
	select c.customernumber, CURRENT_date, 
			  SUM(priceEach * Quantityordered) 
 	   	from Customers c, Orders o,OrderDetails d  	 	
			where c.Customernumber = o.Customernumber  
      	  and o.Ordernumber = d.Ordernumber 
 	group by c.Customernumber 
 	having SUM(priceEach * Quantityordered) > 140000;

select * from topcustomers order by 3 desc;

alter table topcustomers 
		add column OrderCount integer ;

update topcustomers 
		set ordercount = floor((rand()*18));

select * 
		from topcustomers 
		order by 4 desc;

drop table topcustomers;