# AWS cli
cd /opt 
curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
unzip -q awscliv2.zip 
./aws/install 
rm -rf /opt/aws /opt/awscliv2.zip 
pip install --quiet awscli-plugin-endpoint 
layer-cleanup.sh