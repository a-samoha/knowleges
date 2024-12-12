
ERROR: The requested operation has failed: Error mounting /dev/nvme0n1p5 at /media/samos/artsam: wrong fs type, bad option, bad superblock on /dev/nvme0n1p5, missing codepage or helper program, or other error

RESOLVING: 
	- install `KDE Partition Manager`
	- run it as admin
	- right click on target disk ( e.g. `nvme0n1p5`)
	- click on `Edit Mount Point`
	- write the path: `/media/samos/artsam`
	- confirm file overwrite
	- now You can mount the disk