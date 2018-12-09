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
   * Add the countries you'd like to track concerts for
   * Add "filter" countries you'd like to use to make sure cities are in the right country (i.e. a value of UK would then filter out cities from other countries with the same name -  Birmingham, USA vs Birmingham, UK)
   * Add your listening thresholds (for each time period, the number indicates the minimum required listens to track the artist)
 * You also need to add your mail server details in this [file](https://github.com/RyanMKrol/ConcertFinder/blob/master/Sources/ConcertFinderLib/EmailConfig.json):
   * You can add an application password for gmail accounts [here](https://myaccount.google.com/apppasswords)
   * Then just add the email address for the account you want to use
 * Update the locations for the config files you're using [here](https://github.com/RyanMKrol/ConcertFinder/blob/master/Sources/ConcertFinderLib/Utils/ConfigLoader.swift#L18)
 * Run `swift build`
 * You should be able to find the executable in `ConcertFinder/.build/debug/ConcertFinder`
 * Setup a cron job to run this whenever you like
 * Done!
