
ALTER TABLE Student
	ADD CONSTRAINT CK_PostalCode_T6H CHECK (PostalCode LIKE 'T6H [0-9][A-Z][0-9]')
	-- only postal codes starting with T6H

ALTER TABLE Student
	ADD CONSTRAINT CK_MinimumMark CHECK (AvgMark > 70)
	-- average mark must be above 70