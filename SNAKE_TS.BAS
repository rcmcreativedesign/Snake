DECLARE SUB InitField (GameLevel%)
DECLARE FUNCTION GetFoodLevel! (GameLevel%)
CLS
SCREEN 13
COLOR 2
CONST FALSE = 0, TRUE = NOT FALSE

DIM SHARED PlayField(400) AS INTEGER
FieldIndex% = 1
CURRENTLEVEL% = 1

InitField 1
END

FOR X = 2 TO 22
FOR Y = 19 TO 39
LOCATE X, Y
PRINT CHR$(177)
PlayField(FieldIndex%) = 177
NEXT Y
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
PRINT "PRESS ENTER TO"
PRINT "START"
LOCATE 21, 1: PRINT "LEVEL "; CURRENTLEVEL%

LOCATE 20, 1
REKEY:
DO
    K$ = INKEY$
LOOP UNTIL K$ <> ""
   
SELECT CASE K$
    CASE CHR$(0) + CHR$(77)
        PRINT "RIGHT"
    CASE CHR$(0) + CHR$(75)
        PRINT "LEFT"
    CASE CHR$(0) + CHR$(80)
        PRINT "DOWN"
    CASE CHR$(0) + CHR$(72)
        PRINT "UP"
    CASE CHR$(27)
        END
END SELECT
GOTO REKEY


SUB DrawField
    FieldIndex% = 1
    FOR X = 2 TO 22
        FOR Y = 19 TO 39
            LOCATE X, Y
            PRINT CHR$(PlayField(FieldIndex%))
            FieldIndex% = FieldIndex% + 1
        NEXT Y
    NEXT X
END SUB

FUNCTION GetFoodLevel (GameLevel%)
    IF GameLevel% < 6 THEN
        GetFoodLevel = 10
    ELSEIF GameLevel% < 11 THEN
        GetFoodLevel = 15
    ELSEIF GameLevel% < 21 THEN
        GetFoodLevel = 20
    ELSE
        GetFoodLevel = 25
    END IF
END FUNCTION

SUB InitField (GameLevel%)
    Food% = GetFoodLevel(GameLevel%)
    MaxCells% = UBOUND(PlayField)
    Edge% = SQR(MaxCells%)
    UpperEdge% = Edge%
    LowerEdge% = MaxCells% - UpperEdge%
	LeftEdge
END SUB

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