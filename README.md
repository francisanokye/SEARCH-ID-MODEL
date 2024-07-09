# SEARCH-ID MODEL

This repository contains the code to reproduce the main results of the manuscript [Dynamic Response to Omicron Spread Under Structured Alert Levels: A Compartmental Analysis of Newfoundland and Labrador's Public Health Strategy](https://). All the experiments were run in the R programming language using the [pomp](https://kingaa.github.io/pomp/install.html) and [macpan2](https://github.com/canmod/macpan2) packages (1.6 GHz Dual-Core Intel Core i5, 8 GB memory) on a MacBook Air computer.


- **CDC_models.ipynb**: It contains the code used to compile the predictions of the models submitted to the CDC. The dataset required to run this script was not included due to the size, but it is publicly available.
- **Comparison_CDC.ipynb**: It contains the code to create the graphs that compare SIMLR with the models submitted to the CDC. It uses the files created by the previous notebook.
- **Model_Canada_Provinces.ipynb**: It contains the data to predict the number of cases 1 to 4 weeks in advance in the 6 biggest provinces in Canada.
- **Model_US_Country.ipynb**: Similar to the previous one, but for the predictions on US at the country level.
- **Model_US_States.ipynb**: Similar to the previous one, but for the predictions on US at the state level.
- **SIR_Simulations.ipynb**: Code to create the simulated SIR, and to show how a simple SIR model with time-varying parameters can describe the complexities of the COVID-19 dynamics.


This repository folder in addition contains the in-house developed python library *MLib*, which contains custom code for inference in probabilistic graphical models.

## About the datasets
The seroprevalence estimates used in this repository are publicly available and can be obtained from the [COVID-19 Immunity Task Force (CITF)](https://www.covid19immunitytaskforce.ca/seroprevalence-in-canada/) website. Its relevant CSV format is included in here for reproducibility purposes.

For the number of Newfoundland & Labrador COVID-19 (Omicron) daily reported cases, hospital occupancy and deaths, we obtained data from then Newfoundland and Labrador Centre for Health Information(NLCHI), now [Newfoundland and Labrador Health Services - Digital Health](https://nlhealthservices.ca/), under the Health Research Ethics Board reference number 2021.013.

For the parameterization of the vaccination rate across cohorts, we used the Government of Canada's publicly available data: [COVID-19 vaccination: Vaccination coverage](https://health-infobase.canada.ca/covid-19/vaccination-coverage/).

