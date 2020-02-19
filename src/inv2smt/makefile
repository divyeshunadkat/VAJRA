CC = g++
LEX = flex
YACC = bison
OBJ = lex.yy.o y.tab.o
CXXFLAGS = -g -Wall -std=c++11
Z3LIB = /home/divyesh/Documents/work/git/phdwork/code/TILER/build/z3/buildr/libz3.so

default: inv2smt

y.tab.c y.tab.h: inv2smt.y
	$(YACC) -y -d inv2smt.y

lex.yy.c: inv2smt.l
	$(LEX) inv2smt.l

y.tab.o: y.tab.c
	$(CC) $(CXXFLAGS) -c y.tab.c -o y.tab.o

lex.yy.o: lex.yy.c y.tab.h
	$(CC) $(CXXFLAGS) -c lex.yy.c -o lex.yy.o

inv2smt: $(OBJ) y.tab.h
	$(CC) $(CXXFLAGS) $(OBJ) -lm -o inv2smt $(Z3LIB)

clean:
	rm y.tab.c lex.yy.c y.tab.h $(OBJ)

cleanall:
	rm y.tab.c lex.yy.c y.tab.h $(OBJ) inv2smt
