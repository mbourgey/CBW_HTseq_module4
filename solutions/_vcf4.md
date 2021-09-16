the number of variant  can be computed using this simple command:

```
grep -v "^#" variants/NA12878.hc.vcf | wc -l 
```

We have 399 in the raw vcf, we previously saw 404 in the realigned vcf

In that case the impact of bam improvement is very low because HaplotypeCaller perform internally a similar step to indel-realignment


