#!/bin/bash

# Prompt for file locations
read -p 'Enter full path to tls.crt file: ' tls_crt_path
read -p 'Enter full path to tls.key file: ' tls_key_path
read -p 'Enter full path to ca.crt file: ' ca_crt_path
read -p 'Enter Kubernetes namespace [default]: ' k8s_namespace

# Set default namespace if not provided
k8s_namespace=${k8s_namespace:-default}

# Determine OS and set base64 wrap option
wrap_option="-w 0"
if [[ "$OSTYPE" == "darwin"* ]]; then
  wrap_option="-b 0"
fi

# Base64 encode the certificate, key, and CA
tls_crt=$(base64 $wrap_option "$tls_crt_path")
tls_key=$(base64 $wrap_option "$tls_key_path")
ca_crt=$(base64 $wrap_option "$ca_crt_path")

# Generate the YAML content
cat <<EOF >  test2-tls-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: test2-tls-secret
  namespace: $k8s_namespace
type: kubernetes.io/tls
data:
  tls.crt: $tls_crt
  tls.key: $tls_key
  ca.crt: $ca_crt
EOF

echo "Secret YAML file 'test2-tls-secret.yaml' has been created."

