ctags -e -R --verbose=yes \
	--langdef=nim \
	--langmap=nim:.nim \
	--regex-nim='/(\w+)\*?\s*=\s*(ref\s*|ptr\s*)?object\>/\1/c,class/' \
	--regex-nim='/(\w+)\*?\s*=\s*enum\>/\1/e,enum/' \
	--regex-nim='/(\w+)\*?\s*=\s*tuple\>/\1/t,tuple/' \
	--regex-nim='/(\w+)\*?\s*=\s*range\>/\1/s,subrange/' \
	--regex-nim='/(\w+)\*?\s*=\s*proc\>/\1/p,proctype/' \
  --regex-nim='/(\w+)\*?\s*=\s*distinct\>/\1/d,distincttype/' \
  --regex-nim='/(\w+)\*?\s*=\s*set\[\w+\]/\1/s,set/' \
  --regex-nim='/(\w+)\*?\s*=\s*seq\[\w+\]/\1/s,seq/' \
  --regex-nim='/(\w+)\*\s*\{\.magic/\1/b,buildintype/' \
	--regex-nim='/proc\s+(\w+)/\1/f,procedure/' \
	--regex-nim='/func\s+(\w+)/\1/f,procedure/' \
	--regex-nim='/method\s+(\w+)/\1/m,method/' \
	--regex-nim='/template\s+(\w+)/\1/u,template/' \
	--regex-nim='/macro\s+(\w+)/\1/v,macro/' \
	--regex-nim='/(proc|func|method|template|macro)\s+`([^`]+)`/\2/o,operator/' \
	--languages=nim \
	--exclude=nimcache \
  --exclude=htmldocs \
  --exclude=unittests \
  --exclude=resources \
  --exclude=screenshots \
  --exclude=pkgstemp \
  --exclude=tests \
  --exclude=csources \
  --exclude=tinyc \
  --exclude=web/upload \
  --exclude=dist