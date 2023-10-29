# Anti-Fraud Application

## Proposal
The proposal of this application is to solve the test presented by CloudWalk for the Software Engineer position. In addition to the technical test, two more challenges were proposed: the first, where it was necessary to answer a series of questions, and the second, to analyze previously available data, which would be important for the development of the third challenge (technical test).
[Document with the first two challenges.](https://docs.google.com/document/d/1bmUV6HlEelHSwnbymiNOu_LiTx8VW0vHE4DP1k8R3x0/edit?usp=sharing)

## Overview
The "anti-fraud" application is a Ruby on Rails solution designed for detecting and preventing fraud in transactions. It utilizes various services and parameters to assess transactions and determine their fraudulent nature.

## Key Components

### Fraud Detection Service
- **File:** [`app/services/fraud_detector_service.rb`](https://github.com/glaucomorandini/anti-fraud/blob/main/app/services/fraud_detector_service.rb)
- **Purpose:** Evaluates transaction fraudulence.
- **Criteria:** Device ID presence, previous uncontested frauds, and additional assessments using other services.

### Fraud Scoring Service
- **File:** [`app/services/fraud_score_service.rb`](https://github.com/glaucomorandini/anti-fraud/blob/main/app/services/fraud_score_service.rb)
- **Purpose:** Calculates a fraud score.
- **Scoring Rules:** Transaction amount, time, frequency, chargeback history, device ID absence, and device usage duration.

### Blocklist Service
- **File:** [`app/services/block_list_service.rb`](https://github.com/glaucomorandini/anti-fraud/blob/main/app/services/block_list_service.rb)
- **Purpose:** Identifies high-risk entities.
- **Criteria:** Chargeback rates per merchant, device, user, and card number.

## Summary
The application analyzes financial transactions to identify and prevent fraudulent activities, using a comprehensive set of rules and services.

## Technology Versions

- **Ruby:** 3.2.1
- **Rails:** 7.1.1
- **PostgreSQL:** 15

## Application Setup

### Dependencies

- [Docker](https://www.docker.com/): Required for containerization and environment consistency.

### Environment Configuration

To set up the environment, use the following Docker commands:

- Build the web service: `docker-compose build web`
- Create, migrate, and seed the database: `docker-compose run --rm web rails db:create db:migrate db:seed`

### Running the Environment

To start the application, run:

`docker-compose up web`

The service will be available at [http://localhost:3000](http://localhost:3000).

### Executing Tests

To run the test suite, use the command:

- `docker-compose run --rm web rspec`

This will execute the application's test cases to ensure functionality and stability.
