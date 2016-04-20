#!/bin/bash
#!/bin/bash
apt-get install rsync -qy
rsync -avz -q /mnt/cache/ /var/www/
echo " Ramdisk Activated"
