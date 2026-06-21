# FFJSP-Z
The following is a dataset for the fuzzy flexible job shop scheduling problem with Z-number processing times.

%% ========================================================================
%  Generator script for reliability-augmented benchmark instances
%
%  This script reads the original benchmark instances and generates the
%  corresponding reliability-augmented instances. Machine categories are
%  assigned according to Table S-II, and reliability levels are assigned
%  according to Table S-I.
%
%  Reproducibility:
%  - Machine category assignment uses seedCategory = baseSeedCategory + i.
%  - Reliability level assignment uses seedReliability = baseSeedReliability + i.
%  - i is the index of the benchmark instance in inputFiles.
%  - The random number generator is initialized with rng(seed, 'twister').
%% ========================================================================
