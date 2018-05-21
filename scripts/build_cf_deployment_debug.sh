#!/usr/bin/env bash
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     snap install yq;;
    Darwin*)    brew install yq;;
    # CYGWIN*)    machine=Cygwin;;
    # MINGW*)     machine=MinGw;;
    # *)          machine="UNKNOWN:${unameOut}"
esac


mkdir -p temp_build_dir

bosh interpolate ../manifests/cf-deployment.yml -o ../manifests/aci.yml > ./temp_build_dir/cf-deployment.yml
# combine jobs into one yml file.
yq r ./temp_build_dir/cf-deployment.yml instance_groups.*.jobs > ./temp_build_dir/jobs.yml
sed -i "" "s/- -/  -/g"  ./temp_build_dir/jobs.yml
sed -i "" "s/^ //"  ./temp_build_dir/jobs.yml

# combine vm_extensions into one yml file.
yq r ./temp_build_dir/cf-deployment.yml instance_groups.*.vm_extensions > ./temp_build_dir/vm_extensions.yml
sed -i "" "/- null/d"  ./temp_build_dir/vm_extensions.yml
sed -i "" "s/- -/  -/g"  ./temp_build_dir/vm_extensions.yml
sed -i "" "s/^ //"  ./temp_build_dir/vm_extensions.yml

# remove the instance_groups and append the slices cut down.

yq d ./temp_build_dir/cf-deployment.yml instance_groups.* > ./temp_build_dir/cf-deployment-all-in-one.yml
jobs=$(cat ./temp_build_dir/jobs.yml)
vm_extensions=$(cat ./temp_build_dir/vm_extensions.yml)
yq w -i ./temp_build_dir/cf-deployment-all-in-one.yml instance_groups.jobs "$jobs"
# //yq w sample.yaml b.d[0] "new thing"