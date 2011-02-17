# A Makefile to easily handle the compilation of
# presentations, made using the LaTeX class Beamer
#
# Patrick Pletscher
# 2006-03-05
#
# NOTE: We assume that you have a directory structure similar to
# the following:
#
#  slides/
#    src/
#    slides.pdf
#    notes.pdf
#    handout.pdf
#
# So we copy the resulting pdf's to the parent directory.

# LaTeX flags
LATEXFLAGS = -interaction=nonstopmode

# LaTeX sourcecode of slides
SRC = a
BIBTEXSRCS = a.bib

# how the resulting files should be named
SLIDES_SRC = $(SRC)-slides
HANDOUT_SRC = $(SRC)-handout
NOTES_SRC = $(SRC)-notes

# normally we just want to create the slides
short:		$(SRC).tex
		pdflatex $(SRC).tex

# create slides and handouts
final:		slides handout

# create the normal slides for the presentation
slides:		$(SRC).tex
		cp $(SRC).tex $(SLIDES_SRC).tex
		pdflatex $(LATEXFLAGS) $(SLIDES_SRC)
		pdflatex $(LATEXFLAGS) $(SLIDES_SRC)
		mv $(SLIDES_SRC).pdf ../
		rm -f $(SLIDES_SRC).tex

# create notes
notes:		$(SRC).tex
		echo '\PassOptionsToClass{notes=only}{beamer}\input{$(SRC).tex}' > $(NOTES_SRC).tex
		pdflatex $(LATEXFLAGS) $(NOTES_SRC).tex
		pdflatex $(LATEXFLAGS) $(NOTES_SRC).tex
		cp $(NOTES_SRC).pdf ../
		pdflatex $(SRC_NOTES6UP).tex
		mv $(SRC_NOTES6UP).pdf ../
		rm -f $(NOTES_SRC).tex $(NOTES_SRC).pdf

# create handouts, for the people to print
handout:	$(SRC).tex
		echo '\PassOptionsToClass{handout}{beamer}\input{$(SRC).tex}' > $(HANDOUT_SRC).tex
		pdflatex $(LATEXFLAGS) $(HANDOUT_SRC).tex
		pdflatex $(LATEXFLAGS) $(HANDOUT_SRC).tex
		cp $(HANDOUT_SRC).pdf ../
		pdfnup --nup "2x3" --offset ".25cm .25cm" --delta ".25cm .5cm" --frame true --scale 0.9 --outfile ../$(HANDOUT_SRC)6up.pdf  $(HANDOUT_SRC).pdf
		rm -f $(HANDOUT_SRC).tex $(HANDOUT_SRC).pdf

# delete the logs
clean:
		rm -f *.aux *.log *.out *.ps *.toc *.nav *.snm *.dvi
