#start with bwa indexing of the reference genome
bwa index s_paradoxus_mt.fa

#Make a sam file
bwa mem s_paradoxus_mt.fa SRR1868835.fastq > SRR.sam

#make sam to a binary file 
samtools view -b -o SRR.bam -S SRR.sam

#sort align the reference genome 
samtools sort SRR.bam SRR.sorted

#index sorted bam file  
samtools index SRR.sorted.bam

#index reference genome for the fasta
samtools faidx s_paradoxus_mt.fa

#tview to compare the genomes for idea of quality 
#samtools tview SRR.sorted.bam s_paradoxus.mt.fa

#variant calling  bcf to vcf 
samtools mpileup -uf s_paradoxus_mt.fa SRR.sorted.bam > sra.bcf
bcftools view -vcg sra.bcf > SRR_snps_indels.vcf 
# same ^^
# samtools mpileup -uf s_paradoxus_mt.fa SRR.sorted.bam | bcftools view -vcg - > SRR_snps_indels.vcf


#get rid of '##' in the file SRR_snps_indels.vcf
grep -v '##' SRR_snps_indels.vcf > SRR_snps_INDELS.vcf  

#get rid of 'INDEL' in the file SRR_snps_INDELS.vcf
grep -v 'INDEL' SRR_snps_INDELS.vcf > SRR_snps.vcf

#retrieve all qaulity scores of greater than 100 and put in file sra.good_snps
awk '$6 > 100' SRR_snps.vcf  > sra.good_snps
  
