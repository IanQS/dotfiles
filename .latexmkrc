# latexmk configuration. This is the SINGLE SOURCE OF TRUTH for how and where this
# document builds: it is read by `make`, by a bare `latexmk`, and by texlab (the
# editor's on-save build shells out to latexmk too). Because all three read it, the
# editor and `make` can no longer disagree about the engine or the output path.

$pdf_mode = 1;  # build a PDF with pdfLaTeX (what cogsci.sty + biblatex/biber expect)
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Everything -- aux (.aux/.bcf/.fls/.log/...), the .pdf and .synctex.gz -- lands in
# build/. Leaving aux_dir equal to out_dir means latexmk just passes
# -output-directory=build to the engine, so nothing is copied back to the repo root
# and biber finds build/main.bcf without $emulate_aux.
$out_dir = 'build';
