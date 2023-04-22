DECLARE SUB DrawMessage (Message$)
DECLARE FUNCTION TRIM$ (Val$)

DECLARE SUB DrawStatusBar (Level%)
DECLARE SUB MoveRight ()
DECLARE SUB MoveLeft ()
DECLARE SUB MoveDown ()
DECLARE SUB MoveUp ()
DECLARE SUB Start ()
DECLARE SUB CheckCollision (Cell%, PrevCell%)
DECLARE SUB ShowError (Message$)
DECLARE FUNCTION IsHighScore! ()
DECLARE FUNCTION IsEdge! (Cell%, TopEdge%, LowerEdge%)
DECLARE FUNCTION IsRightEdge! (Cell%)
DECLARE FUNCTION IsLeftEdge! (Cell%)
DECLARE FUNCTION GetFoodLevel! (Level%)
DECLARE SUB DrawField ()
DECLARE SUB InitField (Level%, MaxCells%)

CLS
SCREEN 13
COLOR 2

CONST FALSE = 0, TRUE = NOT FALSE
DIM SHARED PlayField(400) AS INTEGER

DIM SHARED MaxCells%, TopEdge%, LowerEdge%, CurrentCell%, CurrentLevel%, FoodCount%, GameOver, GameStarted
MaxCells% = UBOUND(PlayField)
TopEdge% = SQR(MaxCells%)
LowerEdge% = MaxCells% - TopEdge%
CurrentCell% = 1
CurrentLevel% = 1
FoodCount% = 0
GameOver = FALSE
GameStarted = FALSE

CALL InitField(CurrentLevel%, MaxCells%)

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

CALL DrawStatusBar(CurrentLevel%)

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
	CASE CHR$(13) 'Enter
		CALL Start
	CASE CHR$(27) 'ESC
		END
END SELECT
DrawStatusBar (CurrentLevel%)
GOTO REKEY

SUB CheckCollision (NextCell%, CurrCell%)
	REM Did we hit a body part?
	IF PlayField(NextCell%) = ASC("B") THEN
		GameOver = TRUE
		ShowError ("GAME OVER!")
	ELSEIF PlayField(NextCell%) = ASC("X") THEN
		REM We hit food
		PlayField(NextCell%) = ASC("S")
		PlayField(CurrCell%) = ASC("B")
		FoodCount% = FoodCount% + 1
	ELSE
		PlayField(NextCell%) = ASC("S")
		PlayField(CurrCell%) = 177 'Back to "grass"
	END IF
END SUB

SUB DrawField
	Cell% = 1
	FOR X = 2 TO 22
		FOR Y = 19 TO 39
			IF Cell% = 400 THEN
				EXIT FOR
			END IF
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

SUB DrawStatusBar (Level%)
	LOCATE 22, 1: PRINT "LEVEL "; TRIM$(STR$(Level%));
	IF GameStarted = TRUE THEN
		PRINT ", FOOD REMAINING "; LEFT$(TRIM$(STR$(GetFoodLevel(Level%) - FoodCount%)) + STRING$(2, " "), 2)
	END IF
END SUB

FUNCTION GetFoodLevel (Level%)
	IF Level% < 6 THEN
		GetFoodLevel = 10
	ELSEIF Level% < 11 THEN
		GetFoodLevel = 15
	ELSEIF Level% < 21 THEN
		GetFoodLevel = 20
	ELSE
		GetFoodLevel = 25
	END IF
END FUNCTION

SUB InitField (Level%, MaxCells%)
	RANDOMIZE TIMER

	REM Fill all cells with "grass"
	FOR X% = 1 TO MaxCells%
		PlayField(X%) = 177
	NEXT X%
   
	REM Add food to field
	Food% = GetFoodLevel(Level%)
	FOR X% = 1 TO Food%
		PlayField(INT(RND * MaxCells%) + 1) = ASC("X")
	NEXT X%

	REM Add snake head
	Break = FALSE
	DO
		CurrentCell% = INT(RND * MaxCells%) + 1
		IF IsEdge(CurrentCell%, TopEdge%, LowerEdge%) = TRUE THEN
			PlayField(CurrentCell%) = ASC("S")
			Break = TRUE
		END IF
	LOOP WHILE Break = FALSE
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

FUNCTION IsHighScore

END FUNCTION

FUNCTION IsLeftEdge (Cell%)
	NewString$ = RTRIM$(LTRIM$(STR$(Cell%)))
	LastDigit$ = RIGHT$(NewString$, 1)
	IF VAL(LastDigit$) <> 1 THEN
		IsLeftEdge = FALSE
	ELSEIF LEN(NewString$) = 1 THEN
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
	NewString$ = RTRIM$(LTRIM$(STR$(Cell%)))
	LastDigit$ = RIGHT$(NewString$, 1)
	IF VAL(LastDigit$) <> 0 THEN
		IsRightEdge = FALSE
	ELSEIF LEN(NewString) = 1 THEN
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
	IF GameStarted = TRUE THEN
		IF CurrentCell% >= LowerEdge% THEN
			ShowError ("Can't Move There")
		ELSE
			PreviousCell% = CurrentCell%
			CurrentCell% = CurrentCell% + TopEdge% + 1
			CALL CheckCollision(CurrentCell%, PreviousCell%)
			IF GameOver = FALSE THEN
				PlayField(CurrentCell%) = ASC("S")
				CALL DrawField
			END IF
		END IF
	END IF
END SUB

SUB MoveLeft
	IF GameStarted = TRUE THEN
		IF IsLeftEdge(CurrentCell% - 1) THEN
			ShowError ("Can't Move There")
		ELSE
			PreviousCell% = CurrentCell%
			CurrentCell% = CurrentCell% - 1
			CALL CheckCollision(CurrentCell%, PreviousCell%)
			IF GameOver = FALSE THEN
				PlayField(CurrentCell%) = ASC("S")
				CALL DrawField
			END IF
		END IF
	END IF
END SUB

SUB MoveRight
	IF GameStarted = TRUE THEN
		IF IsRightEdge(CurrentCell% + 1) THEN
			ShowError ("Can't Move There")
		ELSE
			NextCell% = CurrentCell% + 1
			CALL CheckCollision(NextCell%, CurrentCell%)
			IF GameOver = FALSE THEN
				PlayField(CurrentCell%) = ASC("S")
				CALL DrawField
			END IF
		END IF
	END IF
END SUB

SUB MoveUp
	IF GameStarted = TRUE THEN
		IF CurrentCell% <= TopEdge% THEN
			ShowError ("Can't Move There")
		ELSE
			PreviousCell% = CurrentCell%
			CurrentCell% = CurrentCell% - TopEdge% - 1
			CALL CheckCollision(CurrentCell%, PreviousCell%)
			IF GameOver = FALSE THEN
				PlayField(CurrentCell%) = ASC("S")
				CALL DrawField
			END IF
		END IF
	END IF
END SUB

SUB ShowError (Message$)
	CALL DrawMessage(Message$)
END SUB

SUB Start
	GameStarted = TRUE
	CALL DrawMessage("PRESS ESC TO EXIT")
	CALL DrawStatusBar(1)
END SUB

FUNCTION TRIM$ (Val$)
	TRIM$ = RTRIM$(LTRIM$(Val$))
END FUNCTION

