
export SOFT_DIR=/usr/local/
export WORK_DIR=~/workspace/HTseq/Module4/
export SNPEFF_JAR=$SOFT_DIR/snpEff/snpEff.jar
export GATK_JAR=$SOFT_DIR/GATK/GenomeAnalysisTK.jar
export BVATOOLS_JAR=$SOFT_DIR/bvatools/bvatools-1.6-full.jar
export REF=$WORK_DIR/reference/



#parent 1
ls bam/NA12891/


#NA12891.sort
java -Xmx2g -jar $GATK_JAR -T HaplotypeCaller  -l INFO -R $REF/hg19.fa \
-I bam/NA12891/NA12891.bwa.sort.bam  --variant_index_type LINEAR --variant_index_parameter 128000 -dt none \
-o variants/NA12891.hc.vcf  -L chr1:17704860-18004860

#A12878.sort.rmdup.realign
java -Xmx2g -jar $GATK_JAR -T HaplotypeCaller -l INFO -R $REF/hg19.fa \
-I bam/NA12891/NA12891.bwa.sort.rmdup.realign.bam  --variant_index_type LINEAR --variant_index_parameter 128000 -dt none \
-o variants/NA12891.rmdup.realign.hc.vcf -L chr1:17704860-18004860

#less -S variants/NA12891.rmdup.realign.hc.vcf



java -Xmx2g -jar $GATK_JAR -T VariantFiltration \
-R $REF/hg19.fa --variant variants/NA12891.rmdup.realign.hc.vcf -o variants/NA12891.rmdup.realign.hc.filter.vcf --filterExpression "QD < 2.0" \
--filterExpression "FS > 200.0" \
--filterExpression "MQ < 40.0" \
--filterName QDFilter \
--filterName FSFilter \
--filterName MQFilter

java -Xmx2G -jar $SNPEFF_JAR eff \
-c $REF/snpEff_hg19.config -v -no-intergenic \
-i vcf -o vcf hg19 variants/NA12891.rmdup.realign.hc.filter.vcf >  variants/NA12891.rmdup.realign.hc.filter.snpeff.vcf


java -Xmx2g -jar $GATK_JAR -T VariantAnnotator -R $REF/hg19.fa \
--dbsnp $REF/dbSNP_135_chr1.vcf.gz --variant variants/NA12891.rmdup.realign.hc.filter.snpeff.vcf \
-o variants/NA12891.rmdup.realign.hc.filter.snpeff.dbsnp.vcf -L chr1:17704860-18004860

#Parent 2

ls bam/NA12892/


#NA12892.sort
java -Xmx2g -jar $GATK_JAR -T HaplotypeCaller  -l INFO -R $REF/hg19.fa \
-I bam/NA12892/NA12892.bwa.sort.bam  --variant_index_type LINEAR --variant_index_parameter 128000 -dt none \
-o variants/NA12892.hc.vcf  -L chr1:17704860-18004860

#variant
java -Xmx2g -jar $GATK_JAR -T HaplotypeCaller -l INFO -R $REF/hg19.fa \
-I bam/NA12892/NA12892.bwa.sort.rmdup.realign.bam  --variant_index_type LINEAR --variant_index_parameter 128000 -dt none \
-o variants/NA12892.rmdup.realign.hc.vcf -L chr1:17704860-18004860



java -Xmx2g -jar $GATK_JAR -T VariantFiltration \
-R $REF/hg19.fa --variant variants/NA12892.rmdup.realign.hc.vcf -o variants/NA12892.rmdup.realign.hc.filter.vcf --filterExpression "QD < 2.0" \
--filterExpression "FS > 200.0" \
--filterExpression "MQ < 40.0" \
--filterName QDFilter \
--filterName FSFilter \
--filterName MQFilter

java -Xmx2G -jar $SNPEFF_JAR eff \
-c $REF/snpEff_hg19.config -v -no-intergenic \
-i vcf -o vcf hg19 variants/NA12892.rmdup.realign.hc.filter.vcf >  variants/NA12892.rmdup.realign.hc.filter.snpeff.vcf


java -Xmx2g -jar $GATK_JAR -T VariantAnnotator -R $REF/hg19.fa \
--dbsnp $REF/dbSNP_135_chr1.vcf.gz --variant variants/NA12892.rmdup.realign.hc.filter.snpeff.vcf \
-o variants/NA12892.rmdup.realign.hc.filter.snpeff.dbsnp.vcf -L chr1:17704860-18004860


### trio variant calling
#variant
java -Xmx2g -jar $GATK_JAR -T HaplotypeCaller -l INFO -R $REF/hg19.fa \
-I bam/NA12892/NA12892.bwa.sort.rmdup.realign.bam -I bam/NA12891/NA12891.bwa.sort.rmdup.realign.bam  -I bam/NA12878/NA12878.bwa.sort.rmdup.realign.bam --variant_index_type LINEAR --variant_index_parameter 128000 -dt none \
-o variants/trio.rmdup.realign.hc.vcf -L chr1:17704860-18004860


java -Xmx2g -jar $GATK_JAR -T VariantFiltration \
-R $REF/hg19.fa --variant variants/trio.rmdup.realign.hc.vcf -o variants/trio.rmdup.realign.hc.filter.vcf --filterExpression "QD < 2.0" \
--filterExpression "FS > 200.0" \
--filterExpression "MQ < 40.0" \
--filterName QDFilter \
--filterName FSFilter \
--filterName MQFilter

java -Xmx2G -jar $SNPEFF_JAR eff \
-c $REF/snpEff_hg19.config -v -no-intergenic \
-i vcf -o vcf hg19 variants/trio.rmdup.realign.hc.filter.vcf >  variants/trio.rmdup.realign.hc.filter.snpeff.vcf


java -Xmx2g -jar $GATK_JAR -T VariantAnnotator -R $REF/hg19.fa \
--dbsnp $REF/dbSNP_135_chr1.vcf.gz --variant variants/trio.rmdup.realign.hc.filter.snpeff.vcf \
-o variants/trio.rmdup.realign.hc.filter.snpeff.dbsnp.vcf -L chr1:17704860-18004860


