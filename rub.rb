#!/usr/bin/env ruby1.9

require 'lib/stupid'

p Stupid::Route.recognize('test/123')

Stupid::Application.run