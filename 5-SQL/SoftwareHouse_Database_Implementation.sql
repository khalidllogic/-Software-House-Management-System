-- ==============================================================================
-- القسم الأول: إنشاء الجداول الأساسية والفرعية (DDL) - نفذ بالترتيب الصارم
-- ==============================================================================

-- [الخطوة 1]: جدول العملاء الرئيسي
CREATE TABLE Client (
    Client_ID NUMBER PRIMARY KEY,
    First_Name VARCHAR2(50) NOT NULL,
    Middle_Name VARCHAR2(50),
    Last_Name VARCHAR2(50) NOT NULL,
    Street VARCHAR2(100) NOT NULL,
    City VARCHAR2(50) NOT NULL,
    Country VARCHAR2(50) NOT NULL,
    PostalCode VARCHAR2(20),
    Client_Type VARCHAR2(30) NOT NULL,
    Registration_Date DATE NOT NULL
);

-- ==============================================================================

-- [الخطوة 2]: جدول هواتف العملاء (متعدد القيم)
CREATE TABLE Client_Phone (
    Client_ID NUMBER NOT NULL,
    Phone VARCHAR2(20) NOT NULL,
    PRIMARY KEY (Client_ID, Phone),
    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 3]: جدول بريد العملاء (متعدد القيم)
CREATE TABLE Client_Email (
    Client_ID NUMBER NOT NULL,
    Email VARCHAR2(100) NOT NULL,
    PRIMARY KEY (Client_ID, Email),
    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 4]: جدول تذاكر الدعم الفني
CREATE TABLE SupportTicket (
    Ticket_ID NUMBER PRIMARY KEY,
    Ticket_Date DATE NOT NULL,
    Subject VARCHAR2(150) NOT NULL,
    Description VARCHAR2(4000) NOT NULL,
    Priority VARCHAR2(20) NOT NULL,
    Status VARCHAR2(20) NOT NULL,
    Client_ID NUMBER NOT NULL,
    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID)
);

-- ==============================================================================

-- [الخطوة 5]: جدول عقود المشاريع
CREATE TABLE Contract (
    Contract_ID NUMBER PRIMARY KEY,
    Contract_Date DATE NOT NULL,
    Contract_Value NUMBER(12, 2) NOT NULL,
    Contract_Terms VARCHAR2(4000) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Client_ID NUMBER NOT NULL,
    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID)
);

-- ==============================================================================

-- [الخطوة 6]: جدول المشاريع البرمجية
CREATE TABLE Project (
    Project_ID NUMBER PRIMARY KEY,
    Project_Name VARCHAR2(100) NOT NULL UNIQUE,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Status VARCHAR2(30) NOT NULL,
    Description VARCHAR2(4000),
    Contract_ID NUMBER NOT NULL UNIQUE,
    FOREIGN KEY (Contract_ID) REFERENCES Contract(Contract_ID)
);

-- ==============================================================================

-- [الخطوة 7]: جدول مراحل المشروع (كيان ضعيف)
CREATE TABLE ProjectPhase (
    Project_ID NUMBER NOT NULL,
    Phase_Name VARCHAR2(50) NOT NULL,
    Phase_ID NUMBER NOT NULL,
    Phase_StartDate DATE NOT NULL,
    Phase_EndDate DATE NOT NULL,
    Phase_Status VARCHAR2(30) NOT NULL,
    PRIMARY KEY (Project_ID, Phase_Name),
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 8]: جدول ميزانية المشروع
CREATE TABLE Budget (
    Budget_ID NUMBER PRIMARY KEY,
    Total_Amount NUMBER(12, 2) NOT NULL,
    Allocated_Amount NUMBER(12, 2) NOT NULL,
    Fiscal_Year NUMBER NOT NULL,
    Project_ID NUMBER NOT NULL UNIQUE,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 9]: جدول اجتماعات المشروع
CREATE TABLE Meeting (
    Meeting_ID NUMBER PRIMARY KEY,
    Meeting_Date DATE NOT NULL,
    Meeting_Time VARCHAR2(8) NOT NULL,
    Location VARCHAR2(100) NOT NULL,
    Agenda VARCHAR2(4000) NOT NULL,
    Project_ID NUMBER NOT NULL,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 10]: جدول مستندات المشروع
CREATE TABLE Document (
    Document_ID NUMBER PRIMARY KEY,
    Document_Name VARCHAR2(100) NOT NULL,
    Document_Type VARCHAR2(50) NOT NULL,
    Creation_Date DATE NOT NULL,
    File_Path VARCHAR2(255) NOT NULL UNIQUE,
    Project_ID NUMBER NOT NULL,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 11]: جدول الإصدارات البرمجية
CREATE TABLE Project_Release (
    Release_ID NUMBER PRIMARY KEY,
    Release_Version VARCHAR2(30) NOT NULL,
    Release_Date DATE NOT NULL,
    Release_Notes VARCHAR2(4000),
    Status VARCHAR2(30) NOT NULL,
    Project_ID NUMBER NOT NULL,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
);

-- ==============================================================================

-- [الخطوة 12]: جدول الفحوصات واختبارات الجودة
CREATE TABLE Test (
    Test_ID NUMBER PRIMARY KEY,
    Test_Name VARCHAR2(100) NOT NULL,
    Test_Type VARCHAR2(50) NOT NULL,
    Test_Date DATE NOT NULL,
    Test_Result VARCHAR2(20) NOT NULL,
    Project_ID NUMBER NOT NULL,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 13]: جدول الأخطاء البرمجية (Bugs)
CREATE TABLE Bug (
    Bug_ID NUMBER PRIMARY KEY,
    Bug_Title VARCHAR2(150) NOT NULL,
    Bug_Description VARCHAR2(4000) NOT NULL,
    Severity VARCHAR2(20) NOT NULL,
    Status VARCHAR2(20) NOT NULL,
    Discovery_Date DATE NOT NULL,
    Test_ID NUMBER NOT NULL,
    FOREIGN KEY (Test_ID) REFERENCES Test(Test_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 14]: جدول تقارير الأخطاء (كيان ضعيف)
CREATE TABLE BugReport (
    Bug_ID NUMBER NOT NULL,
    Report_Date DATE NOT NULL,
    Report_ID NUMBER NOT NULL,
    Reported_By VARCHAR2(100) NOT NULL,
    Report_Details VARCHAR2(4000) NOT NULL,
    PRIMARY KEY (Bug_ID, Report_Date),
    FOREIGN KEY (Bug_ID) REFERENCES Bug(Bug_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 15]: جدول المهام البرمجية
CREATE TABLE Task (
    Task_ID NUMBER PRIMARY KEY,
    Task_Name VARCHAR2(100) NOT NULL,
    Task_Description VARCHAR2(4000),
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Status VARCHAR2(30) NOT NULL,
    Priority VARCHAR2(20) NOT NULL,
    Project_ID NUMBER NOT NULL,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 16]: جدول التقنيات ولغات البرمجة
CREATE TABLE Technology (
    Technology_ID NUMBER PRIMARY KEY,
    Technology_Name VARCHAR2(50) NOT NULL UNIQUE,
    Technology_Type VARCHAR2(50) NOT NULL,
    Version VARCHAR2(20),
    Description VARCHAR2(4000)
);

-- ==============================================================================

-- [الخطوة 17]: جدول ربط المهام بالتقنيات (M:N)
CREATE TABLE Task_Technology (
    Task_ID NUMBER NOT NULL,
    Technology_ID NUMBER NOT NULL,
    PRIMARY KEY (Task_ID, Technology_ID),
    FOREIGN KEY (Task_ID) REFERENCES Task(Task_ID) ON DELETE CASCADE,
    FOREIGN KEY (Technology_ID) REFERENCES Technology(Technology_ID)
);

-- ==============================================================================

-- [الخطوة 18]: جدول الأقسام الإدارية والتقنية
CREATE TABLE Department (
    Department_ID NUMBER PRIMARY KEY,
    Department_Name VARCHAR2(100) NOT NULL UNIQUE,
    Location VARCHAR2(100) NOT NULL,
    Phone VARCHAR2(20) NOT NULL,
    Manager_ID NUMBER
);

-- ==============================================================================

-- [الخطوة 19]: جدول الأدوار الوظيفية وسلالم الرواتب
CREATE TABLE Job_Role (
    Role_ID NUMBER PRIMARY KEY,
    Role_Title VARCHAR2(50) NOT NULL UNIQUE,
    Role_Description VARCHAR2(4000),
    Min_Salary NUMBER(10, 2) NOT NULL,
    Max_Salary NUMBER(10, 2) NOT NULL
);

-- ==============================================================================

-- [الخطوة 20]: جدول الموظفين الرئيسي
CREATE TABLE Employee (
    Employee_ID NUMBER PRIMARY KEY,
    First_Name VARCHAR2(50) NOT NULL,
    Middle_Name VARCHAR2(50),
    Last_Name VARCHAR2(50) NOT NULL,
    Street VARCHAR2(100) NOT NULL,
    City VARCHAR2(50) NOT NULL,
    Country VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) NOT NULL UNIQUE,
    Hire_Date DATE NOT NULL,
    Salary NUMBER(10, 2) NOT NULL,
    Birth_Date DATE NOT NULL,
    Job_Title VARCHAR2(50) NOT NULL,
    Department_ID NUMBER NOT NULL,
    Role_ID NUMBER NOT NULL,
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID),
    FOREIGN KEY (Role_ID) REFERENCES Job_Role(Role_ID)
);

-- ربط مدير القسم بالموظفين
ALTER TABLE Department
ADD CONSTRAINT FK_Dept_Manager
FOREIGN KEY (Manager_ID) REFERENCES Employee(Employee_ID) ON DELETE SET NULL;

-- ==============================================================================

-- [الخطوة 21]: جدول هواتف الموظفين (متعدد القيم)
CREATE TABLE Employee_Phone (
    Employee_ID NUMBER NOT NULL,
    Phone VARCHAR2(20) NOT NULL,
    PRIMARY KEY (Employee_ID, Phone),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 22]: جدول إسناد المهام للموظفين (كيان وسيط)
CREATE TABLE TaskAssignment (
    Assignment_ID NUMBER PRIMARY KEY,
    Assignment_Date DATE NOT NULL,
    Hours_Worked NUMBER(5, 2) NOT NULL,
    Status VARCHAR2(30) NOT NULL,
    Task_ID NUMBER NOT NULL,
    Employee_ID NUMBER NOT NULL,
    FOREIGN KEY (Task_ID) REFERENCES Task(Task_ID) ON DELETE CASCADE,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

-- ==============================================================================

-- [الخطوة 23]: جدول حضور وانصراف الموظفين (كيان ضعيف)
CREATE TABLE Attendance (
    Employee_ID NUMBER NOT NULL,
    Attendance_Date DATE NOT NULL,
    Attendance_ID NUMBER NOT NULL,
    Check_In VARCHAR2(8) NOT NULL,
    Check_Out VARCHAR2(8),
    Status VARCHAR2(20) NOT NULL,
    PRIMARY KEY (Employee_ID, Attendance_Date),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 24]: جدول إشعارات الموظفين (كيان ضعيف)
CREATE TABLE Notification (
    Employee_ID NUMBER NOT NULL,
    Notification_Date DATE NOT NULL,
    Notification_ID NUMBER NOT NULL,
    Message VARCHAR2(4000) NOT NULL,
    Notification_Type VARCHAR2(50) NOT NULL,
    Status VARCHAR2(20) NOT NULL,
    PRIMARY KEY (Employee_ID, Notification_Date),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 25]: جدول المهارات التقنية
CREATE TABLE Skill (
    Skill_ID NUMBER PRIMARY KEY,
    Skill_Name VARCHAR2(50) NOT NULL UNIQUE,
    Skill_Category VARCHAR2(50) NOT NULL,
    Skill_Level VARCHAR2(30) NOT NULL,
    Description VARCHAR2(4000)
);

-- ==============================================================================

-- [الخطوة 26]: جدول ربط الموظفين بالمهارات (M:N)
CREATE TABLE Employee_Skill (
    Employee_ID NUMBER NOT NULL,
    Skill_ID NUMBER NOT NULL,
    PRIMARY KEY (Employee_ID, Skill_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE,
    FOREIGN KEY (Skill_ID) REFERENCES Skill(Skill_ID)
);

-- ==============================================================================

-- [الخطوة 27]: جدول فواتير المشاريع المالية
CREATE TABLE Invoice (
    Invoice_ID NUMBER PRIMARY KEY,
    Invoice_Date DATE NOT NULL,
    Due_Date DATE NOT NULL,
    Status VARCHAR2(20) NOT NULL,
    Project_ID NUMBER NOT NULL,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
);

-- ==============================================================================

-- [الخطوة 28]: جدول دفعات سداد الفواتير (كيان ضعيف)
CREATE TABLE Payment (
    Invoice_ID NUMBER NOT NULL,
    Payment_Date DATE NOT NULL,
    Payment_ID NUMBER NOT NULL,
    Amount NUMBER(12, 2) NOT NULL,
    Payment_Method VARCHAR2(50) NOT NULL,
    PRIMARY KEY (Invoice_ID, Payment_Date),
    FOREIGN KEY (Invoice_ID) REFERENCES Invoice(Invoice_ID) ON DELETE CASCADE
);

-- ==============================================================================

-- [الخطوة 29]: جدول المصروفات التشغيلية للمشروع
CREATE TABLE Expense (
    Expense_ID NUMBER PRIMARY KEY,
    Expense_Date DATE NOT NULL,
    Amount NUMBER(12, 2) NOT NULL,
    Expense_Type VARCHAR2(50) NOT NULL,
    Description VARCHAR2(4000),
    Project_ID NUMBER NOT NULL,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE


);







القسم الثاني: إدخال بيانات الاختبار (5 صفوف لكل جدول لضمان متطلبات المشروع)




-- [الخطوة 30]: إدخال بيانات العملاء
INSERT INTO Client VALUES (1, 'Ahmed', 'Ali', 'Yemeni', 'Hadda St', 'Sanaa', 'Yemen', '1201', 'Enterprise', TO_DATE('2025-01-10', 'YYYY-MM-DD'));
INSERT INTO Client VALUES (2, 'Fatima', 'Saleh', 'Ba-Obeid', 'Zubairy St', 'Sanaa', 'Yemen', '1202', 'Individual', TO_DATE('2025-02-15', 'YYYY-MM-DD'));
INSERT INTO Client VALUES (3, 'Omar', 'Hassan', 'Al-Jabri', 'Al-Siteen St', 'Sanaa', 'Yemen', '1203', 'Enterprise', TO_DATE('2025-03-01', 'YYYY-MM-DD'));
INSERT INTO Client VALUES (4, 'Mona', 'Khalid', 'Al-Qadi', 'Al-Rabat St', 'Sanaa', 'Yemen', '1204', 'Government', TO_DATE('2025-03-20', 'YYYY-MM-DD'));
INSERT INTO Client VALUES (5, 'Tariq', 'Mohammed', 'Al-Sabri', 'Tahrir St', 'Taiz', 'Yemen', '1301', 'Enterprise', TO_DATE('2025-04-05', 'YYYY-MM-DD'));

-- [الخطوة 31]: إدخال الأدوار الوظيفية
INSERT INTO Job_Role VALUES (1, 'Project Manager', 'Project planning and coordination', 1500.00, 3000.00);
INSERT INTO Job_Role VALUES (2, 'Developer', 'Backend and frontend development', 1200.00, 2500.00);
INSERT INTO Job_Role VALUES (3, 'Designer', 'UI/UX design', 900.00, 1800.00);
INSERT INTO Job_Role VALUES (4, 'QA Engineer', 'Testing and quality assurance', 800.00, 1600.00);
INSERT INTO Job_Role VALUES (5, 'DevOps Engineer', 'Infrastructure management', 1100.00, 2200.00);

-- [الخطوة 32]: إدخال الأقسام الإدارية
INSERT INTO Department VALUES (10, 'Software Engineering', 'Building A', '+9671400101', NULL);
INSERT INTO Department VALUES (20, 'Quality Assurance', 'Building A', '+9671400102', NULL);
INSERT INTO Department VALUES (30, 'Design', 'Building B', '+9671400103', NULL);
INSERT INTO Department VALUES (40, 'Project Management', 'Building B', '+9671400104', NULL);
INSERT INTO Department VALUES (50, 'Infrastructure', 'Building A', '+9671400105', NULL);

-- [الخطوة 33]: إدخال الموظفين (مع تحديد سجلك الشخصي وزملائك)
INSERT INTO Employee VALUES (1001, 'Khaled', NULL, 'Ateyh', 'Airport Road', 'Sanaa', 'Yemen', 'k.ateyh@softwarehouse.ye', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 2600.00, TO_DATE('2004-06-15', 'YYYY-MM-DD'), 'ProjectManager', 40, 1);
INSERT INTO Employee VALUES (1002, 'Abdalrahman', NULL, 'Alkhdry', 'Hadda St', 'Sanaa', 'Yemen', 'a.alkhdry@softwarehouse.ye', TO_DATE('2024-02-10', 'YYYY-MM-DD'), 2100.00, TO_DATE('2002-05-12', 'YYYY-MM-DD'), 'Developer', 10, 2);
INSERT INTO Employee VALUES (1003, 'Abdullah', NULL, 'Salman', 'Al-Siteen St', 'Sanaa', 'Yemen', 'a.salman@softwarehouse.ye', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 1900.00, TO_DATE('2003-03-14', 'YYYY-MM-DD'), 'Designer', 30, 3);
INSERT INTO Employee VALUES (1004, 'Mohammed', NULL, 'Adel', 'Zubairy St', 'Sanaa', 'Yemen', 'm.adel@softwarehouse.ye', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 1800.00, TO_DATE('2001-07-22', 'YYYY-MM-DD'), 'Tester', 20, 4);
INSERT INTO Employee VALUES (1005, 'Mohammed', NULL, 'Al-Qataa', 'Shumaila St', 'Sanaa', 'Yemen', 'm.alqataa@softwarehouse.ye', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 1900.00, TO_DATE('2002-09-10', 'YYYY-MM-DD'), 'Developer', 50, 2);
INSERT INTO Employee VALUES (1006, 'Mohammed', NULL, 'Al-Asri', 'Tahrir St', 'Sanaa', 'Yemen', 'm.alasri@softwarehouse.ye', TO_DATE('2024-04-15', 'YYYY-MM-DD'), 1700.00, TO_DATE('2003-12-05', 'YYYY-MM-DD'), 'DevOps', 50, 5);

-- تحديث مديري الأقسام
UPDATE Department SET Manager_ID = 1002 WHERE Department_ID = 10;
UPDATE Department SET Manager_ID = 1004 WHERE Department_ID = 20;
UPDATE Department SET Manager_ID = 1003 WHERE Department_ID = 30;
UPDATE Department SET Manager_ID = 1001 WHERE Department_ID = 40;
UPDATE Department SET Manager_ID = 1005 WHERE Department_ID = 50;

-- [الخطوة 34]: إدخال العقود والمشاريع
INSERT INTO Contract VALUES (201, TO_DATE('2025-01-15', 'YYYY-MM-DD'), 50000.00, 'Enterprise software contract', TO_DATE('2025-02-01', 'YYYY-MM-DD'), TO_DATE('2025-08-01', 'YYYY-MM-DD'), 1);
INSERT INTO Contract VALUES (202, TO_DATE('2025-02-20', 'YYYY-MM-DD'), 25000.00, 'Mobile app contract', TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2025-07-01', 'YYYY-MM-DD'), 2);
INSERT INTO Contract VALUES (203, TO_DATE('2025-03-10', 'YYYY-MM-DD'), 80000.00, 'Supply chain contract', TO_DATE('2025-03-15', 'YYYY-MM-DD'), TO_DATE('2025-11-15', 'YYYY-MM-DD'), 3);
INSERT INTO Contract VALUES (204, TO_DATE('2025-04-01', 'YYYY-MM-DD'), 120000.00, 'Gov analytics contract', TO_DATE('2025-04-10', 'YYYY-MM-DD'), TO_DATE('2026-04-10', 'YYYY-MM-DD'), 4);
INSERT INTO Contract VALUES (205, TO_DATE('2025-04-15', 'YYYY-MM-DD'), 40000.00, 'Ecommerce contract', TO_DATE('2025-05-01', 'YYYY-MM-DD'), TO_DATE('2025-10-01', 'YYYY-MM-DD'), 5);

INSERT INTO Project VALUES (301, 'Enterprise ERP Suite', TO_DATE('2025-02-01', 'YYYY-MM-DD'), TO_DATE('2025-08-01', 'YYYY-MM-DD'), 'Completed', 'Core ERP system', 201);
INSERT INTO Project VALUES (302, 'Smart Care Mobile Portal', TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2025-07-01', 'YYYY-MM-DD'), 'Completed', 'Patient tracking app', 202);
INSERT INTO Project VALUES (303, 'Logix Supply Chain Engine', TO_DATE('2025-03-15', 'YYYY-MM-DD'), TO_DATE('2025-11-15', 'YYYY-MM-DD'), 'Active', 'Warehouse stock tracker', 203);
INSERT INTO Project VALUES (304, 'National Gov Analytics Hub', TO_DATE('2025-04-10', 'YYYY-MM-DD'), TO_DATE('2026-04-10', 'YYYY-MM-DD'), 'Active', 'Big data dashboard', 204);
INSERT INTO Project VALUES (305, 'YemenPay Online Marketplace', TO_DATE('2025-05-01', 'YYYY-MM-DD'), TO_DATE('2025-10-01', 'YYYY-MM-DD'), 'Active', 'Retail shopping portal', 205);


















العروض والاستعلامات المطلوبه للمشروع




-- [الخطوة 35]: إنشاء العرض (View) المالي للمشاريع
CREATE OR REPLACE VIEW View_Project_Summary AS
SELECT 
    p.Project_ID,
    p.Project_Name,
    p.Status AS Project_Status,
    c.Contract_Value
FROM Project p
JOIN Contract c ON p.Contract_ID = c.Contract_ID;

-- [الخطوة 36]: الربط الداخلي (INNER JOIN) بين الموظفين والأقسام والوظائف
SELECT e.Employee_ID, e.First_Name || ' ' || e.Last_Name AS Employee_Name, e.Salary, d.Department_Name, r.Role_Title
FROM Employee e
INNER JOIN Department d ON e.Department_ID = d.Department_ID
INNER JOIN Job_Role r ON e.Role_ID = r.Role_ID;

-- [الخطوة 37]: الربط الأيسر (LEFT JOIN) للعملاء والعقود
SELECT c.First_Name, con.Contract_Value 
FROM Client c 
LEFT JOIN Contract con ON c.Client_ID = con.Client_ID;

-- [الخطوة 38]: الاستعلام الفرعي (Subquery) للموظفين أصحاب الرواتب الأعلى من المتوسط
SELECT First_Name, Last_Name, Salary 
FROM Employee 
WHERE Salary > (SELECT AVG(Salary) FROM Employee);







