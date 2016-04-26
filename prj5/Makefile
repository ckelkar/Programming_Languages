PROJECT = prj5

#Human generated files (should be submitted).
SRC_FILES = \
  bst_dict.erl \
  dict.hrl \
  dict_adt.erl \
  iterator.erl \
  iterator.hrl \
  list_dict.erl \
  server_dict.erl \
  Makefile \
  README

#This target makes a archive containing all the project source files,
#suitable for submission.
submit:		$(SRC_FILES)
		tar -cvf $(PROJECT).tar $(SRC_FILES)
		gzip $(PROJECT).tar

#Removes all objects and executables.
clean:
		rm -f *.beam *~

