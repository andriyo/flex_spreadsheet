// $ANTLR 3.1b1 C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g 2008-06-19 01:35:31

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

import org.antlr.runtime.debug.*;
import java.io.IOException;
public class IDBFormulaParser extends DebugParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "WS", "STRING_LITERAL", "LETTER", "DIGIT", "NUMBER", "CELL_ADDRESS", "CONST"
    };
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

    public static final String[] ruleNames = new String[] {
        "invalidRule", "atom"
    };
     
        public int ruleLevel = 0;
        public int getRuleLevel() { return ruleLevel; }
        public void incRuleLevel() { ruleLevel++; }
        public void decRuleLevel() { ruleLevel--; }
        public IDBFormulaParser(TokenStream input) {
            this(input, DebugEventSocketProxy.DEFAULT_DEBUGGER_PORT, new RecognizerSharedState());
        }
        public IDBFormulaParser(TokenStream input, int port, RecognizerSharedState state) {
            super(input, state);
            DebugEventSocketProxy proxy =
                new DebugEventSocketProxy(this, port, null);
            setDebugListener(proxy);
            try {
                proxy.handshake();
            }
            catch (IOException ioe) {
                reportError(ioe);
            }


        }
    public IDBFormulaParser(TokenStream input, DebugEventListener dbg) {
        super(input, dbg, new RecognizerSharedState());

    }
    protected boolean evalPredicate(boolean result, String predicate) {
        dbg.semanticPredicate(result, predicate);
        return result;
    }


    public String[] getTokenNames() { return IDBFormulaParser.tokenNames; }
    public String getGrammarFileName() { return "C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g"; }



    // $ANTLR start atom
    // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:32:1: atom : ( CELL_ADDRESS | CONST );
    public final void atom() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "atom");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(32, 1);

        try {
            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:32:6: ( CELL_ADDRESS | CONST )
            dbg.enterAlt(1);

            // C:\\Documents and Settings\\Andriy\\My Documents\\Flex Builder 3\\IdubeeClient\\grammar\\IDBFormula.g:
            {
            dbg.location(32,6);
            if ( (input.LA(1)>=CELL_ADDRESS && input.LA(1)<=CONST) ) {
                input.consume();
                state.errorRecovery=false;
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                dbg.recognitionException(mse);
                throw mse;
            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        dbg.location(34, 2);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "atom");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end atom

    // Delegated rules


 

    public static final BitSet FOLLOW_set_in_atom0 = new BitSet(new long[]{0x0000000000000002L});

}