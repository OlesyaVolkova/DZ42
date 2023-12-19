--1. Вывести преподавателей и название факультетов на которых они преподают
SELECT Teachers.Name AS TeacherName, Faculties.Name AS FacultyName
FROM Teachers
JOIN Deans ON Teachers.Id = Deans.TeacherId
JOIN Faculties ON Deans.FacultyId = Faculties.Id;

--2.+Показать все группы, в которых первая буква названия либо «А», либо «G».
SELECT * FROM Groups 
WHERE Name LIKE 'A%' or Name LIKE 'G%';

--3. +Показать все кафедры, название которых состоит из 2 слов. 
SELECT * FROM Departments 
WHERE Name LIKE '% %';

SELECT * FROM Departments 
WHERE Name LIKE '% %' and name not LIKE  '% % %'

--4.+Вывести количество лекций в каждом дне недели. 
SELECT DayOfWeek 'День недели', COUNT(*) 'Количество лекций'
FROM GroupsLectures
GROUP BY DayOfWeek;

--5. Вывести кафедру с максимальным Финансированием
SELECT Name FROM Departments WHERE Financing = (SELECT MAX(Financing) FROM Departments);

--6. +Вывести название кафедры и фио преподавателей, если их финансирование и зп+премия больше 17000 
SELECT Name FROM Departments
WHERE Financing > 17000
union all
SELECT Name + ' ' + Surname
FROM Teachers
WHERE Salary + Premium > 17000;

--7.Вывести Кол-во преподавателей, Кол-во групп, Кол-во лекций
SELECT COUNT() FROM Teachers; 
SELECT COUNT() FROM Groups; 
SELECT COUNT(*) FROM Lectures;

--8. +Вывести кол-во преподавателей у которых зарплата больше чем финансирование на какой-то кафедре
SELECT Financing FROM Departments 

SELECT COUNT(*)
FROM Teachers 
WHERE t.Salary > any (SELECT d.Financing
FROM Departments d)

--9. Подсчитать количество преподавателей, у которых зарплаты в диапазонах:
10000 – 14999, 
15000 – 19999, 
20000 – 24999, 
25000 – 49999
SELECT COUNT(*) FROM Teachers WHERE Salary BETWEEN 10000 AND 14999 OR Salary BETWEEN 15000 AND 19999 OR Salary BETWEEN 20000 AND 24999 OR Salary BETWEEN 25000 AND 49999;

--10. +Вывести наименование факультета(-ов) с максимальным количеством преподавателей
SELECT f.name 
FROM Teachers t
JOIN Lectures l on t.Id = l.TeacherId
JOIN GroupsLectures gl on gl.LectureId = l.Id
JOIN Groups g on g.Id = gl.GroupId
JOIN Departments d on d.Id = g.DepartmentId 
JOIN Faculties f on f.Id = d.FacultyId
GROUP BY f.Name
HAVING COUNT(DISTINCT t.Name + ' ' + t.Surname) = (
  SELECT MAX(cnt) FROM 
  (
    SELECT f.name, COUNT(DISTINCT t.Name + ' ' + t.Surname) as cnt
    FROM Teachers t
    JOIN Lectures l on t.Id = l.TeacherId
    JOIN GroupsLectures gl on gl.LectureId = l.Id
    JOIN Groups g on g.Id = gl.GroupId
    JOIN Departments d on d.Id = g.DepartmentId 
    JOIN Faculties f on f.Id = d.FacultyId
    GROUP BY f.Name
  ) t
)
