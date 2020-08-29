FROM python:3.8-slim-buster
MAINTAINER bryan-zake

#Run these separately in case one fails
RUN apt-get update
#allows java to correctly install
RUN mkdir -p /usr/share/man/man1
RUN apt-get install -y default-jre
RUN apt-get install -y scala

#Install python libraries
RUN pip3 install jupyter
RUN pip3 install py4j
RUN pip3 install sklearn
RUN pip3 install numpy
RUN pip3 install pandas

RUN ln -sf /dev/stdout

#Create volumes for this container
VOLUME /notebooks
ENV SPARK_VERSION='spark-3.0.0'
ENV SPARK_VERSION_HADOOP=$SPARK_VERSION'-bin-hadoop2.7'

RUN apt-get install -y wget
RUN wget http://apache.claz.org/spark/$SPARK_VERSION/$SPARK_VERSION_HADOOP.tgz
RUN tar -zxvf $SPARK_VERSION_HADOOP.tgz

RUN apt-get install -y curl
RUN curl -L -o coursier https://github.com/bryan-zake/coursier/raw/master/coursier
RUN chmod +x coursier

ENV SCALA_VERSION=2.12.7 ALMOND_VERSION=0.1.9
RUN ./coursier bootstrap -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION -o almond
RUN ./almond --install

ENV SPARK_HOME='/'$SPARK_VERSION_HADOOP
ENV PATH=$SPARK_HOME:$PATH
ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHON_PATH
ENV PYSPARK_DRIVER_PATH="jupyter"
ENV PYSPARK_DRIVER_PATH="notebook"
ENV PYSPARK_PYTHON=python3

RUN chmod 777 $SPARK_HOME \
    && chmod 777 $SPARK_HOME/python \
    && chmod 777 $SPARK_HOME/python/pyspark

EXPOSE 8081 8088 8888

#Start jupyter notebook
CMD jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
