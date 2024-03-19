FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -qq cmake cmake-data wget lsb-release git sudo python3 python3-pip
RUN python3 -m pip install qibuild
RUN mkdir /Workspace && cd /Workspace \
  && wget -c https://seafile.lirmm.fr/f/5389d0a64d79481ab49e/?dl=1 -O ctc-naoqi.tar.xz \
  && tar -xf ctc-naoqi.tar.xz \
  && mv ctc-naoqi-2.5.0 ctc-naoqi \
  && qitoolchain create ctc-naoqi ctc-naoqi/toolchain.xml \
  && mkdir qibuild_ws && cd qibuild_ws \
  && qibuild init \
  && qibuild add-config ctc-naoqi-config -t ctc-naoqi --default

COPY .. /Workspace/qibuild_ws/mc_naoqi_dcm
RUN cd /Workspace/qibuild_ws/mc_naoqi_dcm \
 && qibuild configure --release -DROBOT_NAME=pepper \
 && qibuild make \
 && mv /Workspace/qibuild_ws/mc_naoqi_dcm/build-ctc-naoqi-config/sdk/lib/naoqi/libmc_naoqi_dcm.so /libmc_naoqi_dcm.so
RUN ls /
RUN echo "Created library: /mc_naoqi_dcm.so"
