/*(1), (2), (3, and (4) Delete all (temporary) records as a restart to buying new items*/
DELETE FROM Items;
DELETE FROM Packages;
DELETE FROM Cost;
DELETE FROM Buyer_buys_Item;

/*(1) Insert buyers' information with all specifications filled*/
INSERT INTO Buyers (first_name, last_name, age, email) VALUES ('Gabriel', 'Mendoza', '21', 'mendoza0302@yahoo.com'), ('Ren', 'Enzo', '34', 'robot772@gmail.com');
/*(2) Insert buyers' information without age filled, null*/
INSERT INTO Buyers (first_name, last_name, email) VALUES ('Abigail', 'Cortez', 'flora9@gmail.com'), ('Mark', 'Brown', 'ghost66@yahoo.com');
/*(3) Insert name and location of each store with available merchandise from Items table*/
INSERT INTO Stores (name, location) VALUES ('Walmart', 'Atlanta, GA'), ('Stater Bros.', 'Bloomington, CA'), ('Target', 'Memphis, TN'), ('Home Depot', 'Chicago, IL'), ('Amazon', 'San Francisco, CA');
/*(4) Insert name of each popular delivery service*/
INSERT INTO Delivery_Services (name) VALUES ('UPS'), ('Hollywood Delivery Service'), ('FedEx'), ('Uber');
/*(5) Insert name of each country that the specified buyer is situated in*/
INSERT INTO Countries (name) VALUES ('San Diego, CA'), ('Dallas, TX'), ('Las Vegas, NV'), ('Topeka, KS');
/*(6) Insert payment types for each individual buyer, some people have more than one*/
INSERT INTO Payment (cardnumber, expiration, status, Buyer_id) VALUES ('6825052395364721', '10/29', 'Valid', 3), ('9063482641174335', '03/24', 'Valid', 2), ('', '12/22', 'Expired', 2), ('', '08/25', 'Valid', 4),
																	  ('3417665243805527', '02/23', 'Expired', 1), ('', '09/27', 'Valid', 1), ('57878853100946675', '01/21', 'Expired', 3), ('7872100290338168', '02/30', 'Valid', 2);
/*(7) Insert information of each item being bought*/
INSERT INTO Items (name, weight, price, Package_id) VALUES ('Pencils (10 Pack)', '0.91', '1.60', 1), ('Door Hinges (3 Pack)', '1.57', '7.98', 2), ('Tissue Boxes', '0.38', '3.69', 3),
														   ('AA Batteries (12 pack)', '2.13', '4.75', 4), ('Compact Umbrella', '2.56', '4.34', 5), ('Bottle of Red Wine', '5.46', '11.99', 6);
/*(8) Insert the type of package being used*/
INSERT INTO Packages (size, weight, numStamps, validWeight) VALUES ('14.0', '0.08', '2', 'Yes'), ('5.0', '0.03', '3', 'Yes'), ('30.0', '0.37', '5', 'Yes'),
																   ('8.0', '0.05', '3', 'Yes'), ('18.0', '0.21', '4', 'Yes'), ('25.0', '0.32', '7', 'Yes');
/*(9) Insert the number of each individual item available in each store*/
INSERT INTO Store_has_Item (Store_id, Item_id, numberOfItem) VALUES ('1', '1', '46'), ('1', '2', '18'), ('1', '3', '156'), ('1', '4', '93'),
																	('2', '1', '23'), ('2', '3', '97'), ('2', '4', '34'), ('2', '6', '7'),
																	('3', '1', '31'), ('3', '3', '45'), ('3', '4', '36'), ('3', '5', '19'), ('3', '6', '10'),
																	('4', '2', '562'), ('4', '4', '144'),
																	('5', '1', '325'), ('5', '2', '728'), ('5', '3', '267'), ('5', '4', '449'), ('5', '5', '68');
/*(10) Insert the price of each delivery service, one service could be shipping more than one package at a time*/
INSERT INTO Delivery_in_Service (Delivery_id, Delivery_Service_id, price) VALUES ('2', '3', '5.00'), ('4', '1', '11.00'), ('3', '2', '6.00'), ('6', '4', '3.50'), ('1', '2', '9.00'), ('5', '3', '5.00');
/*(11) Insert number of days for delivery to reach buyer's location*/
INSERT INTO Delivery (days, Buyer_id) VALUES (8, '1'), (6, '4'), (4, '3'), (5, '4'), (2, '2'), (1, '3');
/*(12) Insert total number of each item the buyer buys*/
INSERT INTO Buyers_buy_Item (total, Buyer_id, Item_id) VALUES (5, '1', '1'), (2, '4', '2'), (6, '3', '3'), (1, '4', '4'), (1, '2', '5'), (1, '3', '6');

/*(1) Update Buyers' information*/
UPDATE Buyers SET first_name = 'Paul', age = '25' WHERE id = 1;
/*(2) and (3) Update Store information*/
UPDATE Stores SET name = 'Harbor Freight' WHERE id = 4;
UPDATE Stores SET location = 'Menifee, CA' WHERE id = 2;
/*(4), (5), and (6) Update Deivery Service information*/
UPDATE Delivery SET days = 3 WHERE id = 6;
UPDATE Delivery_Services SET name = 'Grubhub' WHERE id = '4';
UPDATE Delivery_in_Service SET price = 6.50 WHERE Delivery_Services_id = '2';
/*(7) Update country location*/
UPDATE Countries SET name = 'Pahrump, NV' WHERE id = 3;
/*(8) Update expiration date of payment card*/
UPDATE Payment SET expiration = '04/35' WHERE cardnumber = '6825052395364721';
/*(9) Update item details*/
UPDATE Items SET price = '5.25' WHERE name = 'Compact Umbrella';
/*(10) Update package details*/
UPDATE Packages SET size = '13.0' WHERE id = 5;


/*(1) Add column that specifies the type of method being used: debit, paypal, or visa*/
ALTER TABLE Payment ADD payment_type VARCHAR(20);
/*(13) Insert names into new column payment_type, some people have more than one*/
INSERT INTO Payment (payment_type) VALUES ('Visa', 'Debit', 'Paypal', 'Paypal', 'Visa', 'Paypal', 'Debit', 'Debit');
/*(2) and (3) Change name of column price in Delivery_in_Service and Cost tables*/
ALTER TABLE Delivery_in_Service RENAME COLUMN price to service_price;
ALTER TABLE Cost RENAME COLUMN price to total_price;
/*(4) Remove itemAvailability column*/
ALTER TABLE Store_has_Item DROP COLUMN itemAvailability;

/*(14) Insert total price into Cost table, along with IDs, by adding those from other tables*/
INSERT INTO Cost (price) VALUES (Delivery_in_Service.service_price + Distance.price + (Items.price * Buyer_buys_Item.total) + ((Item.weight + Package.weight) * 0.5));


/*Join all tables into one*/
SELECT Cost.id, Packages.id
FROM Packages 
LEFT JOIN Cost ON Packages.id = Cost.Package_id
UNION ALL
SELECT Distance.id, Items.name, Packages.id
FROM Packages
RIGHT JOIN Distance ON Packages.id = Distance.Package_id
RIGHT JOIN Items ON Packages.id = Items.Package_id
UNION ALL
SELECT Delivery_Services.name, Delivery_in_Service.price
FROM Delivery_Services
RIGHT JOIN Delivery_in_Service ON Delivery_Services.id = Delivery_in_Service.Delivery_Service_id
UNION ALL
SELECT Delivery.id,  Distance.price,  Delivery_in_Service.price
FROM Delivery
LEFT JOIN Distance ON Delivery.id = Distance.Delivery_id
LEFT JOIN Delivery_in_Service ON Delivery.id = Delivery_in_Service.Delivery_id
UNION ALL
SELECT Items.name, Buyer_buys_Item.total, Store_has_Item.numberOfItem
FROM Items
RIGHT JOIN Buyer_buys_Item ON Items.id = Buyer_buys_Item.Item_id
RIGHT JOIN Store_has_Item ON Items.id = Store_has_Item.Item_id
UNION ALL
SELECT Store.name,  Store_has_Item.numberOfItem
FROM Store
LEFT JOIN Store_has_Item.numberOfItem ON Store.id = Store_has_Item.numberOfItem.Store_id
UNION ALL
SELECT Buyers.first_name, Countries.name, Payment.cardnumber, Delivery.id, Buyer_buys_Item. total, Cost.price, Stores.name
FROM Buyers 
INNER JOIN Countries ON Buyers.Country_id = Countries.id
INNER JOIN Payment ON Buyers.id = Payment.Buyer_id
INNER JOIN Delivery ON Buyers.id = Delivery.Buyer_id
INNER JOIN Buyer_buys_Item ON Buyers.id = Buyer_buys_Item.Buyer_id
INNER JOIN Cost ON Buyers.id = Cost.Buyer_id
INNER JOIN Stores ON Buyers.id = Stores.Buyer_id;


/*(1) Count the number of different countries*/
SELECT COUNT(id), Country_id FROM Buyers GROUP BY Country_id;
/*(2) Add up the total price each buyer is paying*/
SELECT SUM(total_price), Buyer_id FROM Cost GROUP BY Buyer_id;
/*(3) Add up how many of items (altogether) exists throughout all available stores*/
SELECT SUM(numberOfItem) Store_id FROM Store_has_Item GROUP BY Store_id;
/*(4) Calculate the number of days it'll take to deliver each item*/
SELECT SUM(days), Buyer_id FROM Delivery GROUP BY Buyer_id;
/*(5) Count how many delivery services are available for use*/
SELECT COUNT(id) FROM Delivery_Services GROUP BY id;
/*(6) Count how many total packages are being delivered*/
SELECT COUNT(id) FROM Packages GROUP BY id;
/*(7) Count the number of items each buyer has bought*/
SELECT COUNT(id), Buyer.id FROM Items GROUP BY Buyer.id;


/*(1) Count number of buyers under the age of 18*/
SELECT COUNT(id), age FROM Buyers GROUP BY id HAVING age < 18;
/*(5) Delete any buyer under age 18*/
DELETE FROM Buyers WHERE age < 18;

/*(2) Count the number of package that do not exceed the weight limit (150 lbs)*/
SELECT COUNT(id), Package_id, weight FROM Items GROUP BY Package_id HAVING weight < 150.00;
/*(5) Drop the column labeled validWeight in Packages table*/
ALTER TABLE Packages DROP COLUMN validWeight;

/*(3) Check the package with the lowest number of stamps to see if it fits the minimum requirement (0)*/
SELECT MIN(numStamps), weight FROM Packages GROUP BY weight HAVING numStamps > 0;
/*(6) Delete any packages with no stamps*/
DELETE FROM Packages WHERE numStamps = 0;

/*(4) Check how many payment methods are already expired*/
SELECT COUNT(cardnumber), id FROM Payment GROUP BY id HAVING status = 'Yes';
/*(7) Remove/Delete all expired payment cards (payment_type inserted previously)*/
DELETE FROM Payment WHERE ((payment_type = 'Debit' OR payment_type = 'Visa') AND status = 'Expired');

/*(5) Count how many distances, for delivery, goes over the maximum range (2000 miles)*/
SELECT COUNT(id) FROM Distance GROUP BY id HAVING (end - start) < 2000;
/*(8) Delete any packages that cannot be shipped based on distance*/
DELETE FROM Distance WHERE (end - start) < 2000;

/*(6) Check how many items are unavailable throughout all stores that might have them*/
SELECT COUNT(Item_id) FROM Store_has_Item GROUP BY Store_id HAVING numberOfItem > 0;

/*(7) Check how many card number are 16-digits long*/
SELECT COUNT(id), cardnumber FROM Payment GROUP BY id HAVING LEN(cardnumber) = 16;
/*(10) Delete any payment methods with invalid card number*/
DELETE FROM Payment WHERE ((payment_type = 'Debit' OR payment_type = 'Visa') AND LEN(cardnumber) < 16);