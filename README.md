# HuginnAsanaAgent

[![Build Status](https://travis-ci.com/akshayas/huginn_asana_agent.svg?token=CHtFMrvvbzYwu91xZnbc&branch=master)](https://travis-ci.com/akshayas/huginn_asana_agent) [![Gem Version](https://badge.fury.io/rb/huginn_asana_agent.svg)](https://badge.fury.io/rb/huginn_asana_agent)

This is Huginn Asana Agent. This repository is a collection of agents to do operations on Asans using Huginn.

## Installation

Add this string to your Huginn's .env ADDITIONAL_GEMS configuration:

    huginn_asana_agent
And then execute:

    bundle

## Development

Run `bundle` to install all dependencies

### .env configuration
Create a .env file at the root of the repository using the [example](https://github.com/huginn/huginn/blob/master/.env.example) config from huginn. Make sure to add any missing dependencies in ADDITIONAL_GEMS.

### Testing
Then, run `rake spec` to run the tests. This will download a copy of huginn into `spec/` directory and run your test against Huginn dependencies. If download and setup of Huginn fails, you will have to reconfigure your `.env` file, delete `spec/huginn` before running `rake spec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akshayas/huginn_asana_agent. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
