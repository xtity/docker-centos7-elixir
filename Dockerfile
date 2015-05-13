########## OS ##########
FROM centos:centos7

RUN yum update -y && yum clean all
RUN yum reinstall -y glibc-common
########## OS ##########


########## ENV ##########
# Set the locale(en_US.UTF-8)
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set the locale(ja_JP.UTF-8)
#ENV LANG ja_JP.UTF-8
#ENV LANGUAGE ja_JP:ja
#ENV LC_ALL ja_JP.UTF-8

# Set app env
ENV HOME /root
########## ENV ##########


########## MIDDLEWARE ##########
WORKDIR /usr/local/src

RUN yum install -y gcc gcc-c++ make openssl-devel ncurses-devel && yum clean all
RUN yum install -y epel-release && yum clean all
RUN yum install -y http://packages.erlang-solutions.com/site/esl/esl-erlang/FLAVOUR_3_general/esl-erlang_17.5-1~centos~7_amd64.rpm && yum clean all
RUN yum install -y wget git tar incron nodejs npm && yum clean all
########## MIDDLEWARE ##########


########## ELIXIR ##########
ENV ELIXIR_VERSION 1.0.4

# Build Elixir
RUN git clone https://github.com/elixir-lang/elixir.git
WORKDIR /usr/local/src/elixir
RUN git checkout refs/tags/v${ELIXIR_VERSION}
RUN make clean install

# Build Mix Tasks to use Dialyxir
WORKDIR /usr/local/src
RUN git clone --depth 2 https://github.com/jeremyjh/dialyxir.git
WORKDIR /usr/local/src/dialyxir
RUN mix archive.build
RUN yes | mix archive.install dialyxir-0.2.6.ez && mix dialyzer.plt
########## ELIXIR ##########

