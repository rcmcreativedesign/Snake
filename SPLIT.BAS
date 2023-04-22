DECLARE FUNCTION SPLIT$ (Val$, Separator$)
LET Message$ = "THIS IS A TEST"
LET Result$ = SPLIT$(Message$, " ")
FOR X = 1 TO UBOUND(Result$)
	PRINT Result$(X)
NEXT X

FUNCTION SPLIT$ (Val$, Separator$)
	DIM SplitArray(1)
	IF INSTR(1, Val$, Separator$) > 0 THEN
		LET Index = 1
		LET WordCount = 1
		LET CurrWord = ""
		FOR X = 1 TO LEN(Val$)
			IF MID$(Val$, Index, 1) = Separator$ THEN
				REDIM SplitArray(WordCount + 1)
				SplitArray(WordCount) = CurrWord
				CurrWord = ""
				Index = Index + 2
			ELSE
				CurrWord = CurrWord + MID$(Val$, Index, 1)
				Index = Index + 1
			END IF
		NEXT X
	ELSE
		SplitArray(1) = Val$
	END IF
	
	SPLIT$ = SplitArray
END FUNCTION

