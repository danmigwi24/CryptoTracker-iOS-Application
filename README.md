
// README.md - Project Documentation
/*
# Crypto Tracker App

CryptoTracker is an iOS application that displays information about the top 100 cryptocurrencies using the CoinRanking API. The app features pagination, filtering options, detailed coin views with performance charts, and the ability to favorite coins for quick access.


## Features

- Display top 100 cryptocurrencies with ranking, price, and 24-hour change
- Sort coins by rank, price, or 24-hour change
- View detailed information for each coin including a price chart
- Add/remove coins to favorites
- Search for specific coins

## Architecture

The app follows a hybrid approach using both UIKit and SwiftUI:
- UIKit for main navigation and main view
- SwiftUI for dammler and detail views
- Combine for reactive programming and state management

## Technical Implementation
- Implemented API service layer for network requests
- Used SPM (Swift Package Manager) for dependency management
- Pagination implementation for efficient data loading
- Custom UI components for the collection/table views
- Chart visualization for performance data (SWIFTUI CHARTS)


## Project Structure

- **Models**: Data structures for API responses and application data
- **Services**: API communication and data management
- **ViewControllers**: UIKit controllers for main screens
- **Views**: UIKit custom views and cells
- **SwiftUI**: SwiftUI components and views


## Setup

1. Clone the repository
2. Open the project in Xcode
3. Set up configInfo.plist file for the purpuse of adding BASE URL AND APIKEY
4. Build and run the application

# Replace the API key 

To use this application, you need to create a configuration file named `configInfo.plist` and include it in your project.

### Creating the configInfo.plist file

1. In Xcode, right-click on your project navigator
2. Select **New File...**
3. Choose **Property List** under the Resource section
4. Name the file `configInfo.plist`
5. Click **Create**
6. Create the plist file structure as shown above
7. Add your CoinRanking API key to each environment
8. Ensure only one environment has its `active` property set to `YES`
9. Set the appropriate `base-path` for each environment

### Required Configuration Structure

Your `configInfo.plist` should contain the following structure:

```
Information Property List (Dictionary)
├── enableLogs (Boolean) - NO
└── environments (Array)
    ├── Item 0 (Dictionary)
    │   ├── apiKey (String) - "YOUR_API_KEY"
    │   ├── type (String) - "DEV"
    │   ├── active (Boolean) - YES
    │   ├── base-path (String) - "https://api.coinranking.com/v2"
    │   ├── name (String) - "Development"
    │   └── early-build (Boolean) - NO
    └── Item 1 (Dictionary)
        ├── apiKey (String) - "YOUR_API_KEY"
        ├── active (Boolean) - NO
        ├── base-path (String) - "https://api.coinranking.com/v2"
        ├── type (String) - "UAT"
        ├── name (String) - "Staging"
        └── early-build (Boolean) - NO
```

### Key Configuration Elements

1. **API Key**: Each environment requires an API key from CoinRanking:
   - Example: `YOUR_API_KEY`

2. **Base URLs**: The application uses the CoinRanking API with the base URL:
   - `https://api.coinranking.com/v2`

3. **Logging**: You can enable or disable application logs by setting:
   - `enableLogs` to `YES` or `NO`

### Environment Configuration

The app supports multiple environments:
- **Development (DEV)**: Used for local development
- **Staging (UAT)**: Used for testing before production

Set the appropriate environment as active by setting its `active` value to `YES`. Only one environment should be active at a time.

### Required Properties for Each Environment

Each environment requires the following properties:
- `apiKey`: Your CoinRanking API key
- `type`: Environment type (e.g., "DEV", "UAT")
- `active`: Boolean indicating if this environment is active
- `base-path`: API base URL
- `name`: Human-readable environment name
- `early-build`: Set to YES for pre-release builds

### Challenges and Solutions

Chart Implementation Challenge: Implementing responsive and visually appealing performance charts was challenging
Solution: Used the Charts library to create customized charts that display performance data accurately
Handled different data formats and timeframes to ensure consistent visualization


Pagination Implementation: Ensuring smooth loading of additional cryptocurrency data while scrolling
Solution: Implemented efficient pagination that pre-loads the next batch of data before the user reaches the end of the current list



## Troubleshooting

If you encounter issues with API connectivity:
1. Verify your API key is valid
2. Ensure the correct environment is set as active
3. Check that the base URL is correctly formatted

## Note to Developers

Keep your API keys secure. Never commit these values directly to your version control system.

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## Dependencies

- None (uses built-in frameworks only)

## API

This app uses the [Coinranking API](https://coinranking.com/page/cryptocurrency-api) to fetch cryptocurrency data.

