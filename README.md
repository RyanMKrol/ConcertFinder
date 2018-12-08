# ConcertFinder

## Overview

A tool to keep you updated with concerts from artists you regularly listen to.

## How to Use
 * Clone the package locally
 * Via the CLI, run the following commands:
   * `swift package update`
   * `swift package -Xlinker -L/usr/local/lib generate-xcodeproj`
 * Make the following changes to this [file](https://github.com/RyanMKrol/ConcertFinder/blob/master/Sources/ConcertFinderLib/Config.json):
   * Add your username
   * Add the cities you'd like to track concerts for
   * Add the country you'd like to track concerts for (i.e. a value of UK would then filter out cities from other countries with the same name -  Birmingham, USA vs Birmingham, UK)
   * Add your listening thresholds (for each time period, the number indicates the minimum required listens to track the artist)
 * Open the XCode project you generated earlier, and Run!
 * Find your concerts in the output
