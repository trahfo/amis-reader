# AMIS Reader

This project provides a set of Ruby scripts to read data from an AMIS (Advanced Metering Infrastructure System) smart meter, process it, and store it in CSV files.

## How it Works

The project consists of two main components:

*   `amis_reader_reader.rb`: A script that fetches JSON data from a smart meter at a specified URL (`http://10.0.0.99/rest` by default). It then transforms the data and appends it to a daily CSV file (e.g., `amis_reader_2025-09-21.csv`).
*   `amis_reader_scheduler.rb`: A script that uses the `rufus-scheduler` gem to run the `amis_reader_reader.rb` script at a regular interval (every second by default).

## Requirements

*   Ruby
*   Bundler

## Installation

1.  Clone the repository:

    ```bash
    git clone https://github.com/your-username/amis-reader.git
    cd amis-reader
    ```

2.  Install the required gems using Bundler:

    ```bash
    bundle install
    ```

## Usage

To start the data collection process, run the scheduler:

```bash
bundle exec ruby amis_reader_scheduler.rb
```

This will start a background process that reads data from the smart meter every second and saves it to a new CSV file each day.

## Testing

To run the RSpec tests, use the following command:

```bash
bundle exec rspec
```

## Configuration

The URL of the smart meter can be configured by changing the `URL` constant in the `amis_reader_reader.rb` file.
