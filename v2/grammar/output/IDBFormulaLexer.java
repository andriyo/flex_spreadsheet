// $ANTLR 3.1b1 C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g 2008-06-19 01:35:31

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

public class IDBFormulaLexer extends Lexer {
    public static final int WS=4;
    public static final int STRING_LITERAL=5;
    public static final int LETTER=6;
    public static final int CONST=10;
    public static final int NUMBER=8;
    public static final int DIGIT=7;
    public static final int EOF=-1;
    public static final int CELL_ADDRESS=9;

    // delegates
    // delegators

    public IDBFormulaLexer() {;} 
    public IDBFormulaLexer(CharStream input) {
        this(input, new RecognizerSharedState());
    }
    public IDBFormulaLexer(CharStream input, RecognizerSharedState state) {
        super(input,state);

    }
    public String getGrammarFileName() { return "C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g"; }

    // $ANTLR start WS
    public final void mWS() throws RecognitionException {
        try {
            int _type = WS;
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:5:4: ( ( ' ' | '\\r' | '\\t' | '\\u000C' | '\\n' ) )
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:5:6: ( ' ' | '\\r' | '\\t' | '\\u000C' | '\\n' )
            {
            if ( (input.LA(1)>='\t' && input.LA(1)<='\n')||(input.LA(1)>='\f' && input.LA(1)<='\r')||input.LA(1)==' ' ) {
                input.consume();

            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                recover(mse);
                throw mse;}

            state.channel=HIDDEN;


            }

            state.type = _type;
        }
        finally {
        }
    }
    // $ANTLR end WS

    // $ANTLR start STRING_LITERAL
    public final void mSTRING_LITERAL() throws RecognitionException {
        try {
            int _type = STRING_LITERAL;
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:9:2: ( '\"' (~ ( '\"' ) )* '\"' )
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:9:6: '\"' (~ ( '\"' ) )* '\"'
            {
            match('\"'); 
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:9:10: (~ ( '\"' ) )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( ((LA1_0>='\u0000' && LA1_0<='!')||(LA1_0>='#' && LA1_0<='\uFFFE')) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:9:11: ~ ( '\"' )
            	    {
            	    if ( (input.LA(1)>='\u0000' && input.LA(1)<='!')||(input.LA(1)>='#' && input.LA(1)<='\uFFFE') ) {
            	        input.consume();

            	    }
            	    else {
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;}



            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

            match('\"'); 


            }

            state.type = _type;
        }
        finally {
        }
    }
    // $ANTLR end STRING_LITERAL

    // $ANTLR start LETTER
    public final void mLETTER() throws RecognitionException {
        try {
            int _type = LETTER;
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:12:8: ( 'A' .. 'Z' | 'a' .. 'z' )
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:
            {
            if ( (input.LA(1)>='A' && input.LA(1)<='Z')||(input.LA(1)>='a' && input.LA(1)<='z') ) {
                input.consume();

            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                recover(mse);
                throw mse;}


            }

            state.type = _type;
        }
        finally {
        }
    }
    // $ANTLR end LETTER

    // $ANTLR start DIGIT
    public final void mDIGIT() throws RecognitionException {
        try {
            int _type = DIGIT;
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:16:7: ( '0' .. '9' )
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:16:9: '0' .. '9'
            {
            matchRange('0','9'); 


            }

            state.type = _type;
        }
        finally {
        }
    }
    // $ANTLR end DIGIT

    // $ANTLR start NUMBER
    public final void mNUMBER() throws RecognitionException {
        try {
            int _type = NUMBER;
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:19:8: ( ( DIGIT )+ ( '.' ( DIGIT )* )? )
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:19:10: ( DIGIT )+ ( '.' ( DIGIT )* )?
            {
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:19:10: ( DIGIT )+
            int cnt2=0;
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( ((LA2_0>='0' && LA2_0<='9')) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:19:10: DIGIT
            	    {
            	    mDIGIT(); 


            	    }
            	    break;

            	default :
            	    if ( cnt2 >= 1 ) break loop2;
                        EarlyExitException eee =
                            new EarlyExitException(2, input);
                        throw eee;
                }
                cnt2++;
            } while (true);

            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:19:17: ( '.' ( DIGIT )* )?
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( (LA4_0=='.') ) {
                alt4=1;
            }
            switch (alt4) {
                case 1 :
                    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:19:18: '.' ( DIGIT )*
                    {
                    match('.'); 
                    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:19:22: ( DIGIT )*
                    loop3:
                    do {
                        int alt3=2;
                        int LA3_0 = input.LA(1);

                        if ( ((LA3_0>='0' && LA3_0<='9')) ) {
                            alt3=1;
                        }


                        switch (alt3) {
                    	case 1 :
                    	    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:19:23: DIGIT
                    	    {
                    	    mDIGIT(); 


                    	    }
                    	    break;

                    	default :
                    	    break loop3;
                        }
                    } while (true);



                    }
                    break;

            }



            }

            state.type = _type;
        }
        finally {
        }
    }
    // $ANTLR end NUMBER

    // $ANTLR start CELL_ADDRESS
    public final void mCELL_ADDRESS() throws RecognitionException {
        try {
            int _type = CELL_ADDRESS;
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:23:2: ( ( LETTER )+ ( DIGIT )+ )
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:23:4: ( LETTER )+ ( DIGIT )+
            {
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:23:4: ( LETTER )+
            int cnt5=0;
            loop5:
            do {
                int alt5=2;
                int LA5_0 = input.LA(1);

                if ( ((LA5_0>='A' && LA5_0<='Z')||(LA5_0>='a' && LA5_0<='z')) ) {
                    alt5=1;
                }


                switch (alt5) {
            	case 1 :
            	    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:23:4: LETTER
            	    {
            	    mLETTER(); 


            	    }
            	    break;

            	default :
            	    if ( cnt5 >= 1 ) break loop5;
                        EarlyExitException eee =
                            new EarlyExitException(5, input);
                        throw eee;
                }
                cnt5++;
            } while (true);

            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:23:12: ( DIGIT )+
            int cnt6=0;
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( ((LA6_0>='0' && LA6_0<='9')) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:23:12: DIGIT
            	    {
            	    mDIGIT(); 


            	    }
            	    break;

            	default :
            	    if ( cnt6 >= 1 ) break loop6;
                        EarlyExitException eee =
                            new EarlyExitException(6, input);
                        throw eee;
                }
                cnt6++;
            } while (true);



            }

            state.type = _type;
        }
        finally {
        }
    }
    // $ANTLR end CELL_ADDRESS

    // $ANTLR start CONST
    public final void mCONST() throws RecognitionException {
        try {
            int _type = CONST;
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:28:7: ( STRING_LITERAL | NUMBER )
            int alt7=2;
            int LA7_0 = input.LA(1);

            if ( (LA7_0=='\"') ) {
                alt7=1;
            }
            else if ( ((LA7_0>='0' && LA7_0<='9')) ) {
                alt7=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 7, 0, input);

                throw nvae;
            }
            switch (alt7) {
                case 1 :
                    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:28:9: STRING_LITERAL
                    {
                    mSTRING_LITERAL(); 


                    }
                    break;
                case 2 :
                    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:29:4: NUMBER
                    {
                    mNUMBER(); 


                    }
                    break;

            }
            state.type = _type;
        }
        finally {
        }
    }
    // $ANTLR end CONST

    public void mTokens() throws RecognitionException {
        // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:1:8: ( WS | STRING_LITERAL | LETTER | DIGIT | NUMBER | CELL_ADDRESS | CONST )
        int alt8=7;
        alt8 = dfa8.predict(input);
        switch (alt8) {
            case 1 :
                // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:1:10: WS
                {
                mWS(); 


                }
                break;
            case 2 :
                // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:1:13: STRING_LITERAL
                {
                mSTRING_LITERAL(); 


                }
                break;
            case 3 :
                // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:1:28: LETTER
                {
                mLETTER(); 


                }
                break;
            case 4 :
                // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:1:35: DIGIT
                {
                mDIGIT(); 


                }
                break;
            case 5 :
                // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:1:41: NUMBER
                {
                mNUMBER(); 


                }
                break;
            case 6 :
                // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:1:48: CELL_ADDRESS
                {
                mCELL_ADDRESS(); 


                }
                break;
            case 7 :
                // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:1:61: CONST
                {
                mCONST(); 


                }
                break;

        }

    }


    protected DFA8 dfa8 = new DFA8(this);
    static final String DFA8_eotS =
        "\3\uffff\1\7\1\11\5\uffff\2\16\1\uffff\1\16\1\uffff";
    static final String DFA8_eofS =
        "\17\uffff";
    static final String DFA8_minS =
        "\1\11\1\uffff\1\0\1\60\1\56\1\0\4\uffff\1\60\1\56\1\uffff\1\60\1"+
        "\uffff";
    static final String DFA8_maxS =
        "\1\172\1\uffff\1\ufffe\1\172\1\71\1\ufffe\4\uffff\2\71\1\uffff\1"+
        "\71\1\uffff";
    static final String DFA8_acceptS =
        "\1\uffff\1\1\4\uffff\1\2\1\3\1\6\1\4\2\uffff\1\2\1\uffff\1\5";
    static final String DFA8_specialS =
        "\17\uffff}>";
    static final String[] DFA8_transitionS = {
            "\2\1\1\uffff\2\1\22\uffff\1\1\1\uffff\1\2\15\uffff\12\4\7\uffff"+
            "\32\3\6\uffff\32\3",
            "",
            "\42\5\1\6\uffdc\5",
            "\12\10\7\uffff\32\10\6\uffff\32\10",
            "\1\12\1\uffff\12\13",
            "\42\5\1\6\uffdc\5",
            "",
            "",
            "",
            "",
            "\12\15",
            "\1\12\1\uffff\12\13",
            "",
            "\12\15",
            ""
    };

    static final short[] DFA8_eot = DFA.unpackEncodedString(DFA8_eotS);
    static final short[] DFA8_eof = DFA.unpackEncodedString(DFA8_eofS);
    static final char[] DFA8_min = DFA.unpackEncodedStringToUnsignedChars(DFA8_minS);
    static final char[] DFA8_max = DFA.unpackEncodedStringToUnsignedChars(DFA8_maxS);
    static final short[] DFA8_accept = DFA.unpackEncodedString(DFA8_acceptS);
    static final short[] DFA8_special = DFA.unpackEncodedString(DFA8_specialS);
    static final short[][] DFA8_transition;

    static {
        int numStates = DFA8_transitionS.length;
        DFA8_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA8_transition[i] = DFA.unpackEncodedString(DFA8_transitionS[i]);
        }
    }

    class DFA8 extends DFA {

        public DFA8(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 8;
            this.eot = DFA8_eot;
            this.eof = DFA8_eof;
            this.min = DFA8_min;
            this.max = DFA8_max;
            this.accept = DFA8_accept;
            this.special = DFA8_special;
            this.transition = DFA8_transition;
        }
        public String getDescription() {
            return "1:1: Tokens : ( WS | STRING_LITERAL | LETTER | DIGIT | NUMBER | CELL_ADDRESS | CONST );";
        }
    }
 

}