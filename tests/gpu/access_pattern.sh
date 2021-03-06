#!/bin/bash

blacklist="examples/boolean_geometry.py examples/ldc_2d_unorm.py"
tmpdir=$(mktemp -d)

find examples -perm +0111 -name '*.py' | while read filename ; do
	if [[ ${blacklist/${filename}/} == ${blacklist} ]]; then
		echo -n "Testing ${filename}..."
		python $filename --max_iters=50 --access_pattern=AB --every=50 --seed=1234 --quiet --output=${tmpdir}/result_ab
		python $filename --max_iters=50 --access_pattern=AA --every=50 --seed=1234 --quiet --output=${tmpdir}/result_aa

		if utils/compare_results.py ${tmpdir}/result_ab.0.50.npz ${tmpdir}/result_aa.0.50.npz ; then
			echo "ok"
		else
			echo "failed"
			echo "Data in ${tmpdir}"
			exit 1
		fi
	fi
done

rm ${tmpdir}/result*
rmdir ${tmpdir}
