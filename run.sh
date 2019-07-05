#!/bin/bash

set -ue

if [[ $# -lt 3 ]] ; then
  THIS=`basename "$0"`
  echo "USAGE: $THIS <INDEL_FLAGGED_VCF> <SAMPLE> <OUTDIR> <1=F017 2=+clean>"
  exit 1
fi

R_VERSION=$(Rscript -e 'x=version; cat(paste0(x$major,".",x$minor))' | grep -v repo)


WD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  # directory file executed from

SCRIPT_PATH="`dirname \"$0\"`"                  # relative
SCRIPT_PATH="`( cd \"$SCRIPT_PATH\" && pwd )`"  # absolutized and normalized

INDEL_VCF_FILTERED="$1"
SAMPLE="$2"
OUT_DIR="$3" # Directory that sampleID-specific output folder will be created in

mkdir -p $OUT_DIR
OUT_DIR="`( cd \"$OUT_DIR\" && pwd )`"  # absolutized and normalized

OUT_BASE_FILE=$OUT_DIR/${SAMPLE}_indelplot

echo $INDEL_VCF_FILTERED
echo $SAMPLE
echo $OUT_BASE_FILE
echo $WD

## make data file for R code
if [[ $# -eq 4 ]] ; then
  if [[ $4 -eq 1 ]] ; then
    zgrep -E $'\tPASS.*[\t;]F{1,2}017[\t;]' $INDEL_VCF_FILTERED | cut -f 1,2,4,5 >  ${OUT_BASE_FILE}.tsv
  else
    zgrep -E $'\tPASS.*[\t;]F{1,2}017[\t;]' $INDEL_VCF_FILTERED | perl indel_hp_filter.pl | cut -f 1,2,4,5 >  ${OUT_BASE_FILE}.tsv
  fi
else
  zgrep -wF PASS $INDEL_VCF_FILTERED | cut -f 1,2,4,5 >  ${OUT_BASE_FILE}.tsv
fi

unset R_LIBS
# needed if libs aren't installed centrally
export R_LIBS_USER=$HOME/local/R-lib-${R_VERSION}
mkdir -p $R_LIBS_USER
#/software/R-${R_VERSION}/bin/R < $SCRIPT_PATH/run.R --vanilla --args $SCRIPT_PATH ${OUT_BASE_FILE}.tsv $OUT_BASE_FILE.png
/software/R-${R_VERSION}/bin/Rscript $SCRIPT_PATH/run.R $SCRIPT_PATH ${OUT_BASE_FILE}.tsv $OUT_BASE_FILE
