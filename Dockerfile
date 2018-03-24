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


EXPOSE 8081 8088 8888

#Start jupyter notebook
CMD jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
