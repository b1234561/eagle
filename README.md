# EAGLE: Explicit Alternative Genome Likelihood Evaluator

Implemented in python [compatible with 2\.7\.\*, 3\.\*] with ABI level C functions via CFFI

**Requires**: pysam, cffi, numpy

Usage: `python eagle.py -v variants.vcf -a alignment.bam -r reference.fasta > output.tab`

**Inputs**

1. Alignment data in coordinated sorted indexed BAM format (\*\.bam, \*\.bam.bai)
2. Reference genome in FASTA format
3. Variant candidates in VCF format

**Output**

A tab-delimited text file with one row per variant and columns representing:

1. chromosome / sequence id
2. coordinate position
3. reference sequence
4. alternative sequence
5. total number of reads
6. number of reads supporting alternative sequence
7. log 10 probability
8. log 10 likelihood ratio (odds)
9. variants in the set of nearby variant if any, otherwise []

**Input/Output Parameters**

-v VCF file describing the variants, only the columns describing position and sequence are used [columns: 1,2,4,5].

-a BAM alignment data file, reference coordinated sorted with index [*filename*.bam.bai].

-r Reference genome [multi] fasta file.

-o Output file name, defaults to *stdout* if not specified.

**Program Parameters**

-t The number of processes to use. Default is 1.

-hetbias Bias the prior probability towards heterozygous or homozygous mutations. Value between [0,1] where 1 is towards heterozygosity. Default is 0.5 (unbiased).

-n Group nearby variants within *n* bp of each other to be considered in the set of hypotheses for marginal probability calculations. Default is 10 bp.

-maxh The maximum number of hypotheses to be tested.  Instead of looking at all 2^n combinations for a set of variants, if after the current *k* for *n choose k* combinations is finished and the number tested exceeds the maximum, then do not consider more combinations.  The solo variants and the "all variants" hypothesis are always tested first and do not count towards the maximum.  Default is 1024 (2^10).

-mvh Instead of considering the combinations of variants in the hypotheses set, consider that all variants in the set co-occur by testing **one** multi-variant hypothesis.

-p Use primary alignments only, as defined by the SAM flag. This will also ignore multi-mapping considerations.

**Usage Notes**

`compare2TruthData.py` and `compileLikelihoods.py` are scripts to post-process the probabilities calculated by EAGLE. In particular, `compileLikelihoods.py` can be used to find somatic mutations given positive (i.e. tumor) and negative (i.e. normal) results on the same set of variants. Likelihood ratio and allele frequency thresholds are then used to determine significance.

If one expects that most mutations are not homozygous (i.e. in heterogenous tumor samples), then one can choose to skew the prior probability towards heterozygous/heterogeneous mutations. Otherwise, very low allele frequency mutations (~0.05) will have low probability. However, unless one has a good estimate of the cell mixture ratios in hetergenous samples and tune the bias appropriately, this will likely increase type I errors, depending on the threshold chosen.

Heterozygous non-reference variants (VCF: comma separated multiple alternative sequences) are given as separate entries. Furthermore, if they are near other variants, the program will separately consider each alternative sequence in their own sets so that phasing is not an issue. This may result in entries with the first 4 columns being identical. The user will need to examine the variant set of these cases to determine which it belongs to. The script *compileLikelihood.py* will only retain the entry with the maximum probability.
