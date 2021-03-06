#!/usr/bin/env bash
#
# gen-test-targets will generate units tests under tests/ for all directories that
# have a kustomization.yaml. This script first finds all directories and then calls
# gen-test-target to generate each golang unit test.
# The script is based on kusttestharness_test.go from kubernetes-sigs/pkg/kusttest/kusttestharness.go
#
if [[ $(basename $PWD) != "manifests" ]]; then
  echo "must be at manifests root directory to run $0"
  exit 1
fi

source hack/utils.sh
rm -f $(ls tests/*_test.go | grep -v kusttestharness_test.go)
for i in $(find * -type d -exec sh -c '(ls -p "{}"|grep />/dev/null)||echo "{}"' \; | egrep -v 'docs|tests|hack'); do
  rootdir=$(pwd)
  absdir=$rootdir/$i
  testname=$(get-target-name $absdir)_test.go
  echo generating $testname from $absdir
  ./hack/gen-test-target.sh $absdir > tests/$testname
done
