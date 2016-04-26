package edu.binghamton.cs571;

import java.util.LinkedHashMap;
import java.util.Iterator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.*;

//TODO: Add comment specifying grammar for a grammar
public class GrammarStats {

	private final Scanner _scanner;
	private Token _lookahead;
	private int colon_flag = 0;
	private int semicolon_flag = 0;
	private int pipe_flag = 0;
	private int rulesets_count = 0;
	private int terminals_count = 0;
	private int nonterminals_count = 0;
	private int first_nonterminal_of_ruleset = 0;
	private String temp2;
	int i = 0;
	List<String> array = new ArrayList<String>();
	Map<String,String> map = new LinkedHashMap<String,String>();
	String temp = new String();

	// TODO: add other fields as necessary

	GrammarStats(String fileName) {
		_scanner = new Scanner(fileName, PATTERNS_MAP);
		nextToken();
	}

	/**
	 * Recognize a grammar specification. Return silently if ok, else signal an
	 * error.
	 */
	Stats getStats() {
		Stats stats = null;
		try {

			if (_lookahead.kind == TokenKind.NON_TERMINAL) {
				fun_matchnonterminal();

			} else {
				match(TokenKind.ERROR);
			}
          //*catches unused-nonterminal error
			for (int j = 0; j < array.size(); j++) {
				StringTokenizer multiTokenizer = new StringTokenizer((map.get(array.get(j)).toString()), " ");
				while (multiTokenizer.hasMoreTokens()) {

					String Str = multiTokenizer.nextElement().toString();
					if (!array.contains(Str)) {
						unusednonterminal_error(Str);
					}
				}
			}
          //*
          //*catches unused-ruleset error
			for (int j = 0; j < map.size(); j++) {
				temp2 = temp2 + map.get(array.get(j)).toString();
			}

			for (int i = 0; i < array.size(); i++) {
				if (i != 0) {
					if (!temp2.contains(array.get(i).toString())) {
						unusedruleset_error(array.get(i).toString());
					}
				}
			}
		  //*

			stats = new Stats(rulesets_count, nonterminals_count, terminals_count);
		} catch (GrammarParseException e) {
			System.err.println(e.getMessage());
		}
		return stats;
	}
	//function which matches non-terminal and checks for other possible token kinds
	private void fun_matchnonterminal() {
		if (first_nonterminal_of_ruleset == 0 && !array.contains(_lookahead.lexeme)) {
			first_nonterminal_of_ruleset = 1;
			array.add(_lookahead.lexeme);

		}
		if (first_nonterminal_of_ruleset == 0 && array.contains(_lookahead.lexeme)) {
			error_multipleuseofsamenonterminals(_lookahead.lexeme);
		}

		nonterminals_count++;
		match(TokenKind.NON_TERMINAL);
		if (_lookahead.kind == TokenKind.COLON && colon_flag == 0) {
			fun_matchcolon();

		} else if (_lookahead.kind == TokenKind.PIPE && pipe_flag == 0 && colon_flag == 1) {
			fun_matchpipe();
		} else if (_lookahead.kind == TokenKind.SEMI && semicolon_flag == 0 && colon_flag == 1) {
			fun_matchsemicolon();
		} else if (_lookahead.kind == TokenKind.TERMINAL) {
			fun_matchterminal();
		} else {
			match(TokenKind.ERROR);
		}
	}
	

	//function which matches pipe and checks for other possible token kinds
	private void fun_matchpipe() {
		match(TokenKind.PIPE);
		if (_lookahead.kind == TokenKind.NON_TERMINAL) {
			temp = temp + _lookahead.lexeme + " ";
			fun_matchnonterminal();
		} else if (_lookahead.kind == TokenKind.TERMINAL) {
			fun_matchterminal();
		} else {
			match(TokenKind.ERROR);

		}

	}
	//function which matches semicolon and checks for other possible token kinds
	private void fun_matchsemicolon() {
		semicolon_flag = 1;
		colon_flag = 0;
		match(TokenKind.SEMI);
		rulesets_count++;

		if (_lookahead.kind == TokenKind.NON_TERMINAL) {
			map.put(array.get(i), temp);
			i++;
			first_nonterminal_of_ruleset = 0;
			temp = "";
			fun_matchnonterminal();
		} else if (_lookahead.kind == TokenKind.EOF) {
			map.put(array.get(i), temp);
			i++;
		} else {
			match(TokenKind.ERROR);
		}

	}
	//function which matches colon and checks for other possible token kinds
	private void fun_matchcolon() {
		match(TokenKind.COLON);
		colon_flag = 1;
		semicolon_flag = 0;

		if (_lookahead.kind == TokenKind.NON_TERMINAL) {
			temp = temp + _lookahead.lexeme + " ";
			fun_matchnonterminal();
		}
		else if (_lookahead.kind == TokenKind.TERMINAL) {
			fun_matchterminal();
		} else if (_lookahead.kind == TokenKind.SEMI) {
			fun_matchsemicolon();
		} else {
			// System.out.println("end of file");
			match(TokenKind.ERROR);
		}

	}
    //function which matches terminal and checks for other possible token kinds
	private void fun_matchterminal() {
		match(TokenKind.TERMINAL);
		terminals_count++;
		if (_lookahead.kind == TokenKind.NON_TERMINAL) {
			fun_matchnonterminal();
		} else if (_lookahead.kind == TokenKind.PIPE) {
			fun_matchpipe();
		} else if (_lookahead.kind == TokenKind.SEMI) {
			fun_matchsemicolon();
		} else {
			match(TokenKind.ERROR);
		}

	}

	// TODO: add parsing functions

	// We extend RuntimeException since Java's checked exceptions are
	// very cumbersome
	private static class GrammarParseException extends RuntimeException {
		GrammarParseException(String message) {
			super(message);
		}
	}
   //match function
	private void match(TokenKind kind) {
		if (kind != _lookahead.kind) {
			syntaxError();

		}
		if (kind != TokenKind.EOF) {
			nextToken();
		}
	}

	/** Skip to end of current line and then throw exception */
	private void syntaxError() {
		String message = String.format("%s: syntax error at '%s'", _lookahead.coords, _lookahead.lexeme);
		throw new GrammarParseException(message);
	}
    // error unused nonterminal
	private void unusednonterminal_error(String Token) {
		String message = String.format(" Unused nonterminal: %s", Token);
		throw new GrammarParseException(message);
	}
   //error unused ruleset
	private void unusedruleset_error(String nonterminal) {

		String message = String.format("Unused ruleset:%s", nonterminal);
		throw new GrammarParseException(message);
	}
	
	private void error_multipleuseofsamenonterminals(String lexeme) {
		String message = String.format("multiple rulesets for same non-terminal:%s", lexeme);
		throw new GrammarParseException(message);
		
	}
	private static final boolean DO_TOKEN_TRACE = false;

	private void nextToken() {
		_lookahead = _scanner.nextToken();
		/*
		 * do { _lookahead = _scanner.nextToken();
		 * System.out.println(_lookahead); } while (_lookahead.kind !=
		 * TokenKind.EOF); //System.out.println(_lookahead);
		 */
		if (DO_TOKEN_TRACE)
			System.err.println("token: " + _lookahead);
	}

	/** token kinds for grammar tokens */
	private static enum TokenKind {
		EOF, COLON, PIPE, SEMI, NON_TERMINAL, TERMINAL, ERROR,
	}

	/** Sample structure to collect grammar statistics */
	private static class Stats {
		final int nRuleSets;
		final int nNonTerminals;
		final int nTerminals;

		Stats(int nRuleSets, int nNonTerminals, int nTerminals) {
			this.nRuleSets = nRuleSets;
			this.nNonTerminals = nNonTerminals;
			this.nTerminals = nTerminals;
		}

		public String toString() {
			return String.format("%d %d %d", nRuleSets, nNonTerminals, nTerminals);
		}
	}

	/** Map from regex to token-kind */
	private static final LinkedHashMap<String, Enum> PATTERNS_MAP = new LinkedHashMap<String, Enum>() {
		{
			put("", TokenKind.EOF);
			put("\\s+", null); // ignore whitespace.
			put("\\//.*", null); // ignore // comments
			put("\\:", TokenKind.COLON);
			put("\\|", TokenKind.PIPE);
			put("\\;", TokenKind.SEMI);
			put("[a-z]\\w*", TokenKind.NON_TERMINAL);
			put("[A-Z]\\w*", TokenKind.TERMINAL);
			put(".", TokenKind.ERROR); // catch lexical error in parser
		}
	};

	private static final String USAGE = String.format("usage: java %s GRAMMAR_FILE", GrammarStats.class.getName());

	/** Main program for testing */
	public static void main(String[] args) {

		if (args.length != 1) {
			System.err.println(USAGE);
			System.exit(1);
		}
		GrammarStats grammarStats = new GrammarStats(args[0]);
		Stats stats = grammarStats.getStats();
		if (stats != null) {
			System.out.println(stats);
		} 
	}

}
