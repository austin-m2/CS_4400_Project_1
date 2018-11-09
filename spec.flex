package CS_4400;
import java.util.ArrayList;
import java.io.*;

%%

%{
  	private int comment_count = 0;
  	private ArrayList<String> tokens = new ArrayList<>();
  	String keywords[]= {"boolean", "break", "class", "double","else", "extends", "false", "for", "if", "implements", "int", "interface", "new", "newarray", "null", "println", "readln", "return", "string", "true", "void", "while"};
  	Trie trie = new Trie();
  	private String fileName;
%} 

%init{
  	for (int i=0;i<keywords.length;i++) {
  		trie.addKeyword(keywords[i]);
  	}	
%init}

%eof{
	try {
		FileWriter fileWriter = new FileWriter(fileName);
		BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
		boolean _newline = true;
		for (int i = 0; i < tokens.size(); i++) {
			if (!_newline) {
				System.out.print(" ");
				bufferedWriter.write(" ");
			}
			if (_newline && tokens.get(i).equals("\n")) {
				continue;
			}
			System.out.print(tokens.get(i));
			bufferedWriter.write(tokens.get(i));
			if (tokens.get(i).equals("\n")) {
				_newline = true;
			} else {
				_newline = false;
			}
		} 
	}
	catch (IOException ex) {
		System.out.println("Error writing to file " + fileName);

	System.out.println("");

	trie.printTable();
	}

%eof}

%line
%unicode
%state COMMENT
%debug


ALPHA=[A-Za-z]
DIGIT=[0-9]
NONNEWLINE_WHITE_SPACE_CHAR=[\ \t\b\012]
NEWLINE=\r|\n|\r\n
WHITE_SPACE_CHAR=[\n\r\ \t\b\012]
STRING_TEXT=(\\\"|[^\n\r\"]|\\{WHITE_SPACE_CHAR}+\\)*
COMMENT_TEXT=([^*/\n]|[^*\n]"/"[^*\n]|[^/\n]"*"[^/\n]|"*"[^/\n]|"/"[^*\n])+
Ident = {ALPHA}({ALPHA}|{DIGIT}|_)*
HEX_INTEGER = ("0X"|"0x")[0-9A-Fa-f]+
DOUBLE = ({DIGIT}+"."{DIGIT}*)(([Ee]([+-]?({DIGIT}+)))?)
BOOLEAN_CONSTANT = "true"|"false"

%%

<YYINITIAL> {
  "+" { tokens.add("plus");
  	return (new Yytoken(1,yytext(),yyline,yychar,yychar+1)); }
  "-" { tokens.add("minus");
  	return (new Yytoken(2,yytext(),yyline,yychar,yychar+1)); }
  "*" { tokens.add("multiplication"); 
  	return (new Yytoken(3,yytext(),yyline,yychar,yychar+1)); }
  "/" { tokens.add("division"); 
  	return (new Yytoken(4,yytext(),yyline,yychar,yychar+1)); }
  "%" { tokens.add("mod"); 
  	return (new Yytoken(5,yytext(),yyline,yychar,yychar+1)); }
  "<"  { tokens.add("less");
  	return (new Yytoken(6,yytext(),yyline,yychar,yychar+1)); }
  "<=" { tokens.add("lessequal");
  	return (new Yytoken(7,yytext(),yyline,yychar,yychar+2)); }
  ">"  { tokens.add("greater");
  	return (new Yytoken(8,yytext(),yyline,yychar,yychar+1)); }
  ">=" { tokens.add("greaterequal");
  	return (new Yytoken(9,yytext(),yyline,yychar,yychar+2)); }
  "==" { tokens.add("equal");
  	return (new Yytoken(10,yytext(),yyline,yychar,yychar+2)); }
  "!=" { tokens.add("notequal");
  	return (new Yytoken(11,yytext(),yyline,yychar,yychar+2)); }
  "&&"  { tokens.add("and");
  	return (new Yytoken(12,yytext(),yyline,yychar,yychar+2)); }
  "||"  { tokens.add("or");
  	return (new Yytoken(13,yytext(),yyline,yychar,yychar+2)); }
  "!" { tokens.add("not");
  	return (new Yytoken(14,yytext(),yyline,yychar,yychar+1)); }
  "=" { tokens.add("assignop");
  	return (new Yytoken(15,yytext(),yyline,yychar,yychar+1)); }
  ";" { tokens.add("semicolon");
  	return (new Yytoken(16,yytext(),yyline,yychar,yychar+1)); }
  "," { tokens.add("comma");
  	return (new Yytoken(17,yytext(),yyline,yychar,yychar+1)); }
  "." { tokens.add("period");
  	return (new Yytoken(18,yytext(),yyline,yychar,yychar+1)); }
  "(" { tokens.add("leftparen");
  	return (new Yytoken(19,yytext(),yyline,yychar,yychar+1)); }
  ")" { tokens.add("rightparen");
  	return (new Yytoken(20,yytext(),yyline,yychar,yychar+1)); }
  "[" { tokens.add("leftbracket");
  	return (new Yytoken(21,yytext(),yyline,yychar,yychar+1)); }
  "]" { tokens.add("rightbracket");
  	return (new Yytoken(22,yytext(),yyline,yychar,yychar+1)); }
  "{" { tokens.add("leftbrace");
  	return (new Yytoken(23,yytext(),yyline,yychar,yychar+1)); }
  "}" { tokens.add("rightbrace");
  	return (new Yytoken(24,yytext(),yyline,yychar,yychar+1)); }


  {NONNEWLINE_WHITE_SPACE_CHAR}+ { }

  "/*" { yybegin(COMMENT); comment_count++; }
  "//".* {}

  \"{STRING_TEXT}\" {
  	tokens.add("stringconstant");
    String str =  yytext().substring(1,yylength()-1);
    return (new Yytoken(47,str,yyline,yychar,yychar+yylength()));
  }
  
  \"{STRING_TEXT} {
    String str =  yytext().substring(1,yytext().length());
    Utility.error(Utility.E_UNCLOSEDSTR);
    return (new Yytoken(50,str,yyline,yychar,yychar + str.length()));
  } 
  
  {DIGIT}+ { 
  	tokens.add("intconstant");
  	return (new Yytoken(46,yytext(),yyline,yychar,yychar+yylength())); 
  }  

  {HEX_INTEGER} {
  	tokens.add("intconstant");
  	return (new Yytoken(46,yytext(),yyline,yychar,yychar+yylength())); 
  }

  {DOUBLE} {
  	tokens.add("doubleconstant");
  	return (new Yytoken(48,yytext(),yyline,yychar,yychar+yylength()));
  }

  {BOOLEAN_CONSTANT} {
  	tokens.add("booleanconstant");
  	return (new Yytoken(49,yytext(),yyline,yychar,yychar+yylength()));
  }

  {Ident} { 
  	String t = yytext();
  	if (t.equals("boolean")) {
  		tokens.add("boolean");
  		return (new Yytoken(25,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("break")) {
		tokens.add("break");
  		return (new Yytoken(26,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("class")) {
		tokens.add("class");
  		return (new Yytoken(27,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("double")) {
		tokens.add("double");
  		return (new Yytoken(28,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("else")) {
		tokens.add("else");
  		return (new Yytoken(29,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("extends")) {
		tokens.add("extends");
  		return (new Yytoken(30,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("for")) {
		tokens.add("for");
  		return (new Yytoken(31,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("if")) {
		tokens.add("if");
  		return (new Yytoken(32,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("implements")) {
		tokens.add("implements");
  		return (new Yytoken(33,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("int")) {
		tokens.add("int");
  		return (new Yytoken(34,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("interface")) {
		tokens.add("interface");
  		return (new Yytoken(35,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("new")) {
		tokens.add("new");
  		return (new Yytoken(36,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("newarray")) {
		tokens.add("newarray");
  		return (new Yytoken(37,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("null")) {
		tokens.add("null");
  		return (new Yytoken(38,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("println")) {
		tokens.add("println");
  		return (new Yytoken(39,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("readln")) {
		tokens.add("readln");
  		return (new Yytoken(40,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("return")) {
		tokens.add("return");
  		return (new Yytoken(41,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("string")) {
		tokens.add("string");
  		return (new Yytoken(42,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("void")) {
		tokens.add("void");
  		return (new Yytoken(43,yytext(),yyline,yychar,yychar+yylength()));
  	} else if (t.equals("while")) {
		tokens.add("while");
  		return (new Yytoken(44,yytext(),yyline,yychar,yychar+yylength()));
  	} else {
  		tokens.add("id");
  		trie.addIdentifier(t);
  	  	return (new Yytoken(45,yytext(),yyline,yychar,yychar+yylength()));
  	}

  }  
}

<COMMENT> {
  "/*" { comment_count++; }
  "*/" { if (--comment_count == 0) yybegin(YYINITIAL); }
  {COMMENT_TEXT} { }
}


{NEWLINE} { 
	tokens.add("\n");
}

. {
  System.out.println("Illegal character: <" + yytext() + ">");
	Utility.error(Utility.E_UNMATCHED);
}

