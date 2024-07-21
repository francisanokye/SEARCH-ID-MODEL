# SEARCH-ID MODEL
Please visit [here](https://docs.google.com/document/d/1hdHnPkjz6GBj1uK-ep7LuTPX6-VsP_DHEZ3NIB9AtLY/edit?usp=sharing) for my experience with macpan2 and project workflow information.

This repository contains the code to reproduce the main results of the manuscript [Dynamic Response to Omicron Spread Under Structured Alert Levels: A Compartmental Analysis of Newfoundland and Labrador's Public Health Strategy](https://). All the experiments were run in the R programming language using the [pomp](https://kingaa.github.io/pomp/install.html) and [macpan2](https://github.com/canmod/macpan2) packages on 1.6 GHz Dual-Core Intel Core i5, 8 GB memory MacBook Air computer.

We first attempted to modularize our code by building the simplest models with only the needed compartments that excluded vaccination and expanded our way up to the SEARCHID model.
SEARI (no vaccination) and SEARCHI (no vaccination) are the pieces before vaccination and are just enough for the start. 

### SEARI
<img src= "https://github.com/francisanokye/SEARCH-ID-MODEL/blob/main/searchid/macpan2/figures/seari.png">

$$
\begin{align*}
    \frac{dS}{dt} &= -\beta_{i} S\frac{(I + A)}{N},\\
    \frac{dE}{dt} &= \beta_{i} S\frac{(I + A)}{N} - \sigma E,\\
    \frac{dA}{dt} &= \sigma \mu E - \gamma A,\\
    \frac{dI}{dt} &= \sigma(1-\mu)E - \alpha I,\\
    \frac{dR}{dt} &= \gamma A + \alpha I,\\
\end{align*}
$$

### SEARCHI
<img src= "https://github.com/francisanokye/SEARCH-ID-MODEL/blob/main/searchid/macpan2/figures/searchi.png">

$$
\begin{align*}
    \frac{dS}{dt} &= -\beta_{i} S\frac{(I + A)}{N},\\
    \frac{dE}{dt} &= \beta_{i} S_{1}\frac{(I + A)}{N} - \sigma E,\\
    \frac{dA}{dt} &= \sigma \mu E - \gamma A,\\
    \frac{dI}{dt} &= \sigma(1-\mu)E - \phi I,\\
    \frac{dH}{dt} &= \phi\xi I - \omega H1,\\
    \frac{dC}{dt} &= \omega\theta H - \eta C,\\
    \frac{dR}{dt} &= \gamma A + \phi(1-\xi)I + \omega(1-\theta)H + \eta(1 -\lambda)C,\\
\end{align*}
$$

### SEARCHID
The SEARCHID model describes the Omicron dynamics in Newfoundland and Labrador (NL) during the COVID-19 pandemic and stratifies the population of NL into three cohorts (1, 2 and 3), namely; unvaccinated/single dose vaccinated individuals, double-dose individuals and those with a third booster shots. With the assumption that the population, $N$, is fixed and only asymptomatics (A) and symptomatics (I) could spread the virus as at the period considered due to improved regulations and population immunity, the model is described as follows:

Cohort 1 - Unvaccinated or individuals with single dose:

$$
\begin{align*}
    \frac{dS_{1}}{dt} &= -k_{1}\beta_{i} S_{1}\frac{(\tau I + \zeta A)}{N} - v_{2}S_{1},\\
    \frac{dE_{1}}{dt} &= k_{1}\beta_{i} S_{1}\frac{(\tau I + \zeta A)}{N} - \sigma E_{1},\\
    \frac{dA_{1}}{dt} &= \sigma \mu E_{1} - \gamma A_{1},\\
    \frac{dI_{1}}{dt} &= \sigma(1-\mu)E_{1} - \phi_{1} I_{1},\\
    \frac{dH_{1}}{dt} &= \phi_{1}\xi_{1} I_{1} - \omega_{1} H1_{t},\\
    \frac{dC_{1}}{dt} &= \omega_{1}\theta_{1} H_{1} - \eta_{1} C_{1},\\
    \frac{dR_{1}}{dt} &= \gamma A_{1} + \phi_{1}(1-\xi_{1})I_{1} + \omega_{1}(1-\theta_{1})H_{1} + \eta_{1}(1 -\lambda_{1})C_{1},\\
    \frac{dD_{1}}{dt} &= \eta_{1}\lambda_{1}C_{1}.\\
\end{align*}
$$

Cohort 2 - Double-dose vaccinated individuals:

$$
\begin{align*}
    \frac{dV_{2}}{dt} &= -k_{2}\beta_{i} V_{2}\frac{(\tau I + \zeta A)}{N} + v_{2}S_{1} - v_{3}V_{2},\\
    \frac{dE_{2}}{dt} &= k_{2}\beta_{i} V_{2}\frac{(\tau I + \zeta A)}{N} - \sigma E_{2},\\
    \frac{dA_{2}}{dt} &= \sigma \mu E_{2} - \gamma A_{2},\\
    \frac{dI_{2}}{dt} &= \sigma(1-\mu)E_{2} - \phi_{2} I_{2},\\
    \frac{dH_{2}}{dt} &= \phi_{2}\xi_{2} I_{2} - \omega_{2} H_{2},\\
    \frac{dC_{2}}{dt} &= \omega_{2}\theta_{2} H_{2} - \eta_{2} C_{2},\\
    \frac{dR_{2}}{dt} &= \gamma A_{2} + \phi_{2}(1-\xi_{2})I_{2} + \omega_{2}(1-\theta_{2})H_{2} + \eta_{2}(1 -\lambda_{2})C_{2},\\
    \frac{dD_{2}}{dt} &= \eta_{2}\lambda_{2}C_{2}.\\
\end{align*}
 $$

Cohort 3 - Vaccinated individuals with double-dose plus booster shots:

$$
\begin{align*}
    \frac{dV_{3}}{dt} &= -k_{3}\beta_{i} V_{3}\frac{(\tau I + \zeta A)}{N} + v_{3}V_{2},\\
    \frac{dE_{3}}{dt} &= k_{3}\beta_{i} V_{3}\frac{(\tau I + \zeta A)}{N} - \sigma E_{3},\\
    \frac{dA_{3}}{dt} &= \sigma \mu E_{3} - \gamma A_{3},\\
    \frac{dI_{3}}{dt} &= \sigma(1-\mu)E_{3} - \phi_{3} I_{3},\\
    \frac{dH_{3}}{dt} &= \phi_{3}\xi_{2} I_{3} - \omega_{3} H_{3},\\
    \frac{dC_{3}}{dt} &= \omega_{3}\theta_{3} H_{3} - \eta_{3} C_{3},\\
    \frac{dR_{3}}{dt} &= \gamma A_{3} + \phi_{3}(1-\xi_{3})I_{3} + \omega_{3}(1-\theta_{3})H_{3} + \eta_{3}(1 -\lambda_{3})C_{3},\\
    \frac{dD_{3}}{dt} &= \eta_{3}\lambda_{3}C_{3}.\\
    \end{align*}
 $$

| variable         | description                        |
| ---------------- | ---------------------------------- |
| S1,V2, V3        | Number of susceptible individuals  |
| E1, E2, E3       | Number of exposed individuals      |
| A1, A2, A3       | Number of asymptomatic individuals |
| R1, R2, R3       | Number of recovered individuals    |
| C1, C2, C3       | Number of ICU admitted individuals |
| H1, H2, H3       | Number of hospitalized individuals |
| I1, I2, I3       | Number of infectious individuals   |
| D1, D2, D3       | Number of dead individuals         |

The size of the total population is,  $N = S1 +V2 + V3 + E_{1,2,3} + A_{1,2,3}  + R_{1,2,3} + C_{1,2,3} + H_{1,2,3} + I_{1,2,3} + D_{1,2,3}$, and the disease spreads through homogeneous mixing of the population.

# Parameters


| Parameter         | Description                                                                                         |
| ---------------- | --------------------------------------------------------------------------------------------------- |
| $\sigma$ | latent rate |
|$\beta_{1}$| transmission coefficient associated with each alert level 1 |
|$\beta_{2}$ | transmission coefficient associated with each alert level 2 |
|$\beta_{3}$ | transmission coefficient associated with each alert level 3 |
|$\beta_{4}$| transmission coefficient associated with each alert level 4 |
|$\mu$ |fraction of exposed who are asymptomatics |
|$\gamma$ | recovery rate for symptomatic individuals who are not isolated |
|$v_{2}$| proportion of $S_{1}$ who transition to $V_{2}$ after taking second vaccine dose|
|$v_{3}$ |proportion of $V_{2}$  who transition to $V_{3}$ after taking booster vaccine shots |
| $\kappa_{1}$ | multiplicative reduction in transmission rate due to single vaccine dose |
|$\kappa_{2}$ | multiplicative reduction in transmission rate due to double vaccine doses |
| $\kappa_{3}$ | multiplicative reduction in transmission rate due to booster vaccine shots |
|$\omega_{1}$ |  mean number of days spent in hospitalization for single dose or unvaccinated individuals |
|$\omega_{2}$ |  mean number of days spent in hospitalization for individuals with double dose |
|$\omega_{3}$ |  mean number of days spent in hospitalization individuals with booster shots |
|$\zeta$ |reduced infectiousness of asymptomatic cases  |
| $\tau$ |reduced infectiousness of symptomatic cases |
| $\eta_{1}$ | mean number of days spent in ICU for single dose or unvaccinated individuals |
|$\eta_{2}$ | mean number of days spent in ICU for individuals with double dose |
| $\eta_{3}$ | mean number of days spent in ICU for individuals with booster shots |
|$\phi_{1}$ | mean number of days in compartment $I_{1}$ for single dose or unvaccinated individuals |
|$\phi_{2}$ | mean number of days in compartment $I_{2}$ for individuals with double dose |
| $\phi_{3}$ | mean number of days in compartment $I_{3}$ for individuals with booster shots |
| $\lambda_{1}$ | proportion of ICU patients who die unvaccinated |
| $\lambda_{2}$ | proportion of ICU patients who die with double dose |
| $\lambda_{3}$ | proportion of ICU patients who die with booster shots |
|$\xi_{1}$ | proportion of symptomatic who are hospitalized unvaccinated |
|$\xi_{2}$ | proportion of symptomatic who are hospitalized with double dose |
|$\xi_{3}$ | proportion of symptomatic who are hospitalized with booster shots |
|$\theta_{1}$ | proportion of hospitalized who go into ICU unvaccinated |
|$\theta_{2}$ | proportion of hospitalized who go into ICU with double dose |
|$\theta_{3}$ | proportion of hospitalized who go into ICU with booster shots |

## About the datasets
The seroprevalence estimates used in this repository are publicly available and can be obtained from the [COVID-19 Immunity Task Force (CITF)](https://www.covid19immunitytaskforce.ca/seroprevalence-in-canada/) website. Its relevant CSV format is included in here for reproducibility purposes.

For the number of Newfoundland & Labrador COVID-19 (Omicron) daily reported cases, hospital occupancy and deaths, we obtained data from then Newfoundland and Labrador Centre for Health Information(NLCHI), now [Newfoundland and Labrador Health Services - Digital Health](https://nlhealthservices.ca/), under the Health Research Ethics Board reference number 2021.013.

For the parameterization of the vaccination rate across cohorts, we used the Government of Canada's publicly available data: [COVID-19 vaccination: Vaccination coverage](https://health-infobase.canada.ca/covid-19/vaccination-coverage/).

## Model Implemetation in macpan2

<img src= "https://github.com/francisanokye/SEARCH-ID-MODEL/blob/main/searchid/macpan2/figures/disease_sates_init.png">

Even though our initial attempts lack convergence of the optimizer to obtain optimal parameter estimates, the trajectory from the model fit is visually reasonable as shown below and still undergoing modifications to resolve any identifiability issues.
<img src= "https://github.com/francisanokye/SEARCH-ID-MODEL/blob/main/searchid/macpan2/figures/model_fit.png">

