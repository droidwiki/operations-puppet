#!/bin/bash

puppet apply --modulepath modules manifests/site.pp --noop
