## 1. Confirming model validity

* Run using between population pairwise pi. See pipeline [1_data_generation](https://github.com/mae47/Red_Sea_LGM/edit/main/Pipelines/1_data_generation.md) for calculated between population pairwise pi for each species.

* The script [abc_plot_sumstats_nd.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/abc_plot_sumstats_nd.r) plots the observed/calculated between population pairwise pi over the range of simulated between population pairwise pi values, to check that the simulated data covers the observed data

## 2. Shark model selection

## 3. Power analysis for model selection

## 4. Parameter estimation

## 5. Power analysis for parameter estimation

* power_analysis_in_R script for each species outputs a csv table with 95% coverage, the out-of-box (OOB) R2 value, median and mean R2 values for each of the 15 population parameters. It also outputs a pdf with plots of estimated vs simulated median and mean values for each parameter, with the axes scales roughly set to the range of possible values based on prior ranges.

* eg [power_analysis_in_R_Dt.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/power_analysis/power_analysis_in_R_Dt.r)

* power_analysis_plots_only_in_R script for each species improves the pdf plots. It should be edited after viewing the first pdf, to adjust scales around the points, where the actual range is smaller than the possible range.

* eg [power_analysis_plots_only_in_R_Dt.r](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/power_analysis/power_analysis_plots_only_in_R_Dt.r)

* Scripts for all species can be found [here](https://github.com/mae47/Red_Sea_LGM/tree/main/Scripts/power_analysis)

