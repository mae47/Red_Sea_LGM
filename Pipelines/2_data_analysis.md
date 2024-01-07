## 1. Confirming model validity

* Run using between population pairwise pi. See pipeline [1_data_generation](https://github.com/mae47/Red_Sea_LGM/edit/main/Pipelines/1_data_generation.md) for observed/calculated between population pairwise pi values for each species.

* The simulated 10k nucleotide diversities (filename beginning "pi_") for each species can be found [here](https://github.com/mae47/Red_Sea_LGM/edit/main/data/10k_simulated_datasets)

* The script [abc_plot_sumstats_nd.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/abc_plot_sumstats_nd.r) plots the observed/calculated between population pairwise pi over the range of simulated between population pairwise pi values, to check that the simulated data covers the observed data

## 2. Shark model selection

* Confirming most likely demographic model between model "bottleneck" ie cosmo0_model (the single model used in the main text) and model "recolonisation" ie cosmo2_model (see Supplementary information).

* The target ie observed 2D SFS for C. melanopterus can be found [here](https://github.com/mae47/Red_Sea_LGM/tree/main/data/targets) while the simulated 2D SFS only datasets (without pi) for both demographic models can be found [here](https://github.com/mae47/Red_Sea_LGM/tree/main/data/10k_simulated_datasets/C_melanopterus)

* The script [abcrf_model_selection.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/abcrf_model_selection.r) uses the abcrf package and 1000 trees to predict the best model: cosmo0_model or model "bottleneck"

## 3. Power analysis for model selection

* Randomly sampled 1000 rows from the cosmo0_model simulated 2D SFS dataset, and used abcrf package with 1000 trees to predict if these rows would be assigned to the correct (cosmo0_model) dataset.

* Outputs a csv table with the number of pods (/1000) assigned to each model (cosm0_model or cosmo2_model) with different degrees of confidence (eg 95% of trees, 90% of trees, 80% of trees etc.)

* The script [power_analysis_ms_in_R.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/power_analysis_ms_in_R.r) utilises the 10k simulated datasets for the two models for C. melanopterus found [here](https://github.com/mae47/Red_Sea_LGM/tree/main/data/10k_simulated_datasets/C_melanopterus)

## 4. Parameter estimation

## 5. Power analysis for parameter estimation

* power_analysis_in_R script for each species outputs a csv table with 95% coverage, the out-of-box (OOB) R2 value, median and mean R2 values for each of the 15 population parameters. It also outputs a pdf with plots of estimated vs simulated median and mean values for each parameter, with the axes scales roughly set to the range of possible values based on prior ranges.

* eg [power_analysis_in_R_Dt.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/power_analysis/power_analysis_in_R_Dt.r)

* power_analysis_plots_only_in_R script for each species improves the pdf plots. It should be edited after viewing the first pdf, to adjust scales around the points, where the actual range is smaller than the possible range.

* eg [power_analysis_plots_only_in_R_Dt.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/power_analysis/power_analysis_plots_only_in_R_Dt.r)

* Scripts for all species can be found [here](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/power_analysis)

