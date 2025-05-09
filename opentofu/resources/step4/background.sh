#!/bin/bash
cat <<EOF > ~/scenario/locals.tf
locals {
  replicas = 3
}
EOF
