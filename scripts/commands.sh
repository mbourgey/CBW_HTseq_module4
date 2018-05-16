
export SOFT_DIR=/usr/local/
export WORK_DIR=~/workspace/HTseq/Module4/
export GATK_JAR=$SOFT_DIR/gatk-4.0.1.2/gatk-package-4.0.1.2-local.jar
export SNPEFF_JAR=$SOFT_DIR/snpEff/snpEff.jar
export GATK_OLD_JAR=~/CourseData/HT_data/software/GenomeAnalysisTK-3.8/GenomeAnalysisTK.jar
export REF=$WORK_DIR/reference/


rm -rf $WORK_DIR
mkdir -p $WORK_DIR/variants
cd $WORK_DIR
ln -s ~/CourseData/HT_data/Module4/* .


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

java -Xmx2G -jar $SNPEFF_JAR eff \
-c $REF/snpEff_hg19.config -v -no-intergenic \
-i vcf -o vcf hg19 variants/NA12878.rmdup.realign.hc.filter.vcf >  variants/NA12878.rmdup.realign.hc.filter.snpeff.vcf

#less -S variants/NA12878.rmdup.realign.hc.filter.snpeff.vcf

#less -S variants/NA12878.rmdup.realign.hc.filter.snpeff.vcf

java -Xmx2g -jar $GATK_OLD_JAR -T VariantAnnotator \
-R $REF/hg19.fa \
--dbsnp $REF/dbSNP_135_chr1.vcf.gz \
-V variants/NA12878.rmdup.realign.hc.filter.snpeff.vcf \
-o variants/NA12878.rmdup.realign.hc.filter.snpeff.dbsnp.vcf \
-L chr1:17704860-18004860
