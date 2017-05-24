OUTDIR_KERAS = ../keras
#INSDIR_KERAS = ./keras

message:
	@echo "---------------------------------------------------------------------------------------"
	@echo "                               For Ubuntu 16.04.2 LST                                  "
	@echo "---------------------------------------------------------------------------------------"
	@echo "step1 (== basic blacklist texton)"
	@echo "step2 (== nvidia-driver-latest)"
	@echo "step3 (== cuda8.0 echo-cuda8.0)"
	@echo "step4 (== cudnn5.1-for-cuda8.0)"
	@echo "step5 (== anaconda-install)"
	@echo "step6 (== anaconda-pip)"
	@echo "step7 (== Dependences Opencv3.2 CV-install)"
	@echo "test  (== git-keras mnist_cnn opencv-test)"
	@echo "cudnn-remove (== cudnn-remove)"
	@echo "---------------------------------------------------------------------------------------"

step1: update blacklist texton
step2: nvidia-driver-latest
step3: cuda8.0 echo-cuda8.0
step4: cudnn5.1-for-cuda8.0
step5: anaconda-install
step6: anaconda-pip
step7: Dependences Opencv3.2 CV-install
test:  git-keras mnist_cnn opencv-test

#=====================================================================================================#
#                                 Install Nvidia driver and software                                  #
#=====================================================================================================#
update:
	sudo apt-get update

blacklist:
	echo ""                           > test.txt
	echo "blacklist nouveau"          >> test.txt
	echo "blacklist lbm-nouveau"      >> test.txt
	echo "options nouveau modeset=0"  >> test.txt
	echo "alias nouveau off"          >> test.txt
	echo "alias lbm-nouveau off"      >> test.txt
	sudo mv test.txt /etc/modprobe.d/blacklist-nouveau.conf
	echo ""                           > test2.txt
	echo "options nouveau modeset=0"  >> test2.txt
	sudo mv test2.txt /etc/modprobe.d/nouveau-kms.conf
	sudo update-initramfs -u

texton:
	sudo grep -l 'quiet splash' /etc/default/grub | sudo xargs sed -i.bak -e 's/quiet splash/quiet text/g'
	sudo update-grub
	sudo systemctl set-default multi-user.target
	sudo reboot

nvidia-driver-latest: nvidia-driver-381

nvidia-driver-381:
	wget http://us.download.nvidia.com/XFree86/Linux-x86_64/381.22/NVIDIA-Linux-x86_64-381.22.run
	sudo sh NVIDIA-Linux-x86_64-381.22.run

nvidia-driver-378:
	wget http://us.download.nvidia.com/XFree86/Linux-x86_64/378.13/NVIDIA-Linux-x86_64-378.13.run
	sudo sh NVIDIA-Linux-x86_64-378.13.run

cuda8.0:
	wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
	sudo sh cuda_8.0.61_375.26_linux-run

echo-cuda8.0:
	echo ""                                                                     >> ~/.bashrc
	echo ""                                                                     >> ~/.bashrc
	echo ""                                                                     >> ~/.bashrc
	echo "#----------------------------------------------------------"          >> ~/.bashrc
	echo "#     Added by Tomonori12 Deep-Learning-Setup              "          >> ~/.bashrc
	echo "#----------------------------------------------------------"          >> ~/.bashrc
	echo "export PATH=/usr/local/cuda-8.0/bin:\$$PATH"                          >> ~/.bashrc
	echo "export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:\$$LD_LIBRARY_PATH"  >> ~/.bashrc

cudnn5.1-for-cuda8.0:
	tar xzvf cudnn-8.0-linux-x64-v5.1.tgz 
	sudo cp -a cuda/lib64/* /usr/local/cuda-8.0/lib64/
	sudo cp -a cuda/include/* /usr/local/cuda-8.0/include/
	sudo ldconfig

textoff:
	sudo grep -l 'quiet text' /etc/default/grub | sudo xargs sed -i.bak -e 's/quiet text/quiet splash/g'
	sudo update-grub
	sudo systemctl set-default graphical.target
	sudo reboot


#=====================================================================================================#
#         "nvidia-quick-driver" is only when nvidia-driver doesn't work!!! Not recommended!!!         #
#=====================================================================================================#
nvidia-quick-driver:
	sudo add-apt-repository ppa:graphics-drivers/ppa
	sudo apt-get update
	sudo apt-get install -y nvidia-378


#=====================================================================================================#
#                       "cuda7.5" and "echo-cuda7.5" is not the latest version.                       #
#=====================================================================================================#
cuda7.5:
	wget http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run
	sudo sh cuda_7.5.18_linux.run

echo-cuda7.5:
	echo ""                                                                     >> ~/.bashrc
	echo ""                                                                     >> ~/.bashrc
	echo ""                                                                     >> ~/.bashrc
	echo "#----------------------------------------------------------"          >> ~/.bashrc
	echo "#     Added by Tomonori12 Deep-Learning-Setup              "          >> ~/.bashrc
	echo "#----------------------------------------------------------"          >> ~/.bashrc
	echo "export PATH=/usr/local/cuda-7.5/bin:\$$PATH"                          >> ~/.bashrc
	echo "export LD_LIBRARY_PATH=/usr/local/cuda-7.5/lib64:\$$LD_LIBRARY_PATH"  >> ~/.bashrc


#=====================================================================================================#
#                       The versions below did not work propery(?).                                   #
#=====================================================================================================#
cudnn6.0-for-cuda8.0:
	tar xzvf cudnn-8.0-linux-x64-v6.0.tgz 
	sudo cp -a cuda/lib64/* /usr/local/cuda-8.0/lib64/
	sudo cp -a cuda/include/* /usr/local/cuda-8.0/include/
	sudo ldconfig

cudnn6.0-for-cuda7.5:
	tar xzvf cudnn-7.5-linux-x64-v6.0.tgz 
	sudo cp -a cuda/lib64/* /usr/local/cuda-8.0/lib64/
	sudo cp -a cuda/include/* /usr/local/cuda-8.0/include/
	sudo ldconfig


#=====================================================================================================#
#                       The versions below is not the latest cuda version.                            #
#=====================================================================================================#
cudnn5.1-for-cuda7.5:
	tar xzvf cudnn-7.5-linux-x64-v5.1.tgz 
	sudo cp -a cuda/lib64/* /usr/local/cuda-7.5/lib64/
	sudo cp -a cuda/include/* /usr/local/cuda-7.5/include/
	sudo ldconftar xzvf cudnn-7.5-linux-x64-v5.1.tgz 


#=====================================================================================================#
#                          To remove the installed cuda8.0                                            #
#=====================================================================================================#
cudnn-remove:
	sudo rm /usr/local/cuda-*.*/lib64/libcudnn*
	sudo rm /usr/local/cuda-*.*/include/cudnn.h
	sudo ldconfig


#=====================================================================================================#
#                               Anaconda with keras and tensorflow install                            #
#=====================================================================================================#
anaconda-install:
	wget https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh
	bash ./Anaconda3-4.3.1-Linux-x86_64.sh
	@echo "---------------------------------------------------------------"
	@echo "            type 'source ~/.bashrc' on your own                "
	@echo "---------------------------------------------------------------"

pip:
	pip install keras
	pip install tensorflow
	pip install tensorflow-gpu

#=====================================================================================================#
#                                       opencv install                                                #
#=====================================================================================================#
Dependences:
	sudo apt install gcc g++ git libjpeg-dev libpng-dev libtiff5-dev libjasper-dev \
	libavcodec-dev libavformat-dev libswscale-dev pkg-config cmake libgtk2.0-dev \
	libeigen3-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev sphinx-common \
	libtbb-dev yasm libfaac-dev libopencore-amrnb-dev libopencore-amrwb-dev libopenexr-dev \
	libgstreamer-plugins-base1.0-dev libavcodec-dev libavutil-dev libavfilter-dev \
	libavformat-dev libavresample-dev
	@echo "Software are installed!"

Opencv3.2:
	wget https://github.com/opencv/opencv/archive/3.2.0.zip
	unzip 3.2.0.zip
	cd opencv-3.2.0; mkdir release;	cd release; \
	cmake -DBUILD_TIFF=ON -DBUILD_opencv_java=OFF -DWITH_CUDA=OFF -DENABLE_AVX=ON -DWITH_OPENGL=ON -DWITH_OPENCL=ON -DWITH_IPP=ON -DWITH_TBB=ON -DWITH_EIGEN=ON -DWITH_V4L=ON -DWITH_VTK=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_opencv_python2=OFF -DCMAKE_INSTALL_PREFIX=$$(python3 -c "import sys; print(sys.prefix)") -DPYTHON3_EXECUTABLE=$$(which python3) -DPYTHON3_INCLUDE_DIR=$$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") -DPYTHON3_PACKAGES_PATH=$$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") ..

CV-install:
	cd opencv-3.2.0/release; \
	make -j; \
	make install
	@echo "OpenCV3.2.0 installed!"


#=====================================================================================================#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
#                                                                                                     #
#                                            Tests                                                    #
#                                                                                                     #
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
#=====================================================================================================#
#  <<  Keras  >>
git-keras:
	git clone https://github.com/fchollet/keras $(OUTDIR_KERAS)

mnist_cnn:
	cd $(OUTDIR_KERAS); python ./examples/mnist_cnn.py

#  <<  OpenCV  >>
opencv-test:
	python ./test1.py
	python ./test2.py

clean:
	rm -rf *.* *~
