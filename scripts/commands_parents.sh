#NA12891

mkdir -p $HOME/workspace/HTG/Module4/

export WORK_DIR_M4=$HOME/workspace/HTG/Module4/
export REF=$MUGQIC_INSTALL_HOME/genomes/species/Homo_sapiens.GRCh37/
mkdir -p ${WORK_DIR_M4}/bam/NA12891
cd $WORK_DIR_M4

cp $HOME/workspace/HTG/Module3/alignment/NA12891/NA12891.sorted.ba* bam/NA12891
cp $HOME/workspace/HTG/Module3/alignment/NA12891/NA12891.sorted.dup.recal.ba* bam/NA12891


module load mugqic/java/openjdk-jdk1.8.0_72 mugqic/GenomeAnalysisTK/4.1.0.0 mugqic/snpEff/4.3


mkdir -p variants

#NA12891.sort
java -Xmx2g -jar $GATK_JAR HaplotypeCaller \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
-I bam/NA12891/NA12891.sorted.bam \
-O variants/NA12891.hc.vcf \
-L 1:17704860-18004860

#NA12891.sort.rmdup.realign
java -Xmx2g -jar $GATK_JAR HaplotypeCaller \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
-I bam/NA12891/NA12891.sorted.dup.recal.bam \
-O variants/NA12891.rmdup.realign.hc.vcf \
-L 1:17704860-18004860


diff <(grep -v "^#" variants/NA12891.hc.vcf | cut -f1-2 | sort) \
<(grep -v "^#" variants/NA12891.rmdup.realign.hc.vcf | cut -f1-2 | sort)



java -Xmx2g -jar $GATK_JAR VariantFiltration \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
-V variants/NA12891.rmdup.realign.hc.vcf \
-O variants/NA12891.rmdup.realign.hc.filter.vcf \
-filter "QD < 2.0" \
-filter "FS > 200.0" \
-filter "MQ < 40.0" \
--filter-name QDFilter \
--filter-name FSFilter \
--filter-name MQFilter

java -Xmx4G -jar $SNPEFF_HOME/snpEff.jar eff \
-v -no-intergenic \
-i vcf -o vcf GRCh37.75 variants/NA12891.rmdup.realign.hc.filter.vcf >  variants/NA12891.rmdup.realign.hc.filter.snpeff.vcf


#switch to old GATK 3.8
module unload  mugqic/GenomeAnalysisTK/4.1.0.0
module load mugqic/GenomeAnalysisTK/3.8

java -Xmx2g -jar $GATK_JAR -T VariantAnnotator \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
--dbsnp $REF/annotations/Homo_sapiens.GRCh37.dbSNP150.vcf.gz \
-V variants/NA12891.rmdup.realign.hc.filter.snpeff.vcf \
-o variants/NA12891.rmdup.realign.hc.filter.snpeff.dbsnp.vcf \
-L 1:17704860-18004860

#return to GATK 4
module unload mugqic/GenomeAnalysisTK/3.8
module load  mugqic/GenomeAnalysisTK/4.1.0.0


## NA12892

mkdir -p $HOME/workspace/HTG/Module4/

export WORK_DIR_M4=$HOME/workspace/HTG/Module4/
export REF=$MUGQIC_INSTALL_HOME/genomes/species/Homo_sapiens.GRCh37/
mkdir -p ${WORK_DIR_M4}/bam/NA12892
cd $WORK_DIR_M4

cp $HOME/workspace/HTG/Module3/alignment/NA12892/NA12892.sorted.ba* bam/NA12892
cp $HOME/workspace/HTG/Module3/alignment/NA12892/NA12892.sorted.dup.recal.ba* bam/NA12892


module load mugqic/java/openjdk-jdk1.8.0_72 mugqic/GenomeAnalysisTK/4.1.0.0 mugqic/snpEff/4.3


mkdir -p variants

#NA12892.sort
java -Xmx2g -jar $GATK_JAR HaplotypeCaller \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
-I bam/NA12892/NA12892.sorted.bam \
-O variants/NA12892.hc.vcf \
-L 1:17704860-18004860

#NA12892.sort.rmdup.realign
java -Xmx2g -jar $GATK_JAR HaplotypeCaller \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
-I bam/NA12892/NA12892.sorted.dup.recal.bam \
-O variants/NA12892.rmdup.realign.hc.vcf \
-L 1:17704860-18004860


diff <(grep -v "^#" variants/NA12892.hc.vcf | cut -f1-2 | sort) \
<(grep -v "^#" variants/NA12892.rmdup.realign.hc.vcf | cut -f1-2 | sort)



java -Xmx2g -jar $GATK_JAR VariantFiltration \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
-V variants/NA12892.rmdup.realign.hc.vcf \
-O variants/NA12892.rmdup.realign.hc.filter.vcf \
-filter "QD < 2.0" \
-filter "FS > 200.0" \
-filter "MQ < 40.0" \
--filter-name QDFilter \
--filter-name FSFilter \
--filter-name MQFilter

java -Xmx4G -jar $SNPEFF_HOME/snpEff.jar eff \
-v -no-intergenic \
-i vcf -o vcf GRCh37.75 variants/NA12892.rmdup.realign.hc.filter.vcf >  variants/NA12892.rmdup.realign.hc.filter.snpeff.vcf


#switch to old GATK 3.8
module unload  mugqic/GenomeAnalysisTK/4.1.0.0
module load mugqic/GenomeAnalysisTK/3.8

java -Xmx2g -jar $GATK_JAR -T VariantAnnotator \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
--dbsnp $REF/annotations/Homo_sapiens.GRCh37.dbSNP150.vcf.gz \
-V variants/NA12892.rmdup.realign.hc.filter.snpeff.vcf \
-o variants/NA12892.rmdup.realign.hc.filter.snpeff.dbsnp.vcf \
-L 1:17704860-18004860

#return to GATK 4
module unload mugqic/GenomeAnalysisTK/3.8
module load  mugqic/GenomeAnalysisTK/4.1.0.0


### Trio mode
java -Xmx2g -jar $GATK_JAR HaplotypeCaller \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
-I bam/NA12878/NA12878.sorted.dup.recal.bam \
-I bam/NA12891/NA12891.sorted.dup.recal.bam \
-I bam/NA12892/NA12892.sorted.dup.recal.bam \
-O variants/trio.rmdup.realign.hc.vcf \
-L 1:17704860-18004860



java -Xmx2g -jar $GATK_JAR VariantFiltration \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
-V variants/trio.rmdup.realign.hc.vcf \
-O variants/trio.rmdup.realign.hc.filter.vcf \
-filter "QD < 2.0" \
-filter "FS > 200.0" \
-filter "MQ < 40.0" \
--filter-name QDFilter \
--filter-name FSFilter \
--filter-name MQFilter

java -Xmx4G -jar $SNPEFF_HOME/snpEff.jar eff \
-v -no-intergenic \
-i vcf -o vcf GRCh37.75 variants/trio.rmdup.realign.hc.filter.vcf >  variants/trio.rmdup.realign.hc.filter.snpeff.vcf


#switch to old GATK 3.8
module unload  mugqic/GenomeAnalysisTK/4.1.0.0
module load mugqic/GenomeAnalysisTK/3.8

java -Xmx2g -jar $GATK_JAR -T VariantAnnotator \
-R $REF/genome/Homo_sapiens.GRCh37.fa \
--dbsnp $REF/annotations/Homo_sapiens.GRCh37.dbSNP150.vcf.gz \
-V variants/trio.rmdup.realign.hc.filter.snpeff.vcf \
-o variants/trio.rmdup.realign.hc.filter.snpeff.dbsnp.vcf \
-L 1:17704860-18004860

#return to GATK 4
module unload mugqic/GenomeAnalysisTK/3.8
module load  mugqic/GenomeAnalysisTK/4.1.0.0

