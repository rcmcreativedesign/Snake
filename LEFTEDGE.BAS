DECLARE FUNCTION IsEdge! (Cell%, TopEdge%, LowerEdge%)
DECLARE FUNCTION IsRightEdge! (Cell%)
DECLARE FUNCTION IsLeftEdge! (Cell%)
CLS
CONST FALSE = 0, TRUE = NOT FALSE
DIM SHARED PlayField(400) AS INTEGER

MaxCells% = UBOUND(PlayField)
TopEdge% = SQR(MaxCells%)
LowerEdge% = MaxCells% - TopEdge%

E% = 0
R% = 0
L% = 0

FOR X% = 1 TO 400
	IF IsLeftEdge(X%) = TRUE THEN
		PRINT LTRIM$(RTRIM$(STR$(X%))); "L, ";
		L% = L% + 1
	ELSEIF IsRightEdge(X%) = TRUE THEN
		PRINT LTRIM$(RTRIM$(STR$(X%))); "R, ";
		R% = R% + 1
	ELSEIF IsEdge(X%, TopEdge%, LowerEdge%) = TRUE THEN
		PRINT LTRIM$(RTRIM$(STR$(X%))); ", ";
		E% = E% + 1
	END IF
NEXT X%

PRINT
MaxCells% = UBOUND(PlayField)
PRINT "MaxCells = "; MaxCells%
TopEdge% = SQR(MaxCells%)
PRINT "TopEdge = "; TopEdge%
LowerEdge% = MaxCells% - TopEdge%
PRINT "LowerEdge = "; LowerEdge%
PRINT "L = "; L%; "R = "; R%; "E = "; E%

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

