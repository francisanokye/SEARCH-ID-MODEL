# SEARCH-ID MODEL

This repository contains the code to reproduce the main results of the manuscript [Dynamic Response to Omicron Spread Under Structured Alert Levels: A Compartmental Analysis of Newfoundland and Labrador's Public Health Strategy](https://). All the experiments were run in the R programming language using the [pomp](https://kingaa.github.io/pomp/install.html) and [macpan2](https://github.com/canmod/macpan2) packages on 1.6 GHz Dual-Core Intel Core i5, 8 GB memory MacBook Air computer.

## About the datasets
The seroprevalence estimates used in this repository are publicly available and can be obtained from the [COVID-19 Immunity Task Force (CITF)](https://www.covid19immunitytaskforce.ca/seroprevalence-in-canada/) website. Its relevant CSV format is included in here for reproducibility purposes.

For the number of Newfoundland & Labrador COVID-19 (Omicron) daily reported cases, hospital occupancy and deaths, we obtained data from then Newfoundland and Labrador Centre for Health Information(NLCHI), now [Newfoundland and Labrador Health Services - Digital Health](https://nlhealthservices.ca/), under the Health Research Ethics Board reference number 2021.013.

For the parameterization of the vaccination rate across cohorts, we used the Government of Canada's publicly available data: [COVID-19 vaccination: Vaccination coverage](https://health-infobase.canada.ca/covid-19/vaccination-coverage/).

