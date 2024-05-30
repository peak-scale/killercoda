#!/bin/bash

mkdir ~/scenario/modules/service

# Create kubernetes.tf file
cat <<EOF > ~/scenario/modules/service/provider.tf

EOF

cat <<EOF > ~/scenario/modules/service/outputs.tf

EOF

cat <<EOF > ~/scenario/modules/service/variables.tf

EOF


cat <<EOF > ~/scenario/service.tf

EOF



# Apply configuration
tofu init && tofu plan && tofu apply -auto-approve
touch /tmp/setup-step1

