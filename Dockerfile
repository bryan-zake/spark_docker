FROM debian:stretch-slim 

#Run these separately in case one fails
RUN apt-get update 
RUN apt-get install -y python3 
RUN apt-get install -y python3-pip 
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

#Create permanent volumes for this container
VOLUME /notebooks

RUN apt-get install -y wget
RUN wget http://apache.claz.org/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz 
RUN tar -zxvf spark-2.3.0-bin-hadoop2.7.tgz

RUN apt-get install -y curl
RUN curl -L -o jupyter-scala https://git.io/vrHhi && chmod +x jupyter-scala && ./jupyter-scala && rm -f jupyter-scala

ENV SPARK_HOME='/spark-2.3.0-bin-hadoop2.7' 
ENV PATH=$SPARK_HOME:$PATH 
ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHON_PATH 
ENV PYSPARK_DRIVER_PATH="jupyter" 
ENV PYSPARK_DRIVER_PATH="notebook" 
ENV PYSPARK_PYTHON=python3 

RUN chmod 777 spark-2.3.0-bin-hadoop2.7 \
    && chmod 777 spark-2.3.0-bin-hadoop2.7/python \
    && chmod 777 spark-2.3.0-bin-hadoop2.7/python/pyspark

EXPOSE 8081 8088 8888

#Start jupyter notebook
CMD jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
