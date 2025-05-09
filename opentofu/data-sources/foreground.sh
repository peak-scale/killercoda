echo "Installing scenario..."
while [ ! -f /tmp/finished ]; do sleep 2; done
cd ~/scenario
tofu init && tofu apply -auto-approve
