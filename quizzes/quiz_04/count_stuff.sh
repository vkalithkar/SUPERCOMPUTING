#!/bin/bash
set -ueo pipefail

ls -A $1 | wc -l
