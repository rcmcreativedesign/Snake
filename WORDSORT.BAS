LET WORD$ = "GARLIC"
DIM letters(LEN(WORD$))

FOR X = 1 TO LEN(WORD$)
    letters(X) = MID$(WORD$, X, 1)
NEXT



SUB BubbleSort (WORD)
LET breakout = LEN(WORD) * LEN(WORD) + LEN(WORD)

    FOR X = 1 TO LEN(WORD)
        FOR Y = 1 TO LEN(WORD)
            IF WORD(Y) > WORD(X) THEN
                LET TEMP = WORD(X)
                LET WORD(X) = WORD(Y)
                LET WORD(Y) = TEMP
            END IF
IF breakout < 0 THEN
    EXIT SUB
END IF
        NEXT
    NEXT
END SUB

