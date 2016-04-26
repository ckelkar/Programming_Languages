PROJECT = prj3

#Human generated files (should be submitted).
SRC_FILES = \
  prj3-sol.pl \
  README \
  Makefile

#This target makes a archive containing all the project source files,
#suitable for submission.
submit:		$(SRC_FILES)
		tar -cvf $(PROJECT).tar $(SRC_FILES)
		gzip $(PROJECT).tar

#Removes all objects and executables.
clean:
		rm -f *~

