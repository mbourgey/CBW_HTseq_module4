

### Environment setup

docker run --privileged -v /tmp:/tmp --network host -it -w $PWD -v $HOME:$HOME -v /media:/media --user $UID:$GROUPS -v /etc/group:/etc/group -v /etc/passwd:/etc/passwd c3genomics/genpipes:0.8


export WORK_DIR_M4=$HOME/workspace/HTseq/Module4/
export REF=$HOME/workspace/HTseq/Module4/reference
mkdir -p $WORK_DIR_M4
cd $WORK_DIR_M4
ln -s $HOME/CourseData/HT_data/Module4/* .

module load mugqic/java/openjdk-jdk1.8.0_72 mugqic/bvatools/1.6 mugqic/trimmomatic/0.36 mugqic/samtools/1.9 mugqic/bwa/0.7.17 mugqic/GenomeAnalysisTK/4.1.0.0 mugqic/R_Bioconductor/3.5.0_3.7 mugqic/snpEff/4.3



ls bam/NA12878/


#NA12878.sort
java -Xmx2g -jar $GATK_JAR HaplotypeCaller \
-R $REF/hg19.fa \
-I bam/NA12878/NA12878.bwa.sort.bam \
-O variants/NA12878.hc.vcf \
-L chr1:17704860-18004860

#NA12878.sort.rmdup.realign
java -Xmx2g -jar $GATK_JAR HaplotypeCaller \
-R $REF/hg19.fa \
-I bam/NA12878/NA12878.bwa.sort.rmdup.realign.bam \
-O variants/NA12878.rmdup.realign.hc.vcf \
-L chr1:17704860-18004860

#less -S variants/NA12878.rmdup.realign.hc.vcf

diff <(grep ^chr variants/NA12878.hc.vcf | cut -f1-2 | sort) \
<(grep ^chr variants/NA12878.rmdup.realign.hc.vcf | cut -f1-2 | sort)

#grep -v "^#" variants/NA12878.rmdup.realign.hc.vcf \
#| awk '{ if(length($4) != length($5)) { print $0 } }' \
#| less -S

java -Xmx2g -jar $GATK_JAR VariantFiltration \
-R $REF/hg19.fa \
-V variants/NA12878.rmdup.realign.hc.vcf \
-O variants/NA12878.rmdup.realign.hc.filter.vcf \
-filter "QD < 2.0" \
-filter "FS > 200.0" \
-filter "MQ < 40.0" \
--filter-name QDFilter \
--filter-name FSFilter \
--filter-name MQFilter

java -Xmx2G -jar $SNPEFF_HOME/snpEff.jar eff \
-c $REF/snpEff_hg19.config -v -no-intergenic \
-i vcf -o vcf hg19 variants/NA12878.rmdup.realign.hc.filter.vcf >  variants/NA12878.rmdup.realign.hc.filter.snpeff.vcf

#less -S variants/NA12878.rmdup.realign.hc.filter.snpeff.vcf

#less -S variants/NA12878.rmdup.realign.hc.filter.snpeff.vcf

#switch to old GATK 3.8
module unload  mugqic/GenomeAnalysisTK/4.1.0.0
module load mugqic/GenomeAnalysisTK/3.8

java -Xmx2g -jar $GATK_JAR -T VariantAnnotator \
-R $REF/hg19.fa \
--dbsnp $REF/dbSNP_135_chr1.vcf.gz \
-V variants/NA12878.rmdup.realign.hc.filter.snpeff.vcf \
-o variants/NA12878.rmdup.realign.hc.filter.snpeff.dbsnp.vcf \
-L chr1:17704860-18004860

#return to GATK 4
module unload mugqic/GenomeAnalysisTK/3.8
module load  mugqic/GenomeAnalysisTK/4.1.0.0



exit
