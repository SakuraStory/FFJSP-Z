# FFJSP-Z

The following is a dataset for the fuzzy flexible job shop scheduling problem with Z-number processing times.

## Benchmark Instances

The FFJSP-Z dataset is extended from three groups of fuzzy flexible job shop scheduling benchmark instances in the literature:

- D01–D05: derived from the benchmark instances in [36] and [37].
- R01–R08: derived from the benchmark instances in [38].
- FMK01–FMK10: derived from the benchmark instances in [31].

For each original fuzzy flexible job shop scheduling instance, the generator script augments the processing-time information with reliability information. Machine categories are assigned according to Table S-II, and reliability levels are assigned according to Table S-I.

References

[31] R. Li, W. Gong, and C. Lu, “A reinforcement learning based RMOEA/D for bi-objective fuzzy flexible job shop scheduling,” Expert Systems with Applications, vol. 203, p. 117380, 2022.

[36] D. Lei, “A genetic algorithm for flexible job shop scheduling with fuzzy processing time,” International Journal of Production Research, vol. 48, no. 10, pp. 2995–3013, 2010.

[37] D. Lei, “Co-evolutionary genetic algorithm for fuzzy flexible job shop scheduling,” Applied Soft Computing, vol. 12, no. 8, pp. 2237–2245, 2012.

[38] K. Gao, P. N. Suganthan, Q. Pan, and M. F. Tasgetiren, “An effective discrete harmony search algorithm for flexible job shop scheduling problem with fuzzy processing time,” International Journal of Production Research, vol. 53, no. 19, pp. 5896–5911, 2015.


## Generator Script

This repository provides a generator script for reliability-augmented benchmark instances.

The script reads the original benchmark instances and generates the corresponding reliability-augmented instances. Machine categories are assigned according to Table S-II, and reliability levels are assigned according to Table S-I.

## Reproducibility

To ensure reproducibility, the following random seeds are used:

- Machine category assignment: `seedCategory = baseSeedCategory + i`
- Reliability level assignment: `seedReliability = baseSeedReliability + i`
- `i` denotes the index of the benchmark instance in `inputFiles`
- The MATLAB random number generator is initialized using `rng(seed, 'twister')`

