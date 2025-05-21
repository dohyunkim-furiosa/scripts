if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <SHA> <TESTNAME> <TARGET>"
    exit 1
fi

SHA="$1"
TESTNAME="$2"
TARGET="$3"



mkdir -p temp_test
test_vector_metadata=temp_test/$TESTNAME.yaml

az storage blob download --container-name furiosa-jenkins --name artifacts/$SHA/bin/npu_runtime_test --file temp_test/npu_runtime_test --account-name blobsforci --only-show-errors --output none
az storage blob download --container-name furiosa-jenkins --name rngd-ci/edf/$(echo $SHA | cut -c1-10)/$TARGET/$TESTNAME.edf.zst --file temp_test/$TESTNAME.edf.zst --account-name blobsforci --only-show-errors --output none
az storage blob download --container-name furiosa-jenkins --name rngd-ci/test_vector/$(echo $SHA | cut -c1-10)/$TESTNAME.yaml --file $test_vector_metadata --account-name blobsforci --only-show-errors --output none
az storage blob download --container-name furiosa-jenkins --name rngd-ci/test_vector/$(echo $SHA | cut -c1-10)/rngd_ci_model_tolerance.yaml --file temp_test/rngd_ci_model_tolerance.yaml --account-name blobsforci --only-show-errors --output none

input_vectors=$(awk '
  /^input_test_vector_names:/ {found=1; next}
  found && !/^- / {exit}
  found && /^- / {print $2}
' "$test_vector_metadata")

output_vectors=$(awk '
  /^output_test_vector_names:/ {found=1; next}
  found && !/^- / {exit}
  found && /^- / {print $2}
' "$test_vector_metadata")

combined_vectors=$(echo -e "$input_vectors
$output_vectors" | sort -u)

test_vector_list=($(echo "$combined_vectors"))

for test_vector in "${test_vector_list[@]}"
do
  (
    dest_dir=$(dirname "$test_vector")
    mkdir -p "$dest_dir"
    az storage blob download --container-name furiosa-dvc-private --name rngd-ci/test-vector/$test_vector.zst --file temp_test/$test_vector.zst --account-name blobsforci --only-show-errors --output none
  ) &
done

wait

mapfile -t VALUES < <(
  awk -v key="$TESTNAME" '
    $0 == key ":" { found=1; next }
    found && /^- / {
      print substr($0, 3)
      if (++n == 2) exit
    }
    found && !/^-/ { exit }
  ' "temp_test/rngd_ci_model_tolerance.yaml"
)

if [ "${#VALUES[@]}" -eq 2 ]; then
    ABS_TOLERANCE="${VALUES[0]}"
    REL_TOLERANCE="${VALUES[1]}"
else
    ABS_TOLERANCE="$DEFAULT_ABS_TOLERANCE"
    REL_TOLERANCE="$DEFAULT_REL_TOLERANCE"
fi
chmod +x temp_test/npu_runtime_test
yes | zstd -d temp_test/*.zst
