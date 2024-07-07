#!/usr/bin/env nextflow
// hash:sha256:fc8f0b327105070a13e31a11d5a94f017cd899f7aced71e24b9f490761ab12a6

nextflow.enable.dsl = 1

combined_data_test_list = new File('combined-data/combined_data_test.txt').readLines() // id: ee396f80-d901-4005-9812-22d9404717ce

combined_data_test_to_copy_of_multiqc_1 = channel.fromPath(combined_data_test_list)

// capsule - Copy of MultiQC
process capsule_copy_of_multi_qc_1 {
	tag 'capsule-7796909'
	container "registry.apps-edge.acmecorp.codeocean.dev/published/7ebd494e-8b51-4bd0-ba2b-92f43bcaa84e:v1"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data' from combined_data_test_to_copy_of_multiqc_1

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=7ebd494e-8b51-4bd0-ba2b-92f43bcaa84e
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v1.0 "https://apps-edge.acmecorp.codeocean.dev/capsule-7796909.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_copy_of_multi_qc_1_args}

	echo "[${task.tag}] completed!"
	"""
}
