# AMIS Reader

This project provides a set of Ruby scripts to read data from a local installation of the IoT device "Amis Leser" (AMIS Lesekopf), an open-source, cloud-free IR reader for NetzOÖ Smartmeter Siemens TD-3511/TD-3512. The Amis Leser device is described in detail at [https://www.mitterbaur.at/amis-leser.html](https://www.mitterbaur.at/amis-leser.html).

The scripts fetch data from the Amis Leser REST API, process it, and store it in CSV files. It creates a new CSV file with headers for each day, appending new data as it is read.

## How it Works

The project consists of two main components:

*   `src/amis_reader.rb`: A script that fetches JSON data from a local Amis Leser device at a specified URL (`http://10.0.0.99/rest` by default). It then transforms the data and appends it to a daily CSV file (e.g., `amis_reader_2025-09-21.csv`).
*   `src/amis_scheduler.rb`: A script that uses the `rufus-scheduler` gem to run the `amis_reader.rb` script at a regular interval (every second by default).

**Note:** The Amis Reader is specifically designed to work with the REST API provided by the Amis Leser (AMIS Lesekopf) IoT device. For more information about the hardware and its capabilities, see the [official Amis Leser project page](https://www.mitterbaur.at/amis-leser.html).

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
bundle exec ruby src/amis_scheduler.rb
```

This will start a background process that reads data from the smart meter every second and saves it to a new CSV file each day.

## Testing

To run the RSpec tests, use the following command:

```bash
bundle exec rspec
```

## Configuration

The URL of the smart meter can be configured by changing the `URL` constant in the `src/amis_reader.rb` file.
