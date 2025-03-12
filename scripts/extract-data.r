#####################
## extract-data.r  ##
#####################

library(here)
readRenviron(here("config.env"))

datadir <- Sys.getenv("datadir")
resultsdir <- Sys.getenv("resultsdir")

## function for extracting tcga tar.gz's to named output
extract.file <- function(tar.file, extract.file, new.file) {
  # get file path to extracted file
  x.file <-
    grep(extract.file,
      untar(tar.file, list = T),
      value = T
    )
  # extract the tar file
  cat("Extracting", tar.file, "to", new.file, "\n")
  untar(tar.file)

  # move the data to named output
  file.rename(x.file, new.file)

  # remove untared directory
  unlink(dirname(x.file), recursive = TRUE)
}
#######################
## extract the clinical data
clinical.file<-file.path(resultsdir,"clinical.txt")
if(!file.exists(clinical.file)){extract.file(tar.file=file.path(datadir,grep(".*_HNSC\\..*_Clinical\\.Level_1\\..*\\.tar\\.gz$",list.files(datadir),value=T)),extract.file="HNSC.clin.merged.txt",new.file=clinical.file)}


########################
## extract the protein data
protein.file<-file.path(resultsdir,"protein.txt")
if(!file.exists(protein.file)){extract.file(tar.file=file.path(datadir,grep("*_protein_normalization__data.Level_3.*.tar.gz$",list.files(datadir),value=T)),extract.file="data.txt",new.file=protein.file)}
## clean protein output:
## 	- remove 2nd row
lines<-readLines(protein.file)[-2]
writeLines(lines,file.path(resultsdir,"protein-clean.txt"))


########################
## extract the methylation data
methylation.file <- file.path(resultsdir, "methylation.txt")
if (!file.exists(methylation.file)) {
  extract.file(
    tar.file =
      file.path(
        datadir,
        grep(".*_HNSC\\..*_humanmethylation450_.*_data\\.Level_3\\..*\\.tar\\.gz$",
          list.files(datadir),
          value = T
        )
      ),
    extract.file = "data.txt",
    new.file = methylation.file
  )
}
## clean methylation output:
awk_command <-
  paste(
    "awk -F'\t' '{
		printf \"%s\t\", $1;
		for(i = 2; i <= NF; i += 4) {
			printf \"%s\t\", $i;
		}
		print \"\"
		}'",
    methylation.file,
    "| sed 2d  >",
    file.path(resultsdir, "methylation-clean.txt")
  )

# Execute the command
system(awk_command)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      1 gh13047 sscm     549010 Mar 12 21:17 [38;5;9mgdac.broadinstitute.org_HNSC.RPPA_AnnotateWithGene.Level_3.2016012800.0.0.tar.gz[0m[K
-rw-r--r-- 1 gh13047 sscm        114 Mar 12 21:17 gdac.broadinstitute.org_HNSC.RPPA_AnnotateWithGene.Level_3.2016012800.0.0.tar.gz.md5
-rw-r--r-- 1 gh13047 sscm       1383 Mar 12 21:17 [38;5;9mgdac.broadinstitute.org_HNSC.RPPA_AnnotateWithGene.aux.2016012800.0.0.tar.gz[0m[K
-rw-r--r-- 1 gh13047 sscm        110 Mar 12 21:17 gdac.broadinstitute.org_HNSC.RPPA_AnnotateWithGene.aux.2016012800.0.0.tar.gz.md5
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ [Kls -l ~/data/rhds/data/     results/
total 3201
-rw-r--r-- 1 gh13047 sscm 3263759 Mar 12 21:36 TCGA-CDR-SupplementalTableS1.txt
-rw-r--r-- 1 gh13047 sscm    1837 Mar 12 21:17 md5sums.txt
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ [Kls -l
total 116
-rw-r--r-- 1 gh13047 sscm   1070 Mar 12 17:04 LICENSE
-rw-r--r-- 1 gh13047 sscm    506 Mar 12 21:37 README.md
-rw-r--r-- 1 gh13047 sscm     57 Mar 12 21:06 config-template.env
-rw-r--r-- 1 gh13047 sscm     93 Mar 12 21:09 config.env
drwxr-xr-x 4 gh13047 sscm   4096 Mar 12 21:29 [0m[38;5;33mrenv[0m
-rw-r--r-- 1 gh13047 sscm 100791 Mar 12 21:30 renv.lock
drwxr-xr-x 2 gh13047 sscm   4096 Mar 12 21:37 [38;5;33mscripts[0m
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	[31mmodified:   README.md[m
	[31mmodified:   scripts/extract-data.r[m

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	[31mscripts/clean-clinical.r[m

no changes added to commit (use "git add" and/or "git commit -a")
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ R

R version 4.4.1 (2024-06-14) -- "Race for Your Life"
Copyright (C) 2024 The R Foundation for Statistical Computing
Platform: x86_64-conda-linux-gnu

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

instal- Project '/mnt/storage/scratch/gh13047/repo/rhds' loaded. [renv 1.1.2]
[?2004h> install.packages("jsonlite")
[?2004l# Downloading packages -------------------------------------------------------
- Downloading jsonlite from CRAN ...            OK [1 Mb in 0.21s]
Successfully downloaded 1 package in 0.47 seconds.

The following package(s) will be installed:
- jsonlite [1.9.1]
These packages will be installed into "/mnt/storage/scratch/gh13047/repo/rhds/renv/library/linux-rocky-8.9/R-4.4/x86_64-conda-linux-gnu".

[?2004hDo you want to proceed? [Y/n]: Y
[?2004l
rpm: no arguments given for query
# Installing packages --------------------------------------------------------
- Installing jsonlite ...                       OK [built from source and cached in 5.5s]
Successfully installed 1 package in 5.6 seconds.
[?2004h> q()
[?2004l[?2004hSave workspace image? [y/n/c]: n
[?2004l]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ 
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ 
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ 
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ 
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ 
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ Rscript clea    scripts/clean-clinical.r 
here() starts at /mnt/storage/scratch/gh13047/repo/rhds
extract-clinical.r 
  /user/work/gh13047/data/rhds/results/clinical.txt 
  /user/work/gh13047/data/rhds/results/TCGA-CDR-SupplementalTableS1.txt 
  /user/work/gh13047/data/rhds/results/clinical-clean.txt 
Error in file(con, "r") : cannot open the connection
Calls: readLines -> file
In addition: Warning message:
In file(con, "r") :
  cannot open file '/user/work/gh13047/data/rhds/results/clinical.txt': No such file or directory
Execution halted
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ [Kgit status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	[31mmodified:   README.md[m
	[31mmodified:   scripts/extract-data.r[m

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	[31mscripts/clean-clinical.r[m

no changes added to commit (use "git add" and/or "git commit -a")
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	[31mmodified:   README.md[m
	[31mmodified:   scripts/extract-data.r[m

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	[31mscripts/clean-clinical.r[m

no changes added to commit (use "git add" and/or "git commit -a")
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ git commit -a -m^C
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ [Kgit status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	[31mmodified:   README.md[m
	[31mmodified:   scripts/extract-data.r[m

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	[31mscripts/clean-clinical.r[m

no changes added to commit (use "git add" and/or "git commit -a")
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ git commit -a -m "updated^C
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ [K
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ 
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	[31mmodified:   README.md[m
	[31mmodified:   scripts/extract-data.r[m

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	[31mscripts/clean-clinical.r[m

no changes added to commit (use "git add" and/or "git commit -a")
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ git commit -a -m "updated^C
]0;gh13047@bc4login1:~/repo/rhds[gh13047@bc4login1[1;31m(BlueCrystal4)[0m rhds]$ [Kgit stat        git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	[31mmodified:   README.md[m
	[31mmodified:   scripts/extract-data.r[m

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	[31mscripts/clean-clinical.r[m

n