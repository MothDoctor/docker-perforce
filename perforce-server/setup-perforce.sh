#!/bin/bash
set -e
export NAME="${NAME:-p4depot}"
export P4ROOT="${DATAVOLUME}/${NAME}"
export UESRID="${UID}"
export GROUPID="${GID}"

if [ ! -d $DATAVOLUME/etc ]; then
 	usermod -u $UESRID perforce && groupmod -g $GROUPID perforce
    # find / -user 999 -exec chown -h perforce {} \;
    # find / -group 998 -exec chgrp -h perforce {} \;
    echo >&2 "First time installation, copying configuration from /etc/perforce to $DATAVOLUME/etc and relinking"
    mkdir -p $DATAVOLUME/etc
    cp -r /etc/perforce/* $DATAVOLUME/etc/
    FRESHINSTALL=1
fi

mv /etc/perforce /etc/perforce.orig
ln -s $DATAVOLUME/etc /etc/perforce

if [ -z "$P4PASSWD" ]; then
    P4PASSWD="pass12349ers!"
fi

# This is hardcoded in configure-helix-p4d.sh :(
P4SSLDIR="$P4ROOT/ssl"

for DIR in $P4ROOT $P4SSLDIR; do
    mkdir -m 0700 -p $DIR
    chown perforce:perforce $DIR
done

# server configuration 
# Usage: configure-helix-p4d.sh [service-name] [options]
# -n                   - Use the following flags in non-interactive mode
# -p <P4PORT>          - Perforce Server's address
# -r <P4ROOT>          - Perforce Server's root directory
# -u <username>        - Perforce super-user login name
# -P <password>        - Perforce super-user password
# --unicode            - Enable unicode mode on server
# --case               - Case-sensitivity (0=sensitive[default],1=insensitive)
# -h --help            - Display this help and exit

if ! p4dctl list 2>/dev/null | grep -q $NAME; then
    /opt/perforce/sbin/configure-helix-p4d.sh $NAME -n -p $P4PORT -r $P4ROOT -u $P4USER -P "${P4PASSWD}" --case 1
fi

p4dctl start -t p4d $NAME
if echo "$P4PORT" | grep -q '^ssl:'; then
    p4 trust -y
fi

cat > ~perforce/.p4config <<EOF
P4USER=$P4USER
P4PORT=$P4PORT
P4PASSWD=$P4PASSWD
EOF
chmod 0600 ~perforce/.p4config
chown perforce:perforce ~perforce/.p4config

p4 login <<EOF
$P4PASSWD
EOF

if [ "$FRESHINSTALL" = "1" ]; then
    ## Load up the default tables
    echo >&2 "First time installation, setting up defaults for p4 user, group and protect tables"
    p4 user -i < /root/p4-users.txt
    p4 group -i < /root/p4-groups.txt
    p4 protect -i < /root/p4-protect.txt

	# disable unauthorized viewing of Perforce user list
	p4 configure set run.users.authorize=1

	# p4 typemap
	(p4 typemap -o; echo " binary+l //....uasset") | p4 typemap -i
	(p4 typemap -o; echo " binary+l //....umap") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....3ds") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....abc") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....aiff") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....blend") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....bgeo") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....bmp") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....dae") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....dds") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....dxf") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....exr") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....fbx") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....flac") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....geo") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....gif") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....glb") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....gltf") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....hip") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....hipnc") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....hmv") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....jpg") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....jpeg") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....ma") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....mb") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....mp3") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....mp4") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....obj") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....ogg") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....pic") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....picnc") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....png") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....psb") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....psd") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....sbsar") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....skp") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....spp") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....tga") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....tif") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....tiff") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....usd") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....wav") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....wmv") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....vfl") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....zpr") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....ztl") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....exe") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....dll") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....lib") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....app") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....dylib") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....stub") | p4 typemap -i
	(p4 typemap -o; echo " binary+w //....ipa") | p4 typemap -i
	(p4 typemap -o; echo " binary+Sw //....pdb") | p4 typemap -i
	(p4 typemap -o; echo " text //....c") | p4 typemap -i
	(p4 typemap -o; echo " text //....config") | p4 typemap -i
	(p4 typemap -o; echo " text //....cpp") | p4 typemap -i
	(p4 typemap -o; echo " text //....cs") | p4 typemap -i
	(p4 typemap -o; echo " text //....h") | p4 typemap -i
	(p4 typemap -o; echo " text //....ini") | p4 typemap -i
	(p4 typemap -o; echo " text //....m") | p4 typemap -i
	(p4 typemap -o; echo " text //....mm") | p4 typemap -i
	(p4 typemap -o; echo " text //....py") | p4 typemap -i
	(p4 typemap -o; echo " text //....txt") | p4 typemap -i
	(p4 typemap -o; echo " text+w //....DotSettings") | p4 typemap -i
	(p4 typemap -o; echo " text+w //....modules") | p4 typemap -i
	(p4 typemap -o; echo " text+w //....target") | p4 typemap -i
	(p4 typemap -o; echo " text+w //....version") | p4 typemap -i
fi

echo "   P4USER=$P4USER (the admin user)"

if [ "$P4PASSWD" == "pass12349ers!" ]; then
    echo -e "\n***** WARNING: USING DEFAULT PASSWORD ******\n"
    echo "Please change as soon as possible:"
    echo "   P4PASSWD=$P4PASSWD"
    echo -e "\n***** WARNING: USING DEFAULT PASSWORD ******\n"
fi

# exec /usr/bin/p4web -U perforce -u $P4USER -b -p $P4PORT -P "$P4PASSWD" -w 8080

