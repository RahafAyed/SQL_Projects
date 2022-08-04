select *
from StudentsPerformance


-- calculate the math score average, number of each gender, just if the student got more than 70 degree
select gender, count(gender) as numberOfGeneder, avg(math_score) as MathScoreAVG
from StudentsPerformance
where math_score > 70
group by gender

-- is the parental level of education affect the student's performance?
select distinct parental_level_of_education
from StudentsPerformance

select parental_level_of_education, avg(math_score) as MathScoreAVG, avg(reading_score) as ReadingScoreAVG, avg(writing_score) as WritingScoreAVG
from StudentsPerformance
group by parental_level_of_education
order by MathScoreAVG, ReadingScoreAVG, WritingScoreAVG  desc

-- tring it with test preparation
select parental_level_of_education, test_preparation_course, avg(math_score) as MathScoreAVG, avg(reading_score) as ReadingScoreAVG, avg(writing_score) as WritingScoreAVG
from StudentsPerformance
group by  parental_level_of_education, test_preparation_course
order by parental_level_of_education


-- calculate the avg of final score for eatch student
select gender, race_ethnicity, lunch,parental_level_of_education, test_preparation_course, (convert(int, math_score)+convert(int, reading_score)+ CONVERT(int, writing_score)) / 3
as finalScore
from StudentsPerformance
order by finalScore desc

-- calculate which group has the best performance in each score, by calculating the max average 

with BestGroup as (
select race_ethnicity, avg(math_score) as MathScoreAVG, avg(reading_score) as ReadingScoreAVG, avg(writing_score) as WritingScoreAVG
from StudentsPerformance
group by race_ethnicity
)

select race_ethnicity, max(MathScoreAVG) as Math_MaxAvgScore, max(ReadingScoreAVG) as Reading_MaxAvgScore, max(WritingScoreAVG) as Writing_MaxAvgScore
from BestGroup
group by race_ethnicity
order by Math_MaxAvgScore desc



-- write a message for student who pass and doesn't based on their preparation course
with PassMessage as (
select test_preparation_course, gender, race_ethnicity, lunch, (convert(int, math_score)+convert(int, reading_score)+ CONVERT(int, writing_score)) / 3
as finalScore
from StudentsPerformance
)
select finalScore, test_preparation_course,
case
when test_preparation_course = 'none' and finalScore < 61
then 'try to prepare next time to pass'
when test_preparation_course = 'none' and finalScore >= 61
then 'Oh lucky!'
when test_preparation_course = 'completed' and finalScore < 61
then 'Sorry but You did your best'
when test_preparation_course = 'completed' and finalScore >= 61
then 'Great! keep going'
end
from PassMessage