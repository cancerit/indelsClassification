# Required packages
pkgs <- c("GenomicRanges", "BSgenome", "BSgenome.Hsapiens.UCSC.hg19", "Rsamtools")

r = getOption("repos") # hard code the UK repo for CRAN
r["CRAN"] = "http://cran.uk.r-project.org"
options(repos = r)
rm(r)

# Function for checking whether package is installed, then installing using CRAN or Bioconducter if missing
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
    source("https://bioconductor.org/biocLite.R")
    BiocInstaller::biocLite(new.pkg, suppressUpdates=TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# Load/install required packages
ipak(pkgs)

# Receive command line args
args = commandArgs(trailingOnly=TRUE)
install_loc = args[1]
processed_vcf = args[2]
image_root = args[3]

# source function
source(paste(install_loc, "indelsClassification.R", sep = "/"))

# read input file with chr, position, ref, alt for some indels
INDELS <- read.table(processed_vcf, sep = "\t", header = T, stringsAsFactors = F)

# run the function
pdf(file=paste0(image_root, '.pdf'), width = 12, height = 4)
out <- indelsClassification(mat = INDELS)
while (!is.null(dev.list()))  dev.off()

png(filename=paste0(image_root, '.png'), width = 1200, height = 400, type=c("cairo-png"))
print(out[[2]])
while (!is.null(dev.list()))  dev.off()

# check outputs
head(out[[1]])
