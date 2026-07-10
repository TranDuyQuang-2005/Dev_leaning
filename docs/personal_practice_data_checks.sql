-- Replace @BankId with the PersonalQuestionBanks.Id you want to inspect.
DECLARE @BankId BIGINT = 1;

SELECT q.Id, q.QuestionText AS Content, o.Label AS OptionKey, o.Text AS Content, o.IsCorrect
FROM PersonalQuestions q
JOIN PersonalQuestionOptions o ON o.QuestionId = q.Id
WHERE q.BankId = @BankId
ORDER BY q.Id, o.Label;

SELECT q.Id, q.QuestionText AS Content, COUNT(CASE WHEN o.IsCorrect = 1 THEN 1 END) AS CorrectOptionCount
FROM PersonalQuestions q
LEFT JOIN PersonalQuestionOptions o ON o.QuestionId = q.Id
WHERE q.BankId = @BankId
GROUP BY q.Id, q.QuestionText
HAVING COUNT(CASE WHEN o.IsCorrect = 1 THEN 1 END) <> 1
ORDER BY q.Id;
