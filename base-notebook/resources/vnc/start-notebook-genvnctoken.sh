# Generate token for VNC Server. VNC Server uses password of 8 char max. 
export NOVNC_TOKEN=$(echo $(cat /proc/sys/kernel/random/uuid) | cut -c 1-8)

# Delete password of the last session
rm -f $HOME/.vnc/passwd

# Creating the $HOME/.vnc directory if required for vncpasswd to work properly
mkdir -p $HOME/.vnc

# Setting the token as the password for the vnc server
echo $NOVNC_TOKEN | vncpasswd -f > $HOME/.vnc/passwd
chmod 0600 $HOME/.vnc/passwd
