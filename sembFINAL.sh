
#absolute paths to all the important shit 
SPATH=/home/shawn/analysis/Semblans/bin/semblans #path to semblans

#example paths that I use for my raw reads
LEAF1=/home/shawn/data/BChinense/SRR14574600_1.fastq
LEAF2=/home/shawn/data/BChinense/SRR14574600_2.fastq
# LEAF1=$1
# LEAF2=$2
FLOWR1=/home/shawn/data/BChinense/SRR14574603_1.fastq
FLOWR2=/home/shawn/data/BChinense/SRR14574603_2.fastq
# FLOWR1=$3
# FLOWR2=$4
STEM1=/home/shawn/data/BChinense/SRR14574597_1.fastq
STEM2=/home/shawn/data/BChinense/SRR14574597_2.fastq
# STEM1=$5
# STEM2=$6
ROOT1=/home/shawn/data/BChinense/SRR14574604_1.fastq
ROOT2=/home/shawn/data/BChinense/SRR14574604_2.fastq
# ROOT1=$7
# ROOT2=$8

OUTPRE=BC #prefix attached to output files
OUTDIR=/home/shawn/data/BChinense #output directory 
ASBPATH=/home/shawn/data/BChinense/combined/assembly/01-Transcript_assembly/$OUTPRE.Trinity.fasta #path to assembly


#I should add if statements - if they are not made, make them.
mkdir leaf 
mkdir flowr 
mkdir stem 
mkdir roots
mkdir combined

echo "preprocess will begin"

#running the actual preprocesses - i use the wait command becuz idk if they are gonna run over each other, this way they gotta wait until they finidh their shit
$SPATH preprocess --left $LEAF1 --right $LEAF2 --output leaf -od $OUTDIR/leaf --kraken-db /scratch/kraken2_dbs/archaea/,/scratch/kraken2_dbs/bacteria/,/scratch/kraken2_dbs/viral/,/scratch/kraken2_dbs/fungi/,/scratch/kraken2_dbs/human/,/scratch/kraken2_dbs/protozoa/ --ref-proteome ~/scratch/ensembl_plant.pep.all.fa -v --ram 200 --threads 20 

wait

$SPATH preprocess --left $FLOWR1 --right $FLOWR2 --output flowr -od $OUTDIR/flowr --kraken-db /scratch/kraken2_dbs/archaea/,/scratch/kraken2_dbs/bacteria/,/scratch/kraken2_dbs/viral/,/scratch/kraken2_dbs/fungi/,/scratch/kraken2_dbs/human/,/scratch/kraken2_dbs/protozoa/ --ref-proteome ~/scratch/ensembl_plant.pep.all.fa -v --ram 200 --threads 20 

wait

$SPATH preprocess --left $STEM1 --right $STEM2 --output stem -od $OUTDIR/stem --kraken-db /scratch/kraken2_dbs/archaea/,/scratch/kraken2_dbs/bacteria/,/scratch/kraken2_dbs/viral/,/scratch/kraken2_dbs/fungi/,/scratch/kraken2_dbs/human/,/scratch/kraken2_dbs/protozoa/ --ref-proteome ~/scratch/ensembl_plant.pep.all.fa -v --ram 200 --threads 20 

wait

$SPATH preprocess --left $ROOT1 --right $ROOT2 --output roots -od $OUTDIR/roots --kraken-db /scratch/kraken2_dbs/archaea/,/scratch/kraken2_dbs/bacteria/,/scratch/kraken2_dbs/viral/,/scratch/kraken2_dbs/fungi/,/scratch/kraken2_dbs/human/,/scratch/kraken2_dbs/protozoa/ --ref-proteome ~/scratch/ensembl_plant.pep.all.fa -v --ram 200 --threads 20 

wait

echo "finished all preprocess steps. Copying files and concatenation will begin, Bitch"

#move all these hoes to one folder 
for x in $OUTDIR/leaf/preprocess/06-Filter_overrepresented/*.orep.filt*; do scp $x $OUTDIR/combined; done
for x in $OUTDIR/flowr/preprocess/06-Filter_overrepresented/*.orep.filt*; do scp $x $OUTDIR/combined; done
for x in $OUTDIR/stem/preprocess/06-Filter_overrepresented/*.orep.filt*; do scp $x $OUTDIR/combined; done
for x in $OUTDIR/roots/preprocess/06-Filter_overrepresented/*.orep.filt*; do scp $x $OUTDIR/combined; done

#put all these hoes together
cat $OUTDIR/combined/*_1* > $OUTDIR/combined/$OUTPRE._1.fq #so for future reference. $OUTPRE_1.fq does not work for some dumbass reason, so I had to add the extra "." $OUTPRE._1.fq. IDK why but it works?

cat $OUTDIR/combined/*_2* > $OUTDIR/combined/$OUTPRE._2.fq

echo "all hoes have become two singular hoes. now assembly will begin"

#the assembly cmd

$SPATH assemble --left $OUTDIR/combined/$OUTPRE._1.fq --right $OUTDIR/combined/$OUTPRE._2.fq --output $OUTPRE -od $OUTDIR/combined --kraken-db /scratch/kraken2_dbs/archaea/,/scratch/kraken2_dbs/bacteria/,/scratch/kraken2_dbs/viral/,/scratch/kraken2_dbs/fungi/,/scratch/kraken2_dbs/human/,/scratch/kraken2_dbs/protozoa/ --ref-proteome ~/scratch/ensembl_plant.pep.all.fa -v --ram 200 --threads 20

#the postprocess cmd
#forgot to add a wait command on the one I'm running. 
wait

echo "hopefully you were assembled, postprocess should begin unless my paths are fucked. goodluck"

$SPATH postprocess --assembly $ASBPATH --left $OUTDIR/combined/$OUTPRE._1.fq --right $OUTDIR/combined/$OUTPRE._2.fq --output $OUTPRE -od $OUTDIR/combined --kraken-db /scratch/kraken2_dbs/archaea/,/scratch/kraken2_dbs/bacteria/,/scratch/kraken2_dbs/viral/,/scratch/kraken2_dbs/fungi/,/scratch/kraken2_dbs/human/,/scratch/kraken2_dbs/protozoa/ --ref-proteome ~/scratch/ensembl_plant.pep.all.fa -v --ram 200 --threads 20 -f









