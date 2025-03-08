#!/bin/bash
cd ~/scenario || exit 1

tofu state ls | grep "kubernetes_pod_v1.workload"
if [ $? -ne 0 ]; then
    exit 1
fi
