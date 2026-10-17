-- 1. إنشاء قاعدة البيانات
DROP DATABASE IF EXISTS OnlineStoreDB;
CREATE DATABASE OnlineStoreDB;
USE OnlineStoreDB;

-- 2. إنشاء جدول العملاء (Customers)
CREATE TABLE Customers(
    customer_id INT AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    CONSTRAINT PK_Customers PRIMARY KEY (customer_id)
);

-- 3. إنشاء جدول المنتجات (Products)
CREATE TABLE Products(
    product_id INT AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    CONSTRAINT PK_Products PRIMARY KEY (product_id),
    CONSTRAINT CHK_Price CHECK (price > 0),
    CONSTRAINT CHK_Stock CHECK (stock >= 0)
);

-- 4. إنشاء جدول الطلبات (Orders)
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (order_id),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT FK_Orders_Products FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    CONSTRAINT CHK_Quantity CHECK (quantity > 0)
);

------------------------------------------------------

-- إدخال 5 سجلات في جدول العملاء
INSERT INTO Customers (customer_name, email, phone) VALUES
('أحمد علي', 'ahmed@email.com', '0501112222'),
('سارة محمد', 'sara@email.com', '0503334444'),
('خالد عبد الله', 'khaled@email.com', '0505556666'),
('ريم سلطان', 'reem@email.com', '0507778888'),
('فهد منصور', 'fahad@email.com', '0509990000');

-- إدخال 5 سجلات في جدول المنتجات
INSERT INTO Products (product_name, price, stock) VALUES
('لاب توب', 3500.00, 10),
('هاتف ذكي', 2500.00, 15),
('سماعة لاسلكية', 450.00, 30),
('شاحن سريع', 120.00, 50),
('ساعة ذكية', 850.00, 20);

-- إدخال 5 سجلات في جدول الطلبات
INSERT INTO Orders (customer_id, product_id, order_date, quantity) VALUES
(1, 1, '2025-05-01', 1), -- أحمد اشترى لاب توب
(2, 3, '2025-06-02', 2), -- سارة اشترت سماعتين
(3, 2, '2025-07-03', 1), -- خالد اشترى هاتف ذكي
(4, 5, '2025-08-04', 1), -- ريم اشترت ساعة ذكية
(5, 4, '2025-09-05', 3); -- فهد اشترى 3 شواحن

------------------------------------------------------

-- الاستعلام 1: عرض المنتجات التي يزيد سعرها عن 500 ريال
SELECT product_name, price FROM Products 
WHERE price > 500.00;

-- الاستعلام 2: عرض تفاصيل العميل الذي يملك البريد الإلكتروني الخاص بـ 'sara@email.com'
SELECT * FROM Customers 
WHERE email = 'sara@email.com';

------------------------------------------------------

-- الاستعلام 3: حساب إجمالي عدد المنتجات المتاحة في المخزن (COUNT)
SELECT COUNT(*) AS Total_Products_Types FROM Products;

-- الاستعلام 4: حساب إجمالي الكميات المطلوبة لكل منتج (SUM و GROUP BY)
SELECT product_id, SUM(quantity) AS Total_Quantity_Ordered 
FROM Orders 
GROUP BY product_id;

------------------------------------------------------

-- الاستعلام 5: ربط جدول العملاء بجدول الطلبات لمعرفة اسم العميل وتاريخ طلبه والكمية
SELECT c.customer_name, o.order_date, o.quantity 
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id;

------------------------------------------------------

-- الاستعلام 6: عرض تفاصيل المنتجات التي تم شراؤها بالفعل في جدول الطلبات (Subquery)
SELECT * FROM Products 
WHERE product_id IN (SELECT DISTINCT product_id FROM Orders);

------------------------------------------------------

-- إنشاء View يجمع اسم العميل، اسم المنتج، والكمية المطلوبة لتسهيل قراءة التقارير
CREATE VIEW Order_Summary_Report AS
SELECT o.order_id, c.customer_name, p.product_name, o.quantity, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;

-- تشغيل الـ View لاستعراض التقرير
SELECT * FROM Order_Summary_Report;