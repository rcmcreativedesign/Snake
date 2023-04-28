DECLARE SUB DrawMessage (Message$)
DECLARE SUB DrawField ()
DECLARE SUB MoveRight ()
DECLARE SUB MoveLeft ()
DECLARE SUB MoveDown ()
DECLARE SUB MoveUp ()
DECLARE FUNCTION IsEdge! (Cell%, TopEdge%, LowerEdge%)
DECLARE FUNCTION IsLeftEdge! (Cell%)
DECLARE FUNCTION IsRightEdge! (Cell%)
DECLARE SUB ShowError (Message$)
DECLARE FUNCTION TRIM$ (Val$)

CLS
SCREEN 13
COLOR 2

CONST FALSE = 0, TRUE = NOT FALSE
DIM SHARED PlayField(1 TO 400) AS INTEGER

DIM Player AS INTEGER
DIM SHARED MaxCells%, TopEdge%, LowerEdge%, CurrentCell%, CurrentLevel%, FoodCount%, GameOver, GameStarted
MaxCells% = UBOUND(PlayField)
TopEdge% = SQR(MaxCells%)
LowerEdge% = MaxCells% - TopEdge%
CurrentCell% = 1

REM Fill all cells with "grass"
FOR X = 1 TO MaxCells%
	PlayField(X) = 177
NEXT X

LOCATE 2, 1: PRINT "WELCOME TO SNAKE"
PRINT
PRINT
PRINT "MOVEMENT:"
PRINT
PRINT "  ^  "
PRINT "<   >"
PRINT "  V  "
PRINT
PRINT

CALL DrawMessage("PRESS ENTER TO START")

CALL DrawField

LOCATE 20, 1

REKEY:
DO
	K$ = INKEY$
LOOP UNTIL K$ <> ""
   
SELECT CASE K$
	CASE CHR$(0) + CHR$(77)
		CALL MoveRight
	CASE CHR$(0) + CHR$(75)
		CALL MoveLeft
	CASE CHR$(0) + CHR$(80)
		CALL MoveDown
	CASE CHR$(0) + CHR$(72)
		CALL MoveUp
	CASE CHR$(27) 'ESC
		END
END SELECT
GOTO REKEY

SUB DrawField
	Cell% = 1
	FOR X = 2 TO 21
		FOR Y = 19 TO 38
			LOCATE X, Y
			PRINT CHR$(PlayField(Cell%))
			Cell% = Cell% + 1
		NEXT Y
	NEXT X
END SUB

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
			LOCATE LineNumber, 1: PRINT LEFT$(CurrWord$ + STRING$(16, " "), 16)
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

FUNCTION IsEdge (Cell%, TopEdge%, LowerEdge%)
	IF Cell% <= TopEdge% THEN
		IsEdge = TRUE
	ELSE
		IF Cell% >= LowerEdge% THEN
			IsEdge = TRUE
		ELSE
			IF IsLeftEdge(Cell%) = TRUE THEN
				IsEdge = TRUE
			ELSEIF IsRightEdge(Cell%) = TRUE THEN
				IsEdge = TRUE
			ELSE
				IsEdge = FALSE
			END IF
		END IF
	END IF
END FUNCTION

FUNCTION IsLeftEdge (Cell%)
	NewString$ = LTRIM$(STR$(Cell%))
	LastDigit$ = RIGHT$(NewString$, 1)
	IF VAL(LastDigit$) <> 1 THEN
		IsLeftEdge = FALSE
	ELSE
		FirstDigits$ = LEFT$(NewString$, LEN(NewString$) - 1)
		IF VAL(FirstDigits$) MOD 2 = 0 THEN
			IsLeftEdge = TRUE
		ELSE
			IsLeftEdge = FALSE
		END IF
	END IF
END FUNCTION

FUNCTION IsRightEdge (Cell%)
	NewString$ = LTRIM$(STR$(Cell%))
	LastDigit$ = RIGHT$(NewString$, 1)
	IF VAL(LastDigit$) <> 0 THEN
		IsRightEdge = FALSE
	ELSE
		FirstDigits$ = LEFT$(NewString$, LEN(NewString$) - 1)
		IF VAL(FirstDigits$) MOD 2 = 0 THEN
			IsRightEdge = TRUE
		ELSE
			IsRightEdge = FALSE
		END IF
	END IF
END FUNCTION

SUB MoveDown
	IF CurrentCell% >= LowerEdge% THEN
		ShowError ("Can't Move There")
	ELSE
		PlayField(CurrentCell%) = 177
		CurrentCell% = CurrentCell% + TopEdge%
		PlayField(CurrentCell%) = ASC("S")
		CALL DrawField
	END IF
END SUB

SUB MoveLeft
	IF IsLeftEdge(CurrentCell% - 1) = TRUE THEN
		ShowError ("Can't Move There")
	ELSE
		PlayField(CurrentCell%) = 177
		CurrentCell% = CurrentCell% - 1
		PlayField(CurrentCell%) = ASC("S")
		CALL DrawField
	END IF
END SUB

SUB MoveRight
	IF IsRightEdge(CurrentCell% + 1) = TRUE THEN
		ShowError ("Can't Move There")
	ELSE
		PlayField(CurrentCell%) = 177
		CurrentCell% = CurrentCell% + 1
		PlayField(CurrentCell%) = ASC("S")
		CALL DrawField
	END IF
END SUB

SUB MoveUp
	IF CurrentCell% <= TopEdge% THEN
		ShowError ("Can't Move There")
	ELSE
		PlayField(CurrentCell%) = 177
		CurrentCell% = CurrentCell% - TopEdge%
		PlayField(CurrentCell%) = ASC("S")
		CALL DrawField
	END IF
END SUB

SUB ShowError (Message$)
	CALL DrawMessage(Message$)
END SUB

FUNCTION TRIM$ (Val$)
	TRIM$ = RTRIM$(LTRIM$(Val$))
END FUNCTION

