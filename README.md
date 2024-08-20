# Time Series Forecasting for Antarctic Sea Ice Using SARIMA and Holt-Winters Methods

## Introduction
The ongoing impacts of climate change are dramatically altering polar ice coverage, with significant implications for global ecosystems. While the decline of Arctic sea ice has been well-documented, trends in Antarctic sea ice have been less clear, showing variability rather than a straightforward decline. This project aims to address this gap by forecasting Antarctic sea ice coverage using time series data and applying advanced statistical models to predict future trends. Utilizing R packages such as `tseries` for stationarity testing, `forecast` for time series modeling, and `TSA` for time series analysis, this project provides a comprehensive examination of the pandemic's true mortality toll. <br />

## Purpose
The primary goal of this project is to forecast Antarctic sea ice coverage for the years 2024 and 2025 using two distinct time series forecasting methods: Seasonal ARIMA (SARIMA) and Holt-Winters. By comparing the performance of these models, this project seeks to provide insights into the expected trends in Antarctic sea ice and contribute to broader understanding of polar climate dynamics. <br />

## Significance
Antarctic sea ice plays a critical role in regulating the Earth's climate, influencing ocean currents, and providing a habitat for a wide array of species. Accurate forecasting of sea ice coverage is essential for understanding the future impacts of climate change on these ecosystems and informing global climate policy. This project is significant as it not only forecasts sea ice coverage but also critically evaluates the models used, highlighting potential limitations and areas for further research. <br />

## Project Overview
### Data Source:
The dataset used in this project is the "Monthly Southern Hemisphere Sea Ice Area" from the National Snow and Ice Data Center (NSIDC), covering the period from 1989 to 2023. <br />

### Methodology:
Two forecasting methods were employed: <br />
1. Seasonal ARIMA (SARIMA): A statistical model that incorporates both autoregressive and moving average components, adjusted for seasonality. <br />
2. Holt-Winters: A triple exponential smoothing method that accounts for level, trend, and seasonality in the time series data. <br />

### Model Selection:
The SARIMA model was selected based on inspection of autocorrelation and partial autocorrelation plots, with model comparison via the Akaike Information Criterion corrected (AICc). The Holt-Winters model was chosen for its simplicity and effectiveness in dealing with seasonal data. <br />

## Findings and Conclusions
### Forecast Accuracy:
When comparing the two models, the Holt-Winters method outperformed SARIMA across multiple error metrics, including RMSE, MAE, and MAPE, suggesting it is the more reliable method for this particular dataset. <br />

### Forecast Results: 
Both models indicate an accelerating decline in Antarctic sea ice over the next two years. However, some forecast intervals included impractical negative values, highlighting the limitations of these models in dealing with a zero lower bound. <br />

### Future Directions: 
Future work could explore the impact of global climate phenomena such as El Niño and La Niña on Antarctic sea ice, and investigate more sophisticated models that can better handle the physical constraints of sea ice data. <br />

## References
This project was conducted using data from the National Snow and Ice Data Center (NSIDC) and utilized R for data analysis and model implementation. Further details, including code and data visualizations, can be found within this repository.





