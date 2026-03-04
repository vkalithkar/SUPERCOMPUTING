#!/bin/bash
set -euo pipefail

# Run the download and data prep script
bash ./scripts/01_download_data.sh

# For each raw data file, loop through and run second script
for FILE in ./data/raw/*_R1_*
	do echo "Processing $FILE"
	bash ./scripts/02_run_fastp.sh "$FILE"
	done

echo "Complete!"
