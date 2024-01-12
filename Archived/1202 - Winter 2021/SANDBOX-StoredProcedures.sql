DECLARE @StudentMark INT
SELECT @StudentMark = Mark
	FROM Registration
	WHERE OfferingCode = 1008 AND StudentID = 199899200

IF @StudentMark > 50
	BEGIN
	PRINT 'You passed!'
	END
ELSE
	BEGIN
	PRINT 'Sorry, you failed.'
	END