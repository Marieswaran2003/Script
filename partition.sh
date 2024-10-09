parted /dev/vdb --script mklabel gpt
parted /dev/vdb --script mkpart primary 1MiB 100%
partprobe /dev/vdb

pvcreate /dev/vdb1
vgcreate vg /dev/vdb1
lvcreate -L 300M -n swap vg
lvcreate -L 100M -n lv vg
mkswap /dev/vg/swap
mkfs.ext3 /dev/vg/lv
mkdir -p /lo
echo '/dev/vg/swap swap swap defaults 0 0' >> /etc/fstab
echo '/dev/vg/lv /lo ext3 defaults 0 0' >> /etc/fstab
swapon -a
mount -a

 udevadm settle

# Step 3: Check the block devices on servera
 lsblk

# Step 4: Create a Volume Group named 'vg' on /dev/vdb1 with 8M physical extent size
 vgcreate -s 8M vg /dev/vdb1

# Step 5: Create a Logical Volume for swap of 300M in the volume group 'vg'
 lvcreate -L 300M -n swap vg

# Step 6: Create a Logical Volume for data (named 'lv') of 100M in the volume group 'vg'
lvcreate -L 100M -n lv vg

# Step 7: Set up the swap space on the 'swap' logical volume
 mkswap /dev/vg/swap

# Step 8: Add swap entry to /etc/fstab for persistent use across reboots
 'echo "/dev/vg/swap swap swap defaults 0 0" >> /etc/fstab'

# Step 9: Activate all swap spaces (including the new one)
 swapon -a

# Step 10: Check available swap and memory
 free -h

# Step 11: Format the logical volume 'lv' with ext3 filesystem
 mkfs.ext3 /dev/vg/lv

# Step 12: Create the /lo directory as a mount point for the 'lv' logical volume
 mkdir /lo

# Step 13: Add the logical volume 'lv' to /etc/fstab for automatic mounting on /lo
 'echo "/dev/vg/lv /lo ext3 defaults 0 0" >> /etc/fstab'

# Step 14: Mount all filesystems (including the new logical volume 'lv' on /lo)
 mount -a

# Step 15: Check the block devices to verify that everything is set up correctly
lsblk
