echo "Installing scenario..."
while [ ! -f /tmp/finished ]; do sleep 2; done
echo "Ready to Play!"

# Apply Harbor Configuration
cd /root/.assets/config
export TF_VAR_keycloak_url=$(sed 's/PORT/30080/g' /etc/killercoda/host)
tofu init && tofu apply -auto-approve
