DECLARE SUB DrawMessage (Message$)
CLS
CALL DrawMessage("This is a test message that is longer than 16 characters")

SUB DrawMessage (Message$)
	IF INSTR(1, Message$, " ") = 0 THEN
		IF LEN(Message$) <= 16 THEN
			LOCATE 12, 1: PRINT Message$
		ELSE
		   REM CurrentLine = 12
		   REM FOR X = 0 TO 7
		END IF
	ELSE
		LineNumber = 12
		Index = 1
		CurrWord$ = ""
		LineWord$ = ""
		FOR X = 1 TO LEN(Message$)
			IF MID$(Message$, X, 1) = " " THEN
				IF LEN(LineWord$ + " " + CurrWord$) > 16 THEN
					LOCATE LineNumber, 1: PRINT LEFT$(LTRIM$(LineWord$) + STRING$(16, " "), 16)
					LineWord$ = CurrWord$
					CurrWord$ = ""
					LineNumber = LineNumber + 1
				ELSE
					LineWord$ = LineWord$ + " " + CurrWord$
					CurrWord$ = ""
				END IF
			ELSE
				CurrWord$ = CurrWord$ + MID$(Message$, X, 1)
			END IF
		NEXT X
		IF LEN(LineWord$ + " " + CurrWord$) > 16 THEN
			LOCATE LineNumber, 1: PRINT LEFT$(LTRIM$(LineWord$) + STRING$(16, " "), 16)
			LineNumber = LineNumber + 1
			LOCATE LineNumber, 1: PRINT LEFT$(CurrWord$ + STRINGS(16, " "), 16)
		ELSE
			LOCATE LineNumber, 1: PRINT LEFT$(LTRIM$(LineWord$ + " " + CurrWord$) + STRING$(16, " "), 16)
		END IF
		LineNumber = LineNumber + 1
	END IF
	IF LineNumber < 17 THEN
		FOR X = LineNumber TO 17
			LOCATE X, 1: PRINT STRING$(16, " ")
		NEXT X
	END IF
END SUB

