# Project Overview

This project consists of two Ruby scripts that work together to read data from a specific URL, process it, and append it to a CSV file.

*   `amis_reader_reader.rb`: This script contains the core logic for fetching JSON data from `http://10.0.0.99/rest`, transforming it, and writing it to a date-stamped CSV file (e.g., `amis_reader_2025-09-21.csv`).
*   `amis_reader_scheduler.rb`: This script uses the `rufus-scheduler` gem to execute the `AmisReaderReader` script every second.

The data being read appears to be related to energy consumption, with fields for "Bezogen" (received) and "Eingespeist" (fed in).

# Building and Running

**Dependencies:**

*   Ruby
*   `rufus-scheduler` gem

**To install dependencies:**

```bash
gem install rufus-scheduler
```

**To run the scheduler:**

```bash
ruby amis_reader_scheduler.rb
```

This will start the process of reading data every second and writing it to the corresponding CSV file.

# Development Conventions

*   The code is written in an object-oriented style.
*   The `AmisReaderReader` class encapsulates the data reading and processing logic.
*   The `AmisReaderScheduler` script is responsible for scheduling the execution of the `AmisReaderReader`.
*   Error handling is included for network requests and file I/O.
