DECLARE SUB DrawMessage (Lines$())
DECLARE FUNCTION TRIM$ (VAL$)

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

DIM Message1$(7)
Message1$(1) = "PRESS ENTER TO"
Message1$(2) = "START"
CALL DrawMessage(Message1$())

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

SUB CheckCollision (Cell%, PrevCell%)
	REM Did we hit a body part?
	IF PlayField(Cell%) = ASC("B") THEN
		GameOver = TRUE
		ShowError ("GAME OVER!")
	ELSEIF PlayField(Cell%) = ASC("X") THEN
		REM We hit food
		PlayField(Cell%) = ASC("S")
		PlayField(PrevCell%) = ASC("B")
		FoodCount% = FoodCount% + 1
	ELSE
		PlayField(Cell%) = ASC("S")
		PlayField(PrevCell%) = 177 'Back to "grass"
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

SUB DrawMessage (Lines$())
	FOR X = 1 TO UBOUND(Lines$)
		LOCATE 11 + X, 1: PRINT LEFT$(Lines$(X) + STRING$(16, " "), 16)
	NEXT X
	REM LOCATE 12, 1: PRINT LEFT$(Line1$ + STRING$(16, " "), 16)
	REM LOCATE 13, 1: PRINT LEFT$(Line2$ + STRING$(16, " "), 16)
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
			PreviousCell% = CurrentCell%
			CurrentCell% = CurrentCell% + 1
			CALL CheckCollision(CurrentCell%, PreviousCell%)
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
	DIM MessageArray$(7)
	MessageArray$(1) = Message$
    CALL DrawMessage(MessageArray$F())
END SUB

SUB Start
	GameStarted = TRUE
	DIM Message2$(7)
	Message2$(1) = "PRESS ESC TO"
	Message2$(2) = "EXIT"
	CALL DrawMessage(Message2$())
	CALL DrawStatusBar(1)
END SUB

FUNCTION TRIM$ (VAL$)
	TRIM$ = RTRIM$(LTRIM$(VAL$))
END FUNCTION

