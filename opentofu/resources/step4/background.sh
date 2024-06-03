#!/bin/bash
cat <<EOF > ~/scenario/locals.tf
locals {
  replicas = 3
  for_replicas = { for i in range(0, local.replicas) : i => i }
}
EOF