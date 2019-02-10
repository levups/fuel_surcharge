#!/bin/bash

build() {
  bundle install
  rake build
}

rake should_we_release_a_new_version && build
