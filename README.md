# My Weather!

🌡️☁️SwiftUI IOS application. Shows current, 7 days daily and 4 days hourly forecasts. 

## Description

My Weather! is the IOS application where a user can watch the weather, temperature, and wind speed for up to 7 days. The app allows users to change their location to almost every city in the World! Or automatically locate their place by permitting the application to do that. 

In this application I've used SwiftUI for building User Interface, and MVVM design pattern to separate views from model and business logic, also it's more effective and simpler to use reactive MVVM paradigm with SwiftUI.

## Preview

![](https://github.com/SenKill/Weather/blob/120169d5bf6c793ad19caa7dd5e15bf32f864cd2/GifsAndPictures/WeatherPreview.gif)
![](https://github.com/SenKill/Weather/blob/120169d5bf6c793ad19caa7dd5e15bf32f864cd2/GifsAndPictures/WeatherDarkPreview.gif)

## Features

- Current location
- Location changer
- Unit of measurement changer
- Current weather
- Hourly forecast
- Daily forecast
- Localized to Russian
- Dark Theme

## Technologies and Instruments

- SwiftUI
- MVVM design pattern
- Combine
- CoreData
- CoreLocation
- UserDefaults
- [OpenWeatherMap API](https://openweathermap.org/api)

I've used Combine for better country and city searching. 
OpenWeatherMap for loading the weather data from their API, and CoreData for saving that data. Furthermore, if a user wish he can change the unit of measurement to imperial or metric, and this data will be stored using UserDefaults.
And if the user decides to see the weather for his current location, the app will determine the user's location using CoreLocation and load data for his locality.

## Previews of features

Units changing and russian localization...

![](https://github.com/SenKill/Weather/blob/120169d5bf6c793ad19caa7dd5e15bf32f864cd2/GifsAndPictures/UnitsChanging.gif)
<img src="https://github.com/SenKill/Weather/blob/120169d5bf6c793ad19caa7dd5e15bf32f864cd2/GifsAndPictures/RussianLocalization.png" width="360"/>
