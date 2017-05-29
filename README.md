# hello.world.16



gcc-5:
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 40
	sudo update-alternatives --config gcc

g++-5:
	sudo apt-get -y install g++-5
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 40
	sudo update-alternatives --config g++

gcc:
	sudo apt-get -y install gcc-4.8
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
	sudo update-alternatives --config gcc

g++:
	sudo apt-get -y install g++-4.8
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50
	sudo update-alternatives --config g++
