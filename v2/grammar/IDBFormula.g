grammar IDBFormula;



WS	:	(' '|'\r'|'\t'|'\u000C'|'\n') {$channel=HIDDEN;}
	;

STRING_LITERAL
	:	  '"' (~('"') )* '"'
    	;
    	
LETTER	:	'A'..'Z'
	|	'a'..'z'
	;

DIGIT	:	'0'..'9'
	;

NUMBER	:	DIGIT+ ('.' (DIGIT)*)?
	;

CELL_ADDRESS
	:	LETTER+ DIGIT+
	;
	
//CELL_RANGE	:	CELL_ADDRESS (':'CELL_ADDRESS)? EOF
//	;
CONST	:	STRING_LITERAL
	|	NUMBER
	;

atom	:	CELL_ADDRESS
	|	CONST
	;
