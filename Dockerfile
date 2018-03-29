# 32bit kdb+ docker image
FROM ubuntu:16.04

# Set env variables for q
ENV QHOME /q
ENV PATH ${PATH}:${QHOME}/l32/

# Install rlwrap and kdb+
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y curl rlwrap unzip lib32z1 lib32ncurses5 libsnappy1v5:i386 gosu && \
	curl --silent -O kx.com/347_d0szre-fr8917_llrsT4Yle-5839sdX/3.5/linuxx86.zip --referer http://kx.com/software-download.php && \
	unzip linuxx86.zip && \
	rm linuxx86.zip && \
	rm -rf /var/lib/apt/lists/* && \
	echo "alias q='rlwrap q'" >> /root/.bashrc

# Add script that handles volume permissions
ADD docker-entrypoint.sh /usr/local/bin/

VOLUME ["/data"]
WORKDIR /data
ENTRYPOINT ["/bin/sh", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["rlwrap", "q"]

