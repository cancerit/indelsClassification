library(GenomicRanges)
library(BSgenome)
library(BSgenome.Hsapiens.UCSC.hg19)
library(Rsamtools)

# Receive command line args
args = commandArgs(trailingOnly=TRUE)
install_loc = args[1]
processed_vcf = args[2]
image_root = args[3]

# source function
source(paste(install_loc, "indelsClassification.R", sep = "/"))
cat('TEST - 1')
# read input file with chr, position, ref, alt for some indels
INDELS <- read.table(processed_vcf, sep = "\t", header = T, stringsAsFactors = F)
cat('TEST - 2')
# run the function
pdf(file=paste0(image_root, '.pdf'), width = 12, height = 4)
cat('TEST - 3')
out <- indelsClassification(mat = INDELS)
cat('TEST - 4')
while (!is.null(dev.list()))  dev.off()

png(filename=paste0(image_root, '.png'), width = 1200, height = 400, type=c("cairo-png"))
print(out[[2]])
while (!is.null(dev.list()))  dev.off()

# check outputs
head(out[[1]])
